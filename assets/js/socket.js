import { Socket } from "phoenix";

let socket = new Socket("/socket", { params: { token: window.userToken } });

socket.connect();

const id = Math.round(Math.random() * 1000000);

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
    console.log(payload);
    // let messageItem = document.createElement("p");
    // messageItem.innerText = `[${Date()}] ${payload.body}`;
    // messagesContainer.appendChild(messageItem);
});

channel
    .join()
    .receive("ok", (resp) => {
        console.log("Joined successfully", resp);
    })
    .receive("error", (resp) => {
        console.log("Unable to join", resp);
    });

const solveGreedy = () => {
    channel.push("solve", {
        body: [
            { index: 0, coords: [96, 31] },
            { index: 1, coords: [51, 48] },
            { index: 2, coords: [46, 20] },
            { index: 3, coords: [88, 83] },
            { index: 4, coords: [42, 98] },
            { index: 5, coords: [35, 91] },
            { index: 6, coords: [12, 78] },
            { index: 7, coords: [34, 40] },
            { index: 8, coords: [6, 12] },
            { index: 9, coords: [94, 89] },
        ],
    });
};

document.querySelector("#solveGreedy").addEventListener("click", () => {
    solveGreedy();
});

export default socket;
