extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -900
var HP = 100
var jumpable = true
var damagable = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var current_animation: String = ""
@onready var pickup_area: Area2D = $PickupArea

func _ready():
	pickup_area.area_entered.connect(_on_area_entered)
	$HealthDecayTimer.timeout.connect(_on_health_decay_timeout)


#Даник, твоя часть кода, получение дамага
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

#анимация перса
func update_animation() -> void:
	var new_animation: String
	
	var direction: float = 0.0
	if Input.is_key_pressed(KEY_D):
		direction = 1.0
	elif Input.is_key_pressed(KEY_A):
		direction = -1.0
	
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

#при касании с яблоком хилит на 20 хп и удаляет его

func _on_area_entered(area: Area2D):
	if area.get_parent().is_in_group("health"):
		var hp_label = get_node("Camera2D/HP")
		var current_hp = int(hp_label.text)
		var hp_after = str(current_hp+20)
		hp_label.text=hp_after
		area.get_parent().queue_free()

#каждые 2 секунды отнимает хп

func _on_health_decay_timeout():
	var current_HP = int($Camera2D/HP.text)
	if current_HP > 100:
		current_HP -= 2
		$Camera2D/HP.text = str(current_HP)
