extends CharacterBody2D
class_name Player

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var input_gatherer: InputGatherer = $InputGatherer

@export var jump_start_velocity := -400
@export var jump_increment_velocity := -300
@export var jump_player: AudioStreamPlayer

@export var game_manager : GameManager
var listen_to_input := false


enum animation_state {
	run,
	jump,
	fall
}

var states : Dictionary[animation_state, Callable] = {
	animation_state.run: _run_update,
	animation_state.jump: _jump_update,
	animation_state.fall: _fall_update
}

var current_state : animation_state

func _ready() -> void:
	_transition_state(animation_state.run)
	game_manager.game_started.connect(func(): listen_to_input = true)
	game_manager.game_ended.connect(func(): listen_to_input = false)

func _physics_process(delta: float) -> void:
	
	
	var input_state := input_gatherer.gather_action()
	
	if not listen_to_input:
		input_state = InputGatherer.InputState.None
	
	states[current_state].call(delta, input_state)
	
	move_and_slide()

func _run_update(delta: float, input_state: InputGatherer.InputState):
	velocity.y = 0.0
	if input_state == InputGatherer.InputState.Holding:
		_transition_state(animation_state.jump)

var jump_time := 0.0
var max_jump_time := 0.25
func _jump_update(delta: float, input_state: InputGatherer.InputState):
	velocity.y -= jump_increment_velocity * 2 * delta
	
	if jump_time > max_jump_time or input_state == InputGatherer.InputState.Released:
		jump_time = 0.0
		_transition_state(animation_state.fall)
	
	jump_time += delta

func _fall_update(delta: float, input_state: InputGatherer.InputState):
	velocity.y += get_gravity().y * delta * 1.5
	
	if is_on_floor():
		_transition_state(animation_state.run)

func _transition_state(new_state: animation_state):
	current_state = new_state
	match current_state:
		animation_state.run:
			pass
		animation_state.jump:
			jump_player.play()
			velocity.y = jump_start_velocity
		animation_state.fall:
			velocity.y += 100
	sprite.play(animation_state.find_key(current_state))

func set_percent(percentage: float) -> void:
	sprite.material.set_shader_parameter('percentage', percentage)

@onready var initial_scale := sprite.scale
func on_died():
	var t := create_tween()
	t.set_parallel(true)
	t.tween_method(set_percent, 1.0, 0.0, 0.5)
	t.tween_property(sprite, "scale", sprite.scale * 1.5, 0.5)

func set_ready():
	set_percent(1.0)
	sprite.scale = initial_scale
