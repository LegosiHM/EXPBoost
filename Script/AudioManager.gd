extends Node

@onready var test_sound = $TestSound
@onready var test_sound_2 = $TestSound2

const DOOM_CUT = preload("res://NodeScenes/Audio/Doom Cut.mp3")
const FLUFFING_A_DUCK = preload("res://NodeScenes/Audio/Fluffing a Duck.mp3")

@onready var b_gmusic = $BGmusic

func _ready():
	#b_gmusic.stream = DOOM_CUT
	#b_gmusic.play()
	pass

func ChangeBGMusic():
	if b_gmusic.stream == DOOM_CUT:
		b_gmusic.stream = FLUFFING_A_DUCK
	else:
		b_gmusic.stream = DOOM_CUT
		
	b_gmusic.play()
	
