extends CanvasLayer
class_name UIManager

@onready var label: Label = $Label

func update_score(new_score: int):
	label.text = "Score: %d" % new_score
