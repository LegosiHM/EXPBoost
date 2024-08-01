extends Control

func _on_texture_button_2_pressed():
	get_tree().quit() # Replace with function body.


func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")

func _ready():
	AudioManager.background_music.play()
