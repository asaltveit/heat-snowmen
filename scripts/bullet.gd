extends CharacterBody2D

var direction = Vector2()
var speed = 1.0

# length of bullet depends on how long space button is held?
func _ready():
	pass

func _physics_process(delta):
	# speed increases each second, if multiplied
	velocity = direction
	var collision = move_and_collide(velocity * delta)
	if collision:
		# TODO: have bullets face correct direction
		# hit wall
		if collision.get_collider().name == "Boundaries":
			direction = velocity.bounce(collision.get_normal()) # velocity.bounce(collision.get_normal())
			velocity = direction
			look_at(global_position + velocity) # global_
	
		else:
			_on_body_entered(collision.get_collider())

func _on_body_entered(body):
	if body.has_method("hit"):
		#print("has hit " + body.name)
		body.hit()
	# removes bullet
	queue_free()
