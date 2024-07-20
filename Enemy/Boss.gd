extends CharacterBody2D

var theta: float = 0.0
@export_range(0, 3 * PI) var alpha: float = 0.0
@export var bullet_node: PackedScene

@export var laser_node: PackedScene
@export var rotation_speed = 1.0
var lasers = []

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
		

#func _on_speed_timeout():
	#shoot(theta)
	
#func _process(delta):
	## Rotate the lasers around the boss
	#for laser in lasers:
		#laser.rotation += rotation_speed * delta
#
#
#func _ready():
	#spawn_laser(Vector2(100, 0))
	#spawn_laser(Vector2(-100, 0))
	#spawn_laser(Vector2(0, 100))
	#spawn_laser(Vector2(0, -100))
