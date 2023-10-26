const express = require('express');
const http = require('http');
const socketIo = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

let votes = {}; // Store votes. Consider using a database for a real application.

io.on('connection', (socket) => {
    console.log('A user connected');

    // Send current votes to newly connected clients
    socket.emit('update-votes', votes);

    // Listen for new votes
    socket.on('cast-vote', (vote) => {
        if (!votes[vote]) {
            votes[vote] = 1;
        } else {
            votes[vote]++;
        }

        // Notify all clients of the new vote
        io.emit('update-votes', votes);
    });

    socket.on('disconnect', () => {
        console.log('A user disconnected');
    });
});

const PORT = 3000;
server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
