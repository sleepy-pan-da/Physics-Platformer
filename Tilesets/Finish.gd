extends Area2D

onready var Finish_effect = preload("res://effects/Finish_effect.tscn")
signal finished

func _on_Finish_body_entered(body):
	#print("reached")
	var finish_effect = Finish_effect.instance()
	get_tree().current_scene.add_child(finish_effect)
	finish_effect.global_position = body.global_position
	finish_effect.emitting = true
	body.queue_free()
	emit_signal("finished")
