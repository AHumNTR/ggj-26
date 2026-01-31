extends Node
var enemy_killed_this_wave := 0
var wave = 1

func get_enemy_amount():
	return wave*20

func get_spawn_period():
	return 0.1/sqrt(float(wave))

func next_wave():
	wave+=1
	print("Next Wave: ",wave)
	enemy_killed_this_wave = 0
