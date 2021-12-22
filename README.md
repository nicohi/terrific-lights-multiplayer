# terrific-lights-multiplayer

## Run game
Since we are hosting a public matchmaking server, the game can be started with:
`godot MainMenuMulti.tscn`

The default server creates matches with 4 players.
Once you click "start" the game connects to the matchmaking server and waits for the other 3 players to do the same.
As soon as enough players have connected, the game starts.

If you are running your own server, set the `websocket_url` variable to match the IP address of the device you wish to use as a server in Net/ClientManager.gd prior to running the game.

## Run server
`godot Net/Server.tscn`
