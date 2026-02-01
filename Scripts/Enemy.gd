extends CharacterBody3D
class_name Enemy
@export var player:CharacterBody3D
@onready var navagant:NavigationAgent3D=$NavigationAgent3D
const MASK = preload("uid://f5scy1na7fgd")
var target_pos:=Vector3.ZERO
var inv = false

@export var type := 1 #1 is small spider, 2 is floater, 3 is cube guy might add enum later
var score_value := 0.0
var hp := 20
@export var damage:=5.0
@export var speed=5.0
@warning_ignore("unused_parameter")
func enemy_logic(delta):
	pass



func take_damage(damage:float):
	if inv:
		return
	hp-= damage
	if hp <= 0.0:
		die()
		return
	$Sprite3D.modulate = Color(0.655, 0.012, 0.0, 1.0)
	inv = true
	await get_tree().create_timer(0.5).timeout
	$Sprite3D.modulate = Color.WHITE
	inv = false

func die():
	
	Waves.enemy_killed_this_wave+=1
	print(Waves.enemy_killed_this_wave,"/",Waves.get_enemy_amount())
	($/root/world/player as Player).select_next_mask(type)
	queue_free()


func _physics_process(delta: float) -> void:
	navagant.target_position=player.global_position
	target_pos=navagant.get_next_path_position()
	enemy_logic(delta)
	move_and_slide()
