extends CanvasLayer
class_name UIManager


@export var game_manager: GameManager

@export var score_counter: Label
@export var score_counter_2: Label

@export var main_menu: Control
@export var start_button: TextureButton
@export var quit_button: TextureButton

@export var title: Label
@export var restart_game_button: TextureButton
@export var go_home_button: TextureButton
@export var animation_player: AnimationPlayer

func update_score(new_score: int):
	score_counter.text = "%d" % new_score

func _ready() -> void:
	start_button.pressed.connect(
		func():
			create_tween().tween_property(title, "modulate", Color.TRANSPARENT, 0.25)
			score_counter.scale = Vector2.ONE
			animation_player.play("StartGame")
	)
	
	restart_game_button.pressed.connect(
		func():
			score_counter.scale = Vector2.ONE
			animation_player.play("RestartGame")
	)
	
	go_home_button.pressed.connect(
		func():
			create_tween().tween_property(title, "modulate", Color.WHITE, 1.0)
			animation_player.play("BackToMainMenu")
	)
	
	quit_button.pressed.connect(
		func():
			get_tree().quit()
	)
	
	game_manager.on_obstacle_passed.connect(tween_score)


func tween_score() -> void:
	var new_scale := score_counter.scale * 1.1
	new_scale = new_scale.clamp(Vector2.ONE, Vector2(3.5,3.5))
	create_tween()\
	.set_trans(Tween.TRANS_EXPO)\
	.tween_property(score_counter, "scale", new_scale, 0.25)
