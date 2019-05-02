extends Area2D


onready var Pick = $Pick
onready var Lifetime = $Lifetime


func _ready():
	randomize()
	Pick.interpolate_property(
		self, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.5,
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
	Pick.interpolate_property(
		self, 'scale', get_scale(), get_scale()*4, 0.5,
		Tween.TRANS_ELASTIC, Tween.EASE_IN
	)
	if get_global_position().y > G.Main.screenSize.y/2:
		Pick.interpolate_property(
			self, 'position', get_global_position(), G.Main.BaseA.get_global_position(), 0.5,
			Tween.TRANS_QUAD, Tween.EASE_IN
		)
	else:
		Pick.interpolate_property(
			self, 'position', get_global_position(), G.Main.BaseB.get_global_position(), 0.5,
			Tween.TRANS_QUAD, Tween.EASE_IN
		)
	Lifetime.interpolate_property(
		self, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 2,
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
	Lifetime.start()


func _on_Pick_tween_completed(object, key):
	queue_free()


func _on_GunUpgrade_area_entered(area):
	shape_owner_clear_shapes(0)
	area.queue_free()
	G.Main.onGrab_GunUpgrade()
	Lifetime.stop_all()
	if get_global_position().y > G.Main.screenSize.y/2:
		G.Main.BaseA.inc_gunLevel(1)
	else:
		G.Main.BaseB.inc_gunLevel(1)
	Pick.start()


func _on_Lifetime_tween_completed(object, key):
	queue_free()
