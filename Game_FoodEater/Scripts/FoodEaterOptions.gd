extends Control

"""Controls all the buttons in the options menu."""

onready var show_grid_check := $ShowGridCheck
onready var head_color := $HeadColor
onready var tail_color := $TailColor


func _ready() -> void:
	"""Sets all of the options menu values to the values stored in the autoload."""
	show_grid_check.pressed = Autoload.foodeater_show_grid
	head_color.color = Autoload.head_color
	tail_color.color = Autoload.tail_color


# warning-ignore:unused_argument
func _on_ShowGridCheck_toggled(button_pressed: InputEventMouse) -> void:
	"""Turns the grid on and off."""
	Autoload.foodeater_show_grid = !Autoload.foodeater_show_grid


func _on_HeadColor_color_changed(color: Color) -> void:
	"""Changes the color of the snake head."""
	Autoload.head_color = color


func _on_TailColor_color_changed(color: Color) -> void:
	"""Changes the color of the snake tail."""
	Autoload.tail_color = color


func _on_Back_pressed() -> void:
	"""Exits the options menu when the back button is clicked."""
	Autoload.save_config()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game_FoodEater/Scenes/FoodEaterMainMenu.tscn")


func _unhandled_key_input(event: InputEventKey) -> void:
	"""Exits the options menu when the escape key is pressed."""
	if event.scancode == KEY_ESCAPE:
		Autoload.save_config()
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Game_FoodEater/Scenes/FoodEaterMainMenu.tscn")
