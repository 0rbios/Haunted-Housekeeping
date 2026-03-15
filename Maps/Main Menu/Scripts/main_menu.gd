extends Control

# Play As Host
func _play_pressed():
	MultiplayerSettings.clientType = "host"
	get_tree().change_scene_to_file("res://Temp/debug.tscn")

# Close Game
func _exit_button():
	get_tree().quit()

# Play As Client
func _join_pressed():
	MultiplayerSettings.clientType = "client"
	get_tree().change_scene_to_file("res://Temp/debug.tscn")
