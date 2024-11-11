extends Area2D

# TODO: could add good guys/something not to
# be hit to avoid tons of bullets

signal createSnowman

@onready var snowmanCreationTimer = $SnowmanCreationTimer


func hit():
		# removes snow
		queue_free() 

func _on_body_entered(body):
	if body.name != "Boundaries":
		hit()

func _on_ready():
	snowmanCreationTimer.wait_time = Game.snowman_creation_timer_wait_time
	snowmanCreationTimer.start()

func _on_snowman_creation_timer_timeout():
	emit_signal("createSnowman", self.position) # or self.global_position?
