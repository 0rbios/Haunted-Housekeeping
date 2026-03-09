extends Control

func _play_pressed():
	get_tree().change_scene_to_file("res://Temp/debug.tscn")

func _exit_button():
	get_tree().quit()
