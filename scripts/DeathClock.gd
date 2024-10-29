extends Timer
# TODO Change name?

signal createSnow

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("timeout", _on_timer_timeout)
	
func _on_timer_timeout():
	emit_signal("createSnow")
