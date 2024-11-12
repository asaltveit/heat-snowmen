extends Node

# If you lose, you have to repeat the level before continuing
#	disbaled button here? with text saying you have to win to
#	continue?
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

# Add a game ending scene (when player is out of levels)
#	Plus an option to go back into other levels

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

# TODO Add a theme/style for focused on gun?
# TODO Add tabbing between gun and a possible pause button
#	(instead of hitting "p"?)
# possible tab and enter, or always focussed on gun and enter
# 	to shoot?
# TODO Add to settings

# Create new snowmen
@onready var deathClock = $DeathClock
# Level Countdown Timer
@onready var levelCountdownTimer = $LevelCountDown

@onready var level = $".."

# Primary Menu (for pause or level completed)
@onready var primaryMenu = $PrimaryMenu/Menu
@onready var primaryMenuContinueButton = $"PrimaryMenu/Menu/Container/ContinueButton"
@onready var primaryMenuRestartButton = $"PrimaryMenu/Menu/Container/RestartButton"
# Start screen
@onready var startScreen = $start_screen
@onready var startScreenNode = $start_screen/Menu
@onready var startButton = $start_screen/Menu/InnerRectangle/StartButton
# Internal menus
@onready var settingsMenu = $Settings
@onready var helpMenu = $Help
@onready var chooseLevelMenu = $ChooseLevelMenu
# Fail Menu
@onready var failMenu = $FailMenu
@onready var failMenuNode = $FailMenu/Menu
@onready var failMenuRestartButton = $"FailMenu/Menu/RestartButton"

# Shows level count down
@onready var TimerLabel = $TimerLabel

signal openSettingsMenu
signal openHelpMenu
signal openFailMenu
signal openChooseLevelMenu

func _on_ready():
	# Only show start screen on first level+not on restart
	if not Game.show_start_screen: # or Game.current_level > 0
		startScreenNode.visible = false
		deathClock.start()
		if Game.level_time_limit > 0:
			TimerLabel.visible = true
			levelCountdownTimer.start()
	
	primaryMenu.openSettingsMenu.connect(open_settings_menu)
	primaryMenu.openHelpMenu.connect(open_help_menu)
	
	primaryMenu.stopDeathClock.connect(stop_death_clock)
	primaryMenu.startDeathClock.connect(start_death_clock)
	primaryMenu.stopLevelCountdownClock.connect(stop_level_countdown_clock)
	primaryMenu.startLevelCountdownClock.connect(start_level_countdown_clock)
	
	failMenu.openSettingsMenu.connect(open_settings_menu)
	failMenu.openHelpMenu.connect(open_help_menu)
	
	failMenu.stopDeathClock.connect(stop_death_clock)
	failMenu.startDeathClock.connect(start_death_clock)
	failMenu.stopLevelCountdownClock.connect(stop_level_countdown_clock)
	failMenu.startLevelCountdownClock.connect(start_level_countdown_clock)
	
	startScreen.openSettingsMenu.connect(open_settings_menu)
	startScreen.openChooseLevelMenu.connect(open_choose_level_menu)
	startScreen.openHelpMenu.connect(open_help_menu)
	startScreen.startGame.connect(start_game)
	
	settingsMenu.goToPreviousPopup.connect(go_to_previous_popup)
	helpMenu.goToPreviousPopup.connect(go_to_previous_popup)
	chooseLevelMenu.goToPreviousPopup.connect(go_to_previous_popup)
	chooseLevelMenu.startGame.connect(start_game)
	
	levelCountdownTimer.exceedsLevelTimeLimit.connect(level_out_of_time)
	

# TODO Better way to toggle the clocks?
# snow creation timer	
func stop_death_clock():
	deathClock.stop()
	
func start_death_clock():
	deathClock.start()

func stop_level_countdown_clock():
	levelCountdownTimer.stop()
	
func start_level_countdown_clock():
	levelCountdownTimer.start()
	
func level_out_of_time():
	# TODO Add separate help menu instructions
	print("You ran out of time to defeat the snowmen!")
	Game.fail_message_type = 1
	emit_signal("openFailMenu")

# Only for start screen and choose_level_menu
func start_game():
	Game.show_start_screen = false
	# Creates snow (which then creates snowmen)
	start_death_clock()
	# Check if using countdown for this level
	if Game.level_time_limit > 0:
		TimerLabel.visible = true
		levelCountdownTimer.start()
	
# secondary menus - TODO func open_secondary_menu(previous, openSignal)
func open_settings_menu():
	# TODO slim this down
	emit_signal("openSettingsMenu")
	
func open_help_menu():
	# TODO slim this down
	emit_signal("openHelpMenu")
	
func open_choose_level_menu():
	emit_signal("openChooseLevelMenu")

# TODO Add tests to make sure only correct popup is visible
# TODO Add access to choose_level_menu other places than start_screen
func go_to_previous_popup():
	if Game.previous_popup == "start":
		startScreenNode.visible = true
		# TODO Move these into the actual scene?
		startButton.grab_focus()
	elif Game.previous_popup == "pause" or Game.previous_popup == "levelComplete":
		primaryMenu.visible = true
		primaryMenuContinueButton.grab_focus()
	elif Game.previous_popup == "fail":
		failMenuNode.visible = true
		failMenuRestartButton.grab_focus()
	else:
		print("Error: No previous popup - ", Game.previous_popup)
	
# TODO Do something with this?
func _on_level_count_down_timeout():
	pass # Replace with function body.
