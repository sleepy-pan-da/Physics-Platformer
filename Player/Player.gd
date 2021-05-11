extends RigidBody2D

var direction_cursor_to_ball : Vector2 # calculation of force
var direction_ball_to_cursor : Vector2 # calculation of threshold
var impulse : float
var can_move := false
var pull := false
var max_distance = 150
var alpha_modulate = 100
onready var cursor = $cursor
onready var sprite = $Sprite
onready var checkalive = $CheckAlive

signal died

func _ready():
	cursor.visible = false

func _integrate_forces(_state):
#	if state.linear_velocity == Vector2.ZERO:
#		print("not moving")
	
	if Input.is_action_just_pressed("switch_control"):
		pull = !pull
	
	if Input.is_action_pressed("left_click") and can_move:
		cursor.visible = true
		cursor.global_position = get_global_mouse_position()
		direction_cursor_to_ball = cursor.global_position.direction_to(global_position)
		direction_ball_to_cursor = global_position.direction_to(cursor.global_position)
		
	if global_position.distance_to(cursor.global_position) > max_distance:
		cursor.global_position = global_position + direction_ball_to_cursor * max_distance
	

	if Input.is_action_just_released("left_click"):
		impulse = cursor.global_position.distance_to(global_position) * 5
		if pull:
			apply_central_impulse(direction_cursor_to_ball * impulse)
		else:
			apply_central_impulse(direction_ball_to_cursor * impulse)
		cursor.global_position = global_position
		cursor.visible = false


func _on_Player_body_entered(body):
	#print("touched")
	if body.is_in_group("platform") or body.is_in_group("testobject"):
		if !can_move:
			checkalive.stop()
		can_move = true
		#sprite.modulate = Color8(255, 255, 255, 255)
		#print(can_move)
		#print(can_move , "2") 
	if body.is_in_group("spike"):
		checkalive.stop()
		GlobalScript.lastdead_position = global_position
		emit_signal("died")
	if body.is_in_group("bouncy"):
		checkalive.stop()
		checkalive.start()
func _on_Player_body_exited(body):
	if body.is_in_group("platform") or body.is_in_group("testobject"):
		can_move = false
		checkalive.start()
		#sprite.modulate = Color8(255, 255, 255, alpha_modulate)
		#print(can_move)





#func _on_VisibilityNotifier2D_screen_exited():
#	GlobalScript.lastdead_position = global_position
#	emit_signal("died")


func _on_CheckAlive_timeout():
	GlobalScript.lastdead_position = global_position
	emit_signal("died")
