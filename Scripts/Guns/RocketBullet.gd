extends Area3D

@export var particle: PackedScene
@export var speed: float
@export var jumpForce: float
@export var damage: float
@onready var explosionArea:Area3D= $"Area3D"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position+=-speed*delta*basis.z
	get_overlapping_bodies()

func _on_body_entered(body: Node3D) -> void:
	for kill: Node3D in explosionArea.get_overlapping_bodies():

		if(kill is Player):
			var p: Player=kill
			p.velocity+=jumpForce*(p.position-position).normalized()/(p.position-position).length()
		elif(kill.has_method("take_damage")):
				
			kill.take_damage(damage/position.distance_to(kill.position))
	var particleInstance: Node3D=particle.instantiate()
	get_tree().root.add_child(particleInstance)
	particleInstance.global_position=global_position
	queue_free()
