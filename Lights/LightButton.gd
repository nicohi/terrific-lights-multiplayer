extends Node2D

class_name LightButton

signal clicked

onready var sprite = $Sprite

var _pair: LightButton
var _off_texture: ImageTexture
var _on_texture: ImageTexture

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = _off_texture

func set_pair(pair: LightButton):
	_pair = pair
	_pair.connect("clicked", self, "pair_clicked")

func pair_clicked():
	print(_pair.name, " fired")
	sprite.texture = _off_texture

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if sprite == null or sprite.texture == null:
			return
			
		var spriteSize: Vector2 = sprite.texture.get_size()
		var event_pos: Vector2 = event.position
		var pos: Vector2 = self.position - spriteSize / 2
		
		if event_pos.x >= pos.x and event_pos.x <= pos.x + spriteSize.x and event_pos.y >= pos.y and event_pos.y <= pos.y + spriteSize.y: 
			sprite.texture = _on_texture
			emit_signal("clicked")

func set_textures(off_texture_filename: String, on_texture_filename: String):
	var image = Image.new()
	image.load(off_texture_filename)
	_off_texture = ImageTexture.new()
	_off_texture.create_from_image(image, 0)
	
	image = Image.new()
	image.load(on_texture_filename)
	_on_texture = ImageTexture.new()
	_on_texture.create_from_image(image, 0)

func reset():
	sprite.texture = _off_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
