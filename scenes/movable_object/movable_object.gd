extends CharacterBody2D
class_name MovableObject

@export var visibility_notifier: VisibleOnScreenNotifier2D
@export var killer: Area2D
@export var passed: Area2D

static var start_speed := 500.0
static var speed := 500.0

func _ready() -> void:
	visibility_notifier.screen_entered.connect(enable_despawn, CONNECT_ONE_SHOT)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity.x = -speed
	move_and_slide()

func enable_despawn():
	visibility_notifier.screen_exited.connect(exited_screen, CONNECT_ONE_SHOT)

func exited_screen():
	self.queue_free()
