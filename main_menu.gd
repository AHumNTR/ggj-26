extends CanvasLayer


const WORLD = preload("uid://wu6tt5cs0byc")


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD)



func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_h_slider_2_value_changed(value: float) -> void:
	Musicplayer.volume_linear = value/100.0
