extends Control


var screenSize = Vector2()


func _notification(what):
    if what in [MainLoop.NOTIFICATION_WM_QUIT_REQUEST, MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST]:
        get_tree().change_scene('res://Menu.tscn')

func _ready():
	get_tree().set_auto_accept_quit(false)


func _on_About_item_rect_changed():
	screenSize = get_viewport().size

func _draw():
	for i in range(20):
		draw_circle(
			Vector2(
				rand_range(0, screenSize.x), rand_range(0, screenSize.y)
			),
			rand_range(5, 50), Color('5e35b1')
		)

func _on_Code_pressed():
	OS.shell_open("https://github.com/HassanHeydariNasab/2-player-battle")

func _on_Attributions_pressed():
	OS.shell_open("https://github.com/HassanHeydariNasab/2-player-battle/blob/master/ATTRIBUTIONS.md")

func _on_Liberapay_pressed():
	OS.shell_open("https://liberapay.com/hsn6")

func _on_Bitcoin_pressed():
	OS.shell_open("bitcoin:12SL5VgtjozKTXMgpX7w4MjKvvcFAHbTks")


func _on_Back_pressed():
	get_tree().change_scene("res://Menu.tscn")
