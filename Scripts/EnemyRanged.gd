extends Enemy
class_name EnemyRanged


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
	var distance = global_position.distance_to(target_pos)
	var dist_to_player = global_position.distance_to(player.global_position)
	match state:
		Moving:
			damage = 1.0
			if get_node_or_null("Sprite3D"):
				$Sprite3D.global_position.y = 1.8 + 0.3*sin(frame/10.0)
				$CollisionShape3D.global_position.y = 2.0 + 0.5*sin(frame/10.0)
				if $Sprite3D.sprite_frames.has_animation("run"):
					$Sprite3D.play("run")
			velocity.x = lerp(velocity.x,(target_pos-global_position).normalized().x*speed,20.0*delta)
			velocity.z = lerp(velocity.z,(target_pos-global_position).normalized().z*speed,20.0*delta)  
			if dist_to_player<=10.0 and $Timer.is_stopped():
				$Timer.wait_time = randf_range(1.0,4.0)
				$Timer.start()
			
			if distance <= 1.0 and $Timer.is_stopped():
				state = Shooting
		Shooting:
			damage = 10.0
			velocity = Vector3.ZERO
			if $attack_cooldown.is_stopped():
				$Sprite3D.play("attack")
				$attack_cooldown.start()
				var p:ProjEnemy = proj_scene.instantiate()
				p.position = global_position
				get_tree().root.add_child(p)
				p.look_at(player.global_position)
				if dist_to_player > 30.0:
					state = Moving
				if $Timer.is_stopped():
					$Timer.wait_time = randf_range(3.0,5.0)
					$Timer.start()




func _on_timer_timeout() -> void:
	
	
	target_var = Vector3(randf_range(-20.0,20.0),0.0,randf_range(-20.0,20.0))
	
	match state:
		Moving:
			state==Shooting
		Shooting:
			if randi()%2 == 0:
				state==Moving
	
	
func _on_attack_cooldown_timeout() -> void:
	$attack_cooldown.wait_time = randf_range(0.5,1.0)
