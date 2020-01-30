extends Control

"""Controls changes made in the options menu."""

onready var star_check := $StarCheck
onready var paddle_color := $PaddleColor


func _ready() -> void:
	"""Sets all of the options menu values to the values stored in the autoload."""
	star_check.pressed = Autoload.star_check
	paddle_color.color = Autoload.paddle_color


# warning-ignore:unused_argument
func _on_StarCheck_toggled(button_pressed: InputEventMouse) -> void:
	"""Shows and hides the animated star indicator on blocks that contain power-ups."""
	Autoload.star_check = !Autoload.star_check


func _on_PaddleColor_color_changed(color: Color) -> void:
	"""Changes the color of the paddles."""
	Autoload.paddle_color = color


func _on_Back_pressed() -> void:
	"""Exits the options menu when the back button is clicked."""
	Autoload.save_config()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game_BlockCrasher/Scenes/BlockCrasherMainMenu.tscn")


func _unhandled_key_input(event: InputEventKey) -> void:
	"""Exits the options menu when the escape key is pressed."""
	if event.scancode == KEY_ESCAPE:
		Autoload.save_config(null)
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Game_BlockCrasher/Scenes/BlockCrasherMainMenu.tscn")
