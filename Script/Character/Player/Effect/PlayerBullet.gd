extends Area2D

@export var speed = 500
var direction = Vector2.RIGHT

func _physics_process(delta):
	position += direction * speed * delta

func _on_screen_exited():
	queue_free()
	
func _on_hitbox_area_entered(hurtbox):
	if hurtbox.is_in_group("Boss"):
		queue_free() 
