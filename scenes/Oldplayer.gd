extends Area2D
signal hit

export var speed = 400 # player speed (pixels/sec).
var screen_size  # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
#	hide() # start hidden

func _process(delta):
	var velocity = Vector2() # player's movement vector.
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# below is equivilant to: get_node("AnimatedSprite").play()
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	# clamping a value means restricting it to a given range
	position.x = clamp(position.x, +30, screen_size.x -30)
	position.y = clamp(position.y, +30, screen_size.y -30)

func _on_Player_body_entered(_body):
	hide() # player disappears after being hit.
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

# reset the player when starting a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
