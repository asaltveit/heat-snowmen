extends Node

# How to lose? Or game end?
#	1 Get overrun by snowmen - have a limit, 100? 50?
#		Have an if in the creation func to skip if over limit
#	2 Have a time limit? - 3 minutes?
#		If making harder levels, can have short time limits (30s?)
#		If hit a good guy - increase time?
#	3 Have lives - lose if hit good guy? 
#		Something you don't want to melt - ice cream? popsicle?
#			Something summery, that you don't want to go away?
# 3/4 You get all icecreams that you haven't hit at the end
# so trying to keep ice creams

# so 3/4 level types: time limit, # snowmen before getting rid of all?,
# icecream - add time, collect icecream

# TODO Add to resources:
# 	ice cream - number, locations, penalty?
# 	countdown timer limit
# 	background type

# Should there be a way to choose a level?
#	Instead of always playing through

# Design the menus based on game theme
	# Decide whether you're stopping the arrival of winter
	# Or hurrying up the arrival of spring

# Figure out all legal stuff for assets

# Create new snowmen
@onready var deathClock = $DeathClock
# Level Countdown Timer
@onready var levelCountdownTimer = $LevelCountDown
# Level Completed menu
@onready var level = $".."
@onready var levelComplete = $LevelCompleteMenu
@onready var levelCompleteMenu = $"LevelCompleteMenu/Menu"
# Menu fields
@onready var timeCompletedValue = $LevelCompleteMenu/Menu/Container/TimeElapsed/Value
@onready var snowmenValue = $LevelCompleteMenu/Menu/Container/Snowmen/Value
@onready var levelValue = $LevelCompleteMenu/Menu/Container/Level/Value
# Pause menu
@onready var pauseMenu = $"PauseMenu" # ?
@onready var pauseMenuNode = $"PauseMenu/Menu" # ?
@onready var pauseMenuContinueButton = $"PauseMenu/Menu/Container/ContinueButton"
@onready var pauseMenuRestartButton = $"PauseMenu/Menu/Container/RestartButton"
# Start screen
@onready var startScreen = $start_screen
@onready var startScreenNode = $start_screen/Menu
# Internal menus
@onready var settingsMenu = $Settings
@onready var helpMenu = $Help

signal openSettingsMenu
signal openHelpMenu

func _on_ready():
	# Only show start screen on first level+not on restart
	if not Game.show_start_screen: # or Game.current_level > 0
		startScreenNode.visible = false
		deathClock.start()
	
	levelComplete.openSettingsMenu.connect(open_settings_menu)
	levelComplete.openHelpMenu.connect(open_help_menu)
	levelComplete.startDeathClock.connect(start_death_clock)
	levelComplete.stopDeathClock.connect(stop_death_clock)
	
	pauseMenu.openSettingsMenu.connect(open_settings_menu)
	pauseMenu.openHelpMenu.connect(open_help_menu)
	pauseMenu.stopDeathClock.connect(stop_death_clock)
	pauseMenu.startDeathClock.connect(start_death_clock)
	
	startScreen.openSettingsMenu.connect(open_settings_menu)
	startScreen.openHelpMenu.connect(open_help_menu)
	startScreen.startGame.connect(start_game)
	
	settingsMenu.goToPreviousPopup.connect(go_to_previous_popup)
	helpMenu.goToPreviousPopup.connect(go_to_previous_popup)
	
	levelCountdownTimer.exceedsLevelTimeLimit.connect(level_out_of_time)
	

# snow creation timer	
func stop_death_clock():
	deathClock.stop()
	
func start_death_clock():
	deathClock.start()
	
func level_out_of_time():
	# TODO popup
	# TODO separate help menu instructions
	print("You ran out of time to defeat the snowmen!")

# Only for start screen?
func start_game():
	Game.show_start_screen = false
	# Creates snow (which then creates snowmen)
	start_death_clock()
	# Check if using countdown for this level
	if Game.level_time_limit > 0:
		levelCountdownTimer.start()
	
# secondary menus - TODO func open_secondary_menu(previous, openSignal)
func open_settings_menu(previous):
	Game.previous_popup = previous
	emit_signal("openSettingsMenu")
	
func open_help_menu(previous):
	Game.previous_popup = previous
	emit_signal("openHelpMenu")

# TODO Add tests to make sure only correct popup is visible
func go_to_previous_popup():
	if Game.previous_popup == "start":
		startScreenNode.visible = true
	elif Game.previous_popup == "settings":
		# Needed?
		pass
	elif Game.previous_popup == "help":
		# Needed?
		pass
	elif Game.previous_popup == "pause":
		pauseMenuNode.visible = true
	elif Game.previous_popup == "level":
		levelCompleteMenu.visible = true
	else:
		print("Error: No previous popup")
	
	
