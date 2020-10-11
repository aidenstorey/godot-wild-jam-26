extends Node

onready var scene_tree: SceneTree = self.get_tree()

var image: Image = Image.new()
var texture: ImageTexture = ImageTexture.new()
var player : Player
var slice : Sprite
var sliceScene
var slicePosition = Vector2(-1, -1)
var rng : RandomNumberGenerator

func _ready() -> void:
	self.image.create( 128, 3, false, Image.FORMAT_RGBAH )
	# spawn first Toast
	var p = preload("res://Player.tscn")
	player = p.instance()
	add_child(player)
	player.connect("slice_collected", self, "on_slice_collected")

	# setup for Ghost Slices
	rng = RandomNumberGenerator.new()
	rng.randomize()
	sliceScene = preload("res://scenes/Slice.tscn")
	
	restart_game()

func _process(_delta: float) -> void:
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
	
	# to do add checks that game is still in play
	if slicePosition == Vector2(-1, -1):
		# spawn ghost slice
		var legitPosition = false
		while not legitPosition:
			var x = rng.randi_range(1, 17)
			var y = rng.randi_range(1, 10)
			slicePosition = Vector2(x * player.step, y * player.step)
			legitPosition = not player.is_player_at(slicePosition)
		
		slice = sliceScene.instance()
		add_child(slice)
		slice.position = slicePosition

func on_slice_collected():
	slice.free()
	slicePosition = Vector2(-1, -1)

func restart_game() -> void:
	if not slice == null:
		slice.free()
	slicePosition = Vector2(-1, -1)
	player.set_grid_position(Vector2(1, 1))
	player.reset()
	player.canMove = true
