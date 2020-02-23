extends CanvasItem


func _ready():
	pass


func _draw():
	draw_line(
		Vector2(0, G.Main.screenSize.y/2), Vector2(G.Main.screenSize.x, G.Main.screenSize.y/2),
		Color('#E3E8EB'), 7
	)
