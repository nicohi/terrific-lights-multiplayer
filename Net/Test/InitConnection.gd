extends Node

class_name InitConnection

var _relay_client : ClientManager

func _ready():
	_relay_client = $MatchmakingClient
	_relay_client.connect("on_message", self, "_on_message")
	_relay_client.connect("on_players_ready", self, "_on_players_ready")

	_on_start_game()

func _on_start_game():
	_relay_client.connect_to_server()
	print("connecting to matchmaking server")

func _on_players_ready():
	process_match_start()

func _on_game_over():

	_relay_client.disconnect_from_server()

func ping():
	var msg = Message.new()
	msg.is_echo = true
	msg.content = {}
	msg.content["id"] = _relay_client._id
	msg.content["time"] = OS.get_unix_time()
	msg.content["type"] = "ping"
	msg.content["data"] = "Hello world #" + str(randi())
	_relay_client.send_data(msg)
	
func pong(resp):
	var msg = Message.new()
	msg.is_echo = true
	msg.content = {}
	msg.content["id"] = _relay_client._id
	msg.content["time"] = OS.get_unix_time()
	msg.content["type"] = "pong"
	msg.content["data"] = resp
	_relay_client.send_data(msg)

func _on_message(message : Message):
	print(message.content)
	#var is_dict = typeof(message.content) == TYPE_DICTIONARY
	if (message.server_login): return
	if (message.match_start): return
	else:
		#if (message.content.has("gameover")):
		#	_on_game_over()
		# if ping message is received send back pong with the same data
		if (message.content.has("type") && message.content["type"] == "ping"):
			pong(message.content["data"])

func process_match_start():
	# Disconnect from matchmaking server
	_relay_client.disconnect_from_server()

	var peers = _relay_client._match

	#var is_host = peers.find(_relay_client._id) == 0
	#if (is_host):
	#	var msg = Message.new()
	#	msg.is_echo = true
	#	msg.content = {}
	#	msg.content["seed"] = randi()
	#	_relay_client.send_data(msg)
	
var time = 0
var rng = RandomNumberGenerator.new()
var wait = 1

func _process(delta):
	time += delta
	if time > wait:
		rng.randomize()
		wait = rng.randf_range(1.0, 10.0)
		ping()
		# Reset timer
		time = 0
