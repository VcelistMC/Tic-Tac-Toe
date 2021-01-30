extends CenterContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var turn = 1
var res

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	if turn == 1:
		res = "../assests/x-button.png"
		print("x")
	else:
		res = "../assests/o-button.png"
		print("o")
	$GridContainer/CenterContainer/TextureButton.texture_normal = load(res)
	turn = -turn
	
# texture disappers when pressed, even tho it loads nicely using the inspector
