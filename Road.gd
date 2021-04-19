extends Node2D

var tiles = []
var routes = []
var ml = 28
onready var light_ul = $UpperLeft
onready var ul_ewl = $UpperLeft/EastWestLeft
onready var ul_ewr = $UpperLeft/EastWestRight
onready var ul_nsr = $UpperLeft/NorthSouthRight
onready var ul_nsl = $UpperLeft/NorthSouthLeft
onready var light_ur = $UpperRight
onready var ur_ewl = $UpperRight/EastWestLeft
onready var ur_ewr = $UpperRight/EastWestRight
onready var ur_nsr = $UpperRight/NorthSouthRight
onready var ur_nsl = $UpperRight/NorthSouthLeft
onready var light_ll = $LowerLeft
onready var ll_ewl = $LowerLeft/EastWestLeft
onready var ll_ewr = $LowerLeft/EastWestRight
onready var ll_nsr = $LowerLeft/NorthSouthRight
onready var ll_nsl = $LowerLeft/NorthSouthLeft
onready var light_lr = $LowerRight
onready var lr_ewl = $LowerRight/EastWestLeft
onready var lr_ewr = $LowerRight/EastWestRight
onready var lr_nsr = $LowerRight/NorthSouthRight
onready var lr_nsl = $LowerRight/NorthSouthLeft

func setUpTiles():
	var tileIsRoad = false
	var keepOn = false
	for x in range(0, ml):
		tiles.append([])
		if x == 8 || x == 9 || x == 18 || x == 19:
			keepOn = true
		else:
			keepOn = false
		for y in range(0, ml):
			if !keepOn:
				if y == 8 || y == 9 || y == 18 || y == 19:
					tileIsRoad = true
				else:
					tileIsRoad = false
			else:
				tileIsRoad = true
			tiles[x].append(tileIsRoad)
			tileIsRoad = false
	var tile_scene = load("res://Tile.tscn")
	var start = get_viewport_rect().size / 2 - Vector2(540, 540)
	
	var x_pos = start.x
	var y_pos = start.y
	for x in range(0, ml):
		y_pos = start.y
		for y in range(0, ml):
			if tiles[x][y]:
				var tile = tile_scene.instance()
				tiles[x][y] = tile
				add_child(tile)
				tile.position.x = x_pos
				tile.position.y = y_pos
			y_pos += Globals.TILE_SIDE_LEN
		x_pos += Globals.TILE_SIDE_LEN

func setUpRoutes():
	var list = []
	for y in range(0, ml):
		list.append(tiles[8][y])
	var route = Route.new(list)
	routes.append(route)
	
	list = []
	for y in range(0, ml):
		list.append(tiles[9][ml-1 - y])
	route = Route.new(list)
	routes.append(route)
	
	list = []
	for y in range(0, ml):
		list.append(tiles[18][y])
	route = Route.new(list)
	routes.append(route)
	
	list = []
	for y in range(0, ml):
		list.append(tiles[19][ml-1 - y])
	route = Route.new(list)
	routes.append(route)
	
	list = []
	for x in range(0, ml):
		list.append(tiles[x][9])
	route = Route.new(list)
	routes.append(route)
	
	list = []
	for x in range(0, ml):
		list.append(tiles[ml- 1 - x][8])
	route = Route.new(list)
	routes.append(route)
	
	list = []
	for x in range(0, ml):
		list.append(tiles[x][19])
	route = Route.new(list)
	routes.append(route)
	
	list = []
	for x in range(0, ml):
		list.append(tiles[ml- 1 - x][18])
	route = Route.new(list)
	routes.append(route)

func randomRoute():
	var route = routes[randi() % routes.size()]
	return route

func _ready():
	setUpTiles()
	setUpRoutes()
	light_ul.connect("lit", self, "handle_lights")
	light_ll.connect("lit", self, "handle_lights")
	light_ur.connect("lit", self, "handle_lights")
	light_lr.connect("lit", self, "handle_lights")
	light_ul.begin()
	light_ll.begin()
	light_ur.begin()
	light_lr.begin()
	
	for x in range (8, 10):
		for y in range(8, 10):
			tiles[x][y].stopAllTraffic()

func handle_lights(light: LightButton):
	match light:
		ul_ewl:
			print("ul_ewl")
		ul_ewr:
			print("ul_ewr")
		ul_nsl:
			print("ul_nwl")
		ul_nsr:
			print("ul_nwr")
		ll_ewl:
			print()
		ll_ewr:
			print()
		ll_nsl:
			print()
		ll_nsr:
			print()
		ur_ewl:
			print()
		ur_ewr:
			print()
		ur_nsl:
			print()
		ur_nsr:
			print()
		lr_ewl:
			print()
		lr_ewr:
			print()
		lr_nsl:
			print()
		lr_nsr:
			print()

