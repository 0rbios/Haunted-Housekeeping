extends Control

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server...")
		_start_server()

# Play As Host
func _start_server():
	MultiplayerSettings.clientType = "host"
	get_tree().change_scene_to_file("res://Temp/debug.tscn")

# Close Game
func _exit_button():
	get_tree().quit()

# Play As Client
func _join_pressed():
	MultiplayerSettings.clientType = "client"
	MultiplayerSettings.Ip = $"CanvasLayer/IP Entry".text
	get_tree().change_scene_to_file("res://Temp/debug.tscn")
