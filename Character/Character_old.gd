extends Area2D

var parent_node
var HUD

var mouse_pos = Vector2()
var player_pos = Vector2()
var gun_direction = Vector2()
var motion = Vector2()
var score = 0
var speed = 10
var fire_power = 1
var max_speed = 800
var health = 100
var shoot_power
var friction_factor = 0.995
var triple_shot = false
var touching = false


export (PackedScene) var laser


func _ready():
	motion = Vector2()
	parent_node = get_parent()
	HUD = parent_node.get_node("HUD")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed():
			touching = true
			$GunPowerTimer.start()
		elif not event.is_pressed():
			touching = false
			$GunPowerTimer.stop()
			mouse_pos = event.position
			player_pos = get_global_position()
			update_gun_rotation()
			shoot(shoot_power)
			HUD.update_powerbar(0)


func _physics_process(delta: float) -> void:
	if touching:
		update_shoot_power()
	
	position += motion * delta
	motion *= friction_factor
	
	
func update_gun_rotation():
	#mouse_pos = event.get_position()
	player_pos = get_global_position()
	gun_direction = (player_pos - mouse_pos).normalized()
	var gun_rotation = gun_direction.angle() - PI
	$GunRotPoint.rotation = gun_rotation
	
	if gun_rotation < -PI/2 and gun_rotation > -PI*3/2:
		$Sprite.flip_h = true
		$GunRotPoint/Sprite.flip_v = true
	else:
		$Sprite.flip_h = false
		$GunRotPoint/Sprite.flip_v = false


func update_shoot_power():
	var power_value = (2 - $GunPowerTimer.time_left) / 2 * 100
	HUD.update_powerbar(power_value)
	shoot_power = power_value
	if shoot_power < 20:
		shoot_power = 20
	

func shoot(power):
	var spawn_pos = player_pos
	if not triple_shot:
		spawn_bullet(spawn_pos, gun_direction, power)
	elif triple_shot:
		var laser_rot = gun_direction.angle() - PI/6
		for i in range(3):
			var dir_vector = Vector2(cos(laser_rot), sin(laser_rot))
			spawn_bullet(spawn_pos, dir_vector, power)
			laser_rot += PI/6
	
	$Sounds/LaserSound.play(0.0)
	
	motion += gun_direction * speed * power
	motion.x = clamp(motion.x, -max_speed, max_speed)
	motion.y = clamp(motion.y, -max_speed, max_speed)
	
func spawn_bullet(pos, dir, power):
		var laser_inst = laser.instance()
		parent_node.add_child(laser_inst)
		laser_inst.start(pos, dir, power)

func _on_Character_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Up" or body.name == "Down":
		motion.y *= -1
	if body.name == "Left" or body.name == "Right":
		motion.x *= -1

func take_damage(damage, direction):
	motion += direction * 100
	$Sounds/HurtSound.play(0.0)
	$AnimationPlayer.play("hurt")
	health -= damage
	HUD.update_healthbar(health)
	if health <= 0:
		game_over()
		
func game_over():
	parent_node.game_over()
	queue_free()
	GLOBALS.score = score
	if GLOBALS.score > GLOBALS.highscore:
		GLOBALS.highscore = score

func increase_score(num):
	$Sounds/PickUpSound.play(0.0)
	score += num
	HUD.update_score(score)

func activate_triple_shot():
	$Sounds/PowerUp1.play()
	triple_shot = true
	$PowerUpTimer.start()

func heal(value):
	$Sounds/Heal.play()
	health += value
	if health > 100:
		health = 100
	HUD.update_healthbar(health)


func _on_PowerUpTimer_timeout() -> void:
	triple_shot = false
