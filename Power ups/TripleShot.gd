extends "res://Power ups/PowerUp.gd"



func _on_TripleShot_area_entered(area):
	if area.has_method("activate_triple_shot"):
		area.activate_triple_shot()
		queue_free()
