extends Node

onready var scene_tree: SceneTree = self.get_tree()

var image: Image = Image.new()
var texture: ImageTexture = ImageTexture.new()
var player : Player


func _ready() -> void:
	self.image.create( 128, 3, false, Image.FORMAT_RGBAH )

	var p = preload("res://Player.tscn")
	player = p.instance()
	$Viewport.add_child(player)


func _process(delta: float) -> void:
	var lights = self.get_tree().get_nodes_in_group( "light_source" )

	self.image.lock()

	for i in lights.size():
		var light = lights[ i ]
		if light is light_source:
			var position = light.global_position.floor()
			self.image.set_pixel( i, 0, Color( \
				position.x, position.y, \
				0.0, 0.0 ) )
			self.image.set_pixel( i, 1, Color( \
			light.offset, 0.0, \
			light.strength, light.radius ) )

			self.image.set_pixel( i, 2, light.color )

	self.image.unlock()

	self.texture.create_from_image( self.image );

	self.material.set_shader_param( "light_count", lights.size() )
	self.material.set_shader_param( "light_data", texture )
