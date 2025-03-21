extends Timer

signal exceedsLevelTimeLimit

@onready var LevelTimerValue = $"../TimerLabel/InnerRectangle/TimeLeftValue"


func _process(_delta):
	pass
	
func _on_timeout():
	Game.level_time_remaining -= 1
	LevelTimerValue.text = str(Game.level_time_remaining) + "s"
	print("Game.level_time_remaining: ", Game.level_time_remaining)
	if Game.level_time_remaining <= 0:
		emit_signal("exceedsLevelTimeLimit")
		# If you don't explicitly stop it, it restarts
		self.stop()
	else:
		self.start()
		
