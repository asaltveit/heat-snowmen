extends Timer

signal exceedsLevelTimeLimit

# TODO show countdown on screen
#	Don't let snow or snowmen overlap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

func _on_timeout():
	Game.level_time_limit -= 1
	print(Game.level_time_limit)
	if Game.level_time_limit <= 0:
		emit_signal("exceedsLevelTimeLimit")
		# If you don't explicitly stop it, it restarts
		self.stop()
	else:
		self.start()
