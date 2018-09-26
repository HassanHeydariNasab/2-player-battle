extends Node2D

var Rocket = preload('res://Rocket.tscn')

onready var Outlet = $Outlet
onready var Interval = $Interval

var ParentIsReady = false


func _ready():
	$Look.set_color(Color(G.color))


var elapsed = 0
var Rocket_ = null
func _on_Interval_timeout():
	elapsed += 1
	if elapsed == 3:
		if get_parent().rockets >= 1:
			Rocket_ = Rocket.instance()
			Rocket_.set_global_position(Outlet.get_global_position())
			Rocket_.angle = get_global_rotation()+deg2rad(-90)
			G.Main.Bullets.add_child(Rocket_)
			Rocket_.set_global_rotation(get_global_rotation())
			get_parent().rockets -= 1
		elapsed = 0
