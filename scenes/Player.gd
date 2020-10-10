extends KinematicBody2D

class_name Player

export var speed = 10 # player speed (pixels/sec).
var step = 50
# the player's movement vectors
var currentMovement = Vector2(0, 0)
var lastMovement = Vector2(0, 0)

var canMove = false
var didMove = false

var screen_size  # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
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

	if right:
		currentMovement = Vector2(step, 0)
	elif left: 
		currentMovement = Vector2(-step, 0)
	elif up:
		currentMovement = Vector2(0, -step)
	elif down: 
		currentMovement = Vector2(0, step)

	position += currentMovement * delta * speed
	# clamping a value means restricting it to a given range
	position.x = clamp(position.x, + 40, screen_size.x - 40)
	position.y = clamp(position.y, + 40, screen_size.y - 40)
	
# reset the player when starting a new game
func start(pos):
	position = pos
	show()
