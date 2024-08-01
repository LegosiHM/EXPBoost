extends State
class_name pattern1
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var boss = $"../.."
@onready var timer = $"../Timer"
@onready var timer_2 = $"../Timer2"
@export var anticipateTime : float
@export var phaseTime: float
var once : bool
var alpha: float = 2.0

func Enter():
	once = false
	print("bullet")
	timer.wait_time = anticipateTime
	timer_2.wait_time = phaseTime
	timer.start()
	animated_sprite_2d.play("bullet")
	boss.alpha = alpha
	
func Update(delta: float):
	#anticipate Anim
	
	if(timer.time_left <= 0):
		animated_sprite_2d.visible = false
		boss.shoot(2)
		if (!once):
			timer_2.start()
			once = true;
		if(timer_2.time_left == 0):
			Transitioned.emit(self, "idle")
	else:
		animated_sprite_2d.visible = true
		#print("anticipating...")
