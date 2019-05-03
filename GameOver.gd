extends Control


func _ready():
	if G.winner == 'A':
		$Victory_A.show()
	elif G.winner == 'B':
		$Victory_B.show()
	get_tree().set_auto_accept_quit(false)


func _notification(what):
    if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
        get_tree().change_scene('res://Menu.tscn')


func _on_Restart_pressed():
	get_tree().change_scene('res://Main.tscn')


func _on_Back_pressed():
	get_tree().change_scene('res://Menu.tscn')
