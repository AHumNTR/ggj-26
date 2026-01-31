extends Node3D

@export var enemies:Array[PackedScene]
@export var player:CharacterBody3D
var enemy_spawned_this_wave := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()


func _on_timer_timeout() -> void:
	
	if Waves.enemy_killed_this_wave == Waves.get_enemy_amount():
		Waves.next_wave()
		enemy_spawned_this_wave=0
		$Timer.wait_time = 1.0
		$Timer.start()
		return
	if enemy_spawned_this_wave == Waves.get_enemy_amount():
		$Timer.wait_time = 2.0
		$Timer.start()
		return
	print("Spawning: ",enemy_spawned_this_wave+1,"/",Waves.get_enemy_amount())
	global_position.y = 1.0
	global_position.x = player.global_position.x + randf_range(-60.0,60.0)
	global_position.z = player.global_position.y + randf_range(-60.0,60.0)
	global_position.x = clamp(global_position.x,-180.0,180.0)
	global_position.z = clamp(global_position.x,-180.0,180.0)
	$Timer.wait_time = clamp(randf_range(Waves.get_spawn_period()-1.0,Waves.get_spawn_period()+1.0),0.01,INF) 
	$Timer.start()
	var n: Enemy = enemies.pick_random().instantiate()
	n.position = position
	n.player = player
	get_node("/root/world/enemies").add_child(n)
	enemy_spawned_this_wave+=1
