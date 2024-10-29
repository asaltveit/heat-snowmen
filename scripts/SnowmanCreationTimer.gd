extends Timer
# Is this connected to the correct timer?

signal createSnowman(pos)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("timeout", _on_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_timer_timeout():
	# TODO switch to observer signal
	emit_signal("createSnowman", $".".global_position)
	# aiming for "game" as grandparent
	#get_parent().get_parent().create_random_snow()
	#pass
