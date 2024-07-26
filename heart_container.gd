extends HBoxContainer

@onready var heart_GUI_Class = preload("res://heart_gui.tscn")

func setMaxHearts(max: int):
	for i in range(max):
		var heart = heart_GUI_Class.instantiate()
		add_child(heart)
