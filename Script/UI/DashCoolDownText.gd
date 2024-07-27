extends Label

@onready var car_node = $/root/Node2D/Car

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if car_node.canDash:
		text = "Ready! Space or V"
	else:
		text = "cooldown..."
