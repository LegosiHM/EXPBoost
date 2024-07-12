extends Control

func _on_button_pressed():
	AudioManager.test_sound.play()


func _on_button_2_pressed():
	AudioManager.test_sound_2.play()


func _on_button_3_pressed():
	AudioManager.ChangeBGMusic()
