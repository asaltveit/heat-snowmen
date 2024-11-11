extends CanvasLayer

# TODO make a reusable menu for settings, help, choose level menus
@onready var menu = $Menu
@onready var backButton = $Menu/BackButton
@onready var gameManager = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	gameManager.openChooseLevelMenu.connect(open_choose_level_menu)
	
	for level in Game.all_levels:
		var button = Button.new() # or create a button scene instead
		button.pressed.connect(go_to_level)
		button.position = Vector2(300, 100+100*level)
		add_child(button)

func go_to_level():
	Game.current_level = int(self.text.split(' ')[1])
	get_tree().paused = false
	menu.visible = false
	# Restart current scene
	get_tree().reload_current_scene()
	

func open_choose_level_menu():
	menu.visible = true
	backButton.grab_focus()

func _on_back_button_pressed():
	menu.visible = false
	emit_signal("goToPreviousPopup")
