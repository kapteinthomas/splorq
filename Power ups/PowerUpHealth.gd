extends "res://Power ups/PowerUp.gd"

var heal_value = 50

func _on_PowerUpHealth_area_entered(area):
	if area.has_method("heal"):
		area.heal(heal_value)
		queue_free()
