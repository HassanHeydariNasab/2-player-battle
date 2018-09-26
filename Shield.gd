extends Area2D


func shield_points(
	center, radius_internal, radius_external,
	angle_from, angle_to,
	nb_points_internal=10, nb_points_external=12
):
	var points_arc_internal = PoolVector2Array()
	var points_arc_external = PoolVector2Array()

	for i in range(nb_points_internal+1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points_internal-90)
		points_arc_internal.append(center + Vector2(cos(angle_point), sin(angle_point)) * radius_internal)
	for i in range(nb_points_external+1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points_external-90)
		points_arc_external.append(center + Vector2(cos(angle_point), sin(angle_point)) * radius_external)
	points_arc_internal.invert()
	return points_arc_external+points_arc_internal


func _draw():
	var shield_points_ = shield_points(Vector2(0,0), 300, 250, 0, 90)
	draw_polygon(shield_points_, PoolColorArray([Color('#1565C0')]))
	$Collision.set_polygon(shield_points_)
