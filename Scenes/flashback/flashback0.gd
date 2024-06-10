extends Node2D
@onready var animation_player = $AnimationPlayer
@onready var protagonist = $actors/protagonist
@onready var protagonist_book = $sprites/objects/ProtagonistBook

var texts: Array[String]

#var current_animation: String
#var current_animation_position: float

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		continue_animation()

func dialogue(text: Array):
	var ui = get_tree().get_first_node_in_group("ui_node")
	ui._dialogue_touch(text, "dialogue_instances")
	

func pause_animation():
	animation_player.active = false
	#current_animation_position = animation_player.current_animation_length
	#animation_player.stop()

func continue_animation():
	animation_player.active = true
	#animation_player.seek(current_animation_position,true)
	#animation_player.play(animation_player.current_animation)

func deleteScene():
	animation_player.play("fadeOut")


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fadeOut":
			queue_free()


func _on_protagonist_frame_changed():
	if protagonist.animation == "leaveBook" and protagonist.frame == 10:
		protagonist_book.visible = true
