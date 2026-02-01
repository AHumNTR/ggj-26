class_name Electro
extends Gun
@onready var sprite: AnimatedSprite3D= $"AnimatedSprite3D"
func shoot():
	if not !sprite.is_playing():
		return
	sprite.play("default")

func _on_animated_sprite_3d_animation_finished() -> void:
	if raycast.is_colliding():
		var target = raycast.get_collider()
		if target.has_method("take_damage"):
			target.take_damage(damage)
