extends Enemy
class_name EnemyFloating
var target_pos:=Vector3.ZERO
var target_var:=Vector3.ZERO
var frame = 0
func enemy_logic(delta):
	look_at(player.global_position)
	frame+=1
	target_pos = player.global_position+target_var
	global_position.y = 2.50
	#if get_node_or_null("Sprite3D"):
		#$Sprite3D.global_position.y = 2.5 + 0.5*sin(frame/10.0)
		#$CollisionShape3D.global_position.y = 2.0 + 0.5*sin(frame/10.0)
		#if $Sprite3D.sprite_frames.has_animation("run"):
			#$Sprite3D.play("run")
	$AnimationPlayer.play("float")
	velocity.x = lerp(velocity.x,(target_pos-global_position).normalized().x*5.0,20.0*delta)
	velocity.z = lerp(velocity.z,(target_pos-global_position).normalized().z*5.0,20.0*delta)  
