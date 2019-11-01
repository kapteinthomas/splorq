extends Area2D

var animations
var shooting_arm
var shooting_arm_sprite
var gun_sprite
var gun_pos
var aim_dir
var shoot_touch = false
var speed = 10
var motion = Vector2()
var friction_factor = 0.995
var shoot_power
var triple_shot = false
var health = 100
var score = 0
var shield = false

var parent_node

onready var laser = load("res://laser/Laser.tscn")
var HUD #= load("res://HUD/HUD.tscn")

func _ready():
	animations = $AnimationPlayer
	shooting_arm = $Sprites/RightArm
	shooting_arm_sprite = $Sprites/RightArm/s
	gun_sprite = $Sprites/RightArm/Gun
	gun_pos = gun_sprite.get_position()
	animations.play("Idle")
	$Shield.monitoring = false
	parent_node = get_parent()
	HUD = get_parent().get_node("HUD")


func _unhandled_input(event):
	if shoot_touch:
		print(shoot_power)
		#HUD.update_powerbar(shoot_power)
		
	if event is InputEventScreenTouch:
		if event.is_pressed():
			shoot_touch = true
			$GunPowerTimer.start()
		elif not event.is_pressed():
			shoot_touch = false
			$GunPowerTimer.stop()
			aim()
			shoot(shoot_power)
			HUD.update_powerbar(0)
			


func _physics_process(delta):
	if shoot_touch:
		update_shoot_power()
	
	position += motion * delta
	motion *= friction_factor


func aim():
	var mouse_pos = get_global_mouse_position()
	var self_pos = get_global_position()
	aim_dir = (self_pos - mouse_pos).normalized()
	if aim_dir.x < 0:
		shooting_arm_sprite.set_flip_v(true)
		gun_sprite.set_flip_v(false)
		gun_sprite.position = gun_pos
		$ShootingAnimPlayer.play("ShootRight")
	else:
		shooting_arm_sprite.set_flip_v(false)
		gun_sprite.set_flip_v(true)
		gun_sprite.position = gun_pos + Vector2(0, 10)
		$ShootingAnimPlayer.play("ShootLeft")
	shooting_arm.look_at(mouse_pos)
	


func update_shoot_power():
	var power_value = ($GunPowerTimer.wait_time - $GunPowerTimer.time_left) / $GunPowerTimer.wait_time * 100
	shoot_power = power_value
	#if shoot_power < 20:
	#	shoot_power = 20
	HUD.update_powerbar(shoot_power)


func shoot(power):
	if power < 10:
		power = 10
	$Sounds/LaserSound.play(0.0)
	var laser_pos = $Sprites/RightArm/LasperSpawn.get_global_position()
	#var laser_pos = get_global_position()
	if not triple_shot:
		spawn_laser(laser_pos, aim_dir, power)
	elif triple_shot:
		var laser_rot = aim_dir.angle() - PI/6
		for i in range(3):
			var dir_vector = Vector2(cos(laser_rot), sin(laser_rot))
			spawn_laser(laser_pos, dir_vector, power)
			laser_rot += PI/6
	
	motion += aim_dir * speed * power

func spawn_laser(pos, dir, power):
	var laser_inst = laser.instance()
	parent_node.add_child(laser_inst)
	laser_inst.start(pos, dir, power)

func _on_AnimationPlayer_animation_finished(anim_name):
	if not anim_name == "Idle":
		$AnimationPlayer.play("Idle")


func _on_Character_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Up" or body.name == "Down":
		motion.y *= -1
	if body.name == "Left" or body.name == "Right":
		motion.x *= -1


func take_damage(damage, direction):
	motion += direction * 100
	$Sounds/HurtSound.play(0.0)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Hurt")
	health -= damage
	HUD.update_healthbar(health)
	if health <= 0:
		game_over()


func game_over():
	parent_node.game_over()
	queue_free()
	GLOBALS.update_score(score)


func increase_score(num):
	$Sounds/PickUpSound.play(0.0)
	score += num
	HUD.update_score(score)
	if score % 20 == 0:
		parent_node.increase_difficulty()


func activate_triple_shot():
	$Sounds/PowerUp1.play()
	triple_shot = true
	$PowerUpTimer.start()


func activate_shield():
	shield = true
	$Sounds/PowerUp1.play()
	$Shield/AnimSprite.playing = true
	$Shield/AnimSprite.show()
	$Shield.monitoring = true
	$PowerUpTimer.start()

func heal(value):
	$Sounds/Heal.play()
	health += value
	if health > 100:
		health = 100
	HUD.update_healthbar(health)


func _on_PowerUpTimer_timeout() -> void:
	if triple_shot:
		triple_shot = false
	if shield:
		shield = false
		$Shield/AnimSprite.playing = false
		$Shield.monitoring = false
		$Shield/AnimSprite.hide()


func _on_Shield_area_entered(area):
	if area.has_method("killed"):
		area.killed()
