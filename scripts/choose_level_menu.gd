extends CanvasLayer

# TODO make a reusable menu for settings, help, choose level menus
@onready var menu = $Menu
@onready var backButton = $Menu/BackButton
@onready var gameManager = $".."

signal goToPreviousPopup
signal startGame

# Called when the node enters the scene tree for the first time.
func _ready():
	gameManager.openChooseLevelMenu.connect(open_choose_level_menu)

	for level in Game.all_levels:
		# TODO button width, height, placement
		var button = preload("res://scenes/primary_menu_button.tscn").instantiate()
		add_child(button)
		button.pressed.connect(go_to_level.bind(button))
		var x = 100+(200*level)
		var y = 100+(100*level)
		button.global_position = Vector2(x, y)
		button.text = "Level " + str(level)
		button.set_meta("level", int(level))


func go_to_level(button):
	Game.current_level = button.get_meta("level")
	get_tree().paused = false
	self.visible = false
	emit_signal("startGame")
	# Restart current scene
	get_tree().reload_current_scene()
	

func open_choose_level_menu():
	self.visible = true
	menu.visible = true
	backButton.grab_focus()

func _on_back_button_pressed():
	self.visible = false
	emit_signal("goToPreviousPopup")
