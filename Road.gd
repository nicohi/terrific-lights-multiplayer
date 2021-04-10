extends Node2D

var tiles = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func setUpTiles():
	var tileIsRoad = false
	var keepOn = false
	for x in range(0, 28):
		tiles.append([])
		if x == 8 || x == 9 || x == 18 || x == 19:
			keepOn = true
		else:
			keepOn = false
		var y_phase = 0
		for y in range(28):
			if !keepOn:
				if y == 8 || y == 9 || y == 18 || y == 19:
					tileIsRoad = true
				else:
					tileIsRoad = false
			else:
				tileIsRoad = true
			tiles[x].append(tileIsRoad)
			tileIsRoad = false
#	tiles.append([]);
#	for i in range(28):
#		if i == 7 || i == 8 || i == 17 || i == 18:
#			tiles[27].append(true)
#		else:
#			tiles[27].append(false)
			
#	for x in range(28):
#		print(tiles[x])
	var tile_scene = load("res://Tile.tscn")
	var start = OS.window_size / 2 - Vector2(540, 540)
	var x_pos = start.x
	var y_pos = start.y
	for x in range(28):
		y_pos = start.y
		for y in range(28):
			if tiles[x][y]:
				var tile = tile_scene.instance()
				tiles[x][y] = tile
				add_child(tile)
				tile.position.x = x_pos
				tile.position.y = y_pos
#				print(tile.position)
			y_pos += 40
		x_pos += 40
	
#	for x in range(28):
#		print(tiles[x])


# Called when the node enters the scene tree for the first time.
func _ready():
	setUpTiles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
