extends TextureRect
@onready var car = $"../../Car"
const DASH_ICON_READY = preload("res://Assets/Sprite/UI/DashIcon_Ready.png")
const DASH_ICON_NOT_READY = preload("res://Assets/Sprite/UI/DashIcon_NotReady.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if car.canDash:
		self.texture = DASH_ICON_READY
		
	else:
		self.texture = DASH_ICON_NOT_READY
