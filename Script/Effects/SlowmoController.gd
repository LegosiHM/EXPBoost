extends Node

var slowmo_active: bool = false
@export var normal_time_scale: float = 1.0
@export var slowmo_time_scale: float = 0.5

func start_slowmo():
	Engine.time_scale = slowmo_time_scale

func end_slowmo():
	Engine.time_scale = normal_time_scale

func request_slowmo_change():
	if slowmo_active:
		start_slowmo()
	else:
		end_slowmo()
