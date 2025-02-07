extends CharacterBody2D
class_name MovableObject

@export var visibility_notifier: VisibleOnScreenNotifier2D
@export var killer: Area2D
@export var passed: Area2D
@export var sprite: Sprite2D

static var start_speed := 0.0
static var speed := 500.0

@export var sprites: Array[Texture2D]

func _ready() -> void:
	top_level = true
	position = get_parent().position
	sprite.texture = sprites.pick_random()
	visibility_notifier.screen_entered.connect(enable_despawn, CONNECT_ONE_SHOT)

func _physics_process(delta: float) -> void:
	self.velocity.x = -speed
	self.move_and_slide()

func enable_despawn():
	visibility_notifier.screen_exited.connect(exited_screen, CONNECT_ONE_SHOT)

func exited_screen():
	self.queue_free()
