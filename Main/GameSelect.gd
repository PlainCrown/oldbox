extends Control

"""Controls all the buttons in the game select menu."""

onready var music_slider := $MusicSlider
onready var sfx_slider := $SFXSlider
onready var fullscreen_check := $FullscreenCheck
onready var blockcrasher_animation = $BlockCrasherCenter/BlockCrasherAnimation
onready var foodeater_animation = $FoodEaterCenter/FoodEaterAnimation
onready var shapeplacer_animation = $ShapePlacerCenter/ShapePlacerAnimation
onready var audio_player := $AudioStreamPlayer

var playing := true


func _ready() -> void:
	"""Sets all of the game select menu values to the values stored in the autoload."""
	music_slider.value = Autoload.music_volume
	sfx_slider.value = Autoload.sfx_volume
	fullscreen_check.pressed = Autoload.fullscreen
	blockcrasher_animation.play("pulse")
	foodeater_animation.play("pulse")
	shapeplacer_animation.play("pulse")
	"""Prevents the sound effect test sound from playing as soon as the game starts."""
	playing = false


func _on_MusicSlider_value_changed(value: int) -> void:
	"""Changes the music volume."""
	Autoload.music_volume = value


func _on_SFXSlider_value_changed(value: int) -> void:
	"""Changes the sound effect volume."""
	Autoload.sfx_volume = value
	audio_player.volume_db = Autoload.sfx_volume
	if not playing:
		playing = true
		audio_player.play()


func _on_AudioStreamPlayer_finished() -> void:
	"""Prevents the sound effect test from playing again until the previous test has finished."""
	playing = false


# warning-ignore:unused_argument
func _on_FullscreenCheck_toggled(button_pressed: InputEventMouse) -> void:
	"""Switches the fullscreen mode on and off."""
	OS.window_fullscreen = !OS.window_fullscreen
	Autoload.fullscreen = !Autoload.fullscreen


func _on_BlockCrasherButton_pressed() -> void:
	"""Opens the BlockCrasher game."""
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game_BlockCrasher/Scenes/BlockCrasherMainMenu.tscn")


func _on_FoodEaterButton_pressed() -> void:
	"""Opens the FoodEater game."""
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game_FoodEater/Scenes/FoodEaterMainMenu.tscn")


func _on_ShapePlacerButton_pressed() -> void:
	"""Opens the ShapePlacer game."""
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game_ShapePlacer/Scenes/ShapePlacerMainMenu.tscn")


func _on_ExitButton_pressed() -> void:
	"""Closes the game."""
	get_tree().quit()
