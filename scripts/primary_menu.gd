extends ColorRect

# Only for pause menu and level complete menu, currently

@onready var menu = $"."
@onready var level_title = $Container/Title
@onready var animationPlayer = $OpenMenuAnimation
@onready var level = $"../../.."

@onready var timeCompletedValue = $Container/TimeElapsed/Value
@onready var snowmenValue = $Container/Snowmen/Value
@onready var levelValue = $Container/Level/Value


signal openSettingsMenu
signal openHelpMenu

signal stopDeathClock
signal startDeathClock

signal stopLevelCountdownClock
signal startLevelCountdownClock

func _ready():
	level.openPrimaryMenu.connect(open_menu)
	
func createTitle():
	if Game.primaryMenuType == "pause":
		# Game.current_level used to index an array (starts at 0)
		level_title.text = "Level " + str(Game.current_level+1) + " Paused"
	elif Game.primaryMenuType == "levelComplete":
		level_title.text = "Level " + str(Game.current_level+1) + " Complete!"
	else:
		level_title.text = "Menu" # Just in case

func open_menu(final_time, final_num_snowmen, final_level):
	# stop all of the clocks/timers
	emit_signal("stopDeathClock")
	emit_signal("stopLevelCountdownClock")
	
	get_tree().paused = true
	menu.visible = true
	animationPlayer.play("RESET")
	
	createTitle()

	# Set fields
	timeCompletedValue.text = str(final_time)
	snowmenValue.text = str(final_num_snowmen)
	levelValue.text = str(final_level)


func _on_continue_button_pressed():
	# Turn on clocks/timers
	# TODO separate function?
	emit_signal("startDeathClock")
	# TODO Only start if it was going
	# TODO What if it just got to 0 before pause?
	if Game.level_time_limit > 0:
		emit_signal("startLevelCountdownClock")
	
	get_tree().paused = false
	menu.visible = false
	if Game.primaryMenuType == "levelComplete":
		# Can just reload with new resource
		Game.current_level += 1
		get_tree().reload_current_scene()

func _on_restart_button_pressed():
	# Turn on clocks/timers
	emit_signal("startDeathClock")
	if Game.level_time_limit > 0:
		emit_signal("startLevelCountdownClock")
	
	get_tree().paused = false
	menu.visible = false
	# Restart current scene
	get_tree().reload_current_scene()

func _on_settings_button_pressed():
	emit_signal("openSettingsMenu")
	menu.visible = false

func _on_help_button_pressed():
	emit_signal("openHelpMenu")
	menu.visible = false

