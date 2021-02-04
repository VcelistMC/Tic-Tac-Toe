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
var player = "O"
var opponent = "X"


func _ready():
	buttons = $GridContainer.get_children()
	var move = findBestMove(grid)
	print("best move for x is" + str(move+1))
	print("yeeet")
	

func _on_TextureButton_pressed(ind):
	if turn == 1:
		res = "res://assests/x-button.png"
		curr = "X"
		var move = findBestMove(grid)
		print("best move for x is" + str(move+1))
	else:
		res = "res://assests/o-button.png"
		curr = "O"
	buttons[ind-1].texture_normal = load(res)
	buttons[ind-1].disabled = true
	turn = -turn
	grid[ind-1] = curr
	if isWinner(curr): 
		$Label.text = curr + " WON"
		for button in buttons:
			button.disabled = true
	

func isWinner(potential_winner):
	for i in range(3):
		var cell = 3*i
		if grid[cell] == grid[cell+1] and potential_winner == grid[cell+2]: return true #check rows
		elif grid[i] == grid[i+3] and potential_winner == grid[i+6]: return true #check cols
	
	if grid[0] == grid[4] and potential_winner == grid[8]: return true
	elif grid[2] == grid[4] and potential_winner == grid[6]: return true
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
				board[cell] = player
				bestMove = max(bestMove, minimax(board, depth+1, !maxPlayer))
				board[cell] = ""
		return bestMove
	else:
		var bestMove = 10
		for cell in range(9):
			if board[cell] == "":
				board[cell] = opponent
				bestMove = min(bestMove, minimax(board, depth+1, !maxPlayer))
				board[cell] = ""
		return bestMove

func findBestMove(board):
	var bestVal = -10000
	var bestmove = -1
	for cell in range(9):
		if board[cell] == "":
			board[cell] = player
			var val = minimax(board, 0, false)
			board[cell] = ""
			if val > bestVal:
				bestVal = val
				bestmove = cell
	
	return bestmove
