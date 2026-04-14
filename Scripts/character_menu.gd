extends Control

var skins = [
	preload("res://Sprites/Anims/blue_anim.tres"),
	preload("res://Sprites/Anims/green_anim.tres"),
	preload("res://Sprites/Anims/grey_anim.tres"),
	preload("res://Sprites/Anims/red_anim.tres")
]
var index = 0

func _ready():
	update_ui()
	$TextureRect/NextBtn.pressed.connect(_on_next)
	$TextureRect/PrevBtn.pressed.connect(_on_prev)
	$TextureRect/StartBtn.pressed.connect(_on_start)

func update_ui():
	$TextureRect/Preview.sprite_frames = skins[index]
	$TextureRect/Preview.play("idle")
	Global.selected_sprite_frames = skins[index]

func _on_next():
	index = (index + 1) % skins.size()
	update_ui()

func _on_prev():
	index = (index - 1 + skins.size()) % skins.size()
	update_ui()

func _on_start():
	get_tree().change_scene_to_file("res://Scenes/map.tscn")
