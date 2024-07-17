extends State
class_name idle

@export var phaseTime: float = 3.0;
@onready var timer = $"../Timer"
var rand = RandomNumberGenerator.new()
@export var patterns : Array[StringName]
var patternRand : int

func Enter():
	#random pattern
	patternRand = rand.randi_range(0, patterns.size() - 1)
	timer.wait_time = phaseTime
	timer.start()
	pass
	
func Update(delta: float):
	if(timer.time_left == 0):
		Transitioned.emit(self, patterns[patternRand])
