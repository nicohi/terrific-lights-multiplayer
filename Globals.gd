extends Node

const TILE_SIDE_LEN = 40
var CARS_PER_SEC = 2
const VARIKKO = Vector2(-666, -666)
var score = 0
var cars_passed = 0
var players = 1
enum { NONE, ALL, NORTH, EAST, SOUTH, WEST }
enum { LEFT, RIGHT, STRAIGHT }

var instructions_shown = false

enum {
	DIFFICULTY_EASY
	DIFFICULTY_MEDIUM
	DIFFICULTY_HARD
}

var current_difficulty = DIFFICULTY_EASY
