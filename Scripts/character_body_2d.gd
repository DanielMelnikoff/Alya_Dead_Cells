extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -900

var HP = 100
var damage = 30
var jumpable = true
var damagable = true
var enemy = null

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var current_animation: String = ""
@onready var pickup_area: Area2D = $PickupArea

func _ready():
	$Camera2D/HP.visible = true
	$PickupArea.monitorable = true
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
	$Camera2D/HP.visible = false
	$PickupArea.monitorable = false
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://Scenes/characterMenu.tscn")

func _physics_process(delta: float) -> void:
	if is_on_floor():
		jumpable=true
	if not is_on_floor() and Input.is_action_just_pressed("ui_accept") and jumpable and HP>0:
		velocity.y = JUMP_VELOCITY
		jumpable = false

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and HP>0:
		velocity.y = JUMP_VELOCITY
	if not is_on_floor() and HP>0:
		velocity += get_gravity() * delta
		
	if Input.is_key_pressed(KEY_D) and HP>0:
		velocity.x = SPEED 
		if Input.is_key_pressed(KEY_SHIFT) and HP>0:
			velocity.x = SPEED*2
	elif Input.is_key_pressed(KEY_A) and HP>0:
		velocity.x = -SPEED
		if Input.is_key_pressed(KEY_SHIFT) and HP>0:
			velocity.x = -SPEED*2
	else: 
		if damagable: 
			velocity.x = 0
			
	if enemy and enemy.damagable and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		enemy.take_damage(damage)
		

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
	elif Input.is_key_pressed(KEY_SHIFT) and velocity.x!=0:
		new_animation = "roll"
	elif direction != 0:
		new_animation = "walk"
	elif HP<=0:
		new_animation = "dead"
	else:
		new_animation = "idle"
	
	if new_animation != current_animation:
		current_animation = new_animation
		animated_sprite.play(new_animation)
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

#при касании с яблоком хилит на 15 хп, двёт+2 к урону и удаляет его

func _on_area_entered(area: Area2D):
	if area.get_parent().is_in_group("health"):
		var hp_label = get_node("Camera2D/HP")
		await get_tree().create_timer(0.2).timeout
		HP += 15
		damage += 2
		hp_label.text=str(HP)
		area.get_parent().queue_free()

#каждые полсекунды отнимает хп

func _on_health_decay_timeout():
	if HP > 100:
		HP -= 1
		$Camera2D/HP.text = str(HP)
		
func _on_pickup_area_body_entered(body):
	if body.is_in_group("enemy"):
		enemy = body


func _on_pickup_area_body_exited(body):
	if body == enemy:
		enemy = null
