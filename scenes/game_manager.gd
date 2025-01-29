extends Node
class_name GameManager

@export var enemy_spawner: Spawner
@export var ui_manager: UIManager
@export var cat_player: Player

@export var animation_player: AnimationPlayer

@export var obstacle_passed_player: AudioStreamPlayer
@export var player_hit_player: AudioStreamPlayer

signal game_started
signal game_ended
signal on_obstacle_passed

var base_delta_multiplier := 100.0
var obstacle_passed_multiplier := 1.0
var score := 0:
	set(val):
		score = val
		ui_manager.update_score(score)

func _ready() -> void:
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_LANDSCAPE)
	set_physics_process(false)

func obstacle_passed(_body: CharacterBody2D) -> void:
	MovableObject.speed += 50.0
	obstacle_passed_multiplier *= 1.1
	on_obstacle_passed.emit()

func player_was_hit(_body: CharacterBody2D) -> void:
	MovableObject.speed = MovableObject.start_speed
	ui_manager.score_counter_2.text = "%d" % score
	cat_player.on_died()
	enemy_spawner._on_obstacle_passed.disconnect(obstacle_passed)
	enemy_spawner._on_player_hit.disconnect(player_was_hit)
	
	enemy_spawner._on_obstacle_passed.disconnect(obstacle_passed_player.play)
	enemy_spawner._on_player_hit.disconnect(player_hit_player.play)
	
	enemy_spawner.stop_spawning()
	animation_player.play("DeathScreen")
	
	game_ended.emit()
	set_physics_process(false)

@onready var cat_initial_pos := cat_player.position

func _start_game():
	MovableObject.speed = 500.0
	enemy_spawner.restart()
	cat_player.position = cat_initial_pos
	cat_player.set_ready()
	score = 0.0
	obstacle_passed_multiplier = 1.0
	var t := create_tween()
	t.tween_property(cat_player, "position:x", 80, 1.0)
	await t.finished
	set_physics_process(true)
	enemy_spawner.start_spawning()
	enemy_spawner._on_obstacle_passed.connect(obstacle_passed)
	enemy_spawner._on_player_hit.connect(player_was_hit)
	
	enemy_spawner._on_obstacle_passed.connect(obstacle_passed_player.play)
	enemy_spawner._on_player_hit.connect(player_hit_player.play)
	
	game_started.emit()

func _physics_process(delta: float) -> void:
	score += delta * base_delta_multiplier * obstacle_passed_multiplier
