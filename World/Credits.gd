extends Node2D


onready var timesdiedlabel = $Label2
onready var timespentingame = $Label3
var nextlvl = "res://World/Level1.tscn"
var seconds : int
var minutes : int

# Called when the node enters the scene tree for the first time.
func _ready():
	seconds = int(GlobalScript.timespentingame) % 60
	minutes = (int(GlobalScript.timespentingame) - seconds) / 60
	
	timesdiedlabel.text = "Number of times died: " + str(GlobalScript.timesdied)
	if minutes <= 0:
		timespentingame.text = "Time spent in game: " + str(int(GlobalScript.timespentingame)) + " seconds"
	else:
		timespentingame.text = "Time spent in game: " + str(minutes) + " minutes " + str(seconds) + " seconds" 

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		GlobalScript.timesdied = 0
		GlobalScript.timespentingame = 0
		SceneChanger.change_scene(nextlvl)
