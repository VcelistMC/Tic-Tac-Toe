extends CenterContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var turn = 1
var res
var buttons
var grid = [
	"", "", "", 
	"", "", "", 
	"", "", ""
]
var curr

# Called when the node enters the scene tree for the first time.
func _ready():
	buttons = $GridContainer.get_children()
	print(grid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pas
	

func _on_TextureButton_pressed(ind):
	if turn == 1:
		res = "res://assests/x-button.png"
		curr = "X"
	else:
		res = "res://assests/o-button.png"
		curr = "O"
	buttons[ind-1].texture_normal = load(res)
	buttons[ind-1].disabled = true
	turn = -turn
	grid[ind-1] = curr
	if check_winner(curr): 
		$Label.text = curr + " WON"
		for button in buttons:
			button.disabled = true

func check_winner(player):
	for i in range(3):
		var cell = 3*i
		if grid[cell] == grid[cell+1] and curr == grid[cell+2]: return true #check rows
		elif grid[i] == grid[i+3] and curr == grid[i+6]: return true #check cols
	
	if grid[0] == grid[4] and curr == grid[8]: return true
	elif grid[2] == grid[4] and curr == grid[6]: return true
	else: return false
	
