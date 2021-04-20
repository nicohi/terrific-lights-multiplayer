extends Node

const TILE_SIDE_LEN = 40
const MAX_CAR_ENGINES_ON = 8
const SAMPLE_HZ = 22050.0

var engine_idx = 0

const ENGINE_CONFS = [
	{
		"baseHz": 60, 
		"hz": 80
	},
	{
		"baseHz": 62,
		"hz": 82
	},
	{
		"baseHz": 65, 
		"hz": 85
	},
	{
		"baseHz": 70,
		"hz": 90
	},
	{
		"baseHz": 55, 
		"hz": 75
	},
	{
		"baseHz": 68,
		"hz": 88
	},
	{
		"baseHz": 58, 
		"hz": 78
	},
	{
		"baseHz": 53,
		"hz": 73
	},
]

var car_engines_on = 0

func get_engine_conf():
	if car_engines_on == MAX_CAR_ENGINES_ON:
		return null
	
	car_engines_on += 1
	engine_idx = (engine_idx + 1) % ENGINE_CONFS.size() 
	
	return ENGINE_CONFS[engine_idx]
