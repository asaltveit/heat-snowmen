extends CanvasLayer

# TODO make a reusable menu for settings, help, choose level menus
@onready var menu = $Menu
@onready var backButton = $Menu/InnerRectangle/BackButton
@onready var gridContainer = $Menu/InnerRectangle/ScrollContainer/GridContainer
@onready var gameManager = $".."

signal goToPreviousPopup
signal startGame

func _ready():
	gameManager.openChooseLevelMenu.connect(open_choose_level_menu)
	Game.all_levels = 20 # To test grid
	for level in Game.all_levels:
		var button = preload("res://scenes/primary_menu_button.tscn").instantiate()
		gridContainer.add_child(button)
		button.pressed.connect(go_to_level.bind(button))
		button.tooltip_text = "Choose level"
		button.text = "Level " + str(level+1)
		button.set_meta("level", int(level))


func go_to_level(button):
	Game.current_level = button.get_meta("level")
	get_tree().paused = false
	menu.visible = false
	emit_signal("startGame")
	# Restart current scene
	get_tree().reload_current_scene()
	

func open_choose_level_menu():
	menu.visible = true
	backButton.grab_focus()


func _on_back_button_pressed():
	menu.visible = false
	emit_signal("goToPreviousPopup")
