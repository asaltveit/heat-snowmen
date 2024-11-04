extends Node2D

signal openLevelMenu
signal openPrimaryMenu
signal openFailMenu

@onready var settings = $GameManager/Settings

# TODO Add something not to hit (ice cream? Something good and frozen?)
# if hit, adds time to score/final_time?
# TODO store previous final times

# load all of the resources, then just index with the level number?
# TODO fix later

# Have to remember to include new levels here
const LEVELS_LIST: Array[LevelParameters] = [
	preload("res://scripts/resources/level_1.tres"),
	preload("res://scripts/resources/level_2.tres"),
	preload("res://scripts/resources/level_3.tres")
]

# For snow creation
var rand_y
var rand_x

# For level
var numSnowmen = 0 # can decrease (and increase)
var final_time = ""
var final_num_snowmen = 0 # only increase
var level_start_time

# Limits - Could change based on level in future
var snowmenLimit = 5 # 20
var gameTimeLimit = 300 # 5x60 seconds = 5 minutes

# Is this separately needed?
var bg_music_on = false

@onready var deathClock = $GameManager/DeathClock
# Max limit
@onready var levelTimer = $GameManager/LevelTimer

# This is level now, is it needed?
@onready var level = $'.'

@onready var iceBGSound = $IceBGSound
@onready var player = $"heat-gun"

@onready var startScreen = $GameManager/start_screen
@onready var gameManager = $GameManager

var allowLevelComplete = false
var locations = [Vector2(274, 181), Vector2(100, 181)]


func _ready():
	# For testing icecream
	# create_icecream()
	
	# Level doesn't exist - default parameters
	if Game.current_level >= len(LEVELS_LIST):
		create_starting_snowmen(locations)
	else:
		# Set level parameters
		var levelParameters = LEVELS_LIST[Game.current_level]
		create_starting_snowmen(levelParameters.snowmen_locations)
		deathClock.wait_time = levelParameters.snow_time
		Game.snowman_creation_timer_wait_time = levelParameters.snowmen_time
		
	deathClock.createSnow.connect(create_random_snow)
	settings.toggleBgMusic.connect(toggle_bg_music)
	
	# Only when level starts - needed?
	if Game.bg_music_on:
		iceBGSound.play()

	level_start_time = Time.get_ticks_msec()
	
func toggle_bg_music():
	# Just got toggled on
	if Game.bg_music_on:
		iceBGSound.play()
	# Just got toggled off
	else:
		iceBGSound.stop()

func create_random_snow():
	var snow = preload("res://scenes/Snow.tscn").instantiate()
	rand_y = randf_range(0, 500) # H=648
	rand_x = randf_range(0, 1100) # W=1152
	# TODO: Don't spawn beyond/on boundaries
	snow.global_position = Vector2(rand_x, rand_y)
	add_child(snow)
	snow.createSnowman.connect(create_snowman)
	
func create_icecream():
	var icecream = preload("res://scenes/ice_cream.tscn").instantiate()
	icecream.global_position = Vector2(600, 300)
	add_child(icecream)
	
func create_starting_snowmen(locs = []):
	# Create snowmen in locations
	for pos in locs:
		create_snowman(pos)
	# allow level complete check / allows player to win
	allowLevelComplete = true
	
func create_snowman(pos):
	# for now,
	# each snowflake has a timer
	# on timeout, snowman appears
	# TODO should have a check for any snowmen too close/overlapping
	# check for snowman on borders/boundaries
	
	var snowman = preload("res://scenes/Snowman.tscn").instantiate()
	# TODO: Don't spawn beyond/on boundaries
	# TODO: Bottom right corner of snowman on snow center currently
	snowman.global_position = pos #Vector2(x, y)
	add_child(snowman)
	
	snowman.decreaseSnowmen.connect(decrease_num_snowmen)
	increase_num_snowmen()
	
func decrease_num_snowmen():
	numSnowmen -= 1
	
func increase_num_snowmen():
	numSnowmen += 1
	final_num_snowmen += 1

func get_final_time():
	# TODO: Doesn't pause when game pauses
	# Time to complete in seconds
	var time_taken = (Time.get_ticks_msec() - level_start_time) / 1000.0 # Convert to seconds
	var time_rounded = str(roundf(time_taken)) + " secs"
	# TODO Put in Game vars?
	final_time = time_rounded

func _process(_delta):
	# Needed?
	#if not Game.bg_music_on:
		#iceBGSound.stop()
	if Input.is_action_just_pressed("pause"):
		get_final_time()
		Game.primaryMenuType = "pause"
		emit_signal("openPrimaryMenu", final_time, final_num_snowmen)
	#Possibly should be elif?
	if not allowLevelComplete:
		pass
	elif numSnowmen <= 0:
		get_final_time()
		Game.primaryMenuType = "levelComplete"
		emit_signal("openPrimaryMenu", final_time, final_num_snowmen)
	elif numSnowmen >= snowmenLimit:
		Game.fail_message_type = 1
		emit_signal("openFailMenu")
		print("You lost! You've been overrun with snowmen!")
		#get_tree().paused = true
		
func _on_ice_bg_sound_finished():
	iceBGSound.play()
