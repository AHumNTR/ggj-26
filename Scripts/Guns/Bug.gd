class_name Bug
extends Gun
@export var bocukScene: PackedScene
@onready var sprite: AnimatedSprite3D= $"AnimatedSprite3D"
func _ready():
	gun_name="Bug"
	super._ready()
func shoot():
	if not can_shoot:
		return
	
	var bocuk:Node3D= bocukScene.instantiate()
	bocuk.global_transform=raycast.global_transform
	get_tree().root.add_child(bocuk)

	sprite.play("default")
	start_cooldown()
	super.shoot()
func start_cooldown():
	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
