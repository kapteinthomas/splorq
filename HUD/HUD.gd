extends CanvasLayer
	
func _ready():
	$GameOverLabel.hide()

func update_healthbar(value):
	$Margin/VSplitContainer/HSplitContainer/HealthBar.value = value

func update_powerbar(value):
	$Margin/VSplitContainer/Control/PowerBar.value = value
	
func update_score(value):
	$ScoreLabel.text = str(value)
	
func game_over():
	$GameOverLabel.show()