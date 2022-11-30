extends Node2D

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite

func play_animation(animation: String):
	animation_player.play(animation)

func set_texture(texture: Texture):
	sprite.texture = texture
