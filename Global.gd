extends Node

var Main = null

var winner = 'A'

var color = '#5E35B1'
var health_color = '#335E35B1'

var rocketsA = 1
var rocketsB = 1

var is_online = false
var is_server = false

var connect_to_IP = '192.168.1.2'
var connect_to_port = 6789
var listen_to_port = 6789

const LAYER = {
	'BASE': 0, 'BULLET': 1, 'ROCKET': 2, 'GUN_UPGRADE': 3, 'ROCKET_PACK': 4,
	'BOMB': 5
}
