extends Control

@export
var item: PackedScene

@onready var animation_player = $AnimationPlayer
@onready var empty_inv_label = $emptyInvLabel
@onready var v_box_container = $inventoryContainer/VBoxContainer
var has_visible_items: bool

func _process(delta):
	for item in v_box_container.get_children():
		if item.visible:
			has_visible_items = true
			break
		else:
			has_visible_items = false
	
	empty_inv_label.visible = !has_visible_items

func _on_close_button_released():
	animation_player.play("fade_out")
	
func _add_items(idItems:Array, typeItem:String):
	var v_box_container = $inventoryContainer/VBoxContainer
	for i in range(idItems.size()):
		var newItem = item.instantiate()
		newItem.id = idItems[i]
		newItem.typeItem = typeItem
		v_box_container.add_child(newItem)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		_close()

func _close():
	var countNodes: Array
	countNodes.append(get_tree().get_nodes_in_group("container"))
	for i in range(countNodes[0].size()):
		var container = get_tree().get_nodes_in_group("container")[i]
		if container.open:
			container.open = false
			queue_free()
