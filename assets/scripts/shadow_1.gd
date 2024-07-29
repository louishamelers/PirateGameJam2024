extends CharacterBody2D


var SPEED = 60
var player_chase = false
var player = null


func _physics_process(_delta):
	if player_chase:
		position += (player.position-position)/SPEED
		$AnimatedSprite2D.play("moving")
		if (player.position.x - position.x)<0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true



func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
