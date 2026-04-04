extends Area2D

# Переменная для хранения ссылки на игрока, пока он внутри
var player_inside = null

func _ready():
	# Соединяем сигналы программно (надежнее всего)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$Timer.timeout.connect(_on_timer_timeout)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = body
		do_action()      
		$Timer.start()  

func _on_body_exited(body):
	if body == player_inside:
		player_inside = null
		$Timer.stop() 

func _on_timer_timeout():
	if player_inside:
		do_action()
func do_action():
	player_inside.take_damage(10)
	
