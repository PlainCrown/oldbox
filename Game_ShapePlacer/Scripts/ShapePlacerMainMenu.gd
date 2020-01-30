extends Control

"""Controls the functionality of all the buttons on the main menu screen."""

onready var controls_page := $ControlsPage
onready var controls_back := $ControlsBack


func _on_Start_pressed() -> void:
	"""Starts the game."""
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game_ShapePlacer/Scenes/ShapePlacerGame.tscn")


func _on_Options_pressed() -> void:
	"""Opens the options menu."""
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game_ShapePlacer/Scenes/ShapePlacerOptions.tscn")


func _on_Controls_pressed() -> void:
	"""Shows the controls page."""
	controls_back.show()
	controls_page.show()


func _on_ControlsBack_pressed() -> void:
	"""Hides the controls page when the back button is clicked."""
	controls_back.hide()
	controls_page.hide()



func _unhandled_key_input(event: InputEventKey) -> void:
	"""Returns to the main game select menu."""
	if event.scancode == KEY_ESCAPE and event.pressed and not controls_page.visible:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Main/GameSelect.tscn")
	
		"""Hides the controls page when the escape key is pressed."""
	elif event.scancode == KEY_ESCAPE and event.pressed:
		controls_back.hide()
		controls_page.hide()


func _on_Back_pressed() -> void:
	"""Returns to the main game select menu."""
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main/GameSelect.tscn")
