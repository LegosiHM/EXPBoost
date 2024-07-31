extends Node2D

@onready var heartContainer = $CanvasLayer/heartContainer
@onready var player = $Car

func _ready():
	heartContainer.setMaxHearts(player.maxHealth)
	heartContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartContainer.updateHearts)
