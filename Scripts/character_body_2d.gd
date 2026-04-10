extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -800.0
var HP = 100
var jumpable = true
var damagable = true

func _take_damage(amount, source_pos):
	HP -= amount
	$Camera2D/HP.text = str(HP)
	if HP<=0:
		die()
	var direction = sign(abs(global_position.x)-abs(source_pos.x))
	velocity.x = move_toward(direction*1000, 0, SPEED)
	velocity.y = -400
	damagable = false
	await get_tree().create_timer(0.8).timeout
	damagable = true
	
	
	

func die():
	await get_tree().create_timer(1.3).timeout
	get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	if is_on_floor():
		jumpable=true
	if not is_on_floor() and Input.is_action_just_pressed("ui_accept") and jumpable:
		velocity.y = JUMP_VELOCITY
		jumpable = false

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_key_pressed(KEY_D):
		velocity.x = SPEED
	elif Input.is_key_pressed(KEY_A):
		velocity.x = -SPEED
	else: 
		if damagable: 
			velocity.x = 0

	move_and_slide()
