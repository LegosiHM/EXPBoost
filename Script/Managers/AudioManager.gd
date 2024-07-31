extends Node

@onready var test_sound = $TestSound
@onready var test_sound_2 = $TestSound2
@onready var car_moving = $CarMoving
@onready var car_dash = $CarDash
@onready var car_perfect_dash = $CarPerfectDash
@onready var car_get_hit_01 = $CarGetHit01
@onready var car_get_hit_02 = $CarGetHit02
@onready var boss_bullet = $BossBullet
@onready var boss_changing_phase = $BossChangingPhase
@onready var boss_laser_hold = $BossLaserHold
@onready var boss_laser_one_hit = $BossLaserOneHit
@onready var dash_on_cooldwon = $DashOnCooldwon
@onready var dash_reset = $DashReset
@onready var point_increase = $PointIncrease
@onready var point_perfect_dash = $PointPerfectDash


const DOOM_CUT = preload("res://Assets/Audio/Doom Cut.mp3")
#const FLUFFING_A_DUCK = preload("res://Assets/Audio/Fluffing a Duck.mp3")

@onready var b_gmusic = $BGmusic

func _ready():
	#b_gmusic.stream = DOOM_CUT
	#b_gmusic.play()
	pass

#func ChangeBGMusic():
	#if b_gmusic.stream == DOOM_CUT:
		#b_gmusic.stream = FLUFFING_A_DUCK
	#else:
		#b_gmusic.stream = DOOM_CUT
		
	#b_gmusic.play()
	
