extends Node2D

var Bullet = preload('res://Bullet.tscn')

onready var Shoot = $Shoot
onready var Outlet = $Outlet
onready var Interval = $Interval
onready var Flame = $Flame
onready var Flash = $Flame/Flash


func _ready():
	$Look.set_color(Color(G.color))
	Flash.interpolate_property(Flame, 'modulate', Color('#00FFAB40'), Color('#44FFAB40'), 0.08, Tween.TRANS_QUAD, Tween.EASE_OUT)
	Flash.interpolate_property(Flame, 'modulate', Color('#44FFAB40'), Color('#00FFAB40'), 0.02, Tween.TRANS_QUAD, Tween.EASE_IN, 0.08)


var Bullet_ = null
var rand_scale = 1.0
func _on_Interval_timeout():
	rand_scale = rand_range(2.4, 3.1)
	Flame.set_scale(Vector2(rand_scale, rand_scale))
	Flash.reset_all()
	Flash.start()
	Shoot.play()
	Bullet_ = Bullet.instance()
	Bullet_.set_global_position(Outlet.get_global_position())
	Bullet_.angle = get_global_rotation()+deg2rad(-90)
	G.Main.Bullets.add_child(Bullet_)
	Bullet_.set_global_rotation(get_global_rotation())
