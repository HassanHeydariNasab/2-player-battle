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
	is_online = true
	BaseA.is_A = true
	BaseB.is_A = false
	BaseB.set_rotation(deg2rad(180))
	BaseA.rockets = 2
	BaseB.rockets = 2
	set_process(true)
	set_physics_process(true)


	var args = OS.get_cmdline_args()
	if '-s' in args:
		# create server
		var peer = NetworkedMultiplayerENet.new()
		peer.create_server(6789, 2)
		get_tree().set_network_peer(peer)
		get_tree().connect("network_peer_connected", self, "_player_connected")
		get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
		
	elif is_online:
		# connect client to server
		var peer = NetworkedMultiplayerENet.new()
		peer.create_client('127.0.0.1', 6789)
		get_tree().set_network_peer(peer)
		get_tree().connect("connected_to_server", self, "_connected_ok")
		get_tree().connect("connection_failed", self, "_connected_fail")
		get_tree().connect("server_disconnected", self, "_server_disconnected")


func _draw():
	draw_line(
		Vector2(0, screenSize.y/2), Vector2(screenSize.x, screenSize.y/2),
		Color('#66B0BEC5'), 7
	)


var is_touching = false
func _input(event):
	if event is InputEventScreenDrag or event is InputEventScreenTouch:
#		printt(event.position, event.index)
		# rotation
		if not is_online and event.position.y > screenSize.y/2:
			BaseA._set_rotation(event.position.x*90/screenSize.x-45)
			is_touching = true
		elif is_online and BaseA.get_network_master() == get_tree().get_network_unique_id():
			BaseA.rpc('_set_rotation', event.position.x*90/screenSize.x-45)
			BaseA._set_rotation(event.position.x*90/screenSize.x-45)
			is_touching = true
		# gunshot
		if is_touching:
			is_touching = false
			if BaseA.Gun.is_visible_in_tree():
				if event.is_pressed() and BaseA.Gun.Interval.is_stopped():
					if is_online and BaseA.get_network_master() == get_tree().get_network_unique_id():
						BaseA.rpc('Gun_start')
						BaseA.Gun_start()
					else:
						BaseA.Gun_start()
				elif event is InputEventScreenTouch and (not event.is_pressed()):
					if is_online:
						BaseA.rpc('Gun_stop')
						BaseA.Gun_stop()
					else:
						BaseA.Gun_stop()
			else:
				if event.is_pressed() and BaseA.Launchpad.Interval.is_stopped() and BaseA.rockets >= 1:
					if is_online and BaseA.get_network_master() == get_tree().get_network_unique_id():
						BaseA.rpc('Launchpad_start')
						BaseA.Launchpad_start()
					else:
						BaseA.Launchpad_start()
				elif event is InputEventScreenTouch and (not event.is_pressed()):
					if is_online and BaseA.get_network_master() == get_tree().get_network_unique_id():
						BaseA.rpc('Launchpad_stop')
						BaseA.Launchpad_stop()
					else:
						BaseA.Launchpad_stop()
					
		# rotation
		if not is_online and event.position.y < screenSize.y/2:
			BaseB._set_rotation(event.position.x*90/-screenSize.x-135)
			is_touching = true
		elif is_online and BaseB.get_network_master() == get_tree().get_network_unique_id():
			BaseB.rpc('_set_rotation', event.position.x*90/screenSize.x+135)
			BaseB._set_rotation(event.position.x*90/screenSize.x+135)
			is_touching = true
		# gunshot
		if is_touching:
			is_touching = false
			if BaseB.Gun.is_visible_in_tree():
				if event.is_pressed() and BaseB.Gun.Interval.is_stopped():
					if is_online and BaseB.get_network_master() == get_tree().get_network_unique_id():
						BaseB.rpc('Gun_start')
						BaseB.Gun_start()
					else:
						BaseB.Gun_start()
				elif event is InputEventScreenTouch and (not event.is_pressed()):
					if is_online:
						BaseB.rpc('Gun_stop')
						BaseB.Gun_stop()
					else:
						BaseB.Gun_stop()
			else:
				if event.is_pressed() and BaseB.Launchpad.Interval.is_stopped() and BaseB.rockets >= 1:
					if is_online and BaseB.get_network_master() == get_tree().get_network_unique_id():
						BaseB.rpc('Launchpad_start')
						BaseB.Launchpad_start()
					else:
						BaseB.Launchpad_start()
				elif event is InputEventScreenTouch and (not event.is_pressed()):
					if is_online and BaseB.get_network_master() == get_tree().get_network_unique_id():
						BaseB.rpc('Launchpad_stop')
						BaseB.Launchpad_stop()
					else:
						BaseB.Launchpad_stop()
	elif event is InputEventKey:
		# change weapon
		if event.is_action_pressed('A_change_weapon'):
			if not is_online:
				BaseA._change_weapon()
			elif is_online:
				if BaseA.get_network_master() == get_tree().get_network_unique_id():
					BaseA.rpc('_change_weapon')
					BaseA._change_weapon()
				elif BaseB.get_network_master() == get_tree().get_network_unique_id():
					BaseB.rpc('_change_weapon')
					BaseB._change_weapon()
		elif event.is_action_pressed('B_change_weapon'):
			if not is_online:
				BaseB._change_weapon()
		# shooting
		elif event.is_action_pressed('A_shoot'):
			if not is_online:
				if BaseA.Gun.is_visible_in_tree():
					BaseA.Gun_start()
				else:
					if BaseA.Launchpad.Interval.is_stopped() and BaseA.rockets >= 1:
						BaseA.Launchpad_start()
			else:
				if BaseA.get_network_master() == get_tree().get_network_unique_id():
					if BaseA.Gun.is_visible_in_tree():
						BaseA.rpc('Gun_start')
						BaseA.Gun_start()
					else:
						if BaseA.Launchpad.Interval.is_stopped() and BaseA.rockets >= 1:
							BaseA.rpc('Launchpad_start')
							BaseA.Launchpad_start()
				elif BaseB.get_network_master() == get_tree().get_network_unique_id():
					if BaseB.Gun.is_visible_in_tree():
						BaseB.rpc('Gun_start')
						BaseB.Gun_start()
					else:
						if BaseB.Launchpad.Interval.is_stopped() and BaseB.rockets >= 1:
							BaseB.rpc('Launchpad_start')
							BaseB.Launchpad_start()
		elif event.is_action_pressed('B_shoot'):
			if not is_online:
				if BaseB.Gun.is_visible_in_tree():
					BaseB.Gun_start()
				else:
					if BaseB.Launchpad.Interval.is_stopped() and BaseB.rockets >= 1:
						BaseB.Launchpad_start()
		# stop shooting
		elif event.is_action_released('A_shoot'):
			if not is_online:
				if BaseA.Gun.is_visible_in_tree():
					BaseA.Gun_stop()
				else:
					BaseA.Launchpad_stop()
			else:
				if BaseA.get_network_master() == get_tree().get_network_unique_id():
					if BaseA.Gun.is_visible_in_tree():
						BaseA.rpc('Gun_stop')
						BaseA.Gun_stop()
					else:
						BaseA.rpc('Launchpad_stop')
						BaseA.Launchpad_stop()
				elif BaseB.get_network_master() == get_tree().get_network_unique_id():
					if BaseB.Gun.is_visible_in_tree():
						BaseB.rpc('Gun_stop')
						BaseB.Gun_stop()
					else:
						BaseB.rpc('Launchpad_stop')
						BaseB.Launchpad_stop()
		elif event.is_action_released('B_shoot'):
			if not is_online:
				if BaseB.Gun.is_visible_in_tree():
					BaseB.Gun_stop()
				else:
					BaseB.Launchpad_stop()


func _physics_process(delta):
	if not is_online:
		if Input.is_action_pressed('A_left'):
			BaseA.rotate(deg2rad(-2))
		elif Input.is_action_pressed('A_right'):
			BaseA.rotate(deg2rad(2))
		if Input.is_action_pressed('B_left'):
			BaseB.rotate(deg2rad(2))
		elif Input.is_action_pressed('B_right'):
			BaseB.rotate(deg2rad(-2))
	elif is_online:
		if Input.is_action_pressed('A_left'):
			if BaseA.get_network_master() == get_tree().get_network_unique_id():
				BaseA.rpc('_rotate', -2)
				BaseA._rotate(-2)
			elif BaseB.get_network_master() == get_tree().get_network_unique_id():
				BaseB.rpc('_rotate', -2)
				BaseB._rotate(-2)
		elif Input.is_action_pressed('A_right'):
			if BaseA.get_network_master() == get_tree().get_network_unique_id():
				BaseA.rpc('_rotate', 2)
				BaseA._rotate(2)
			elif BaseB.get_network_master() == get_tree().get_network_unique_id():
				BaseB.rpc('_rotate', 2)
				BaseB._rotate(2)


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



# on server
func _player_connected(id):
	print('player connected: ', id)
	if $ContainerA.get_network_master() == 1:
		# on server
		$ContainerA.set_network_master(id)
	elif $ContainerB.get_network_master() == 1:
		# on server
		$ContainerB.set_network_master(id)
		# to clients
		rpc('set_ContainerB_master', id)
		rpc('set_ContainerA_master', $ContainerA.get_network_master())
		# to B
		rpc_id(id, '_rotate_Main_scene')
	else:
		print('The game is full')
	printt($ContainerA.get_network_master(), $ContainerB.get_network_master())

# comes from server to clients
remote func set_ContainerA_master(id):
	print('A:',id)
	$ContainerA.set_network_master(id)

# comes from server to clients
remote func set_ContainerB_master(id):
	print('B:',id)
	# TEST
	$ContainerB.set_network_master(id)

# comes from server to B
remote func _rotate_Main_scene():
	MainCamera.set_rotation_degrees(180)

# on server
func _player_disconnected(id):
	print('player disconnected: ', id)

# on client
func _connected_ok():
	print('connected to the server. my id is ', get_tree().get_network_unique_id())

# on client
func _connected_fail():
	print('could not connect to the server')

# on client
func _server_disconnected():
	print('the server kicked us!')
	
