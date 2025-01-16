extends Node2D
class_name Spawner

@export var obstacles : Array[PackedScene]

signal _on_obstacle_passed(_body: CharacterBody2D)
signal _on_player_hit(_body: CharacterBody2D)

func start_spawning() -> void:
	var t := Timer.new()
	t.one_shot = false
	t.timeout.connect(spawn_timer_finished)
	t.ready.connect(t.start.bind(2.0))
	self.add_child.call_deferred(t)

func spawn_timer_finished() -> void:
	var obstacle : MovableObject = obstacles.pick_random().instantiate()
	obstacle.killer.body_entered.connect(_on_player_hit.emit)
	obstacle.passed.body_exited.connect(_on_obstacle_passed.emit)
	self.add_child.call_deferred(obstacle)
