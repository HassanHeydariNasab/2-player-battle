extends Node


onready var BaseA = $ContainerA/BaseA
onready var BaseB = $ContainerB/BaseB

onready var HealthA = $ContainerA/HealthA
onready var HealthB = $ContainerB/HealthB

onready var Bullets = $Bullets
onready var Packs = $Packs

onready var RocketExplosionOnAir = $RocketExplosionOnAir
onready var RocketExplosionOnBase = $RocketExplosionOnBase
onready var Ricochet1 = $Ricochet1
onready var Ricochet2 = $Ricochet2

onready var MainCamera = $MainCamera


var RocketPack = preload('res://RocketPack.tscn')
var GunUpgrade = preload('res://GunUpgrade.tscn')


var screenSize = Vector2()

var is_online = false
func _ready():
	G.Main = self
	BaseA.is_A = true
	BaseB.is_A = false
	BaseB.set_rotation(deg2rad(180))
	BaseA.rockets = 2
	BaseB.rockets = 2
	set_process(true)
	set_physics_process(true)

	$RocketPackInterval.start()
	$GunUpgradeInterval.start()


func _draw():
#	draw_line(
#		Vector2(0, screenSize.y/2), Vector2(screenSize.x, screenSize.y/2),
#		Color('#66B0BEC5'), 7
#	)
	pass


var is_touching = false
func _input(event):
	if event is InputEventScreenDrag or event is InputEventScreenTouch:
#		printt(event.position, event.index)
		# rotation
		if event.position.y > screenSize.y/2:
			BaseA._set_rotation(event.position.x*90/screenSize.x-45)
			is_touching = true
		# gunshot
		if is_touching:
			is_touching = false
			if BaseA.Gun.is_visible_in_tree():
				if event.is_pressed() and BaseA.Gun.Interval.is_stopped():
					BaseA.Gun_start()
				elif event is InputEventScreenTouch and (not event.is_pressed()):
					BaseA.Gun_stop()
			else:
				if event.is_pressed() and BaseA.Launchpad.Interval.is_stopped() and BaseA.rockets >= 1:
					BaseA.Launchpad_start()
				elif event is InputEventScreenTouch and (not event.is_pressed()):
					BaseA.Launchpad_stop()

		# rotation
		if event.position.y < screenSize.y/2:
			BaseB._set_rotation(event.position.x*90/-screenSize.x-135)
			is_touching = true
		# gunshot
		if is_touching:
			is_touching = false
			if BaseB.Gun.is_visible_in_tree():
				if event.is_pressed() and BaseB.Gun.Interval.is_stopped():
					BaseB.Gun_start()
				elif event is InputEventScreenTouch and (not event.is_pressed()):
					BaseB.Gun_stop()
			else:
				if event.is_pressed() and BaseB.Launchpad.Interval.is_stopped() and BaseB.rockets >= 1:
					BaseB.Launchpad_start()
				elif event is InputEventScreenTouch and (not event.is_pressed()):
					BaseB.Launchpad_stop()
	elif event is InputEventKey:
		# change weapon
		if event.is_action_pressed('A_change_weapon'):
			BaseA._change_weapon()
		elif event.is_action_pressed('B_change_weapon'):
			BaseB._change_weapon()
		# shooting
		elif event.is_action_pressed('A_shoot'):
			if BaseA.Gun.is_visible_in_tree():
				BaseA.Gun_start()
			else:
				if BaseA.Launchpad.Interval.is_stopped() and BaseA.rockets >= 1:
					BaseA.Launchpad_start()
		elif event.is_action_pressed('B_shoot'):
			if BaseB.Gun.is_visible_in_tree():
				BaseB.Gun_start()
			else:
				if BaseB.Launchpad.Interval.is_stopped() and BaseB.rockets >= 1:
					BaseB.Launchpad_start()
		# stop shooting
		elif event.is_action_released('A_shoot'):
			if BaseA.Gun.is_visible_in_tree():
				BaseA.Gun_stop()
			else:
				BaseA.Launchpad_stop()
		elif event.is_action_released('B_shoot'):
			if BaseB.Gun.is_visible_in_tree():
				BaseB.Gun_stop()
			else:
				BaseB.Launchpad_stop()


func _physics_process(delta):
	if Input.is_action_pressed('A_left'):
		BaseA.rotate(deg2rad(-2))
	elif Input.is_action_pressed('A_right'):
		BaseA.rotate(deg2rad(2))
	if Input.is_action_pressed('B_left'):
		BaseB.rotate(deg2rad(2))
	elif Input.is_action_pressed('B_right'):
		BaseB.rotate(deg2rad(-2))


func _on_Main_item_rect_changed():
	screenSize = get_viewport().size
	$MainCamera.set_offset(Vector2(screenSize.x/2, screenSize.y/2))


func _onGameOver(winner):
	G.winner = winner
	get_tree().change_scene('res://GameOver.tscn')


func _onRocketExplosionOnAir():
	RocketExplosionOnAir.play()


func _onRocketExplosionOnBase():
	RocketExplosionOnBase.play()


var RocketPack_random_x = 0
var RocketPack_random_y = 0
# on server
func _on_RocketPackInterval_timeout():
	RocketPack_random_x = rand_range(0, screenSize.x)
	RocketPack_random_y = rand_range(300, screenSize.y-300)
	_spawn_RocketPack(RocketPack_random_x, RocketPack_random_y)

var RocketPack_ = null
func _spawn_RocketPack(random_x, random_y):
	RocketPack_ = RocketPack.instance()
	RocketPack_.set_global_position(
		Vector2(random_x, random_y)
	)
	Packs.add_child(RocketPack_)


var GunUpgrade_random_x = 0
var GunUpgrade_random_y = 0
# on server
func _on_GunUpgradeInterval_timeout():
	GunUpgrade_random_x = rand_range(0, screenSize.x)
	GunUpgrade_random_y = rand_range(300, screenSize.y-300)
	_spawn_GunUpgrade(GunUpgrade_random_x, GunUpgrade_random_y)

var GunUpgrade_ = null
func _spawn_GunUpgrade(random_x, random_y):
	GunUpgrade_ = GunUpgrade.instance()
	GunUpgrade_.set_global_position(
		Vector2(random_x, random_y)
	)
	Packs.add_child(GunUpgrade_)
