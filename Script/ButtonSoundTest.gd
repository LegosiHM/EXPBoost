extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	AudioManager.test_sound.play()


func _on_button_2_pressed():
	AudioManager.test_sound_2.play()


func _on_button_3_pressed():
	AudioManager.ChangeBGMusic()
