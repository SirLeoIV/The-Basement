extends Node2D

var moves = 0
var items = 0
var players = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_parent().start_game()


func calculate_score():
	var moves_score = (1000 - moves) / 250
	var final_score = items * players * moves_score * 10
	
	if players == 3:
		get_node("Survivors").text = "Everyone survived!!"
	else:
		get_node("Survivors").text = "Unfortunately only " + str(players) + " out of the 3 players survived..."
		
	if items == 3:
		get_node("Items").text = "You retrieved all 3 items!"
	else:
		get_node("Items").text = "You retrieved " + str(items) + "/3 items."
	
	get_node("Moves").text = "You spend " + str(moves) + " moves."
	get_node("Score").text = "Score: " + str(final_score)

