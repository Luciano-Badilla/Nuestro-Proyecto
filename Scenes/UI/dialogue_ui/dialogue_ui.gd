extends Control

var canPlay = true
var queefree = true
@onready var text_label = $TextLabel
@onready var animation_player = $AnimationPlayer

func _ready():
	for i in get_tree().get_nodes_in_group("dialogue_touch"):
		i.queue_free()

func _process(delta):
	var text = text_label.text
	if text_label.visible_characters == text.length() and queefree == true:
		$queuefree_timer.start()
		queefree = false

func _on_queuefree_timer_timeout():
	animation_player.play("fade_out")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		queue_free()


func _on_typing_timer_timeout():
	text_label.visible_characters += 1

