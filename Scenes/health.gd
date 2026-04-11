extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $Area2D/AnimatedSprite2D

func _ready():
		animated_sprite.play("idle")
