extends CanvasLayer

# TODO Add fail menu resource - failure text

@onready var failureText = $Menu/FailureText
@onready var menu = $Menu
@onready var restartButton = $Menu/RestartButton
@onready var gameManager = $".."
@onready var level = $"../.."

const messages = ["Oh No! You were overrun by snowmen!", "You ran out of time to defeat the snowmen!"]

# TODO Make this more reusable with the primary menu and start screen
signal openSettingsMenu
signal openHelpMenu

signal stopDeathClock
signal startDeathClock

signal stopLevelCountdownClock
signal startLevelCountdownClock


func _ready():
	gameManager.openFailMenu.connect(open_menu)
	level.openFailMenu.connect(open_menu)

func open_menu():
	# stop all of the clocks/timers
	emit_signal("stopDeathClock")
	emit_signal("stopLevelCountdownClock")
	
	Game.previous_popup = "fail"
	
	failureText.text = messages[Game.fail_message_type]
	
	get_tree().paused = true
	menu.visible = true
	$Menu/AnimationPlayer.play("reveal")

	restartButton.grab_focus()

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
