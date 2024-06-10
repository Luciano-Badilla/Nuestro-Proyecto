extends Control
@onready var animation_player = $AnimationPlayer
@onready var UI = get_tree().get_first_node_in_group("ui_node")
@onready var items = get_tree().get_first_node_in_group("items")
var id
var texts: Array

func _ready():
	animation_player.play("fade")
	animation_player.play()
	#if texts.size() > 0:
		#UI._dialogue_touch(texts,"inspectionZone")

func _on_texture_button_released():
	animation_player.play("fade_out")
	var dialogue = get_tree().get_nodes_in_group("dialogue_touch_ui")
	if dialogue.size() > 0:
		dialogue[0]._on_queuefree_timer_timeout()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		self.queue_free()

func inspection():
	UI._dialogue_touch(texts,"inspectionZone")

func use():
	items._interact(id)
