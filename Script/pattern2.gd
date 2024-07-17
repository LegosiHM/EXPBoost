extends State
class_name pattern2

var phaseTime: float = 2.0;
@onready var boss = $"../.."
@onready var timer = $"../Timer"


func Enter():
	print("laser")
	timer.wait_time = phaseTime
	timer.start()

func Update(delta: float):
	boss.spawn_laser(Vector2(100, 0))
	boss.spawn_laser(Vector2(-100, 0))
	boss.spawn_laser(Vector2(0, 100))
	boss.spawn_laser(Vector2(0, -100))
	if(timer.time_left == 0):
		Transitioned.emit(self, "idle")

func Exit():
	boss.despawn_laser()
