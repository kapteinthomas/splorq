extends Sprite

var motion = Vector2()
var speed = 100


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		var mouse_pos = get_global_mouse_position()
		var player_pos = get_global_position()
		var direction = player_pos - mouse_pos
		motion = direction.normalized() * speed
		
	position += motion * delta	