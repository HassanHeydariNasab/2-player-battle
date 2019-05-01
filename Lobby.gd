extends Control

func _ready():
	pass

func _on_connect_to_IP_text_changed(new_text):
	G.connect_to_IP = str(new_text)

func _on_connect_to_port_text_changed(new_text):
	G.connect_to_port = int(new_text)

func _on_listen_to_port_text_changed(new_text):
	G.listen_to_port = int(new_text)

func _on_Connect_pressed():
	G.is_online = true
	G.is_server = false
	get_tree().change_scene('res://Main.tscn')

func _on_Create_pressed():
	G.is_online = true
	G.is_server = true
	get_tree().change_scene('res://Main.tscn')

func _on_Offline_pressed():
	G.is_online = false
	G.is_server = false
	get_tree().change_scene('res://Main.tscn')

