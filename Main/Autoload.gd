extends Node

"""Autoload script containing variables that are used across multiple different scripts.
Responsible for saving and loading save files and user preferences.
Also adds and controls the music audio player."""

onready var music_file: Resource = preload("res://Assets/Sounds/music_track.ogg")
onready var config_path = "user://config.ini"
onready var save_path = "user://save.dat"

# FoodEater
const CELL_SIZE = 40
const SLOW = 2.5
const NORMAL = 3.5
const FAST = 4.5

# ShapePlacer
const DEFAULT_SHAPE_DROP_SPEED = 1.04
const DEFAULT_COLOR_DIC = {
	0: Color(0.1, 0.91, 0.91, 1),
	1: Color(0.1, 0.38, 0.91, 1),
	2: Color(0.65, 0.1, 0.91, 1),
	3: Color(0.1, 0.91, 0.24, 1),
	4: Color(0.91, 0.88, 0.1, 1),
	5: Color(0.91, 0.45, 0.1, 1),
	6: Color(0.91, 0.1, 0.24, 1)}

var music_player := AudioStreamPlayer.new()

# BlockCrasher
# warning-ignore:unused_class_variable
var star_check := true
# warning-ignore:unused_class_variable
var broken_brick_array := []
# warning-ignore:unused_class_variable
var victory := false

# FoodEater
# warning-ignore:unused_class_variable
var tail_scale := 0.998
# warning-ignore:unused_class_variable
var snake_speed = NORMAL
# warning-ignore:unused_class_variable
var obstacles := false
# warning-ignore:unused_class_variable
var just_started := true
# warning-ignore:unused_class_variable
var moving := true
# warning-ignore:unused_class_variable
var obstacle_positions := []
# warning-ignore:unused_class_variable
var all_last_pos := []
# warning-ignore:unused_class_variable
var all_current_pos := []
# warning-ignore:unused_class_variable
var all_next_pos := []

"""Array of positions where food and obstacles should never spawn at the start of each game."""
# warning-ignore:unused_class_variable
var no_spawn_zone := [Vector2(40, 320), Vector2(80, 320), Vector2(120, 320), Vector2(160, 320), Vector2(200, 320)]

"""Helps SnakeBody.gd distinguish betweeen tail nodes and default nodes."""
# warning-ignore:unused_class_variable
var default_node_count = null

# ShapePlacer
# warning-ignore:unused_class_variable
var shape_drop_speed := DEFAULT_SHAPE_DROP_SPEED

"""Variables saved to config.ini"""
var music_volume: int setget music_volume_change
var sfx_volume: int setget sfx_volume_change
var fullscreen: bool setget fullscreen_change
# BlockCrasher
var current_scene = null setget save_config
var paddle_color: Color setget color_change
# FoodEater
var foodeater_show_grid: bool
var head_color: Color setget head_color_change
var tail_color: Color setget tail_color_change
# ShapePlacer
var shapeplacer_show_grid: bool
var fast_mode: bool
var invisible_mode: bool
var color_dic := {
	0: Color(0.1, 0.91, 0.91, 1),
	1: Color(0.1, 0.38, 0.91, 1),
	2: Color(0.65, 0.1, 0.91, 1),
	3: Color(0.1, 0.91, 0.24, 1),
	4: Color(0.91, 0.88, 0.1, 1),
	5: Color(0.91, 0.45, 0.1, 1),
	6: Color(0.91, 0.1, 0.24, 1)}

"""Dictionary saved to save.dat"""
var level_locked_dict := {} setget save_data
var foodeater_highscore_dictionary := {} setget save_data
var shapeplacer_highscore_dictionary := {} setget save_data


func _ready() -> void:
	"""Loads the config.ini and save.dat files.
	Switches to fullscreen if it was previously turned on by the user."""
	load_config()
	if fullscreen:
		OS.window_fullscreen = true
	load_data()
	
	"""Creates and plays the music audio player which continues to play even 
	when scenes are changed."""
	get_viewport().get_node("/root").call_deferred("add_child", music_player)
	music_player.stream = music_file
	music_player.volume_db = music_volume
	music_player.play()


func music_volume_change(value: int) -> void:
	"""Stores and adjusts the music volume setting."""
	music_volume = value
	if music_volume == -40:
		music_volume = -1000
	music_player.volume_db = music_volume
	save_config()


func sfx_volume_change(value: int) -> void:
	"""Stores and adjusts the sound effect volume setting."""
	sfx_volume = value
	if sfx_volume == -50:
		sfx_volume = -1000
	save_config()


func fullscreen_change(value: bool) -> void:
	"""Stores and adjusts the fullscreen setting."""
	fullscreen = value
	save_config()


func color_change(new_color: Color) -> void:
	"""Stores and adjusts the color of the paddles in BlockCrasher."""
	paddle_color = new_color


func head_color_change(new_color: Color) -> void:
	"""Stores and adjusts the color of the snake's head in FoodEater."""
	head_color = new_color


func tail_color_change(new_color: Color) -> void:
	"""Stores and adjusts the color of the snake's tail in FoodEater."""
	tail_color = new_color


func save_config(scene_path = null) -> void:
	"""Saves the furthest played BlockCrasher level for easy access."""
	if scene_path != null:
		if current_scene == null or int(scene_path) > int(current_scene):
			current_scene = scene_path
	"""Creates a config file and saves all user preferences."""
	var config := ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("display", "fullscreen", fullscreen)
	# BlockCrasher
	config.set_value("last_level", "current_scene", current_scene)
	config.set_value("paddle", "paddle_color", paddle_color)
	# FoodEater
	config.set_value("display", "foodeater_show_grid", foodeater_show_grid)
	config.set_value("snake", "head_color", head_color)
	config.set_value("snake", "tail_color", tail_color)
	# ShapePlacer
	config.set_value("display", "shapeplacer_show_grid", shapeplacer_show_grid)
	config.set_value("game_mode", "fast_mode", fast_mode)
	config.set_value("game_mode", "invisible_mode", invisible_mode)
	config.set_value("shape_colors", "color_dic", color_dic)
	var err := config.save(config_path)
	
	"""Checks if the config file was saved successfully."""
	if err != OK:
		print("Error while saving config.")


func load_config() -> void:
	"""Loads the config file."""
	var config := ConfigFile.new()
	var err := config.load(config_path)
	
	"""Sets all values to default if the config file fails to load or does not exist."""
	if err != OK:
		music_volume = -10
		sfx_volume = -20
		fullscreen = false
		# BlockCrasher
		current_scene = null
		paddle_color = Color(0.168627, 0.333333, 1, 1)
		# FoodEater
		foodeater_show_grid = true
		head_color = Color(0.72, 0, 0.13, 1)
		tail_color = Color(0.59, 0, 0.13, 1)
		# ShapePlacer
		shapeplacer_show_grid = true
		fast_mode = false
		invisible_mode = false
		color_dic = DEFAULT_COLOR_DIC
		print("Error while loading config. Default settings loaded.")
		return
	
	"""Sets all values to the values stored in the config file."""
	music_volume = config.get_value("audio", "music_volume")
	sfx_volume = config.get_value("audio", "sfx_volume")
	fullscreen = config.get_value("display", "fullscreen")
	# BlockCrasher
	current_scene = config.get_value("last_level", "current_scene")
	paddle_color = config.get_value("paddle", "paddle_color")
	# FoodEater
	foodeater_show_grid = config.get_value("display", "foodeater_show_grid")
	head_color = config.get_value("snake", "head_color")
	tail_color = config.get_value("snake", "tail_color")
	# ShapePlacer
	shapeplacer_show_grid = config.get_value("display", "shapeplacer_show_grid")
	fast_mode = config.get_value("game_mode", "fast_mode")
	invisible_mode = config.get_value("game_mode", "invisible_mode")
	color_dic = config.get_value("shape_colors", "color_dic")


func save_data(new_scores: Dictionary) -> void:
	"""Creates a save file."""
	if new_scores.size() == 30:
		level_locked_dict = new_scores
	elif new_scores.size() == 6:
		foodeater_highscore_dictionary = new_scores
	else:
		shapeplacer_highscore_dictionary = new_scores
	var save_file := File.new()
	var err := save_file.open(save_path, File.WRITE)
	
	"""Checks if the save file was opened successfully."""
	if err != OK:
		print("Error while opening save file.")
		return
	
	"""Saves the progress and high scores for all games, and closes the save file."""
	save_file.store_var(level_locked_dict)
	save_file.store_var(foodeater_highscore_dictionary)
	save_file.store_var(shapeplacer_highscore_dictionary)
	save_file.close()


func load_data() -> void:
	"""Loads the save file."""
	var save_file := File.new()
	var err := save_file.open(save_path, File.READ)
	
	"""Sets all progress and high scores to default if the save file fails to load 
	or does not exist."""
	if err != OK:
		level_locked_dict = {
			1: false,
			2: true,
			3: true,
			4: true,
			5: true,
			6: true,
			7: true,
			8: true,
			9: true,
			10: true,
			11: true,
			12: true,
			13: true,
			14: true,
			15: true,
			16: true,
			17: true,
			18: true,
			19: true,
			20: true,
			21: true,
			22: true,
			23: true,
			24: true,
			25: true,
			26: true,
			27: true,
			28: true,
			29: true,
			30: true}
		foodeater_highscore_dictionary = {
			1: 0,  # SLOW
			2: 0,  # SLOW + OBSTACLES
			3: 0,  # NORMAL
			4: 0,  # NORMAL + OBSTACLES
			5: 0,  # FAST
			6: 0}   # FAST + OBSTACLES
		shapeplacer_highscore_dictionary = {
			1: 0,  # NORMAL
			2: 0,  # FAST
			3: 0,  # INVISIBLE
			4: 0}  # FAST + INVISIBLE
		print("Error while loading save file. Default settings loaded.")
		return
	
	"""Sets all progress and high score values to the values stored in the save file."""
	level_locked_dict = save_file.get_var()
	foodeater_highscore_dictionary = save_file.get_var()
	shapeplacer_highscore_dictionary = save_file.get_var()
	save_file.close()
