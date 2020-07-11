import { Socket } from "phoenix";

let socket = new Socket("/socket", { params: { token: window.userToken } });

socket.connect();

const id = Math.round(Math.random() * 1000000)

let channel = socket.channel(`solver:${id}`, {});
let chatInput = document.querySelector("#chat-input");
let messagesContainer = document.querySelector("#messages");

chatInput.addEventListener("keypress", (event) => {
    if (event.key === "Enter") {
        channel.push("solve", { body: chatInput.value });
        chatInput.value = "";
    }
});

channel.on("solution", (payload) => {
    let messageItem = document.createElement("p");
    messageItem.innerText = `[${Date()}] ${payload.body}`;
    messagesContainer.appendChild(messageItem);
});

channel
    .join()
    .receive("ok", (resp) => {
        console.log("Joined successfully", resp);
    })
    .receive("error", (resp) => {
        console.log("Unable to join", resp);
    });

export default socket;
