extends CenterContainer

var turn = 1
var buttons
var grid = [
	"", "", "", 
	"", "", "", 
	"", "", ""
]
var player = Global.player
var opponent = Global.oppenent

var player_texture = Global.player_texture
var opponent_texture = Global.oppenent_texture


func _ready():
	buttons = $GridContainer.get_children()

	

func _on_TextureButton_pressed(ind):
	# FIXME: oppenent wins but game no end??? lmao
	buttons[ind-1].texture_normal = player_texture
	buttons[ind-1].disabled = true
	turn = -turn
	grid[ind-1] = player
	if isWinner("O"): 
		$Label.text = "O WON"
		for button in buttons:
			button.disabled = true
	
	var move = findBestMove(grid)
			
	buttons[move].texture_normal = opponent_texture
	buttons[move].disabled = true
	grid[move] = opponent
	
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
	if isWinner(opponent): return 10
	elif isWinner(player): return -10
	else: return 0

func minimax(board, depth, maxPlayer, alpha, beta):
	var val = evaluate()
	if val != 0: return val
	elif not board.has(""): return 0
	
	if maxPlayer:
		var bestMove = -10
		for cell in range(9):
			if board[cell] == "":
				board[cell] = opponent
				bestMove = max(bestMove, minimax(board, depth+1, !maxPlayer, alpha, beta))
				board[cell] = ""
				alpha = max(alpha, bestMove)
				if alpha >= beta:
					break
		return bestMove
	else:
		var bestMove = 10
		for cell in range(9):
			if board[cell] == "":
				board[cell] = player
				bestMove = min(bestMove, minimax(board, depth+1, !maxPlayer, alpha, beta))
				board[cell] = ""
				beta = min(beta, bestMove)
				if beta <= alpha:
					break
		return bestMove

func findBestMove(board):
	var bestVal = -10000
	var bestmove = -1
	for cell in range(9):
		if board[cell] == "":
			board[cell] = opponent
			var val = minimax(board, 0, false, -INF, INF)
			board[cell] = ""
			if val > bestVal:
				bestVal = val
				bestmove = cell
	
	return bestmove
