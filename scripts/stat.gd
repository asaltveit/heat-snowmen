extends ColorRect

@onready var primaryMenuMenu = $"../../../.."
# These get set with the last set values
@onready var label = $Label
@onready var value = $Value


func _ready():
	primaryMenuMenu.setStats.connect(set_stats)
	

# TODO Will I be able to connect this to something?
func set_stats(l, v):
	label.text = l
	value.text = v
