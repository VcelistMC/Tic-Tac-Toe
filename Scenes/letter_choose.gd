extends CenterContainer




func _on_Button_pressed():
	Global.player = "X"
	Global.oppenent = "O"
	Global.player_texture = load("res://assests/x-button.png")
	Global.oppenent_texture = load("res://assests/o-button.png")
	get_tree().change_scene("res://Scenes/playground.tscn")



func _on_Button2_pressed():
	Global.player = "O"
	Global.oppenent = "X"
	Global.oppenent_texture = load("res://assests/x-button.png")
	Global.player_texture = load("res://assests/o-button.png")
	get_tree().change_scene("res://Scenes/playground.tscn")
