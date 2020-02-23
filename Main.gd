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
onready var BombExplosion = $BombExplosion
onready var GunUpgradeSound = $GunUpgradeSound
onready var RocketPackSound = $RocketPackSound

onready var MainCamera = $MainCamera
onready var ShakeCamera = $ShakeCamera

var RocketPack = preload('res://RocketPack.tscn')
var GunUpgrade = preload('res://GunUpgrade.tscn')
var Bomb = preload('res://Bomb.tscn')


var screenSize = Vector2()

var is_online = false
func _ready():
	get_tree().set_auto_accept_quit(false)
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
	$BombInterval.start()

	ShakeCamera.interpolate_property(
		MainCamera, 'offset',
		Vector2(
			screenSize.x/2, screenSize.y/2
		),
		Vector2(
			screenSize.x/2+4, screenSize.y/2+4
		), 0.1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT
	)
	ShakeCamera.interpolate_property(
		MainCamera, 'offset',
		Vector2(
			screenSize.x/2+4, screenSize.y/2+4
		),
		Vector2(
			screenSize.x/2-4, screenSize.y/2-3
		), 0.1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, 0.1
	)
	ShakeCamera.interpolate_property(
		MainCamera, 'offset',
		Vector2(
			screenSize.x/2-4, screenSize.y/2-3
		),
		Vector2(
			screenSize.x/2+5, screenSize.y/2-5
		), 0.1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, 0.2
	)
	ShakeCamera.interpolate_property(
		MainCamera, 'offset',
		Vector2(
			screenSize.x/2+5, screenSize.y/2-3
		),
		Vector2(
			screenSize.x/2, screenSize.y/2
		), 0.3, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, 0.2
	)
	ShakeCamera.interpolate_property(
		MainCamera, 'zoom',
		Vector2(
			1,1
		),
		Vector2(
			1.02, 1.02
		), 0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0
	)
	ShakeCamera.interpolate_property(
		MainCamera, 'zoom',
		Vector2(
			1.02,1.02
		),
		Vector2(
			1, 1
		), 0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0.2
	)
	# only a flag
	ShakeCamera.interpolate_property(
		MainCamera, 'rotating',
		false,
		false
		, 0.4, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, 0
	)


var back_count = 0
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().change_scene('res://Menu.tscn')
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		back_count += 1
		if back_count > 3:
			get_tree().change_scene('res://Menu.tscn')


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

func onBombExplosion():
#	if not BombExplosion.is_playing():
		BombExplosion.play()
		ShakeCamera.start()


func onGrab_GunUpgrade():
	GunUpgradeSound.play()

func onGrab_RocketPack():
	RocketPackSound.play()

var RocketPack_random_x = 0
var RocketPack_random_y = 0
var RocketPack_ = null
func _on_RocketPackInterval_timeout():
	RocketPack_random_x = rand_range(0, screenSize.x)
	RocketPack_random_y = rand_range(300, screenSize.y-300)
	RocketPack_ = RocketPack.instance()
	RocketPack_.set_global_position(
		Vector2(RocketPack_random_x, RocketPack_random_y)
	)
	Packs.add_child(RocketPack_)


var GunUpgrade_random_x = 0
var GunUpgrade_random_y = 0
var GunUpgrade_ = null
func _on_GunUpgradeInterval_timeout():
	GunUpgrade_random_x = rand_range(0, screenSize.x)
	GunUpgrade_random_y = rand_range(300, screenSize.y-300)
	GunUpgrade_ = GunUpgrade.instance()
	GunUpgrade_.set_global_position(
		Vector2(GunUpgrade_random_x, GunUpgrade_random_y)
	)
	Packs.add_child(GunUpgrade_)


var Bomb_random_x = 0
var Bomb_random_y = 0
var Bomb_ = null
func _on_BombInterval_timeout():
	randomize()
	Bomb_random_x = rand_range(0, screenSize.x)
	Bomb_random_y = rand_range(300, screenSize.y-300)
	Bomb_ = Bomb.instance()
	Bomb_.set_global_position(
		Vector2(Bomb_random_x, Bomb_random_y)
	)
	Packs.add_child(Bomb_)


func _on_ShakeCamera_tween_completed(object, key):
	if key == ':rotating':
		ShakeCamera.set_active(false)
