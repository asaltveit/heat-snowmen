extends ColorRect

# Only for pause menu and level complete menu, currently

@onready var menu = $"."
@onready var level_title = $Container/Border/Title
@onready var animationPlayer = $OpenMenuAnimation
@onready var level = $"../../.."

@onready var continueButton = $Container/Border/FooterButtons/ContinueButton

@onready var statsContainer = $Container/Border/Stats


signal openSettingsMenu
signal openHelpMenu

signal stopDeathClock
signal startDeathClock

signal stopLevelCountdownClock
signal startLevelCountdownClock

signal setStats

# TODO Where does the eye go? To a middle or right continue button?
# TODO Continue button needs to stand out more
#	- Should it be a setting/flag in the button
#	- Or a different "important" button?

# TODO Have restart button with just icon and tooltip
#	Have it btw a home button and start?
# TODO Have help instructions specific to each level show before it,
#	be able to open them in the game directly? 
#	Or still go to primary menu?
# That's a lot of buttons to have

# TODO Use resources instead of this:
var statLabels = ['Time:', 'Total Snowmen:']


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
	

func createStats(final_time, final_num_snowmen):
	for label in statLabels:
		var stat = preload("res://scenes/stat.tscn").instantiate()
		print(stat)
		statsContainer.add_child(stat)
		stat.get_node("Label").text = label
		# TODO Use resource to set
		if label == statLabels[0]:
			stat.get_node("Value").text = str(final_time)
		else:
			stat.get_node("Value").text = str(final_num_snowmen)


func open_menu(final_time, final_num_snowmen):
	# stop all of the clocks/timers
	emit_signal("stopDeathClock")
	emit_signal("stopLevelCountdownClock")
	
	get_tree().paused = true
	menu.visible = true
	animationPlayer.play("RESET")
	
	createTitle()
	# TODO change tabbing cycle (?)
	continueButton.grab_focus()
	
	Game.previous_popup = Game.primaryMenuType
	
	# TODO Set appropriate stats using a resource/resources
	createStats(final_time, final_num_snowmen)

	# Set fields
	#timeCompletedValue.text = str(final_time)
	#snowmenValue.text = str(final_num_snowmen)


func _on_continue_button_pressed():
	# Turn on clocks/timers
	emit_signal("startDeathClock")
	# Only start if it was going
	if Game.level_time_remaining > 0:
		emit_signal("startLevelCountdownClock")
	
	get_tree().paused = false
	menu.visible = false
	
	if Game.primaryMenuType == "levelComplete":
		# Can just reload with new resource
		Game.current_level += 1
		get_tree().reload_current_scene()

func _on_restart_button_pressed():
	# Reset for level count down timer
	Game.level_time_remaining = Game.level_time_limit
	
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

