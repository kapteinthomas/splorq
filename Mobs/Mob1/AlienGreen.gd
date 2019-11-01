extends Area2D

var speed = 500
var direction = Vector2()
var screensize
var damage = 10
var parent_node
var alien_juice = preload("res://loot/AlienJuuice.tscn")
#var can_spawn_juice = true
var steer_force = 0.2

func _ready() -> void:
	$AnimationPlayer.play("Default")
	screensize = get_viewport().size
	parent_node = get_parent()
	
func start(dir):
	direction = dir

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
	if position.x > screensize.x + 200:
		queue_free()
	if position.x < -200:
		queue_free()
	if position.y > screensize.y + 200:
		queue_free()
	if position.y < -200:
		queue_free()

func _on_AlienGreen_area_entered(area: Area2D) -> void:	
	if area.has_method("take_damage"):
		if not area.shield:
			area.take_damage(damage, direction)
		die()


func die():
	queue_free()


func killed():
	$CollisionShape2D.disabled = true
	$DeathSound.play(0.0)
	$AnimatedSprite.hide()
	var a = alien_juice.instance()
	parent_node.add_child(a)
	a.start(position, direction)
	
	"""
	if can_spawn_juice:
		var a = alien_juice.instance()
		parent_node.add_child(a)
		a.start(position, direction)
	can_spawn_juice = false"""

func _on_DeathSound_finished() -> void:
	queue_free()


func _on_AdjustPosTimer_timeout():
	#Get position of player
	if parent_node.get_node("Character") == null:
		return
	seek()
	"""
	var target_dir = parent_node.get_node("Character").get_global_position() - get_global_position()
	var new_dir = (direction + target_dir).normalized()
	#Update direction
	direction = new_dir
	"""
	#Start timer again
	$AdjustPosTimer.start()

func seek():
	var desired = parent_node.get_node("Character").get_global_position() - get_global_position()
	desired = desired.normalized()
	var steering = (desired - direction) * steer_force
	direction = steering