extends State
class_name pattern2

@onready var boss = $"../.."
@onready var timer = $"../Timer"
@onready var timer_2 = $"../Timer2"
@onready var animated_sprite_2d = $AnimatedSprite2D

@export var anticipateTime : float
@export var phaseTime : float
var once : bool

func Enter():
	print("laser")
	once = false
	timer.wait_time = anticipateTime
	timer_2.wait_time = phaseTime
	timer.start()
	animated_sprite_2d.play("rotato")

func Update(delta: float):
	if(timer.time_left <= 0):
		animated_sprite_2d.visible = false
		if(!once):
			boss.spawn_laser(0.0, 0.007)
			boss.spawn_laser(deg_to_rad(90.0), 0.007)
			timer_2.start()
			AudioManager.boss_laser_hold.play()
			once = true
		print("lasering")
		if(timer_2.time_left == 0):
			AudioManager.boss_laser_hold.stop()
			Transitioned.emit(self, "idle")
	else:
		animated_sprite_2d.visible = true
		#print("anticipating...")

func Exit():
	AudioManager.boss_laser_hold.stop()
	boss.despawn_laser()
