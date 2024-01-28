extends CharacterBody2D


const SPEED = 300.0

@export var hair: String = 'bowl'
@export var animation: String = 'idle'
@onready var baseSprite = $base as AnimatedSprite2D
@onready var hairSprite = $hair as AnimatedSprite2D
@onready var toolsSprite = $tools as AnimatedSprite2D

func _ready():
	set_animation(animation)


func set_animation(_animation: String):
	animation = _animation
	baseSprite.play(animation + '_base')
	hairSprite.play(animation + '_' + hair)
	toolsSprite.play(animation)
