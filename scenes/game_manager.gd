extends Node
class_name GameManager

@export var enemy_spawner: Spawner
@export var ui_manager: UIManager
@export var cat_player: Player

var score := 0

func _ready() -> void:
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_LANDSCAPE)
	_start_game()

func obstacle_passed(_body: CharacterBody2D) -> void:
	MovableObject.speed += 50.0
	score += 1
	ui_manager.update_score(score)

func player_was_hit(_body: CharacterBody2D) -> void:
	MovableObject.speed = MovableObject.start_speed
	get_tree().reload_current_scene.call_deferred()

func _start_game():
	print("starting game!")
	var t := create_tween()
	t.tween_property(cat_player, "position:x", 80, 1.0)
	await t.finished
	enemy_spawner.start_spawning()
	enemy_spawner._on_obstacle_passed.connect(obstacle_passed)
	enemy_spawner._on_player_hit.connect(player_was_hit)
