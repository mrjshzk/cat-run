extends Node
class_name InputGatherer


var jump := false
var last_jump := jump

enum InputState {
	None,
	Holding,
	Released
}

func _process(delta: float) -> void:
	last_jump = jump

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump = true
	if event.is_action_released("jump"):
		jump = false
	
	if event is InputEventScreenTouch:
		jump = (event as InputEventScreenTouch).pressed
		
	
	

func gather_action() -> InputState:
	if jump and last_jump:
		return InputState.Holding
	if not jump and last_jump:
		return InputState.Released
	
	return InputState.None
