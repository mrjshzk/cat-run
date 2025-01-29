extends Node2D
class_name Spawner

@export var obstacles : Array[PackedScene]

signal _on_obstacle_passed(_body: CharacterBody2D)
signal _on_player_hit(_body: CharacterBody2D)

var t : Timer

func _ready() -> void:
	t = Timer.new()
	self.add_child.call_deferred(t)


func start_spawning() -> void:
	t.one_shot = false
	t.timeout.connect(spawn_timer_finished)
	t.start(2.0)
	spawn_timer_finished()

func spawn_timer_finished() -> void:
	var obstacle : MovableObject = obstacles.pick_random().instantiate()
	obstacle.killer.body_entered.connect(_on_player_hit.emit)
	obstacle.passed.body_exited.connect(_on_obstacle_passed.emit)
	self.add_child.call_deferred(obstacle)
	obstacle.ready.connect(func(): obstacle.set_physics_process(true))

func stop_spawning():
	t.timeout.disconnect(spawn_timer_finished)
	t.stop()

func restart():
	t.start()
	for child in get_children():
		if child is Timer:
			continue
		child.queue_free()
