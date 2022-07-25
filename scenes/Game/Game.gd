extends Node

# Declare member variables here. Examples:
onready var hud = get_node("CanvasLayer/HUD")
onready var finalScreen = get_node("CanvasLayer/FinalScreen")

var score_player_one = 0
var score_player_two = 0

var max_score = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score()
	$StartTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	if $StartTimer.time_left > 1:
		hud.get_node("CountdownContainer/CenterContainer/ActionText").set_text(str(round($StartTimer.time_left)))


func _on_Field_goal_left():
	score_player_two += 1
	update_score()
	
	if score_player_two < max_score:
		start_new_round()
	else:
		show_winner("You Loose")

func _on_Field_goal_right():
	score_player_one += 1
	update_score()
	
	if score_player_one < max_score:
		start_new_round()
	else:
		show_winner("You Win")

func start_new_round():
	$Ball.reset()
	$Player1.set_position(Vector2(50, 256))
	$Player2.set_position(Vector2(974, 256))
	hud.get_node("CountdownContainer").set_visible(true)
	$StartTimer.start()

func start_new_game():
	score_player_one = 0
	score_player_two = 0
	update_score()
	finalScreen.set_visible(false)
	start_new_round()

func _on_StartTimer_timeout():
	hud.get_node("CountdownContainer").set_visible(false)
	$Ball.set_start_direction()

func update_score():
	hud.get_node("PointsDisplay/ScorePlayerOne").set_text(str(score_player_one))
	hud.get_node("PointsDisplay/ScorePlayerTwo").set_text(str(score_player_two))

func show_winner(message):
	finalScreen.set_visible(true)
	finalScreen.get_node("VBoxContainer/ResultMessage").set_text(message)

func _on_FinalScreen_new_round():
	start_new_game()


func _on_FinalScreen_exit():
	get_tree().quit()
