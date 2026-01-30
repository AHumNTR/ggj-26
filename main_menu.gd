extends CanvasLayer


const WORLD = preload("uid://wu6tt5cs0byc")


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD)
