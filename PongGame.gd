extends Node2D


# Declare member variables here. Examples:
var screenSize
var padSize
var direction = Vector2(1.0,0.0)

# initial speed of the ball at spawn
const initialBallSpeed = 80
var ballSpeed  = initialBallSpeed

var running = false

const padSpeed = 150

var pointsLeft = 0
var pointsRight = 0

var labelLeft
var labelRight

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	padSize = get_node("left").get_texture().get_size()
	labelLeft = get_node("pointsLeft")
	labelRight = get_node("pointsRight")
	
	labelLeft.text = str(pointsLeft)
	labelRight.text = str(pointsRight)
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(running == false):
		if(Input.is_action_pressed("restart")):
			running = true
		return
	
	if(pointsLeft == 10 || pointsRight == 10):
		if(Input.is_action_pressed("restart")):
			pointsLeft = 0
			pointsRight = 0
			labelLeft.text = str(pointsLeft)
			labelRight.text = str(pointsRight)
		return
		
	var ballPos = get_node("ball").position
	var leftPad = Rect2(get_node("left").position - padSize*0.5, padSize)
	var rightPad = Rect2(get_node("right").position -padSize*0.5, padSize)
	
	ballPos += direction * ballSpeed * delta
	
	# Flip when touching roof or floor
	if ((ballPos.y < 0 and direction.y < 0) or (ballPos.y > screenSize.y and direction.y > 0)):
		direction.y = -direction.y

# Flip, change direction and increase speed when touching pads
	if ((leftPad.has_point(ballPos) and direction.x < 0) or (rightPad.has_point(ballPos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
		ballSpeed *= 1.1
	
	# Check gameover
	if (ballPos.x < 0 or ballPos.x > screenSize.x):
		if (ballPos.x < 0):
			pointsRight += 1
		if (ballPos.x > screenSize.x):
			pointsLeft += 1
		labelLeft.text = str(pointsLeft)
		labelRight.text = str(pointsRight)
		ballPos = screenSize*0.5
		ballSpeed = initialBallSpeed
		direction = Vector2(-1, 0)
	
	get_node("ball").position = ballPos
	
	# Move left pad
	var leftPos = get_node("left").position

	if (leftPos.y > 0 and Input.is_action_pressed("left_move_up")):
		leftPos.y += -padSpeed * delta
	if (leftPos.y < screenSize.y and Input.is_action_pressed("left_move_down")):
		leftPos.y += padSpeed * delta

	get_node("left").position = leftPos
	
		# Move right pad
	var rightPos = get_node("right").position

	if (rightPos.y > 0 and Input.is_action_pressed("right_move_up")):
		rightPos.y += -padSpeed * delta
	if (rightPos.y < screenSize.y and Input.is_action_pressed("right_move_down")):
		rightPos.y += padSpeed * delta

	get_node("right").position = rightPos
