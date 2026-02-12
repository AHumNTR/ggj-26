extends CanvasLayer


const WORLD = preload("uid://wu6tt5cs0byc")
func _ready() -> void:
	PlayerSettings.load_game()
	$HBoxContainer/HSlider.value=PlayerSettings.musicVolume
	$HBoxContainer/HSlider2.value=PlayerSettings.effectVolume
	$HBoxContainer/HSlider3.value=PlayerSettings.sensitivity

func _on_play_pressed() -> void:
	Waves.enemy_killed_this_wave = 0
	Waves.wave = 1
	get_tree().change_scene_to_packed(WORLD)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_Effect_Slider_value_changed(value: float) -> void:
	PlayerSettings.effectVolume=value
	
func _on_Music_Slider_value_changed(value: float) -> void:
	PlayerSettings.musicVolume=value
	
func _on_Sens_Slider_value_changed(value: float) -> void:
	PlayerSettings.sensitivity=value
	
func SaveGame(test):
	PlayerSettings.save_game()
