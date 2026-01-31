extends Area3D
class_name ProjEnemy
@export var speed:=15.0
@export var damage:=10.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	global_position+=-global_basis.z*speed*delta

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.take_damage(damage)
	if body is not Enemy:
		queue_free()


func _on_ded_timeout() -> void:
	queue_free()
