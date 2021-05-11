extends Node2D

onready var finish = $Finish
onready var player = $Player
onready var Deatheffect = preload("res://effects/Finish_effect.tscn")
#things that require changes
onready var currentlvl = "res://World/Level23.tscn" 
onready var nextlvl = "res://World/Credits.tscn"
var timespentonlvl : float
func _ready():
	finish.connect("finished", self, "level_transition")
	player.connect("died", self, "reset_stage")
	print("ready")
	check_dead()
	
func _process(delta):
	timespentonlvl += delta
	if Input.is_action_just_pressed("reset"):
		GlobalScript.timesdied += 1
		GlobalScript.lastdead_position = player.global_position
		reset_stage()
		

func level_transition():
	GlobalScript.timespentingame += timespentonlvl
	SceneChanger.change_scene(nextlvl)

func play_deatheffect():
	print("play deatheffect")
	var deatheffect = Deatheffect.instance()
	get_tree().current_scene.add_child(deatheffect)
	deatheffect.global_position = GlobalScript.lastdead_position
	deatheffect.emitting = true

func reset_stage():
	GlobalScript.timespentingame += timespentonlvl
	get_tree().change_scene(currentlvl)
	GlobalScript.dead = true
	print("stage resetted")
	
func check_dead():
	if GlobalScript.dead:
		play_deatheffect()
		GlobalScript.dead = false
