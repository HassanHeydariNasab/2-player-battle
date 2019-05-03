extends Control


func _ready():
	get_tree().set_auto_accept_quit(true)


func _notification(what):
	if what in [MainLoop.NOTIFICATION_WM_QUIT_REQUEST, MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST]:
		get_tree().quit()


func _on_Play_pressed():
	get_tree().change_scene("res://Main.tscn")

func _on_Settings_pressed():
	get_tree().change_scene("res://Settings.tscn")

func _on_About_pressed():
	get_tree().change_scene("res://About.tscn")

func _on_Exit_pressed():
	get_tree().quit()
