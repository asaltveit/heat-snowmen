extends CanvasLayer

@onready var menu = $"Menu"
@onready var pauseMenuAnimation = $PauseMenuAnimation
@onready var level = $"../.."

@onready var timeCompletedValue = $Menu/Container/TimeElapsed/Value
@onready var snowmenValue = $Menu/Container/Snowmen/Value
@onready var levelValue = $Menu/Container/Level/Value

@onready var title_label = $Menu/Container/Label

signal openSettingsMenu
signal openHelpMenu
signal stopDeathClock
signal startDeathClock

func _ready():
	level.openPauseMenu.connect(open_pause_menu)
	# Game.current_level used to index an array (starts at 0)
	title_label.text = "Level " + str(Game.current_level+1) + " Paused"
	

func open_pause_menu(final_time, final_num_snowmen, final_level):
	emit_signal("stopDeathClock")
	get_tree().paused = true
	menu.visible = true
	pauseMenuAnimation.play("pause")

	timeCompletedValue.text = str(final_time)
	snowmenValue.text = str(final_num_snowmen)
	levelValue.text = str(final_level)

# TODO Switch order of buttons
func _on_continue_button_pressed():
	emit_signal("startDeathClock")
	get_tree().paused = false
	menu.visible = false

func _on_restart_button_pressed():
	emit_signal("startDeathClock")
	get_tree().paused = false
	menu.visible = false
	# Restart current scene
	get_tree().reload_current_scene()

func _on_settings_button_pressed():
	emit_signal("openSettingsMenu", "pause")
	menu.visible = false

func _on_help_button_pressed():
	emit_signal("openHelpMenu", "pause")
	menu.visible = false
