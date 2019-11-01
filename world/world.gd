extends Node

export (PackedScene) var Mob
onready var powerups = [preload("res://Power ups/PowerUpShield.tscn"),
						preload("res://Power ups/PowerUpHealth.tscn"),
						preload("res://Power ups/TripleShot.tscn")]

var game_over_scene = "res://MainMenu/GameOverScene.tscn"

var enemy_timer = 4


func _ready():
	randomize()
	$MobHandler/Timer.wait_time = enemy_timer
	spawn_enemy()

func _on_Timer_timeout():
	spawn_enemy()

	
func spawn_enemy():
	$MobHandler/MobSpawnPath/SpawnLocation.set_offset(randi())
	var mob = Mob.instance()
	add_child(mob)
	mob.position = $MobHandler/MobSpawnPath/SpawnLocation.position
			
	var direction = ($Character.position - mob.position).normalized()
	mob.start(direction)

func increase_difficulty():
	print("increasing difficulty")
	enemy_timer *= 0.8
	print("enemy timer: " + str(enemy_timer))
	$MobHandler/Timer.wait_time = enemy_timer
	
	

func _on_PowerUpTimer_timeout():
	var power = powerups[randi() % powerups.size()].instance()
	add_child(power)

func game_over():
	$HUD.game_over()
#warning-ignore:return_value_discarded
	get_tree().change_scene(game_over_scene)