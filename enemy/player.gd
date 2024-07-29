extends CharacterBody3D
@onready var animation_player = $AnimationPlayer
@onready var animated:AnimatedSprite3D = $AnimatedSprite3D
@onready var area_of_attacks = $area_of_attacks


@export var speed:float = 25
@export var acceleration:float = 2

@export var max_hp := 100
var current_hp = 100
@export var player_damage :int
@export var defense :int
var attack_cooldown = true
var player_alive = true
var enemy_in_attack_range = false
var enemy_in_hitbox = false
var took_damage = false
var attackable = true
var enemy_type := "nothing"
var damage
var base_damage :int
var take_attack_cooldown = true
var dash_delay = false
#Items owned
#swords
var copper_sword_a = true
var silver_sword_a = false
var silver_stinger_a = false
#hammers
var lead_hammer_a = true
var gold_hammer_a = false
var THE_HOLY_HAMMER_a = false
#potions
var heal_potion_drinkable = true



func _ready():
	animated.play("left_idle")
	current_hp = 100

func _physics_process(delta:float)->void:
	handle_player_movement()
	handle_dash()
	move_and_slide()
	chose_attack()
	enemy_attack()
	handle_gravity(delta)
	attack_rotation()
	death()
	drink_heal_potion()
func _process(_delta:float)->void:
	handle_player_movement_animations()


func handle_gravity(delta):
	velocity.y -= 10 * delta

func handle_player_movement_animations():
	
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


func handle_player_movement():
	var direction:= Vector3.ZERO
	direction.x = Input.get_axis("left","right")
	direction.z = Input.get_axis("up","down")
	
	velocity.x = move_toward(velocity.x,speed*direction.x,acceleration)
	velocity.z = move_toward(velocity.z,speed*direction.z,acceleration)
	
#combat
func player():
	pass

		
func attack_rotation():
	if Input.is_action_just_pressed("left"):
		area_of_attacks.rotation_degrees = Vector3i(0,90,0)
	elif Input.is_action_just_pressed("right"):
		area_of_attacks.rotation_degrees = Vector3i(0,-90,0)
	elif Input.is_action_just_pressed("up"):
		area_of_attacks.rotation_degrees = Vector3i(0,0,0)
	elif Input.is_action_just_pressed("down"):
		area_of_attacks.rotation_degrees = Vector3i(0,180,0)


#  movement
func handle_dash():
	#handle movement
	if Input.is_action_just_pressed("dash"):
		if dash_delay == false:
			var direction:= Vector3.ZERO
			direction.x = Input.get_axis("left","right")
			direction.z = Input.get_axis("up","down")
			var dash_speed = 50
			velocity = dash_speed * direction
			dash_delay = true
	#handle I-frames
			animation_player.play("dash")

#  attacks

func chose_attack():
	if attackable == true:
		if Input.is_action_just_pressed("attack_sword"):
			attack_sword()
			attackable = false
	if attackable == true:
		if Input.is_action_just_pressed("attack_hammer"):
			attack_hammer()
			attackable = false
	if attackable == true:
		if Input.is_action_just_pressed("attack_phil"):
			phil_attack()
			attackable = false


func phil_attack():
	animation_player.play("phil_attack")
	
		
func attack_sword():
	if copper_sword_a == true:
		animation_player.play("copper_sword_anim")
	elif silver_sword_a == true:
		animation_player.play("silver_sword_anim")
	elif silver_stinger_a == true:
		animation_player.play("silver_stinger_anim")

func attack_hammer():
	if lead_hammer_a == true:
		animation_player.play("lead_hammer_anim")
	elif gold_hammer_a == true:
		animation_player.play("gold_hammer_anim")
	elif gold_hammer_a == true:
		animation_player.play("THE_HOLY_HAMMER_anim")

func death():
	if current_hp <= 0:
		player_alive = false
		animation_player.play("death")
		queue_free()

func _on_area_of_attack_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_hitbox = true

func _on_area_of_attack_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_hitbox = false

func _on_on_attack_delay_timeout():
	attackable = true

func enemy_attack():
	if enemy_in_attack_range == true:
		if enemy_type == "grunt":
			if take_attack_cooldown == false:
				current_hp -= 15
				take_attack_cooldown = true
				print(current_hp)
		elif enemy_type == "brute":
			if take_attack_cooldown == false:
				current_hp -= 30
				take_attack_cooldown = true
				print(current_hp)

func _on_hurtbox_area_entered(area):
	if area.has_method("hitbox"):
		enemy_in_attack_range = true
		if area.has_method("grunt"):
			enemy_type = "grunt"
		elif area.has_method("brute"):
			enemy_type = "brute"

func _on_hurtbox_area_exited(area):
	if area.has_method("hitbox"):
		enemy_in_attack_range = false
		enemy_type = "nothing"

func _on_take_damage_delay_timeout():
	take_attack_cooldown = false


func _on_dash_delay_timeout():
	dash_delay = false

func _on_heal_potion_delay_timeout():
	heal_potion_drinkable = true
@onready var heal_potion_delay = $heal_potion_delay

func drink_heal_potion():
	if heal_potion_drinkable == true:
		if Input.is_action_just_pressed("heal"):
			current_hp += 50
			heal_potion_drinkable = false
			animated.play("heal_drink")
			print(str(heal_potion_delay.wait_time) + "s cooldown")
