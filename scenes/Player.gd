extends KinematicBody2D

class_name Player

signal slice_collected

export var speed = 50 # player speed (pixels/sec).
var step = 50
var tick = 0.35
var timeToNextTick
# the player's movement vectors
var currentMovement = Vector2(0, 0)
var lastMovement = Vector2(0, 0)
var grow = false

var canMove = false
var didMove = false

var loafScene
var loaf = [] # array of ghost slice sprites

var screen_size  # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	loafScene = preload("res://scenes/Loaf.tscn")
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	if not canMove:
		return
		
	# Get inputs
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	
	if (not didMove) and (right or left or up or down):
		didMove = true
	elif not didMove:
		return

	# Set proper movement vector
	var changeDirection = false
	
	if right and (loaf.size() == 0 or lastMovement != Vector2(-step, 0)):
		currentMovement = Vector2(step, 0)
	elif left and (loaf.size() == 0 or lastMovement != Vector2(step, 0)):
		currentMovement = Vector2(-step, 0)
	elif up and (loaf.size() == 0 or lastMovement != Vector2(0, step)):
		currentMovement = Vector2(0, -step)
	elif down and (loaf.size() == 0 or lastMovement !=  Vector2(0, -step)):
		currentMovement = Vector2(0, step)
	
	if currentMovement != lastMovement:
		changeDirection = true
	
	# only move when ready
	timeToNextTick -= delta
	
	if timeToNextTick > 0 and not changeDirection: return
	else: timeToNextTick = tick
	
	# Collision detection
	collision_layer = 2
	collision_mask = 2
	if test_move(transform, currentMovement):
		emit_signal("slice_collected")
		grow = true
		
		
	# Movement
	var nextPosition = position
	position += currentMovement * delta * speed
	# clamping a value means restricting it to a given range
	position.x = clamp(position.x, + 40, screen_size.x - 40)
	position.y = clamp(position.y, + 40, screen_size.y - 40)
	lastMovement = currentMovement
	
	# Move loaf slices
	var loafObject : Loaf
	var loafMover : KinematicBody2D
	if grow:
		tick -= 0.01
		loafObject = loafScene.instance() as Loaf
		add_child(loafObject)
		loafMover = loafObject.LoafMover
		grow = false
	elif loaf.size() > 0:
		loafObject = loaf[loaf.size()-1]
		loaf.remove(loaf.size()-1)
		loafMover = loafObject.LoafMover
	
	if loafMover != null:
		loafMover.position = nextPosition
		loaf.insert(0, loafObject)

func is_player_at(var gridPos : Vector2) -> bool:
	if position == gridPos:
		return true
	
	for slices in loaf:
		var loafSprite : Loaf
		loafSprite = slices
		if loafSprite.LoafMover.position == gridPos:
			return true
	
	return false
	
func set_grid_position(var gridPos : Vector2) -> bool:
	position = step * gridPos
	return true
	
# reset the player when starting a new game
#func start(pos):
#	position = pos
#	show()

func reset() -> void:
	while loaf.size() > 0:
		var l = loaf.pop_back() as Loaf
		l.free()
	
	tick = 0.35
	lastMovement = Vector2(0, 0)
	currentMovement = Vector2(0, 0)
	grow = false
	timeToNextTick = tick
	didMove = false
