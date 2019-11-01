extends Node

#var alien = preload("res://Mobs/Mob1/AlienGreen.tscn")
var main_scene = "res://world/world.tscn"

"""
func _ready():
	spawn_alien()

func _on_AlienGreen_tree_exited():
	spawn_alien()

func spawn_alien():
	var a = alien.instance()
	add_child(a)
	a.start(Vector2(rand_range(10, 200), rand_range(10, 200)))
	a.speed = 1"""

func _on_StartButton_pressed():
	get_tree().change_scene(main_scene)


func _on_ExitButton_pressed():
	get_tree().quit()
