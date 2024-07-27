extends State
class_name pattern2

@onready var boss = $"../.."
@onready var timer = $"../Timer"
@onready var timer_2 = $"../Timer2"

@export var anticipateTime : float
@export var phaseTime : float
var once : bool

func Enter():
	print("laser")
	once = false
	timer.wait_time = anticipateTime
	timer_2.wait_time = phaseTime
	timer.start()


func Update(delta: float):
	if(timer.time_left <= 0):
		if(!once):
			boss.spawn_laser(0.0)
			boss.spawn_laser(deg_to_rad(90.0))
			timer_2.start()
			once = true
		print("lasering")
		if(timer_2.time_left == 0):				
			Transitioned.emit(self, "idle")
	#else:
		#print("anticipating...")

func Exit():
	boss.despawn_laser()
