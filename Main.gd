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


var RocketPack = preload('res://RocketPack.tscn')
var GunUpgrade = preload('res://GunUpgrade.tscn')


var screenSize = Vector2()


func _ready():
	G.Main = self
	BaseA.is_A = true
	BaseB.is_A = false
	BaseB.set_rotation(deg2rad(180))
	BaseA.rockets = 2
	BaseB.rockets = 2
	set_process(true)
	set_physics_process(true)


func _draw():
	draw_line(
		Vector2(0, screenSize.y/2), Vector2(screenSize.x, screenSize.y/2),
		Color('#66B0BEC5'), 7
	)


func _input(event):
	if event is InputEventScreenDrag or event is InputEventScreenTouch:
#		printt(event.position, event.index)
		if event.position.y > screenSize.y/2:
			BaseA.set_rotation(deg2rad(event.position.x*90/screenSize.x-45))
			if BaseA.Gun.is_visible_in_tree():
				if event.is_pressed() and BaseA.Gun.Interval.is_stopped():
					BaseA.Gun.Interval.start()
				elif event is InputEventScreenTouch and (not event.is_pressed()):
					BaseA.Gun.Interval.stop()
			else:
				if event.is_pressed() and BaseA.Launchpad.Interval.is_stopped() and BaseA.rockets >= 1:
					BaseA.Launchpad.Interval.start()
					BaseA.Launchpad.DustR.set_emitting(true)
					BaseA.Launchpad.DustL.set_emitting(true)
					BaseA.Launchpad.Launch.play()
				elif event is InputEventScreenTouch and (not event.is_pressed()):
					BaseA.Launchpad.Interval.stop()
					BaseA.Launchpad.DustR.set_emitting(false)
					BaseA.Launchpad.DustL.set_emitting(false)
					BaseA.Launchpad.Launch.stop()
				
		elif event.position.y < screenSize.y/2:
			BaseB.set_rotation(-deg2rad(event.position.x*90/screenSize.x+135))
			if BaseB.Gun.is_visible_in_tree():
				if event.is_pressed() and BaseB.Gun.Interval.is_stopped():
					BaseB.Gun.Interval.start()
				elif event is InputEventScreenTouch and (not event.is_pressed()):
					BaseB.Gun.Interval.stop()
			else:
				if event.is_pressed() and BaseB.Launchpad.Interval.is_stopped() and BaseB.rockets >= 1:
					BaseB.Launchpad.Interval.start()
					BaseB.Launchpad.DustR.set_emitting(true)
					BaseB.Launchpad.DustL.set_emitting(true)
					BaseB.Launchpad.Launch.play()
				elif event is InputEventScreenTouch and (not event.is_pressed()):
					BaseB.Launchpad.Interval.stop()
					BaseB.Launchpad.DustR.set_emitting(false)
					BaseB.Launchpad.DustL.set_emitting(false)
					BaseB.Launchpad.Launch.stop()
	elif event is InputEventKey:
		if Input.is_action_just_pressed('A_change_weapon'):
			BaseA._change_weapon()
		elif Input.is_action_just_pressed('B_change_weapon'):
			BaseB._change_weapon()


func _physics_process(delta):
	if Input.is_action_pressed('A_left'):
		BaseA.rotate(deg2rad(-2))
	elif Input.is_action_pressed('A_right'):
		BaseA.rotate(deg2rad(2))
	if Input.is_action_pressed('B_left'):
		BaseB.rotate(deg2rad(2))
	elif Input.is_action_pressed('B_right'):
		BaseB.rotate(deg2rad(-2))


func _process(delta):
	if Input.is_action_just_pressed('A_shoot'):
		if BaseA.Gun.is_visible_in_tree():
			BaseA.Gun.Interval.start()
		else:
			if BaseA.Launchpad.Interval.is_stopped() and BaseA.rockets >= 1:
				BaseA.Launchpad.Interval.start()
				BaseA.Launchpad.DustR.set_emitting(true)
				BaseA.Launchpad.DustL.set_emitting(true)
				BaseA.Launchpad.Launch.play()
	elif Input.is_action_just_released('A_shoot'):
		if BaseA.Gun.is_visible_in_tree():
			BaseA.Gun.Interval.stop()
		else:
			BaseA.Launchpad.Interval.stop()
			BaseA.Launchpad.DustR.set_emitting(false)
			BaseA.Launchpad.DustL.set_emitting(false)
			BaseA.Launchpad.Launch.stop()
	
	if Input.is_action_just_pressed('B_shoot'):
		if BaseB.Gun.is_visible_in_tree():
			BaseB.Gun.Interval.start()
		else:
			if BaseB.Launchpad.Interval.is_stopped() and BaseB.rockets >= 1:
				BaseB.Launchpad.Interval.start()
				BaseB.Launchpad.DustR.set_emitting(true)
				BaseB.Launchpad.DustL.set_emitting(true)
				BaseB.Launchpad.Launch.play()
	elif Input.is_action_just_released('B_shoot'):
		if BaseB.Gun.is_visible_in_tree():
			BaseB.Gun.Interval.stop()
		else:
			BaseB.Launchpad.Interval.stop()
			BaseB.Launchpad.DustR.set_emitting(false)
			BaseB.Launchpad.DustL.set_emitting(false)
			BaseB.Launchpad.Launch.stop()
	

func _on_Main_item_rect_changed():
	screenSize = get_viewport().size


func _onGameOver(winner):
	G.winner = winner
	get_tree().change_scene('res://GameOver.tscn')


func _onRocketExplosionOnAir():
	RocketExplosionOnAir.play()


func _onRocketExplosionOnBase():
	RocketExplosionOnBase.play()


var RocketPack_ = null
func _on_RocketPackInterval_timeout():
	RocketPack_ = RocketPack.instance()
	RocketPack_.set_global_position(
		Vector2(
			rand_range(0, screenSize.x),
			rand_range(300, screenSize.y-300)
		)
	)
	Packs.add_child(RocketPack_)


var GunUpgrade_ = null
func _on_GunUpgradeInterval_timeout():
	GunUpgrade_ = GunUpgrade.instance()
	GunUpgrade_.set_global_position(
		Vector2(
			rand_range(0, screenSize.x),
			rand_range(300, screenSize.y-300)
		)
	)
	Packs.add_child(GunUpgrade_)
