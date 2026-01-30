extends CharacterBody3D
@export var MaxHealth: int
@onready var Health: int=MaxHealth
func take_damage(damage):
	Health-=damage
	print(Health)
	if(Health<=0):
		free()
