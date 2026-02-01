class_name Laser
extends Gun
@onready var sprite: AnimatedSprite3D= $"AnimatedSprite3D"
@export var shapeCast:ShapeCast3D
func _ready():
	gun_name="Crab"
	super._ready()
func shoot():
	if not !sprite.is_playing():
		return
	sprite.play("default")

func _on_animated_sprite_3d_animation_finished() -> void:
	var count = shapeCast.get_collision_count()

	for i in range(count):
		var hit_object = shapeCast.get_collider(i)
		
		if hit_object.has_method("take_damage"):
			hit_object.take_damage(damage)
