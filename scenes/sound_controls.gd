extends HBoxContainer

@export var music_button: TextureButton
@export var sfx_button: TextureButton

var music_on := true
var sfx_on := true

func _ready() -> void:
	music_button.pressed.connect(
		func():
			if music_on:
				music_on = false
				music_button.modulate = Color.RED
				AudioServer.set_bus_mute(1, true)
			else:
				music_on = true
				music_button.modulate = Color.WHITE
				AudioServer.set_bus_mute(1, false)
			music_button.release_focus()
	)
	
	sfx_button.pressed.connect(
		func():
			if sfx_on:
				sfx_on = false
				sfx_button.modulate = Color.RED
				AudioServer.set_bus_mute(2, true)
			else:
				sfx_on = true
				sfx_button.modulate = Color.WHITE
				AudioServer.set_bus_mute(2, false)
			sfx_button.release_focus()
	)
