extends State
class_name pattern1

var phaseTime: float = 2.0;
@onready var boss = $"../.."
@onready var timer = $"../Timer"


func Enter():
	print("bullet")
	timer.wait_time = phaseTime
	timer.start()

func Update(delta: float):
	boss.shoot(boss.theta)
	if(timer.time_left == 0):
		Transitioned.emit(self, "idle")
