class_name RocketGun
extends Gun

@onready var animation: AnimatedSprite3D =$"AnimatedSprite3D"
@export var rocket: PackedScene 
func shoot():
	if not can_shoot:
		return
	# Raycast logic example
	var rocketInstance:Area3D= rocket.instantiate()
	rocketInstance.global_transform=raycast.global_transform
	get_tree().root.add_child(rocketInstance)
	animation.play("default")
	super.shoot()
	start_cooldown()

func start_cooldown():
	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
