extends ColorRect

# TODO Use with resources?

# TODO Use HBoxContainer here

func _ready():
	pass # Replace with function body.

func _on_button_toggled(toggled_on):
	$Button.text = "On" if toggled_on else "Off"
	#pass # Replace with function body.
