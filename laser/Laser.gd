extends Node2D

const SPEED = 50
var screensize
var motion = Vector2()

func _ready() -> void:
	screensize = get_viewport().size

func start(pos: Vector2, dir: Vector2, power) -> void:
	position = pos
	$Position2D.rotation = dir.angle()
	motion = dir * -1 * power

func _physics_process(delta: float) -> void:
	position += motion * SPEED * delta
	

	#Kill when off screen
	if position.x > screensize.x:
		queue_free()
	if position.x < 0:
		queue_free()
	if position.y > screensize.y:
		queue_free()
	if position.y < 0:
		queue_free()


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.has_method("killed"):
		area.killed()
	queue_free()
