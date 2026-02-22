extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$waveprogress.max_value=lerp($waveprogress.max_value,Waves.get_enemy_amount()*1.0,10.0*delta)
	$waveprogress.value=Waves.enemy_killed_this_wave
	$Label2.text="Wave: "+str(Waves.wave)
