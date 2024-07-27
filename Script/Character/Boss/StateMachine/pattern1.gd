extends State
class_name pattern1

@onready var boss = $"../.."
@onready var timer = $"../Timer"
@onready var timer_2 = $"../Timer2"
@export var anticipateTime : float
@export var phaseTime: float
var once : bool

func Enter():
	once = false
	print("bullet")
	timer.wait_time = anticipateTime
	timer_2.wait_time = phaseTime
	timer.start()

func Update(delta: float):
	#anticipate Anim
	if(timer.time_left <= 0):
		boss.shoot(boss.theta)
		if (!once):
			timer_2.start()
			once = true;
		if(timer_2.time_left == 0):
			Transitioned.emit(self, "idle")
	#else:
		#print("anticipating...")
