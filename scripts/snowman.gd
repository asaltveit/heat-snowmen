extends CharacterBody2D


@onready var sprite = $Sprite
#@onready var gameManager = $Game/GameManager

var snowmanLives = 3

@onready var livesLabel = $LivesLabel

@onready var deepDyingSound = $DeepDyingSound
@onready var longDyingSound = $LongDyingSound

@onready var deathTimer = $DeathTimer

@onready var animationPlayer = $AnimationPlayer
@onready var shape = $CollisionShape2D

signal decreaseSnowmen

func _ready():
	# Allows each snowman to flash individually
	sprite.material = sprite.material.duplicate()

func _physics_process(_delta):
	pass
	
func lose_life():
	snowmanLives -= 1
	livesLabel.text = str(snowmanLives)

func play_random_dying_sound():
	# Can add more sounds by changing pitch
	# 0 or 1
	if (randi() % 2):
		deepDyingSound.play()
	else:
		longDyingSound.play()
	
func hit():
	# TODO: animation is too slow, 
	# doesn't happen after the first if bullets hit quickly
	animationPlayer.play("hurt")
	# snowman health decreases
	lose_life() # should life decrease when already dead?
	if Game.sounds_on:
		play_random_dying_sound() # should it speak when dead?
	if snowmanLives <= 0:
		# start death timer
		deathTimer.start()
		# Above allows stuff to happen before the snowman disappears
		 
func _on_death_timer_timeout():
	emit_signal("decreaseSnowmen")
	# Removes Snowman
	queue_free()

# Doesn't stay red if animation paused part way
func _on_animation_player_animation_finished(_anim_name):
	sprite.modulate = Color(1,1,1,1)
