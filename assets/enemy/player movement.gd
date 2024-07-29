extends Node
@onready var player = $".."

@onready var animated_sprite_2d = $AnimatedSprite2D

var speed = 200
#var acceleration = 1.2

func _process(delta):
	movement(delta)
	
func movement(delta):
	if Input.is_action_pressed("left"):
		animated_sprite_2d.play("left")
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("right"):
		animated_sprite_2d.play("right")
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("up"):
		animated_sprite_2d.play("up")
		velocity.y = -speed
		velocity.x = 0
	elif Input.is_action_pressed("down"):
		animated_sprite_2d.play("down")
		velocity.y = speed
		velocity.x = 0
	else:
		animated_sprite_2d.play("idle")
		velocity.y = 0
		velocity.x = 0
	move_and_slide()
