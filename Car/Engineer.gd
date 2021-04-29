extends Node2D

var playback: AudioStreamPlayback
var phase = 0.0
var engine_conf = null
var velocity = Vector2.ZERO

onready var enginePlayer := $EngineAudioStreamPlayer

func _ready():
	$EngineAudioStreamPlayer.stream.mix_rate = Globals.SAMPLE_HZ
	playback = $EngineAudioStreamPlayer.get_stream_playback()

func _physics_process(delta):
	_fill_audio_buffer()

func play():
	engine_conf = Globals.get_engine_conf()
	
	if engine_conf != null:
		enginePlayer.play()

func stop():
	if enginePlayer.playing:
		enginePlayer.stop()
		Globals.car_engines_on -= 1

func _fill_audio_buffer():
	if engine_conf == null:
		return
		
	var increment = (engine_conf["baseHz"] + (velocity * .015).length() * engine_conf["hz"]) / Globals.SAMPLE_HZ
	
	var to_fill = playback.get_frames_available()
	
	while to_fill > 0:
		var vec = Vector2.ONE
		
		if phase < .25:
			vec *= (.25 - phase) / .25
		elif phase < .50:
			vec *= 1.0 - (.25 - phase) / .25
		elif phase < .75:
			vec *= -((.25 - phase) / .25)
		else:
			vec *= (.25 - phase) / .25 - 1
			
		playback.push_frame(vec)
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1
