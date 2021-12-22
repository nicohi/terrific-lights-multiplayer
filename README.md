# terrific-lights-multiplayer

The main additions to the original game are in the `Net/` folder and `MainMenuMulti.gd` and `Map/MapMulti.gd`.

## Requirements
Godot must be installed.

## Run game
Since we are hosting a public matchmaking server, the game can be started with:
`godot MainMenuMulti.tscn`

If you wish to test the game and don't have friends to play with, run the game in 4 terminals or run:
`./start_clients.sh` (requires tmux)
TURN DOWN SPEAKER/HEADPHONE VOLUME. Sounds from all 4 games play at once.

And to quit:
`tmux kill-session`

The default server creates matches with 4 players.
Once you click "start" the game connects to the matchmaking server and waits for the other 3 players to do the same.
As soon as enough players have connected, the game starts.

If you are running your own server, set the `websocket_url` variable in Net/ClientManager.gd to the IP address of your server before starting the game.

## Run server
`godot Net/Server.tscn`
