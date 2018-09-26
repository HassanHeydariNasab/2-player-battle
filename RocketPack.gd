extends Area2D


onready var Pick = $Pick
onready var Lifetime = $Lifetime


func _ready():
	randomize()
	set_rotation_degrees(rand_range(0,360))
	Pick.interpolate_property(
		self, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.5,
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
	Pick.interpolate_property(
		self, 'scale', get_scale(), get_scale()*4, 0.5,
		Tween.TRANS_ELASTIC, Tween.EASE_IN
	)
	Lifetime.interpolate_property(
		self, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 2,
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
	Lifetime.start()


func _on_Pick_tween_completed(object, key):
	queue_free()


func _on_RocketPack_area_entered(area):
	shape_owner_clear_shapes(0)
	area.queue_free()
	Lifetime.stop_all()
	if get_global_position().y > G.Main.screenSize.y/2:
		G.Main.BaseA.rockets += 1
	else:
		G.Main.BaseB.rockets += 1
	Pick.start()


func _on_Lifetime_tween_completed(object, key):
	queue_free()
