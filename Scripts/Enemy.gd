extends CharacterBody3D
class_name Enemy
@export var player:CharacterBody3D

const MASK = preload("uid://f5scy1na7fgd")


@export var type := 1 #1 is small spider, 2 is floater, 3 is cube guy might add enum later
var score_value := 0.0
var hp := 20
var damage:=5.0
@export var speed=5.0
@warning_ignore("unused_parameter")
func enemy_logic(delta):
	pass

func take_damage(damage:float):
	hp-= damage
	if hp <= 0.0:
		die()

func die():
	
	Waves.enemy_killed_this_wave+=1
	print(Waves.enemy_killed_this_wave,"/",Waves.get_enemy_amount())
	($/root/world/player as Player).select_next_mask(type)
	queue_free()


func _physics_process(delta: float) -> void:
	enemy_logic(delta)
	move_and_slide()
