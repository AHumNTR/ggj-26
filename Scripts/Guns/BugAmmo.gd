extends Area3D

@onready var searchArea= $"Area3D"
# Called when the node enters the scene tree for the first time.
@onready var closestEnemy:Node3D =null
func _ready() -> void:
	var mindist=9999999
	for enemy: Node3D in searchArea.get_overlapping_bodies():
		print(enemy)
		if(position.distance_to(enemy.position)<mindist):
			mindist=position.distance_to(enemy.position)
			closestEnemy=enemy
	print(closestEnemy)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
