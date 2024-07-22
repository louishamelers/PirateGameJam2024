extends CharacterBody3D

@onready var animated:AnimatedSprite3D = $AnimatedSprite3D

@export var speed:float = 25
@export var acceleration:float = 2



func _ready():
	animated.play("left_idle")
	
	
	
func _physics_process(_delta:float)->void:
	var direction:= Vector3.ZERO
	direction.x = Input.get_axis("left","right")
	direction.z = Input.get_axis("up","down")
	
	
	
	velocity.x = move_toward(velocity.x,speed*direction.x,acceleration)
	velocity.z = move_toward(velocity.z,speed*direction.z,acceleration)
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
