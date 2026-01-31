extends Enemy
class_name EnemyRanged


var target_pos:=Vector3.ZERO
var target_var:=Vector3.ZERO
var frame = 0
var state = 0

var proj_scene:PackedScene = preload("res://enemy_proj_1.tscn")

enum {
	Moving,
	Shooting
}
func enemy_logic(delta):
	frame+=1
	target_pos = player.global_position+target_var
	match state:
		Moving:
			if get_node_or_null("Sprite3D"):
				$Sprite3D.global_position.y = 2.5 + 0.5*sin(frame/10.0)
				$CollisionShape3D.global_position.y = 2.0 + 0.5*sin(frame/10.0)
				if $Sprite3D.sprite_frames.has_animation("run"):
					$Sprite3D.play("run")
			velocity.x = lerp(velocity.x,(target_pos-global_position).normalized().x*5.0,20.0*delta)
			velocity.z = lerp(velocity.z,(target_pos-global_position).normalized().z*5.0,20.0*delta)  
		Shooting:
			velocity = Vector3.ZERO
			if $attack_cooldown.is_stopped():
				$attack_cooldown.start()
				var p:ProjEnemy = proj_scene.instantiate()
				p.position = global_position
				get_parent().add_child(p)
				p.look_at(player.global_position)
			



func _on_timer_timeout() -> void:
	$Timer.wait_time = randf_range(2.0,5.0)
	$Timer.start()
	target_var = Vector3(randf_range(-20.0,20.0),0.0,randf_range(-20.0,20.0))
	var distance = global_position.distance_to(player.global_position)
	if state == Moving:
		if randi()%3>=1 and distance< 30.0:
			state=Shooting
	else:
		if distance> 30.0:
			state=Moving
		elif randi()%3==0:
			state=Moving


func _on_attack_cooldown_timeout() -> void:
	$attack_cooldown.wait_time = randf_range(0.5,1.0)
