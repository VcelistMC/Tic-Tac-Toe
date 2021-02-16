extends CenterContainer

var buttons # array for all buttons on the map
var grid #array too hold string values for the 

var human_player
var human_player_texture

var opponent_texture
var opponent
var moves = 9



func _ready():
	buttons = $VBoxContainer/GridContainer.get_children()
	human_player = Global.player
	human_player_texture = Global.player_texture
	opponent = Global.oppenent
	opponent_texture = Global.oppenent_texture
	grid = [
		"", "", "", 
		"", "", "", 
		"", "", ""
	]


func isGameOver(player):
	if isWinner(player):
		$Reset_timer.start()
		$VBoxContainer/Label.text = player + " WON"
		for button in buttons:
			button.disabled = true
	elif not grid.has(""):
		$Reset_timer.start()
		$VBoxContainer/Label.text = "It's a draw!"
		for button in buttons:
			button.disabled = true


func _on_TextureButton_pressed(ind):
	buttons[ind-1].texture_normal = human_player_texture
	buttons[ind-1].disabled = true
	grid[ind-1] = human_player
	isGameOver(human_player)
	
			
	var move = findBestMove(grid)
	print(move)
	if move >= 0:
		buttons[move].texture_normal = opponent_texture
		buttons[move].disabled = true
		grid[move] = opponent
		isGameOver(opponent)
	print(grid)


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
	elif isWinner(human_player): return -10
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
				board[cell] = human_player
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


func _on_Reset_timer_timeout():
	get_tree().change_scene("res://Scenes/letter_choose.tscn")
