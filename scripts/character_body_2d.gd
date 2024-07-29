extends CharacterBody2D

@onready var animated:AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D

@export var speed:float = 200
@export var acceleration:float = 10

func _ready():
	animated.play("left_idle")

func _physics_process(_delta:float)->void:
	var direction : Vector2 = Input.get_vector("left","right","up","down")
	
	velocity.x = move_toward(velocity.x,speed*direction.x,acceleration)
	velocity.y = move_toward(velocity.y,speed*direction.y,acceleration)
	move_and_slide()

func _process(_delta:float)->void:
	#press
	if Input.is_action_pressed("left"):
		animated.play("left")
	elif Input.is_action_pressed("right"):
		animated.play("right")
	elif Input.is_action_pressed("down"):
		animated.play("down")
	elif Input.is_action_pressed("up"):
		animated.play("up")
	#release
	if Input.is_action_just_released("left"):
		animated.play("left_idle")
	elif Input.is_action_just_released("right"):
		animated.play("right_idle")
	elif Input.is_action_just_released("down"):
		animated.play("down_idle")
	elif Input.is_action_just_released("up"):
		animated.play("up_idle")
