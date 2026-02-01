class_name Electro
extends Gun
@onready var sprite: AnimatedSprite3D= $"AnimatedSprite3D"
@onready var area3d:Area3D=$Area3D
func shoot():
	if not !sprite.is_playing():
		return
	sprite.play("default")

func _on_animated_sprite_3d_animation_finished() -> void:
	print(area3d.get_overlapping_bodies())

	for hit_object in area3d.get_overlapping_bodies():
		if hit_object.has_method("take_damage"):
			hit_object.take_damage(damage)
