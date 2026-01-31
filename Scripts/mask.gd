extends Area3D
class_name Mask

@export var type = 1
@export var mask_sprites:Array[Texture2D]

func _ready() -> void:
	$Sprite3D.texture = mask_sprites[type]
