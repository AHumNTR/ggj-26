class_name GunController
extends Node3D

# Type hint ensures only Gun objects (or inheritors) can be added
var guns: Array[Gun]
@export var raycast: RayCast3D 
var current_gun_index: int = 0
var current_gun: Gun = null

func _ready():
	# Initialize the first gun if available
	for child in get_children():
		# 2. Check if the child inherits from the 'Gun' class
		if child is Gun:
			guns.append(child)
	if guns.size() > 0:
		_equip_gun(0)

func _input(event):
	# Handle Switching
	if event.is_action_pressed("weapon_next"):
		switch_weapon(1)
	elif event.is_action_pressed("weapon_prev"):
		switch_weapon(-1)
	
	# Handle Actions (Pass inputs to the current gun)
	if current_gun:
		if event.is_action_pressed("fire"):
			current_gun.shoot()
		if event.is_action_pressed("interact"):
			current_gun.interact()

func switch_weapon(direction: int):
	# Calculate new index with wrapping
	var new_index = (current_gun_index + direction) % guns.size()
	
	# Handle negative wrapping (GDScript modulo can return negative)
	if new_index < 0:
		new_index = guns.size() - 1
	_equip_gun(new_index)

func _equip_gun(index: int):
	# Disable the old gun
	if current_gun:
		current_gun.visible = false
		current_gun.set_process(false)
		current_gun.disableGun()
	
	# Update index and reference
	current_gun_index = index
	current_gun = guns[index]
	
	# Enable the new gun
	if current_gun:
		current_gun.visible = true
		current_gun.set_process(true)
		current_gun.enableGun()
