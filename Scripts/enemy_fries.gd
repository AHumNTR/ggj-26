extends Enemy
class_name EnemeyFries

var target_pos:=Vector3.ZERO
var target_var:=Vector3.ZERO
var frame = 0
var state = 0
var dash_dir = Vector3.ZERO
var proj_scene:PackedScene = preload("res://enemy_proj_1.tscn")

enum {
	Moving,
	Attacking
}
func enemy_logic(delta):
	global_position.y = 8.0
	frame+=1
	target_pos = player.global_position+target_var
	var dist_to_player = global_position.distance_to(player.global_position)
	match state:
		Moving:
			damage=0.0
			if get_node_or_null("Sprite3D"):
				#$CollisionShape3D.global_position.y = 2.0 + 0.5*sin(frame/10.0)
				if $Sprite3D.sprite_frames.has_animation("run"):
					$Sprite3D.play("run")
			velocity.x = lerp(velocity.x,(target_pos-global_position).normalized().x*5.0,20.0*delta)
			velocity.z = lerp(velocity.z,(target_pos-global_position).normalized().z*5.0,20.0*delta)  
			if dist_to_player<10.0 and $attack_cooldown.is_stopped():
				state=Attacking
				velocity = Vector3.ZERO
				dash_dir = (player.global_position-global_position).normalized()
				$Timer.start()
				$attack_cooldown.start()
			 

		Attacking:
			$Sprite3D.play("attack")
			damage = 20.0




func _on_timer_timeout() -> void:
	state = Moving
