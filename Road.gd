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
				tile.setCoordinates(x, y)
				tiles[x][y] = tile
				add_child(tile)
				tile.position.x = x_pos
				tile.position.y = y_pos
				if (x == 8 || x == 9 || x == 18 || x == 19) and (y == 8 || y == 9 || y == 18 || y == 19):
					tile.is_crossing = true
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

enum { NONE, ALL, NORTH, EAST, SOUTH, WEST }
enum { STRAIGHT_OR_RIGHT, LEFT_TURN }

func handle_lights(light: LightButton):
	match light:
		ul_ewl:
			tiles[8][8].incoming = NONE
			tiles[8][8].leaving = STRAIGHT_OR_RIGHT
			
			tiles[8][9].incoming = WEST
			tiles[8][9].leaving = LEFT_TURN
			
			tiles[9][8].incoming = EAST
			tiles[9][8].leaving = LEFT_TURN
			
			tiles[9][8].incoming = NONE
			tiles[9][8].leaving = STRAIGHT_OR_RIGHT
		ul_ewr:
			tiles[8][8].incoming = WEST
			tiles[8][8].leaving = STRAIGHT_OR_RIGHT
			
			tiles[8][9].incoming = EAST
			tiles[8][9].leaving = STRAIGHT_OR_RIGHT
			
			tiles[9][8].incoming = WEST
			tiles[9][8].leaving = STRAIGHT_OR_RIGHT
			
			tiles[9][9].incoming = EAST
			tiles[9][9].leaving = STRAIGHT_OR_RIGHT
		ul_nsl:
			pass
		ul_nsr:
			tiles[8][8].incoming = SOUTH
			tiles[8][8].leaving = STRAIGHT_OR_RIGHT
			
			tiles[8][9].incoming = SOUTH
			tiles[8][9].leaving = STRAIGHT_OR_RIGHT
			
			tiles[9][8].incoming = NORTH
			tiles[9][8].leaving = STRAIGHT_OR_RIGHT
			
			tiles[9][9].incoming = NORTH
			tiles[9][9].leaving = STRAIGHT_OR_RIGHT
		ll_ewl:
			pass
		ll_ewr:
			tiles[8][18].incoming = WEST
			tiles[8][18].leaving = STRAIGHT_OR_RIGHT
			
			tiles[8][19].incoming = EAST
			tiles[8][19].leaving = STRAIGHT_OR_RIGHT
			
			tiles[9][18].incoming = WEST
			tiles[9][18].leaving = STRAIGHT_OR_RIGHT
			
			tiles[9][19].incoming = EAST
			tiles[9][19].leaving = STRAIGHT_OR_RIGHT
		ll_nsl:
			pass
		ll_nsr:
			tiles[8][18].incoming = SOUTH
			tiles[8][18].leaving = STRAIGHT_OR_RIGHT
			
			tiles[8][19].incoming = SOUTH
			tiles[8][19].leaving = STRAIGHT_OR_RIGHT
			
			tiles[9][18].incoming = NORTH
			tiles[9][18].leaving = STRAIGHT_OR_RIGHT
			
			tiles[9][19].incoming = NORTH
			tiles[9][19].leaving = STRAIGHT_OR_RIGHT
		ur_ewl:
			pass
		ur_ewr:
			tiles[18][8].incoming = WEST
			tiles[18][8].leaving = STRAIGHT_OR_RIGHT
			
			tiles[18][9].incoming = EAST
			tiles[18][9].leaving = STRAIGHT_OR_RIGHT
			
			tiles[19][8].incoming = WEST
			tiles[19][8].leaving = STRAIGHT_OR_RIGHT
			
			tiles[19][9].incoming = EAST
			tiles[19][9].leaving = STRAIGHT_OR_RIGHT
		ur_nsl:
			pass
		ur_nsr:
			tiles[18][8].incoming = SOUTH
			tiles[18][8].leaving = STRAIGHT_OR_RIGHT
			
			tiles[18][9].incoming = SOUTH
			tiles[18][9].leaving = STRAIGHT_OR_RIGHT
			
			tiles[19][8].incoming = NORTH
			tiles[19][8].leaving = STRAIGHT_OR_RIGHT
			
			tiles[19][9].incoming = NORTH
			tiles[19][9].leaving = STRAIGHT_OR_RIGHT
		lr_ewl:
			pass
		lr_ewr:
			tiles[18][18].incoming = WEST
			tiles[18][18].leaving = STRAIGHT_OR_RIGHT
			
			tiles[18][19].incoming = EAST
			tiles[18][19].leaving = STRAIGHT_OR_RIGHT
			
			tiles[19][18].incoming = WEST
			tiles[19][18].leaving = STRAIGHT_OR_RIGHT
			
			tiles[19][19].incoming = EAST
			tiles[19][19].leaving = STRAIGHT_OR_RIGHT
		lr_nsl:
			pass
		lr_nsr:
			tiles[18][18].incoming = SOUTH
			tiles[18][18].leaving = STRAIGHT_OR_RIGHT
			
			tiles[18][19].incoming = SOUTH
			tiles[18][19].leaving = STRAIGHT_OR_RIGHT
			
			tiles[19][18].incoming = NORTH
			tiles[19][18].leaving = STRAIGHT_OR_RIGHT
			
			tiles[19][19].incoming = NORTH
			tiles[19][19].leaving = STRAIGHT_OR_RIGHT
