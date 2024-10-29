extends Timer

signal levelOutOfTime

# TODO not currently doing anything?

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("timeout", _on_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_timer_timeout():
	emit_signal("levelOutOfTime")
