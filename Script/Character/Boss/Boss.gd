extends CharacterBody2D

var theta: float = 0.0
@export_range(0, 3 * PI) var alpha: float = 0.0
@export var bullet_node: PackedScene

@export var laser_node: PackedScene
@export var rotation_speed = 1.0
var lasers = []

@onready var healthbar = $Healthbar 

@export var maxHealth:int = 100
var currentHealth: int = maxHealth : set = set_health

func set_health(value:int):
	currentHealth = value

func _ready():
	healthbar.init_health(currentHealth)

func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta), sin(theta))

func shoot(angle):
	var bullet = bullet_node.instantiate()
	bullet.position = global_position
	bullet.direction = get_vector(angle)
	get_tree().current_scene.call_deferred("add_child", bullet)
	
func spawn_laser(angle):
	var laser = laser_node.instantiate()
	add_child(laser)
	laser.rotation = angle
	lasers.append(laser)
	
func despawn_laser():
	for i in range(lasers.size()-1, -1, -1):
		lasers[i].queue_free()
		lasers.remove_at(i)


func _on_hurtbox_area_entered(hitbox):
	if hitbox.is_in_group("PlayerBullet"):
		currentHealth -= 1
		healthbar.health = currentHealth
		print(currentHealth)
