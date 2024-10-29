extends CharacterBody2D

# Gun
@onready var animationPlayer = $AnimationPlayer
# Bullets
@export var bullet : CharacterBody2D
@onready var pew = $pew

var final_time = ""
var final_num_snowmen = 1
var final_level = 1
var level_start_time

func _ready():
	# TODO fix placement, arm rotation
	# TODO should change the animation name
	# It moves the orange gun arm
	$AnimationPlayer.play("RESET")
	

# TODO make game screen bigger - at least taller
func shoot(speed = 1.0):
	bullet = load("res://scenes/Bullet.tscn").instantiate()
	#var rotation = $"orange-rectangle/Muzzle".global_rotation 
	# It's a bit to the side instead of straight up?
	bullet.global_position = $"orange-rectangle".global_position.rotated($"orange-rectangle/Muzzle".global_rotation)
	bullet.direction = $"orange-rectangle/Muzzle".global_position-$"orange-rectangle".global_position
	bullet.global_transform = $"orange-rectangle/Muzzle".global_transform
	bullet.speed = speed
	get_parent().add_child(bullet)
	if Game.sounds_on:
		pew.play()
	
func _physics_process(_delta): 
	get_input()
		
func get_input():
	if Input.is_action_just_pressed("shoot"):
		# Nothing for now
		# Could choose bullet speed?
		#shoot(3.0)
		pass
	if Input.is_action_just_released("shoot"):
		# Perhaps it just never stops moving
		shoot(10)
		
