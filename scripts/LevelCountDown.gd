extends Timer

signal exceedsLevelTimeLimit

# TODO show countdown on screen
#	Don't let snow or snowmen overlap
	
func _process(_delta):
	#print("")
	pass
	
func _on_timeout():
	Game.level_time_remaining -= 1
	print("Game.level_time_remaining: ", Game.level_time_remaining)
	if Game.level_time_remaining <= 0:
		emit_signal("exceedsLevelTimeLimit")
		# If you don't explicitly stop it, it restarts
		self.stop()
	else:
		self.start()
