extends Node
var sensitivity: float
var musicVolume: float
var effectVolume: float
@onready var sfx_bus_index = AudioServer.get_bus_index("SFX")
@onready var music_bus_index = AudioServer.get_bus_index("MUSIC")
func _ready() -> void:
	load_game()	

func save_game():
	print(sensitivity,musicVolume,effectVolume)
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_dict = {
		"sensitivity" : sensitivity,
		"musicVolume": musicVolume,
		"effectVolume": effectVolume,
	}
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)
	save_file.close()
	set_bus_volume(musicVolume,music_bus_index)
	set_bus_volume(effectVolume,sfx_bus_index)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	sensitivity=json.data["sensitivity"]
	musicVolume=json.data["musicVolume"]
	effectVolume=json.data["effectVolume"]
	print(sensitivity,musicVolume,effectVolume)

	set_bus_volume(musicVolume,music_bus_index)
	set_bus_volume(effectVolume,sfx_bus_index)
	save_file.close()
	

func set_bus_volume(linear_value: float,bus_id:int):
	# linear_value should be between 0.0 and 1.0
	
	# Clamp value to avoid errors
	var value = clamp(linear_value, 0.0, 1.0)
	
	# Convert linear (0-1) to Decibels
	# linear_to_db is a built-in Godot function
	var db_volume = linear_to_db(value)
	
	# Set the volume on the bus
	AudioServer.set_bus_volume_db(bus_id, db_volume)
	
	# Optional: Mute if volume is 0 to avoid faint audio artifacts
	AudioServer.set_bus_mute(bus_id, value < 0.01)
