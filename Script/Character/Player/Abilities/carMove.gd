extends CharacterBody2D

#Health
signal healthChanged
const maxHealth: int = 3
@onready var currentHealth: int = maxHealth
var can_take_damage: bool = true
@export var iframe_time: float = 1.0

#@export var max_speed := 300;
#@export_range(0, 10, 0.1) var drag_factor := 0.1
#
#var desired_velocity := Vector2.ZERO
#var steering_velocity := Vector2.ZERO

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
var dashCooldown: float = 0.5
var dashDuration: float = 0.1
var canDash: bool = true
var isDashing: bool = false
var perfect_dash_timer: float = 0.7

# PerfectDash Effect
@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer
@onready var slowmoController = $SlowmoController
@export var slowdown_time = 1


# Perfect dodge area
@onready var perfect_dodge_area = $PerfectDodgeEnter
	
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
	
	if Input.is_action_just_pressed("Dash") and canDash and $Timer.is_stopped() == false:
		_start_perfect_dash()
	elif Input.is_action_just_pressed("Dash") and canDash:
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

func _start_perfect_dash():
	isDashing = true
	canDash = false
	ghost_timer.start()
	iframe()
	await get_tree().create_timer(dashDuration).timeout
	ghost_timer.stop()
	isDashing = false
	# Additional feedback for perfect dash
	_perfect_dash_feedback()
	canDash = true
		
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
		iframe()
		self.currentHealth -= 1
		healthChanged.emit(currentHealth)

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
