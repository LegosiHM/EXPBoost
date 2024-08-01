extends CharacterBody2D

#Health
signal healthChanged
const maxHealth: int = 3
@onready var currentHealth: int = maxHealth
var can_take_damage: bool = true
@export var iframe_time: float = 1.0
@onready var hit_flash_anim_player = $AnimationPlayer
@onready var screenoverlay = $"../Camera2D/AnimationPlayer"
var shoot_timer = 0.4
var boss_position = Vector2(620, 340)
@export var bullet_node: PackedScene


# Movement variables
@export var wheel_base: int = 70
@export_range(0,180) var steering_angle: int = 15
@export var engine_power: int = 1500
@export var friction: float = -1.1
@export var drag: float = -0.002
@export var braking: int = -600
@export var max_speed_reverse: int = 500
@export var slip_speed:int = 600

# if 1.0 then normal
@export_range(0,1.0) var traction_fast: float = 0.1
@export_range(0,1.0) var traction_slow: float = 0.7

var acceleration = Vector2.ZERO
var steer_direction

# Dash variables
@export var dashSpeed: int = 250
var dashCooldown: float = 1.0
var dashDuration: float = 0.1
var canDash: bool = true
var isDashing: bool = false
var perfect_dash_timer: float = 0.7

# PerfectDash Effect
@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer
@onready var slowmoController = $SlowmoController
@export var slowdown_time = 1
var oneFrame : bool = false
var oneFrame2 : bool = false

# Perfect dodge area
@onready var perfect_dodge_area = $PerfectDodgeEnter

func _ready():
	AudioManager.car_moving.play()

func _process(delta):
	if currentHealth < 0:
		AudioManager.car_moving.stop()
		get_tree().change_scene_to_file("res://Assets/Sprite/UI/LoseScene.tscn")

#func _physics_process(delta: float) -> void:
func _physics_process(delta):
	
	#var direction = Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')
	#desired_velocity = direction * max_speed
	#steering_velocity = desired_velocity - velocity
	#velocity += steering_velocity * drag_factor
	#rotation = velocity.angle()
	#move_and_slide()
	
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force

func get_input():
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn += 1
	if Input.is_action_pressed("steer_left"):
		turn -= 1
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
		AudioManager.car_moving.volume_db = -25
	else:
		AudioManager.car_moving.volume_db = -200
		
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking
	
	if Input.is_action_just_pressed("Dash") and canDash:
		_start_perfect_dash()
	elif Input.is_action_just_pressed("Dash"):
		AudioManager.dash_on_cooldwon.play()
	if isDashing:
		if !oneFrame:
			AudioManager.car_dash.play()
			oneFrame = true
		velocity += transform.x * dashSpeed
	else:
		oneFrame = false
		oneFrame2 = false

func _start_perfect_dash():
	isDashing = true
	canDash = false
	can_take_damage = false
	await get_tree().create_timer(dashDuration).timeout
	Engine.time_scale = 1.0
	can_take_damage = true
	isDashing = false
	await get_tree().create_timer(dashCooldown).timeout
	canDash = true
	AudioManager.dash_reset.play()
		
func _perfect_dash_feedback():
	Engine.time_scale = 0.1
	print("Perfect!")
	await get_tree().create_timer(slowdown_time).timeout
	Engine.time_scale = 1.0
	

func _on_perfect_dodge_area_area_entered(perfect_dodge_area):
	if perfect_dodge_area.is_in_group("Bullet"):
		print("collided")
		$Timer.start()
		

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.lerp(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()


func _on_hurtbox_area_entered(hitbox):
	if can_take_damage:
		self.currentHealth -= 1
		screenoverlay.play("damaged")
		hit_flash_anim_player.play("hit_flash")
		AudioManager.car_get_hit_02.play()
		iframe()
		if self.currentHealth >= 0:
			healthChanged.emit(currentHealth)
	else:
		if isDashing:
			Engine.time_scale = 0.1
			DamageNumbers.display_number(300, Vector2(620,258), true)
			DamageNumbers.current_score += 300
			if !oneFrame2:
				AudioManager.car_perfect_dash.play()
		#playFlashingAnim
		print("iframe")
		iframe()
		

func iframe():
	can_take_damage = false
	await get_tree().create_timer(iframe_time).timeout
	can_take_damage = true
	


func _on_timer_timeout():
	print("Timer Expired")


func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(position, $Sprite2D.scale)
	get_tree().current_scene.add_child(ghost)


func _on_ghost_timer_timeout():
	add_ghost()

func _on_shoot_timer_timeout():
	var bullet = bullet_node.instantiate()
	bullet.position = global_position
	bullet.direction = (boss_position - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child", bullet)
