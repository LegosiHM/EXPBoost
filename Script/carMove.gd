extends CharacterBody2D

#@export var max_speed := 300;
#@export_range(0, 10, 0.1) var drag_factor := 0.1
#
#var desired_velocity := Vector2.ZERO
#var steering_velocity := Vector2.ZERO

@export var wheel_base: int = 70
@export_range(0,180) var steering_angle: int = 15
@export var engine_power = 1500
var friction = -1.1
var drag = -0.002
var braking = -600
var max_speed_reverse = 500
var slip_speed = 600

# if 1.0 then normal
var traction_fast = 0.1
var traction_slow = 0.7

var acceleration = Vector2.ZERO
var steer_direction

var dashSpeed = 250
var dashCooldown = 0.5
var dashDuration = 0.1
var canDash = true
var isDashing = false

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
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking
	
	if Input.is_action_just_pressed("Dash") and canDash:
		StartDash()
	if isDashing:
		velocity += transform.x * dashSpeed

func StartDash():
	isDashing = true
	canDash = false
	await get_tree().create_timer(dashDuration).timeout
	isDashing = false
	await get_tree().create_timer(dashCooldown).timeout
	canDash = true

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
