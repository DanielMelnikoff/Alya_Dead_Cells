extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = 1200

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_player = null

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var current_animation: String = ""

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction: float = 0.0
	
	if target_player:
		var dist = target_player.global_position.x - global_position.x
		direction = sign(dist)
		velocity.x = direction * SPEED
		
		if is_on_wall() and is_on_floor():
			velocity.y = -JUMP_VELOCITY
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	update_animation(direction)


func update_animation(direction: float) -> void:
	var new_animation: String
	
	if not is_on_floor():
		new_animation = "jump"
	elif abs(velocity.x) > 1.0: 
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


func _on_vision_area_body_entered(body):
	if body.is_in_group("player"):
		target_player = body


func _on_vision_area_body_exited(body):
	if body == target_player:
		target_player = null


func _on_attack_timer_timeout():
	var overlapping_bodies = $DamageArea.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("player"):
			body._take_damage(15, global_position)
			$Timer.start()
