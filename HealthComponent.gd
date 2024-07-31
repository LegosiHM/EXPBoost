extends Node

signal died

@export var maxHealth:int = 100
var currentHealth: int = maxHealth

func set_health(value:int):
	currentHealth = value
	if currentHealth <= 0:
		emit_signal("died")


func _on_hurtbox_area_entered(hitbox):
	currentHealth -= 1
