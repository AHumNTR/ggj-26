class_name Electro
extends Gun
@onready var sprite: AnimatedSprite3D= $"AnimatedSprite3D"
@onready var area3d:Area3D=$Area3D
@export var particleScene:PackedScene
func shoot():
	if sprite.animation=="default":
		return
	sprite.play("default")

func _on_animated_sprite_3d_animation_finished() -> void:
	var particle:GPUParticles3D= particleScene.instantiate()
	particle.emitting=true
	get_tree().root.add_child(particle)
	particle.global_position=area3d.global_position

	for hit_object in area3d.get_overlapping_bodies():
		if hit_object.has_method("take_damage"):
			hit_object.take_damage(damage)
	sprite.play("idle")
