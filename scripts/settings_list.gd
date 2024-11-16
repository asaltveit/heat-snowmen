extends VBoxContainer

@onready var soundsButton = $SoundContainer/Toggle
@onready var bgMusicButton = $BGMusicContainer/Toggle

# Called when the node enters the scene tree for the first time.
func _ready():
	soundsButton.text = "on" if Game.sounds_on else "off"
	bgMusicButton.text = "on" if Game.bg_music_on else "off"


func _on_sounds_toggle_toggled(toggled_off):
	Game.toggle_sounds()
	if toggled_off:
		soundsButton.text = "off"
	else:
		soundsButton.text = "on"


func _on_bg_music_toggle_toggled(toggled_off):
	Game.toggle_bg_music()
	emit_signal("toggleBgMusic")
	if toggled_off:
		bgMusicButton.text = "off"
	else:
		bgMusicButton.text = "on"


