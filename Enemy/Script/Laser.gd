extends Node2D


# Laser length
@export var laser_length = 400.0

# Sprites
@onready var head_sprite = $Head
@onready var body_sprite = $Body

func _ready():
	update_laser()

func update_laser():
	# Set the position of the head sprite to the end of the laser
	head_sprite.position = Vector2(laser_length, 0)

	# Set the scale of the body sprite to match the laser length
	body_sprite.scale = Vector2(laser_length / body_sprite.texture.get_size().x, 1)

	# Adjust the body sprite's position to start at the origin
	body_sprite.position = Vector2(0, -body_sprite.texture.get_size().y / 2)
