extends Node

var score
var highscore = 0 setget set_highscore

const FILEPATH = "user://highscore.data"

func _ready():
	load_highscore()
	

func load_highscore():
	var file = File.new()
	if not file.file_exists(FILEPATH):
		return
	file.open(FILEPATH, file.READ)
	highscore = file.get_var()
	file.close()
	
func save_highscore():
	var file = File.new()
	file.open(FILEPATH, file.WRITE)
	file.store_var(highscore)
	file.close()

func set_highscore(new_value):
	highscore = new_value
	save_highscore()

func update_score(value):
	score = value
	if score > highscore:
		highscore = score