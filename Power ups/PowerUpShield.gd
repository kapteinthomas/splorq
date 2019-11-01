extends "res://Power ups/PowerUp.gd"


func _on_Shield_area_entered(area):
	if area.has_method("activate_shield"):
		area.activate_shield()
		queue_free()
