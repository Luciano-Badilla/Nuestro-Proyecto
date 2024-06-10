extends Control

var textCount: int
var currentText = 0
var texts: Array

@onready var textLabel = $TextLabel
@onready var animation_player = $AnimationPlayer
@onready var queuefree_timer = $queuefree_timer
@onready var touch_icon = $touchIcon


func _ready():
	for i in get_tree().get_nodes_in_group("dialogue"):
		i.queue_free()

func _process(delta):
	
	if texts != null and currentText == 0 and texts.size() > 0:
		textLabel.text = texts[currentText]
	
	if textLabel.visible_characters >= tr(textLabel.text).length():
		if (currentText +1) < texts.size():
			touch_icon.play("default2")
		else:
			touch_icon.play("default3")
			
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		_update_dialogue()

func _on_visible_chars_timer_timeout():
	if textLabel.visible_characters < tr(textLabel.text).length():
		textLabel.visible_characters += 1


func _on_queuefree_timer_timeout():
	animation_player.play("fade_out")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		self.queue_free()

func _update_dialogue():
	touch_icon.frame = 0
	touch_icon.stop()
	
	currentText += 1
	if currentText <= textCount:
		textLabel.visible_characters = 0
		textLabel.text = texts[currentText]
	elif currentText > textCount:
		queuefree_timer.start()
