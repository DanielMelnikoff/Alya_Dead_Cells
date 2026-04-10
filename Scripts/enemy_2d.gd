extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_player = null

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if target_player:
		var dist = abs(target_player.global_position.x)-abs(global_position.x)
		var direction = sign(dist)
		velocity.x = direction * SPEED
		
		if is_on_wall() and is_on_floor():
			velocity.y = JUMP_VELOCITY
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


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
