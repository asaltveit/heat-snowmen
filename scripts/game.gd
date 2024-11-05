extends Node2D

# TODO How many autoload variables are needed/normal?

# For scene switching
var current_scene = null

var previous_popup = "start"

# For level labels and indexing level resources
var current_level = 0

# Toggle sound/music in settings
var bg_music_on = true
var sounds_on = true

# Whether to show start screen
var show_start_screen = true

# Accessed in snow when starting timer
var snowman_creation_timer_wait_time = 10

var primaryMenuType = "" # "pause", "levelComplete"

# For fail menus
var fail_message_type = 0 # To index messages, 0 or 1

# For level types
# TODO set these from level resource
# TODO succeed within time limit and shortest time level type
# need a var for level type? or just 0 in one and not 0 in the other?

# If 0, timer won't run
var level_time_limit = 15 # in seconds? so 300 = 5 minutes?
# Need to keep the limit known, so decrease below instead
var level_time_remaining = 15
# TODO don't hit the icecream level type
var total_icecream = 0

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path, level=0):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", path)
	# A num
	current_level = level
	

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene.
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
	
func toggle_bg_music():
	bg_music_on = not bg_music_on
	
func toggle_sounds():
	sounds_on = not sounds_on
