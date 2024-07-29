extends Area2D

@export var speed = 100
@export var iframe_time: float = 1.0
var direction = Vector2.RIGHT
var can_take_damage = true

func _ready():
	pass

func _process(delta):
	translate(direction * speed * delta)

func _on_screen_exited():
	queue_free()


func _on_hitbox_area_entered(hurtbox):
	if hurtbox.is_in_group("Environment"):
		queue_free() 
	if can_take_damage == true and hurtbox.is_in_group("Player"):
		iframe()
		queue_free()

func iframe():
	can_take_damage = false
	await get_tree().create_timer(iframe_time).timeout
	can_take_damage = true
