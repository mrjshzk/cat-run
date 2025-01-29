extends Node2D

@export var sky_background: Parallax2D
@export var far_background: Parallax2D
@export var near_background: Parallax2D

@export var sky_scroll_speed := 0.5
@export var far_scroll_speed := 1.0
@export var near_scroll_speed := 2.0

@export var game_manager: GameManager

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	sky_background.scroll_offset.x += sky_scroll_speed * (game_manager.base_delta_multiplier * 0.02)
	far_background.scroll_offset.x += far_scroll_speed * (game_manager.base_delta_multiplier * 0.02)
	near_background.scroll_offset.x += near_scroll_speed * (game_manager.base_delta_multiplier * 0.02)
