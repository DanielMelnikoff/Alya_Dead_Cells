extends Area2D

var player_inside = null

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$Timer.timeout.connect(_on_timer_timeout)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = body
		_damage()      
		$Timer.start()  

func _on_body_exited(body):
	if body == player_inside:
		player_inside = null
		$Timer.stop() 

func _on_timer_timeout():
	if player_inside:
		_damage()
		
func _damage():
	player_inside._take_damage(5, global_position)
	
