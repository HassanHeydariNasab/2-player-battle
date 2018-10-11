extends Control


func _ready():
	var args = OS.get_cmdline_args()
	if '-s' in args:
		print(1)


func _on_Connect_pressed():
	pass # replace with function body
