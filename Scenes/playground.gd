extends CenterContainer

var turn = 1
var res
var buttons
var curr
var grid = [
	"", "", "", 
	"", "", "", 
	"", "", ""
]
var player = "X"
var opponent = "O"

var x_texture = load("res://assests/x-button.png")
var o_texture = load("res://assests/o-button.png")
var empty = load("res://assests/download.png")
var moves


func _ready():
	buttons = $GridContainer.get_children()
	
func wait(time):
	var t = Timer.new()
	t.set_wait_time(time)
	t.set_one_shot(true)
	$".".add_child(t)
	t.start()
	yield(t, "timeout")
	

func _on_TextureButton_pressed(ind):
	buttons[ind-1].texture_normal = o_texture
	buttons[ind-1].disabled = true
	turn = -turn
	grid[ind-1] = "O"
	if isWinner("O"): 
		$Label.text = "O WON"
		for button in buttons:
			button.disabled = true
	
	var move = findBestMove(grid)
	for i in moves:
		if i >= 0:
			buttons[i].texture_normal = x_texture if turn == 1 else o_texture
			turn = -turn
		else:
			buttons[abs(i)].texture_normal = empty
		
		var t = Timer.new()
		t.set_wait_time(0.01)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
			
	buttons[move].texture_normal = x_texture
	buttons[move].disabled = true
	grid[move] = "X"
	
	if isWinner("X"): 
		$Label.text = "X WON"
		for button in buttons:
			button.disabled = true
	

func isWinner(potential_winner):
	for i in range(3):
		var cell = 3*i
		if grid[cell] == grid[cell+1] and grid[cell+1] == grid[cell+2]: 
			return (grid[cell] == potential_winner) #check rows
		elif grid[i] == grid[i+3] and grid[i+3] == grid[i+6]: 
			return (grid[i] == potential_winner) #check cols
	
	if grid[0] == grid[4] and grid[4] == grid[8]: 
		return (grid[0] == potential_winner)
	
	elif grid[2] == grid[4] and grid[4] == grid[6]: 
		return (grid[2] == potential_winner)
	else: return false
	
func evaluate():
	if isWinner("X"): return 10
	elif isWinner("O"): return -10
	else: return 0

func minimax(board, depth, maxPlayer):
	var val = evaluate()
	if val != 0: return val
	elif not board.has(""): return 0
	
	if maxPlayer:
		var bestMove = -10
		for cell in range(9):
			if board[cell] == "":
				moves.append(cell)
				board[cell] = player
				buttons[cell].texture_normal = o_texture if player == "O" else x_texture
				bestMove = max(bestMove, minimax(board, depth+1, !maxPlayer))
				board[cell] = ""
				moves.append(-cell)
				buttons[cell].texture_normal = empty
		return bestMove
	else:
		var bestMove = 10
		for cell in range(9):
			if board[cell] == "":
				moves.append(cell)
				board[cell] = opponent
				buttons[cell].texture_normal = o_texture if player == "O" else x_texture
				bestMove = min(bestMove, minimax(board, depth+1, !maxPlayer))
				board[cell] = ""
				moves.append(-cell)
				buttons[cell].texture_normal = empty
		return bestMove

func findBestMove(board):
	var bestVal = -10000
	var bestmove = -1
	moves = []
	for cell in range(9):
		if board[cell] == "":
			moves.append(cell)
			board[cell] = player
			buttons[cell].texture_normal = o_texture if player == "O" else x_texture
			var val = minimax(board, 0, false)
			board[cell] = ""
			moves.append(-cell)
			buttons[cell].texture_normal = empty
			if val > bestVal:
				bestVal = val
				bestmove = cell
	
	return bestmove
