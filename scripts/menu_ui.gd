extends CanvasLayer

@onready var level = $"../.."
@onready var menu = $Menu
@onready var level_title = $Menu/Container/Label
@onready var animationPlayer = $Menu/LevelCompleteMenuAnimation

@onready var timeCompletedValue = $Menu/Container/TimeElapsed/Value
@onready var snowmenValue = $Menu/Container/Snowmen/Value
@onready var levelValue = $Menu/Container/Level/Value

signal startNextLevel
signal startDeathClock
signal stopDeathClock
signal openSettingsMenu
signal openHelpMenu

func _ready():
	# Game.current_level indexes an array, so starts at 0
	level_title.text = "Level " + str(Game.current_level+1) + " Complete!"
	level.openLevelMenu.connect(open_level_complete_menu)

# TODO compare current level and all-time high score?
func open_level_complete_menu(final_time, final_num_snowmen, final_level):
	emit_signal("stopDeathClock")
	get_tree().paused = true
	menu.visible = true
	animationPlayer.play("RESET")
	
	timeCompletedValue.text = str(final_time)
	snowmenValue.text = str(final_num_snowmen)
	levelValue.text = str(final_level)


# TODO Switch order of buttons (?)
func _on_continue_button_pressed():
	print("level menu continue pressed")
	# TODO rename to next level button?
	emit_signal("startDeathClock")
	get_tree().paused = false
	menu.visible = false
	# Can just reload with new resource
	Game.current_level += 1
	get_tree().reload_current_scene()
	
func _on_restart_button_pressed():
	get_tree().paused = false
	menu.visible = false
	# Restart current scene
	get_tree().reload_current_scene()


func _on_settings_button_pressed():
	emit_signal("openSettingsMenu", "level")
	menu.visible = false


func _on_help_button_pressed():
	emit_signal("openHelpMenu", "level")
	menu.visible = false
