extends Area2D


const TYPE = 'Bullet'


var angle = 0  # Radian
const SPEED = 15
const POWER = 0.2


func _ready():
	pass


func _on_Tick_timeout():
	translate(
		Vector2(
			cos(angle)*SPEED, sin(angle)*SPEED
		)
	)


func _on_Lifetime_timeout():
	queue_free()
