extends CharacterBody3D
@onready var animation_player = $AnimationPlayer
@onready var nav_agent = $NavigationAgent3D
@onready var animateds = $AnimatedSprite3D
@onready var attack_rotation = $attack_rotation

var defense := 10
var max_hp :=150
var current_hp := 150
var death = false
var player_chase = false
var acceleration = 2
var speed = 0.025
var player_in_range = false
var player_in_hitbox = false
var player = null
var weapon_type := "none"
var player_hit := false
var take_damage_cooldown = true
var shield = true
var look_delay = false

func _ready():
	shield = true
	current_hp = 100
	death = false
	animateds.play("idle")

func _process(delta):
	pass
func player_trace(): #kind of works
	if player_chase == true:
		self.position += (player.position-self.position)*speed

func _physics_process(delta:float)->void:
	player_trace()
	attack_player()
	move_and_slide()
	player_damage()
	handle_gravity(delta)
	death_()
	handle_ememy_movement_animations()
	
	
func make_path():
	nav_agent.target_position = player.global_position

func handle_ememy_movement_animations(): #doesn't work
	if player_chase:
		if look_delay == false:
			if Input.is_action_pressed("up"):
				animateds.play("up")
				look_delay=true
			elif Input.is_action_pressed("down"):
				animateds.play("down")
				look_delay=true
			elif Input.is_action_pressed("left"):
				animateds.play("left")
				look_delay=true
			elif Input.is_action_pressed("right"):
				animateds.play("right")
				look_delay=true
	
	else:
		animateds.play("idle")



func handle_gravity(delta):
	velocity.y -= 3 * delta

func death_():
	if current_hp <= 0:
		death = true
		animation_player.play("death")
		queue_free()

#var direction:= Vector3.ZERO
#	velocity.x = move_toward(velocity.x,(player.position-position)*speed*direction.x,acceleration)
#	velocity.z = move_toward(velocity.z,(player.position-position)*speed*direction.z,acceleration)

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false


func _on_timer_timeout():
	make_path()


func enemy():
	pass

func attack_player():
	if player_in_range == true:
		animation_player.play("attack1")


func _on_enemy_attack_range_body_entered(body):
	if body.has_method("player"):
		player_in_range = true


func _on_enemy_atack_range_body_exited(body):
	if body.has_method("player"):
		player_in_range = false

func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_hitbox = true


func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_hitbox = false

func _on_hurtbox_area_entered(area):
	if area.has_method("hitbox"):
		player_hit = true
		if area.has_method("copper_sword"):
			weapon_type = "copper_sword"
		elif area.has_method("silver_sword"):
			weapon_type = "silver_sword"
		elif area.has_method("silver_stinger"):
			weapon_type = "silver_stinger"
		elif area.has_method("lead_hammer"):
			weapon_type = "lead_hammer"
		elif area.has_method("gold_hammer"):
			weapon_type = "gold_hammer"
		elif area.has_method("THE_HOLY_HAMMER"):
			weapon_type = "THE_HOLY_HAMMER"
		elif area.has_method("phil_stone"):
			weapon_type = "phil_stone"

func _on_hurtbox_area_exited(area):
	if area.has_method("hitbox"):
		player_hit = false


func player_damage():
	if player_hit == true:
		if take_damage_cooldown == false:
			if weapon_type == "copper_sword":
				current_hp -= 40 - defense
				take_damage_cooldown = true
				print(current_hp)
			elif weapon_type == "silver_sword":
				current_hp -= 45 - defense
				take_damage_cooldown = true
			elif weapon_type == "silver_sword":
				current_hp -= 60 - defense
				take_damage_cooldown = true
			elif weapon_type == "lead_hammer":
				if shield == false:
					current_hp-= 20 - defense
				else:
					shield = false
			elif weapon_type == "gold_hammer":
				if shield == false:
					current_hp-= 30 - defense
				else:
					shield = false
			elif weapon_type == "THE_HOLY_HAMMER":
				if shield == false:
					current_hp-= 40 - defense
				else:
					shield = false
			elif weapon_type == "phil_stone":
				current_hp -= 60 - defense


func _on_take_damage_cooldown_timeout():
	take_damage_cooldown = false


func _on_look_delay_timeout():
	look_delay = false
