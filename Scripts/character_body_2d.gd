extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -800
var HP = 100
var jumpable = true
var damagable = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var current_animation: String = ""

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
	
	update_animation()


func update_animation() -> void:
	var new_animation: String
	
	var direction: float = 0.0
	if Input.is_key_pressed(KEY_D):
		direction = 1.0
	elif Input.is_key_pressed(KEY_A):
		direction = -1.0
	
	# Определяем нужную анимацию
	if not is_on_floor():
		new_animation = "jump"
	elif direction != 0:
		new_animation = "walk"
	else:
		new_animation = "idle"
	
	if new_animation != current_animation:
		current_animation = new_animation
		animated_sprite.play(new_animation)
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
