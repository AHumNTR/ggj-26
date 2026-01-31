extends Node3D

@export var enemies:Array[PackedScene]
@export var player:CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()


func _on_timer_timeout() -> void:
	global_position.y = 1.0
	global_position.x = randf_range(-100.0,100.0)
	global_position.z = randf_range(-100.0,100.0)
	$Timer.wait_time = randf_range(1.0,3.0)
	$Timer.start()
	var n:EnemyAlt = enemies.pick_random().instantiate()
	n.position = position
	n.player = player
	get_parent().add_child(n)
