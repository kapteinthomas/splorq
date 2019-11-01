extends Area2D

var direction = Vector2()
var rot_speed
var speed = 300
var screensize
var points = 10

func _ready():
	screensize = get_viewport().size

func start(pos, dir):
	position = pos
	direction = dir
	rot_speed = randf()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	rotation += rot_speed * delta
	
	if position.x > screensize.x:
		queue_free()
	if position.x < 0:
		queue_free()
	if position.y > screensize.y:
		queue_free()
	if position.y < 0:
		queue_free()

func _on_AlienJuice_area_entered(area: Area2D) -> void:
	if area.has_method("increase_score"):
		area.increase_score(points)
		queue_free()



func _on_Timer_timeout():
	queue_free()


func _on_AnimationTimer_timeout():
	$AnimationPlayer.play("Blink")
