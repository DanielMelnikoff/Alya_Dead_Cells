extends Area2D

# Переменная для хранения ссылки на игрока, пока он внутри
var player_inside = null

func _ready():
	# Соединяем сигналы программно (надежнее всего)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$Timer.timeout.connect(_on_timer_timeout)
	
	# Настройки таймера (на всякий случай)
	$Timer.wait_time = 1.0
	$Timer.one_shot = false

func _on_body_entered(body):
	# Проверяем, что вошел именно игрок
	if body.is_in_group("player"):
		player_inside = body
		do_action()      # Делаем действие ПЕРВЫЙ РАЗ сразу при входе
		$Timer.start()   # Запускаем повторы каждую секунду

func _on_body_exited(body):
	if body == player_inside:
		player_inside = null
		$Timer.stop()    # Игрок вышел — выключаем повторы

func _on_timer_timeout():
	# Это срабатывает каждую секунду, пока игрок внутри
	if player_inside:
		do_action()
func do_action():
	player_inside.take_damage(10)
	
