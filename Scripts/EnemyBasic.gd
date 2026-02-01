extends Enemy
class_name EnemyBasic

var target_var:=Vector3.ZERO
var base_speed := 5.0
func enemy_logic(delta):
	if get_node_or_null("Sprite3D"):
		if $Sprite3D.sprite_frames.has_animation("run"):
			$Sprite3D.play("run")
	velocity.x = lerp(velocity.x,(target_pos-global_position).normalized().x*5.0,20.0*delta)
	velocity.z = lerp(velocity.z,(target_pos-global_position).normalized().z*5.0,20.0*delta)  
	if not is_on_floor():
		velocity += get_gravity()


func _on_timer_timeout() -> void:
	$Timer.wait_time = randf_range(5.0,10.0)
	$Timer.start()
	target_var = Vector3(randf_range(-3.0,3.0),0.0,randf_range(-3.0,3.0))
