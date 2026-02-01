extends Node3D

@export var enemies:Array[PackedScene]
@export var player:CharacterBody3D
@export var spawnboxes:Array[CSGBox3D]
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
	var spawn_pos = Vector3(0.0,1.0,0.0)
	print("Spawning: ",enemy_spawned_this_wave+1,"/",Waves.get_enemy_amount())
	var reg:CSGBox3D = spawnboxes.pick_random()
	
	spawn_pos.x=randf_range(-reg.size.x/2.0,reg.size.x/2.0)
	spawn_pos.z=randf_range(-reg.size.z/2.0,reg.size.z/2.0)
	
	
	spawn_pos.y = 1.2
	global_position=spawn_pos
	$Timer.wait_time = clamp(randf_range(Waves.get_spawn_period()-1.0,Waves.get_spawn_period()+1.0),0.01,INF) 
	$Timer.start()
	var n: Enemy = enemies.pick_random().instantiate()
	n.position = spawn_pos
	n.player = player
	n.speed += randfn(-1.0,1.0)
	get_node("/root/world/enemies").add_child(n)
	enemy_spawned_this_wave+=1
