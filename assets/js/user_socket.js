// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import { Socket } from "phoenix";

// And connect to the path in "lib/discuss_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", { params: { token: window.userToken } });

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/discuss_web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/discuss_web/templates/layout/app.html.heex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/discuss_web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect();

// Now that you are connected, you can join channels with a topic.
// Let's assume you have a channel with a topic named `room` and the
// subtopic is its id - in this case 42:

const commentTemplate = (comment, userId) => {
  return `
      <li class="collection-item" id="comment-${comment.id}">
        <strong>
          ${comment.user.email.split("@")[0]}
        </strong> says: ${comment.content}
        ${
          (Boolean(comment.user.id === userId) &&
            `<span class="list-link list-link__destroy" style="float: right;">
              <i class="md-10 material-icons">delete_forever</i>
            </span>`) ||
          ""
        }
      </li>
    `;
};

const renderComments = (comments, userId) => {
  const renderedComments = comments.map((comment) =>
    commentTemplate(comment, userId)
  );

  document.querySelector(".collection").innerHTML = renderedComments.join("");
};

const applyDestroyButtons = (channel) => {
  document.querySelectorAll(".list-link__destroy").forEach((span) => {
    span.addEventListener("click", (e) => {
      e.preventDefault();
      const commentId = e.target.parentElement.parentElement.id.split("-")[1];

      channel.push("comment:destroy", { commentId: commentId });
    });
  });
};

const renderComment = (data, userId, channel) => {
  const { comment } = data;
  const renderedComment = commentTemplate(comment, userId);

  document.querySelector(".collection").innerHTML += renderedComment;
  applyDestroyButtons(channel);
};

const removeComment = (data) => {
  const { id } = data.comment;
  const comment = document.querySelector(`#comment-${id}`);

  comment.parentElement.removeChild(comment);
};

const createSocket = (topicId, userId) => {
  let channel = socket.channel(`comments:${topicId}`, { userId: userId });

  channel
    .join()
    .receive("ok", (resp) => {
      renderComments(resp.comments, userId);
      applyDestroyButtons(channel);
    })
    .receive("error", (resp) => {
      console.log("Unable to join", resp);
    });

  channel.on(`comments:${topicId}:new`, (data) =>
    renderComment(data, userId, channel)
  );
  channel.on(`comments:${topicId}:destroy`, (data) => removeComment(data));

  document.querySelector("button").addEventListener("click", function () {
    const textarea = document.querySelector("textarea");
    channel.push("comment:add", { content: textarea.value });
    textarea.value = "";
  });
};

window.createSocket = createSocket;

export default socket;
