extends CanvasLayer

# TODO Add fail menu resource - failure text

@onready var failureText = $Menu/FailureText
@onready var menu = $Menu
@onready var restartButton = $Menu/RestartButton
@onready var gameManager = $".."
@onready var level = $"../.."

const messages = ["Oh No! You were overrun by snowmen!", "You ran out of time to defeat the snowmen"]

# TODO Make this more reusable with the primary menu and start screen
signal openSettingsMenu
signal openHelpMenu

signal stopDeathClock
signal startDeathClock

signal stopLevelCountdownClock
signal startLevelCountdownClock

# Called when the node enters the scene tree for the first time.
func _ready():
	failureText.text = messages[Game.fail_message_type]
	gameManager.openFailMenu.connect(open_menu)
	level.openFailMenu.connect(open_menu)


func open_menu():
	# stop all of the clocks/timers
	emit_signal("stopDeathClock")
	emit_signal("stopLevelCountdownClock")
	
	Game.previous_popup = "fail"
	
	get_tree().paused = true
	menu.visible = true
	$Menu/AnimationPlayer.play("reveal")

	restartButton.grab_focus()

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
