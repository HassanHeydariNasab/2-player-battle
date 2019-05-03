extends Area2D


onready var Explode = $Explode
onready var Lifetime = $Lifetime

const POWER = 10
var target = null

var is_exploded = false

func _ready():
	randomize()
	Explode.interpolate_property(
		self, 'modulate', Color(1,1,1,1), Color(1,0.5,0.5,0), 0.5,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	Explode.interpolate_property(
		self, 'scale', get_scale(), get_scale()*7, 0.5,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	Lifetime.interpolate_property(
		self, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 2,
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
	Lifetime.start()


func _draw():
	draw_circle(Vector2(0, 0), 20, Color('F4511E'))
	draw_circle(Vector2(0, 0), 17, Color('212121'))

func _on_Explode_tween_completed(object, key):
	queue_free()


func _on_Bomb_area_entered(area):
	# Base
	if area.get_collision_layer_bit(G.LAYER['BASE']):
		area.health -= POWER
	# Bullet, Rocket, Bomb,...
	elif area.get_collision_layer_bit(G.LAYER['BULLET']) and not is_exploded:
		is_exploded = true
		area.shape_owner_clear_shapes(0)
		area.queue_free()
		G.Main.onBombExplosion()
		Explode.start()
		Lifetime.stop_all()
#	elif area.get_collision_layer_bit(G.LAYER['BOMB']):
#		area.queue_free()


func _on_Lifetime_tween_completed(object, key):
	queue_free()
