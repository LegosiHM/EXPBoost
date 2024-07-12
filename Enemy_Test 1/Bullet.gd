extends Area2D

@export var speed = 100
var direction = Vector2.RIGHT

func _ready():
	print("Bullet spawned at position:", position)

func _process(delta):
	translate(direction * speed * delta)

func _on_screen_exited():
	queue_free()
