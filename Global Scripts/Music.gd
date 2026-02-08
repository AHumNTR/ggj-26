extends AudioStreamPlayer

@export var music_level = 1.0

func _ready() -> void:
	play()

func _process(delta: float) -> void:
	if not playing:
		play()
