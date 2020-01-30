extends Control

"""Controls all the buttons in the main menu."""

onready var continue_button := $MarginContainer/VBoxContainer/Continue
onready var controls_page := $ControlsPage
onready var controls_back := $ControlsBack


func _ready() -> void:
	"""Shows the continue button if the player was on any level other than the first one."""
	if Autoload.current_scene != null and Autoload.current_scene != "res://Game_BlockCrasher/Scenes/LevelScenes/Level1.tscn":
		continue_button.visible = true
	else:
		continue_button.visible = false


func _on_Continue_pressed() -> void:
	"""Opens the furthest level the player has reached."""
# warning-ignore:return_value_discarded
	get_tree().change_scene(Autoload.current_scene)


func _on_Start_pressed() -> void:
	"""Opens the level select menu."""
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game_BlockCrasher/Scenes/LevelSelect.tscn")


func _on_Options_pressed() -> void:
	"""Opens the options menu."""
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game_BlockCrasher/Scenes/BlockCrasherOptions.tscn")


func _on_Controls_pressed() -> void:
	"""Shows the controls page."""
	controls_page.show()
	controls_back.show()


func _on_ControlsBack_pressed() -> void:
	"""Hides the controls page when the back button is clicked."""
	controls_page.hide()
	controls_back.hide()


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
