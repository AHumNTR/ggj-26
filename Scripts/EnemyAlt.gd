extends CharacterBody3D
class_name EnemyAlt
@export var player:CharacterBody3D

var score_value := 0.0
var hp := 20

@warning_ignore("unused_parameter")
func enemy_logic(delta):
	pass

func take_damage(damage:float):
	hp-= damage
	print(hp)
	if hp <= 0.0:
		die()

func die():
	queue_free()


func _physics_process(delta: float) -> void:
	enemy_logic(delta)
	move_and_slide()
