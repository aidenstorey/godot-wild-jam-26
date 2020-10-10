extends Node

onready var scene_tree: SceneTree = self.get_tree()

var image: Image = Image.new()
var texture: ImageTexture = ImageTexture.new()


func _ready() -> void:
	self.image.create( 128, 2, false, Image.FORMAT_RGBAH )


func _process(delta: float) -> void:
	var lights = self.get_tree().get_nodes_in_group( "light_source" )
	
	self.image.lock()
	
	for i in lights.size():
		var light = lights[ i ]
		if light is light_source:
			var position = light.global_position.floor()
			self.image.set_pixel( i, 0, Color( \
				position.x, position.y, \
				light.strength, light.radius ) )
				
			self.image.set_pixel( i, 1, light.color )
			
	self.image.unlock()
		
	self.texture.create_from_image( self.image );
	
	self.material.set_shader_param( "light_count", lights.size() )
	self.material.set_shader_param( "light_data", texture )
