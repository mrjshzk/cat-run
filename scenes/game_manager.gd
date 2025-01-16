extends Node
class_name GameManager

@export var enemy_spawner: Spawner
@export var ui_manager: UIManager

var score := 0

func _ready() -> void:
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_LANDSCAPE)
	enemy_spawner.start_spawning()
	enemy_spawner._on_obstacle_passed.connect(obstacle_passed)
	enemy_spawner._on_player_hit.connect(player_was_hit)

func obstacle_passed(_body: CharacterBody2D) -> void:
	MovableObject.speed += 50.0
	score += 1
	ui_manager.update_score(score)

func player_was_hit(_body: CharacterBody2D) -> void:
	MovableObject.speed = MovableObject.start_speed
	get_tree().reload_current_scene.call_deferred()
