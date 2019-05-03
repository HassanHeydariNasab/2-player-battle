extends Area2D


onready var Gun = $Gun
onready var GunInterval = $Gun/Interval
onready var Launchpad = $Launchpad
onready var RocketsCount = get_node('../RocketsCount')
onready var GunLevel = $Gun/GunLevel
onready var Red = $Red


var is_A = null


var health setget set_health
func set_health(value):
	if value > 180:
		value = 180
	elif value <= 0:
		value = 0
		if is_A:
			G.Main._onGameOver('B')
		else:
			G.Main._onGameOver('A')
	health = value
	if is_A:
		G.Main.HealthA.set_rotation(deg2rad(value+90))
	elif is_A == false:
		G.Main.HealthB.set_rotation(deg2rad(value-90))


var rockets setget set_rockets
func set_rockets(value):
	if value >= 0 and value <= 5:
		rockets = value
		RocketsCount.set_value(value)

var gunLevel = 1 setget set_gunLevel
func set_gunLevel(value):
	if value >= 0 and value <= 100:
		gunLevel = value
		GunLevel.set_text(str(value))
		GunInterval.set_wait_time(1.0/(value+10)*5)

func inc_gunLevel(by):
	self.gunLevel += by


func _ready():
	self.health = 2
	self.gunLevel = 1
	Gun.show()
	Launchpad.hide()
	Launchpad.Interval.stop()
	set_process(true)
	Red.interpolate_property(
		self, 'modulate', Color(1,1,1,1), Color('#FF5252'),
		0.2, Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	Red.interpolate_property(
		self, 'modulate', Color('#FF5252'), Color(1,1,1,1),
		0.2, Tween.TRANS_QUAD, Tween.EASE_OUT
	)

func _draw():
	draw_circle(Vector2(0,0), 180, Color(G.color))


func _process(delta):
	pass


func _on_Base_area_entered(area):
	area.shape_owner_clear_shapes(0)
	self.health -= area.POWER
	if area.get_collision_layer_bit(G.LAYER['ROCKET']):
		area.Tick.stop()
		area.Explosion.start()
		G.Main._onRocketExplosionOnBase()
		Red.start()
	elif area.get_collision_layer_bit(G.LAYER['BULLET']):
		if randi()%2:
			G.Main.Ricochet1.play()
		else:
			G.Main.Ricochet2.play()
		area.queue_free()
		Red.start()
	elif area.get_collision_layer_bit(G.LAYER['BOMB']):
		Red.start()


func _set_rotation(angle):
	set_rotation(deg2rad(angle))

func _rotate(angle):
	rotate(deg2rad(angle))

func Gun_start():
	Gun.Interval.start()

func Gun_stop():
	Gun.Interval.stop()

func Launchpad_start():
	Launchpad.Interval.start()
	Launchpad.DustR.set_emitting(true)
	Launchpad.DustL.set_emitting(true)
	Launchpad.Launch.play()

func Launchpad_stop():
	Launchpad.Interval.stop()
	Launchpad.DustR.set_emitting(false)
	Launchpad.DustL.set_emitting(false)
	Launchpad.Launch.stop()


func _change_weapon():
	if Gun.is_visible_in_tree():
		Gun.hide()
		Gun.Interval.stop()
		Launchpad.show()
	elif Launchpad.is_visible_in_tree():
		Gun.show()
		Launchpad.hide()
		Launchpad.Interval.stop()


func _on_ChangeWeapon_pressed():
	_change_weapon()


func _on_Red_tween_completed(object, key):
	Red.set_active(false)
