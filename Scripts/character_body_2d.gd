extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -600.0
var HP = 100

func take_damage(amount):
	HP -= amount
	$Camera2D/HP.text = str(HP)
	if HP<=0:
		die()

func die():
	get_tree().reload_current_scene()

var rand = RandomNumberGenerator.new()
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_key_pressed(KEY_D):
		velocity.x = SPEED
	elif Input.is_key_pressed(KEY_A):
		velocity.x = -SPEED
	else: velocity.x = 0
		#move_toward(velocity.x, 0, SPEED)
	move_and_slide()
