var ws = new WebSocket('ws://localhost:8081/');

ws.onmessage = function(event) {
	ws.send(JSON.stringify(eval(event.data)))
};
