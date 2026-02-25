extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const MaxJump = 2  # Allows for one double jump
var NumJumps = 0

# Ensure these names match your Scene Tree exactly
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D 
@onready var coyote_timer: Timer = $CoyoteTimer

func _physics_process(delta: float) -> void:
	# 1. HANDLE GRAVITY & COYOTE STATE
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		# If we just walked off a ledge (after Coyote Time) but haven't jumped:
		if coyote_timer.is_stopped() and NumJumps == 0:
			NumJumps = 1
	else:
		# Reset jump counter and start the grace period timer when touching groundd
		# Allows 2 jumps if falling off ledge during Coyote Time
		NumJumps = 0
		coyote_timer.start()

	# 2. HANDLE JUMP INPUT
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or not coyote_timer.is_stopped() or NumJumps < MaxJump:
			velocity.y = JUMP_VELOCITY
			NumJumps += 1
			coyote_timer.stop() # Ensure we don't jump again using the same window

	# 3. HANDLE HORIZONTAL MOVEMENT
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the sprite based on direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# 4. HANDLE ANIMATIONS
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement velocity
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
