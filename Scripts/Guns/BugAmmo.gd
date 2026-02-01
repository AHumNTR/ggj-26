extends Area3D

@onready var searchArea= $"Area3D"
# Called when the node enters the scene tree for the first time.
@onready var closestEnemy:Node3D =null
@export var speed:float
@export var damage:float
func _ready() -> void:
	var mindist:float=99999999
	for enemy: Node3D in 	get_node("/root/world/enemies").get_children(false):
		if(global_position.distance_squared_to(enemy.global_position)<mindist):
			mindist=global_position.distance_squared_to(enemy.global_position)
			closestEnemy=enemy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(is_instance_valid(closestEnemy)):
		position=position.move_toward(closestEnemy.position,speed*delta)
	else: queue_free()




func _on_body_entered(body: Node3D) -> void:
	if(body.has_method("take_damage")): body.take_damage(damage)
	queue_free()
