extends CharacterBody2D

var theta: float = 0.0
@export_range(0, 3 * PI) var alpha: float = 0.0
@export var bullet_node: PackedScene

@export var laser_node: PackedScene
@export var rotation_speed = 1.0
var lasers = []

@onready var sprite_2d = $Sprite2D
@onready var animated_sprite_2d = $AnimatedSprite2D


@onready var state_machine = $StateMachine

@onready var healthbar = $Healthbar 
@export var phase : int

@export var maxHealth:int = 100
var currentHealth: int = maxHealth : set = set_health
var once = false
var rePhasing = false
var countDown = 0
var countDown2 = 0

func set_health(value:int):
	currentHealth = value
	

func _ready():
	healthbar.init_health(currentHealth)

func _process(delta):
	if currentHealth <= 0:
		
		rePhasing = true
		if !once:
			phase -= 1
			AudioManager.boss_changing_phase.play()
			state_machine.current_state.Exit()
			
			once = true
		state_machine.current_state = state_machine.initial_state
		countDown += delta
		print(countDown)
		if countDown > 10:
			currentHealth = 100
			print("change")
	else:
		countDown = 0
		once = false
		rePhasing = false
	if phase < 0:
		AudioManager.boss_changing_phase.stop()
		sprite_2d.visible = false
		animated_sprite_2d.visible = true
		animated_sprite_2d.play()
		AudioManager.background_music.stop()
		countDown2 += delta
		if countDown2 > 3:
			get_tree().change_scene_to_file("res://Script/UI/winningScene.tscn")

func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta), sin(theta))

func shoot(angle):
	var bullet = bullet_node.instantiate()
	bullet.position = global_position
	bullet.direction = get_vector(angle).normalized()
	get_tree().current_scene.call_deferred("add_child", bullet)
	
func spawn_laser(angle, rota):
	var laser = laser_node.instantiate()
	add_child(laser)
	laser.rotateSpeed = rota
	laser.rotation = angle
	lasers.append(laser)
	
func despawn_laser():
	for i in range(lasers.size()-1, -1, -1):
		lasers[i].queue_free()
		lasers.remove_at(i)

func _on_hurtbox_area_entered(hitbox):
	if hitbox.is_in_group("PlayerBullet"):
		if !rePhasing:
			currentHealth -= 1
			AudioManager.point_increase.play()
			DamageNumbers.display_number(50, $DamageNumber.global_position)
			DamageNumbers.current_score += 50
			healthbar.health = currentHealth
			print(currentHealth)
