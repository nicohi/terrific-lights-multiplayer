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

const NORTH = Vector2(0, -1)
const NORTHEAST = Vector2(1, -1)
const EAST = Vector2(1, 0)
const SOUTHEAST = Vector2(1, 1)
const SOUTH = Vector2(0, 1)
const SOUTHWEST = Vector2(-1, 1)
const WEST = Vector2(-1, 0)
const NORTHWEST = Vector2(-1, -1)

const NWW_START_POS = Vector2(0, 9)
const NWN_START_POS = Vector2(8, 0)
const NEN_START_POS = Vector2(18, 0)
const NEE_START_POS = Vector2(27, 8)
const SEE_START_POS = Vector2(27, 18)
const SES_START_POS = Vector2(19, 27)
const SWS_START_POS = Vector2(9, 27)
const SWW_START_POS = Vector2(0, 19)

var LEFT = Globals.LEFT
var RIGHT = Globals.RIGHT
var STRAIGHT = Globals.STRAIGHT

var routeSetup = [
	{
		"startPos": NWN_START_POS,
		"startDir": SOUTH,
		"turns": [LEFT, RIGHT, LEFT],
	},
	{
		"startPos": NEE_START_POS,
		"startDir": WEST,
		"turns": [LEFT, RIGHT, LEFT],
	},
	{
		"startPos": SES_START_POS,
		"startDir": NORTH,
		"turns": [LEFT, RIGHT, LEFT],
	},
	{
		"startPos": SWW_START_POS,
		"startDir": EAST,
		"turns": [LEFT, RIGHT, LEFT],
	},
	{
		"startPos": NWN_START_POS,
		"startDir": SOUTH,
		"turns": [STRAIGHT, LEFT, RIGHT],
	},
	{
		"startPos": NEE_START_POS,
		"startDir": WEST,
		"turns": [STRAIGHT, LEFT, RIGHT],
	},
	{
		"startPos": SES_START_POS,
		"startDir": NORTH,
		"turns": [STRAIGHT, LEFT, RIGHT],
	},
	{
		"startPos": SWW_START_POS,
		"startDir": EAST,
		"turns": [STRAIGHT, LEFT, RIGHT],
	},
	{
		"startPos": NEN_START_POS,
		"startDir": SOUTH,
		"turns": [STRAIGHT, RIGHT, STRAIGHT],
	},
	{
		"startPos": SEE_START_POS,
		"startDir": WEST,
		"turns": [STRAIGHT, RIGHT, STRAIGHT],
	},
	{
		"startPos": SWS_START_POS,
		"startDir": NORTH,
		"turns": [STRAIGHT, RIGHT, STRAIGHT],
	},
	{
		"startPos": NWW_START_POS,
		"startDir": EAST,
		"turns": [STRAIGHT, RIGHT, STRAIGHT],
	},
	{
		"startPos": NEN_START_POS,
		"startDir": SOUTH,
		"turns": [STRAIGHT, RIGHT, STRAIGHT],
	},
	{
		"startPos": SEE_START_POS,
		"startDir": WEST,
		"turns": [STRAIGHT, RIGHT, STRAIGHT],
	},
	{
		"startPos": SWS_START_POS,
		"startDir": NORTH,
		"turns": [STRAIGHT, RIGHT, STRAIGHT],
	},
	{
		"startPos": NWW_START_POS,
		"startDir": EAST,
		"turns": [STRAIGHT, RIGHT, STRAIGHT],
	},
]

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

func _straight(targetArray: Array, steps: int, from: Vector2, toDir: Vector2, nextTurn) -> Vector2:
	var pos = from
	
	for i in 2:
		pos += toDir
		targetArray.push_back({"tile": tiles[pos.x][pos.y], "turn": STRAIGHT})
		
	for i in steps - 2:
		pos += toDir
		targetArray.push_back({"tile": tiles[pos.x][pos.y], "turn": nextTurn})
		
	return pos
		
func _turn_left(targetArray: Array, from: Vector2, toDir: Vector2, nextTurn) -> Vector2:
	var pos = from
	
	for i in 2:
		match toDir:
			NORTH:
				pos += NORTHEAST
			EAST:
				pos += SOUTHEAST
			SOUTH:
				pos += SOUTHWEST
			WEST:
				pos += NORTHWEST
				
		targetArray.push_back({"tile": tiles[pos.x][pos.y], "turn": LEFT})
	
	pos += toDir
	targetArray.push_back({"tile": tiles[pos.x][pos.y], "turn": LEFT})
	
	for i in 6:
		pos += toDir
		targetArray.push_back({"tile": tiles[pos.x][pos.y], "turn": nextTurn})
	
	return pos

func _turn_right(targetArray: Array, from: Vector2, toDir: Vector2, nextTurn) -> Vector2:
	var pos = from
	
	match toDir:
		NORTH:
			pos += WEST
		EAST:
			pos += NORTH
		SOUTH:
			pos += EAST
		WEST:
			pos += SOUTH
			
	targetArray.push_back({"tile": tiles[pos.x][pos.y], "turn": RIGHT})
	pos += toDir
	targetArray.push_back({"tile": tiles[pos.x][pos.y], "turn": RIGHT})
	
	for i in 7:
		pos += toDir
		targetArray.push_back({"tile": tiles[pos.x][pos.y], "turn": nextTurn})
		
	return pos

func _left_from(dir: Vector2) -> Vector2:
	match dir:
		NORTH:
			return WEST
		EAST:
			return NORTH
		SOUTH:
			return EAST
		_:
			return SOUTH

func _right_from(dir: Vector2) -> Vector2:
	match dir:
		NORTH:
			return EAST
		EAST:
			return SOUTH
		SOUTH:
			return WEST
		_:
			return NORTH

func _get_turn_vector(turnTo, directionFrom: Vector2) -> Vector2:
	match turnTo:
		LEFT:
			return _left_from(directionFrom)
		RIGHT:
			return _right_from(directionFrom)
		_:
			return directionFrom

func setUpRoutes():	
	for route in routeSetup:
		var turnPos = 0
		var nextTurn = route["turns"][turnPos]
		
		var pos = route["startPos"]
		var dir = route["startDir"]
		var arr = [{"tile": tiles[pos.x][pos.y], "turn": nextTurn}]

		pos = _straight(arr, 7, pos, dir, nextTurn)

		for turn in route["turns"]:
			turnPos += 1
			
			nextTurn = STRAIGHT
			
			if turnPos < route["turns"].size():
				nextTurn = route["turns"][turnPos]
			
			match turn:
				STRAIGHT:
					pos = _straight(arr, 10, pos, dir, nextTurn)
				LEFT:
					dir = _get_turn_vector(turn, dir)
					pos = _turn_left(arr, pos, dir, nextTurn)
				RIGHT:
					dir = _get_turn_vector(turn, dir)
					pos = _turn_right(arr, pos, dir, nextTurn)

		routes.append(Route.new(arr))
#
#	var list = []
#	for y in range(0, ml):
#		list.append(tiles[8][y])
#	var route = Route.new(list)
#	routes.append(route)
#
#	list = []
#	for y in range(0, ml):
#		list.append(tiles[9][ml-1 - y])
#	route = Route.new(list)
#	routes.append(route)
#
#	list = []
#	for y in range(0, ml):
#		list.append(tiles[18][y])
#	route = Route.new(list)
#	routes.append(route)
#
#	list = []
#	for y in range(0, ml):
#		list.append(tiles[19][ml-1 - y])
#	route = Route.new(list)
#	routes.append(route)
#
#	list = []
#	for x in range(0, ml):
#		list.append(tiles[x][9])
#	route = Route.new(list)
#	routes.append(route)
#
#	list = []
#	for x in range(0, ml):
#		list.append(tiles[ml- 1 - x][8])
#	route = Route.new(list)
#	routes.append(route)
#
#	list = []
#	for x in range(0, ml):
#		list.append(tiles[x][19])
#	route = Route.new(list)
#	routes.append(route)
#
#	list = []
#	for x in range(0, ml):
#		list.append(tiles[ml- 1 - x][18])
#	route = Route.new(list)
#	routes.append(route)

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
	
func switchLights(t1, t2, t3, t4, light):
	match light:
		"ewr":
			t1.incoming = Globals.WEST
			t1.leaving = Globals.STRAIGHT_OR_RIGHT
			t2.incoming = Globals.EAST
			t2.leaving = Globals.STRAIGHT_OR_RIGHT
			t3.incoming = Globals.WEST
			t3.leaving = Globals.STRAIGHT_OR_RIGHT
			t4.incoming = Globals.EAST
			t4.leaving = Globals.STRAIGHT_OR_RIGHT
		"nsr":
			t1.incoming = Globals.SOUTH
			t1.leaving = Globals.STRAIGHT_OR_RIGHT
			t2.incoming = Globals.SOUTH
			t2.leaving = Globals.STRAIGHT_OR_RIGHT
			t3.incoming = Globals.NORTH
			t3.leaving = Globals.STRAIGHT_OR_RIGHT
			t4.incoming = Globals.NORTH
			t4.leaving = Globals.STRAIGHT_OR_RIGHT
		"ewl":
			t1.incoming = Globals.WEST
			t1.leaving = Globals.LEFT_TURN
			t2.incoming = Globals.EAST
			t2.leaving = Globals.LEFT_TURN
			t3.incoming = Globals.WEST
			t3.leaving = Globals.LEFT_TURN
			t4.incoming = Globals.EAST
			t4.leaving = Globals.LEFT_TURN
		"nsl":
			t1.incoming = Globals.SOUTH
			t1.leaving = Globals.LEFT_TURN
			t2.incoming = Globals.NORTH
			t2.leaving = Globals.LEFT_TURN
			t3.incoming = Globals.SOUTH
			t3.leaving = Globals.LEFT_TURN
			t4.incoming = Globals.NORTH
			t4.leaving = Globals.LEFT_TURN

func handle_lights(light: LightButton):
	match light:
		ul_ewl:
			switchLights(tiles[8][8], tiles[8][9], tiles[9][8], tiles[9][9], "ewl")
		ul_ewr:
			switchLights(tiles[8][8], tiles[8][9], tiles[9][8], tiles[9][9], "ewr")
		ul_nsl:
			switchLights(tiles[8][8], tiles[8][9], tiles[9][8], tiles[9][9], "nsl")
		ul_nsr:
			switchLights(tiles[8][8], tiles[8][9], tiles[9][8], tiles[9][9], "nsr")
		ll_ewl:
			switchLights(tiles[8][18], tiles[8][19], tiles[9][18], tiles[9][19], "ewl")
		ll_ewr:
			switchLights(tiles[8][18], tiles[8][19], tiles[9][18], tiles[9][19], "ewr")
		ll_nsl:
			switchLights(tiles[8][18], tiles[8][19], tiles[9][18], tiles[9][19], "nsl")
		ll_nsr:
			switchLights(tiles[8][18], tiles[8][19], tiles[9][18], tiles[9][19], "nsr")
		ur_ewl:
			switchLights(tiles[18][8], tiles[18][9], tiles[19][8], tiles[19][9], "ewl")
		ur_ewr:
			switchLights(tiles[18][8], tiles[18][9], tiles[19][8], tiles[19][9], "ewr")
		ur_nsl:
			switchLights(tiles[18][8], tiles[18][9], tiles[19][8], tiles[19][9], "nsl")
		ur_nsr:
			switchLights(tiles[18][8], tiles[18][9], tiles[19][8], tiles[19][9], "nsr")
		lr_ewl:
			switchLights(tiles[18][18], tiles[18][19], tiles[19][18], tiles[19][19], "ewl")
		lr_ewr:
			switchLights(tiles[18][18], tiles[18][19], tiles[19][18], tiles[19][19], "ewr")
		lr_nsl:
			switchLights(tiles[18][18], tiles[18][19], tiles[19][18], tiles[19][19], "nsl")
		lr_nsr:
			switchLights(tiles[18][18], tiles[18][19], tiles[19][18], tiles[19][19], "nsr")
