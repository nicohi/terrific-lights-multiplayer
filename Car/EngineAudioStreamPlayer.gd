extends AudioStreamPlayer2D

onready var playback = get_stream_playback()

func _ready():
	stream.mix_rate = Globals.SAMPLE_HZ
