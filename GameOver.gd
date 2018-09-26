extends Control


func _ready():
	$Winner.set_text('Winner: '+G.winner)


func _on_Restart_pressed():
	get_tree().change_scene('res://Main.tscn')


func _on_Exit_pressed():
	get_tree().quit()
