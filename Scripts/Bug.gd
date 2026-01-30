class_name Bug
extends Gun

func _init():
	gun_name="Bull"
func shoot():
	if not can_shoot:
		return
	
	print(gun_name + " fired!")
	
	# Raycast logic example
	if raycast.is_colliding():
		var target = raycast.get_collider()
		print(target)
		if target.has_method("take_damage"):
			target.take_damage(damage)
			
	start_cooldown()

func interact():
	# Example: Inspect the weapon or switch fire modes
	print("Inspecting " + gun_name + "... It looks shiny.")
func start_cooldown():
	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
