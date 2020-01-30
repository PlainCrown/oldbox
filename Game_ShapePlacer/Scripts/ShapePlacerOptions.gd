extends Control

"""Controls all the buttons in the options menu."""

onready var show_grid_check := $ShowGridCheck
onready var fast_check := $FastCheck
onready var invisible_check := $InvisibleCheck


func _ready() -> void:
	"""Sets all of the options menu values to the values stored in the autoload."""
	show_grid_check.pressed = Autoload.shapeplacer_show_grid
	fast_check.pressed = Autoload.fast_mode
	invisible_check.pressed = Autoload.invisible_mode


# warning-ignore:unused_argument
func _on_ShowGridCheck_toggled(button_pressed: InputEventMouse) -> void:
	"""Turns the grid on and off."""
	Autoload.shapeplacer_show_grid = !Autoload.shapeplacer_show_grid


# warning-ignore:unused_argument
func _on_FastModeCheck_toggled(button_pressed: InputEventMouse) -> void:
	"""Turns the fast mode on and off."""
	Autoload.fast_mode = !Autoload.fast_mode


# warning-ignore:unused_argument
func _on_InvisibleCheck_toggled(button_pressed: InputEventMouse) -> void:
	"""Turns invisble mode on and off."""
	Autoload.invisible_mode = !Autoload.invisible_mode


func _on_ShapeColorButton_pressed() -> void:
	"""Opens the shape color menu."""
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game_ShapePlacer/Scenes/ShapeColorMenu.tscn")


func _on_Back_pressed() -> void:
	"""Exits the options menu when the back button is clicked."""
	Autoload.save_config()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game_ShapePlacer/Scenes/ShapePlacerMainMenu.tscn")


func _unhandled_key_input(event: InputEventKey) -> void:
	"""Exits the options menu when the escape key is pressed."""
	if event.scancode == KEY_ESCAPE and event.pressed:
		Autoload.save_config()
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Game_ShapePlacer/Scenes/ShapePlacerMainMenu.tscn")
