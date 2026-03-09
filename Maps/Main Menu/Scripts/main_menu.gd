extends Control

func _play_pressed():
	MultiplayerSettings.clientType = "host"
	get_tree().change_scene_to_file("res://Temp/debug.tscn")

func _exit_button():
	get_tree().quit()

func _join_pressed():
	MultiplayerSettings.clientType = "client"
	get_tree().change_scene_to_file("res://Temp/debug.tscn")
