class_name Gun
extends Node3D
@onready var sound: AudioStreamPlayer3D= $AudioStreamPlayer3D
@export var gun_name: String = "Base Gun"
@export var fire_rate: float = 0.5
@export var damage: int = 10
@export var raycast: RayCast3D

var can_shoot: bool = true

func _ready() -> void:
	pass
func shoot():
	sound.play()

# This simulates an abstract method
func interact():
	push_error("Method 'interact' must be overridden in child class: %s" % name)
func enableGun():
	pass
# Common helper function for cooldowns
func disableGun():
	pass
