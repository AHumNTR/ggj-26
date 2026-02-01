class_name Laser
extends Gun
@onready var sprite: AnimatedSprite3D= $"AnimatedSprite3D"
@export var shapeCast:ShapeCast3D


const LASEREFFECT = preload("uid://cj3jl6yf5s6vd")


func _ready():
	gun_name="Laser"
	
	super._ready()
func shoot():
	if sprite.is_playing():
		return
	sprite.play("default")

func _on_animated_sprite_3d_animation_finished() -> void:

	var count = shapeCast.get_collision_count()
	sound.play()	

	for i in range(count):
		var hit_object = shapeCast.get_collider(i)
		
		if hit_object.has_method("take_damage"):
			hit_object.take_damage(damage)
	
	
	var l:Node3D = LASEREFFECT.instantiate()
	add_child(l)
	var offset = get_parent().global_basis*Vector3(-0.05,0.0,0.0)
	l.global_position = get_parent().global_position + get_parent().global_basis.z*-50.0
	l.look_at(get_parent().global_position+offset)
	print(global_position + -50.0 * global_basis.z, " ", -l.global_basis.z)
