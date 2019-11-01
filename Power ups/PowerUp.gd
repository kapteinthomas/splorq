extends Area2D

var time = 0
var speed = 100
var motion = Vector2()
var start_pos = Vector2()
var rot_speed = 0.5
var screensize

func _ready() -> void:
	screensize = get_viewport().size
	start_pos.x = -50
	start_pos.y = randi() % int(screensize.y)
	position = start_pos
	var direction = (screensize/2 - get_global_position()).angle()
	rotation = direction
	

func _physics_process(delta: float) -> void:
	time += 1 * delta
	motion.y = sin(time) * 2
	
	motion.x = speed * delta
	rotation += rot_speed * delta
	position += motion