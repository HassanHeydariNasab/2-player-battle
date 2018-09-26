extends Area2D


onready var Gun = $Gun
onready var Launchpad = $Launchpad
onready var nRockets = $nRockets


const TYPE = 'Base'


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
		nRockets.set_text(str(value))


func _ready():
	self.health = 180
	Gun.show()
	Launchpad.hide()
	Launchpad.Interval.stop()
	self.rockets = 2
	set_process(true)


func _draw():
	draw_circle(Vector2(0,0), 180, Color(G.color))


func _process(delta):
	pass


func _on_Base_area_entered(area):
	self.health -= area.POWER
	if area.TYPE == 'Rocket':
		area.shape_owner_clear_shapes(0)
		area.Tick.stop()
		area.Explosion.start()
		G.Main._onRocketExplosionOnBase()
	else:
		if randi()%2:
			G.Main.Ricochet1.play()
		else:
			G.Main.Ricochet2.play()
		area.queue_free()


func _change_weapon():
	if Gun.is_visible_in_tree():
		Gun.hide()
		Gun.Interval.stop()
		Launchpad.show()
		Launchpad.elapsed = 0
	elif Launchpad.is_visible_in_tree():
		Gun.show()
		Gun.Interval.start()
		Launchpad.hide()
		Launchpad.Interval.stop()


func _on_ChangeWeapon_pressed():
	_change_weapon()
