extends Enemy
class_name EnemeyDash

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
	frame+=1
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
			if dist_to_player<7.0 and $attack_cooldown.is_stopped():
				state=Attacking
				velocity = Vector3.ZERO
				dash_dir = (player.global_position-global_position).normalized()
				$Timer.start()
				$attack_cooldown.start()
			 
			if not is_on_floor():
				velocity += get_gravity()*0.5
			
		Attacking:
			$Sprite3D.play("attack")
			damage = 20.0
			velocity.x = 50.0*dash_dir.x
			velocity.z = 50.0*dash_dir.z



func _on_timer_timeout() -> void:
	state = Moving
