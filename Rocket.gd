extends Area2D


const TYPE = 'Rocket'


onready var Explosion = $Explosion
onready var Flame = $Flame
onready var Tick = $Tick

var angle = 0  # Radian
const SPEED = 4
const POWER = 30

var health setget set_health
func set_health(value):
	if value <= 0:
		shape_owner_clear_shapes(0)
		Tick.stop()
		Flame.stop()
		G.Main._onRocketExplosionOnAir()
		Explosion.start()
	else:
		health = value


func _ready():
	self.health = 10
	Explosion.interpolate_property(
		self, 'scale', get_scale(), get_scale()*2.4, 0.5,
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
	Explosion.interpolate_property(
		self, 'modulate', get_modulate(), Color(1,1,1,0), 0.5,
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
	randomize()
	Explosion.interpolate_property(
		self, 'rotation', angle+deg2rad(90),
		angle+deg2rad(90)+deg2rad(rand_range(-60, 60)), 0.5,
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
	var Fire = $Fire
	Explosion.interpolate_property(
		Fire, 'scale', Vector2(1,1), Vector2(12,12), 0.5,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	Explosion.interpolate_property(
		Fire, 'modulate', Color('#00debc21'), Color('#66FF6D00'), 0.3,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	Explosion.interpolate_property(
		Fire, 'modulate', Color('#66FF6D00'), Color('#00debc21'), 0.2,
		Tween.TRANS_QUAD, Tween.EASE_IN, 0.3
	)


func _on_Tick_timeout():
	translate(
		Vector2(
			cos(angle)*SPEED, sin(angle)*SPEED
		)
	)


func _on_Lifetime_timeout():
	queue_free()


func _on_Rocket_area_entered(area):
	if area.TYPE == 'Bullet':
		self.health -= area.POWER
		area.queue_free()
		if randi()%2:
			G.Main.Ricochet1.play()
		else:
			G.Main.Ricochet2.play()


func _on_Explosion_tween_completed(object, key):
	if object == self:
		queue_free()