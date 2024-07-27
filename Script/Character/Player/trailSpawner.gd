extends Node2D

@export var trail_node: PackedScene
@export var trailRate : float

@onready var car = $".."
var carPosKeep

var frameCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#15 frames
	if (car.isDashing):
		print("spawn")
		carPosKeep = car.position
		if(frameCount%5 == 0):
			var trail = trail_node.instantiate()
			trail.position = car.position
			trail.rotation = car.rotation
			get_tree().root.add_child(trail)
		frameCount = frameCount + 1
