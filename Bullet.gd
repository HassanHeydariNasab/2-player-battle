extends Area2D


var angle = 0  # Radian
var speed = 15
const POWER = 0.2


func _ready():
	pass


func _on_Tick_timeout():
	translate(
		Vector2(
			cos(angle)*speed, sin(angle)*speed
		)
	)


func _on_Lifetime_timeout():
	queue_free()
