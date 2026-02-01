class_name DefaultGun
extends Gun
@onready var sprite:AnimatedSprite3D= $"AnimatedSprite3D"
func shoot():
	if not can_shoot:
		return
	# Raycast logic example
	if raycast.is_colliding():
		var target = raycast.get_collider()
		if target.has_method("take_damage"):
			target.take_damage(damage)
			
	start_cooldown()
	sprite.play("default")

	# Example: Inspect the weapon or switch fire modes
func start_cooldown():
	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
