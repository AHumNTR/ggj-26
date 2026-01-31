class_name Player
extends CharacterBody3D
#refs
@export var head:Node3D
@export var cam:Camera3D
@export var hand:Node3D
@onready var slide_timer: Timer = $slide_timer
@onready var slide_cooldown: Timer = $slide_cooldown


#control settings
var SENSIVITY:float = 0.0042

#movement stats
const SPEED_GROUND := 6.5
const SPEED_AIR :=1.8
const STOP_SPEED :=2.0
const FRICTION:float = 5.5
const AIR_FRICTION:float = 0.02
const WALL_FRICTION:float = 0
const MAX_SPEED := INF
const MAX_ACCEL := SPEED_GROUND * 10
const MAX_ACCEL_AIR:= SPEED_AIR * 12
var gravity = 9.81
@onready var JUMP_VELOCITY = sqrt(gravity*2*1.15)

#movement scales
var speed_scale := 1.0
var jump_velocity_scale := 1.0


#stuff
var wish_dir := Vector3.ZERO
var will_jump = false
var is_sliding = false
@onready var hand_def_pos = hand.position

var hp:=100.0

var maxjumpamount := 2
@onready var jumpsleft:=maxjumpamount

var horizontal_velocity = velocity


var active_mask:int = 0 #change object with custom mask class
@export var mask_sprites:Array[Texture2D]


func skill_logic():
	$ui/mask/masksprite.texture = mask_sprites[active_mask]
	speed_scale = 1.0
	maxjumpamount = 1
	match active_mask: #change integers with custom mask ENUM
		0:
			pass # do nothing and display no mask symbol
		1:
			speed_scale = 1.5
		2:
			maxjumpamount = 2
		3:
			pass #idk



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x*SENSIVITY)
		head.rotate_x(-event.relative.y*SENSIVITY)
		hand.rotate_y(event.relative.x*0.001)
		hand.rotate_x(event.relative.y*0.001)
		var sw = deg_to_rad(rotation_sway_amount)
		hand.rotation.x = clamp(hand.rotation.x,-PI/45,PI/45)
		hand.rotation.y = clamp(hand.rotation.y,-PI/45,PI/45)
		if abs(event.relative.x) > 10.0:
			hand.position.x += event.relative.x*sw
#		hand.position.y -= event.relative.y*SENSIVITY
		head.rotation.x = clamp(head.rotation.x,-PI/2,PI/2)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton:
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
func handle_input():
	hand.rotation = lerp(hand.rotation,Vector3.ZERO,0.4)
	var key_input = Input.get_vector("left", "right", "forward", "backward")
	wish_dir = (transform.basis * Vector3(key_input.x, 0, key_input.y)).normalized()
	will_jump = Input.is_action_just_pressed("jump") and jumpsleft > 0
func ground_movement(delta):
	var speed = velocity.length()
	if speed != 0 and slide_timer.is_stopped():
		friction(FRICTION,speed,delta)
	var slide_speed_scale = 1+int(not slide_timer.is_stopped())
	accel(SPEED_GROUND*slide_speed_scale*speed_scale,MAX_ACCEL,delta)

func accel(max_vel:float,max_accel:float,delta):
	var current_speed = velocity.dot(wish_dir)
	var add_speed = clamp(max_vel-current_speed,0,max_accel*delta)
	velocity += add_speed*wish_dir

func friction(amount:float,speed:float,delta,horizontal_only=false):
	var control = max(STOP_SPEED, speed)
	var drop = control * amount * delta
	# Scale the velocity based on friction
	if horizontal_only:
		velocity.x *= max(speed - drop, 0) / speed
		velocity.z *= max(speed - drop, 0) / speed
	else:
		velocity *= max(speed - drop, 0) / speed

func air_movement(delta):
	var speed = velocity.length()
	if speed != 0:
		friction(AIR_FRICTION,speed,delta)
	accel(SPEED_AIR,MAX_ACCEL_AIR,delta)


func get_h_velocity(as_vector:bool=false):
	if as_vector:
		return Vector2(velocity.x,velocity.z)
	return Vector2(velocity.x,velocity.z).length()
	
func get_forward_velocity():
	return velocity.dot(-transform.basis.z)
	
func get_local_velocity():
	return Vector3(velocity.dot(transform.basis.x),velocity.dot(transform.basis.y),velocity.dot(transform.basis.z))

var sway_step = 0.0
var movement_sway_amount = 0.10
var rotation_sway_amount = 0.01
var gun_recovery_speed = 3.0
func gun_sway(delta):
	hand.position -= (get_local_velocity()/SPEED_GROUND)*delta*movement_sway_amount
	hand.position = lerp(hand.position,hand_def_pos,delta*gun_recovery_speed)
	hand.position = hand_def_pos+ (hand.position-hand_def_pos).limit_length(0.12)
	
	if is_on_floor() and is_zero_approx(velocity.y) and get_h_velocity() > 2.0:
		sway_step += delta * get_forward_velocity()
		if sway_step >= PI*2:
			sway_step = sway_step-PI*2
	else:
		var bottom = 0.0
		if sway_step > PI/2.0 and sway_step < 3*PI/2.0:
			bottom = PI
		elif sway_step > 3*PI/2.0:
			bottom = 2*PI
		sway_step = lerp(sway_step,bottom,delta*5.0)
		if is_equal_approx(sway_step,bottom):
			sway_step = 0.0
	hand.position += Vector3(sin(sway_step)*get_forward_velocity()*0.0003,-abs(cos(sway_step+PI/2.0))*get_forward_velocity()*0.0003 ,0)


func _process(delta: float) -> void:
	$ui/hpbar.scale = (1.0 + clamp(smoothstep(0.0,20.0,abs($ui/hpbar.value-hp)),0.0,1.0))*Vector2.ONE
	$ui/hpbar.value = lerp($ui/hpbar.value,hp,5.0*delta)
	
func _physics_process(delta):
	skill_logic()
	gun_sway(delta)
	
	rotate_y(Input.get_axis("ui_left","ui_right")*-0.3/(sqrt(get_h_velocity())+1))
	
	handle_input()
	
	if is_on_floor() and Input.is_action_just_pressed("slide") and slide_cooldown.is_stopped() and wish_dir:
		slide_timer.start()
		slide_cooldown.start()
		$AnimationPlayer.play("slide")

	if is_on_wall() and get_h_velocity():
		friction(WALL_FRICTION,velocity.length(),delta,false)
	if is_on_floor():
		jumpsleft = maxjumpamount
		if will_jump:
			air_movement(delta)
		else:
			ground_movement(delta)
	else:
		var something = 1
		if is_on_wall():
			something = (Vector3.ONE - get_wall_normal()).dot(Vector3.UP)
		velocity.y -= gravity * delta
		air_movement(delta)
	
	if will_jump:
		jumpsleft -= 1
		velocity.y = JUMP_VELOCITY
		print(jumpsleft)
	
	
	horizontal_velocity = velocity
	horizontal_velocity.y = 0
	if horizontal_velocity.length() > MAX_SPEED:
		horizontal_velocity = horizontal_velocity.limit_length(MAX_SPEED)
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z


	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		
		if c.get_collider() is Enemy:
			var enemy:Enemy = c.get_collider()
			if slide_timer.is_stopped():
				take_damage(enemy.damage)
			else:
				enemy.take_damage(0.0)
				enemy.velocity += (enemy.global_position-(global_position+Vector3.DOWN*0.5)).normalized()*50.0

func take_damage(damage:float)->void:
	if $inv_frames.is_stopped():
		$inv_frames.start()
		hp -= damage
		print("damage taken ",damage)
	return
