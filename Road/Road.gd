extends Node2D

var tiles = []
var routes = []

func setUpTiles():
	var tileIsRoad = false
	var keepOn = false
	for x in range(28):
		tiles.append([])
		if x == 8 || x == 9 || x == 18 || x == 19:
			keepOn = true
		else:
			keepOn = false
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
	var tile_scene = load("res://Road/Tile.tscn")
	var start = get_viewport_rect().size / 2 - Vector2(540, 540)
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
			y_pos += 40
		x_pos += 40

func setUpRoutes():
	var list = []
	for y in range(28):
		list.append(tiles[8][y])
	var route = Route.new(list)
	routes.append(route)
	
	list = []
	for y in range(27):
		list.append(tiles[9][27 - y])
	route = Route.new(list)
	routes.append(route)
	
	list = []
	for y in range(28):
		list.append(tiles[18][y])
	route = Route.new(list)
	routes.append(route)
	
	list = []
	for y in range(27):
		list.append(tiles[19][27 - y])
	route = Route.new(list)
	routes.append(route)

func randomRoute(car):
	# set a random route for the car to follow
	var route = routes[randi() % routes.size()]
	# car.setRoute(route) which also sets car ind at 0
	pass

func _ready():
	setUpTiles()
	setUpRoutes()
