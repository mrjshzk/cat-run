extends Node

var clicked_audio_stream := "res://assets/audio/sfx/GUI - Accept 001.wav"

var audio_stream_player : AudioStreamPlayer

func _enter_tree() -> void:
	audio_stream_player = AudioStreamPlayer.new()
	var random_stream := AudioStreamRandomizer.new()
	random_stream.add_stream(0, load(clicked_audio_stream))
	random_stream.random_pitch = 1.1
	
	audio_stream_player.bus = &"SFX"
	audio_stream_player.stream = random_stream
	
	self.add_child.call_deferred(audio_stream_player)
	get_tree().node_added.connect(set_audio)

func set_audio(node):
	if node is TextureButton:
		node.pressed.connect(audio_stream_player.play)
