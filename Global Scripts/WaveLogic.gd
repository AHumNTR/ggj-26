extends Node
var enemy_killed_this_wave := 0
var wave = 1

func get_enemy_amount():
	return wave*1

func get_spawn_period():
	return 0.2/sqrt(float(wave))

func next_wave():
	wave+=1
	enemy_killed_this_wave = 0
	
