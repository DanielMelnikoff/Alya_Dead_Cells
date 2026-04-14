extends Node2D

@onready var timer_label: Label = $CanvasLayer/Control/timer_count
@onready var player: CharacterBody2D = $Player

var enemy_scene: PackedScene = preload("res://Scenes/enemy.tscn")
var last_spawn_time_multiple: int = 0
var timer_value = 0

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)
	var p_scene = load("res://Scenes/Player.tscn")
	player = p_scene.instantiate()
	player.global_position = $SpawnPoint.global_position
	add_child(player)
	
	if Global.selected_sprite_frames != null:
		var anim = player.get_node("AnimatedSprite2D")
		anim.sprite_frames = Global.selected_sprite_frames
		anim.play("idle")
	
func _on_timer_timeout():
	timer_value += 1
	timer_label.text = str(timer_value)
	
	if timer_value > 0 and timer_value % 30 == 0 and timer_value != last_spawn_time_multiple:
		last_spawn_time_multiple = timer_value
		spawn_enemies()
		
func spawn_enemies():
	var count: int = (timer_value / 30) * 2
	for i in range(count):
		var enemy = enemy_scene.instantiate()
		
		var side = 1 if randf() > 0.5 else -1
		var distance = randf_range(1000.0, 2000.0)
		var offset_x = side * distance
		
		enemy.global_position = player.global_position + Vector2(offset_x, -400)
		add_child(enemy)
