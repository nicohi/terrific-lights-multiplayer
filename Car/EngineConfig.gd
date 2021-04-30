extends Node

const MAX_CAR_ENGINES_ON = 5
const SAMPLE_HZ = 22050.0

var engine_idx = 0

const ENGINE_CONFS = [
	{
		"baseHz": 50, 
		"hz": 70
	},
	{
		"baseHz": 52,
		"hz": 72
	},
	{
		"baseHz": 55, 
		"hz": 75
	},
	{
		"baseHz": 60,
		"hz": 80
	},
	{
		"baseHz": 45, 
		"hz": 65
	},
	{
		"baseHz": 58,
		"hz": 78
	},
	{
		"baseHz": 48, 
		"hz": 68
	},
	{
		"baseHz": 43,
		"hz": 63
	},
]

var car_engines_on = 0

func get_engine_conf():
	if car_engines_on == MAX_CAR_ENGINES_ON:
		return null
	
	car_engines_on += 1
	engine_idx = (engine_idx + 1) % ENGINE_CONFS.size() 
	
	return ENGINE_CONFS[engine_idx]
