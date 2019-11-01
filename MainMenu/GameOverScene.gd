extends Node

var main_scene = "res://world/world.tscn"

func _ready():
	$Score.text = "Score: " + str(GLOBALS.score)
	$HighScore.text = "Your Highscore: " + str(GLOBALS.highscore)

func _on_PlayAgainButton_pressed():
	get_tree().change_scene(main_scene)


func _on_Exit_pressed():
	get_tree().quit()

func _on_Reset_pressed():
	GLOBALS.set_highscore(0)
