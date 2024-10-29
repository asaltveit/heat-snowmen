extends CharacterBody2D

@onready var sprite = $Sprite

func _ready():
	# Allow each ice cream to have it's own color loop?
	#sprite.material = sprite.material.duplicate()
	# no material - could be animation
	pass
	
func hit():
	# TODO add error noise
	# TODO decrease num icecreams?
	print("hit an ice cream")
	queue_free()
