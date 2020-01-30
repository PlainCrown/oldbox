extends Control

"""Leaves the level select menu through the back button and the escape key."""


func _on_ExitButton_pressed() -> void:
	"""Returns to the main menu when the back button is clicked."""
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game_BlockCrasher/Scenes/BlockCrasherMainMenu.tscn")


func _unhandled_key_input(event: InputEventKey) -> void:
	"""Returns to the main menu when the escape button is pressed."""
	if event.scancode == KEY_ESCAPE and event.pressed:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Game_BlockCrasher/Scenes/BlockCrasherMainMenu.tscn")
