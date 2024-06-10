extends Control

@export
var item: PackedScene
@onready var animation_player = $AnimationPlayer
@onready var v_box_container = $inventoryContainer/VBoxContainer
@onready var empty_text_label = $emptyTextLabel
@onready var UI = get_tree().get_first_node_in_group("ui_node")
@onready var inspection_button = $inspectionButton
@onready var use_button = $useButton

var has_visible_items: bool
var selectedItem

func _ready():
	for dialogue in get_tree().get_nodes_in_group("dialogue_touch"):
		dialogue.queue_free()
	for dialogue in get_tree().get_nodes_in_group("dialogue"):
		dialogue.queue_free()
	
	select_first_item()
		
func _process(delta):
	for item in v_box_container.get_children():
		if item.visible:
			has_visible_items = true
			break
		else:
			has_visible_items = false
	
	empty_text_label.visible = !has_visible_items
	
	if v_box_container.get_child_count() == 0:
		inspection_button.disabled = true
		use_button.disabled = true
	elif v_box_container.get_child_count() > 0:
		for item in v_box_container.get_children():
			if item.selected:
				selectedItem = item
		
		if selectedItem != null:
			if selectedItem.canInspect(selectedItem.id):
				inspection_button.disabled = false
			else:
				inspection_button.disabled = true

			if selectedItem.canUse(selectedItem.id):
				use_button.disabled = false
			else:
				use_button.disabled = true
		
		if selectedItem.isReadItem(selectedItem.id):
			inspection_button.text = tr("KEY0_uiText3")
		else:
			inspection_button.text = tr("KEY0_uiText1") 
		
func select_first_item():
	if v_box_container.get_child_count() > 0: 
		v_box_container.get_child(0)._inspectionUI(v_box_container.get_child(0).id)

func select_next_item(index):
	if v_box_container.get_child_count() > 0: 
		if index != 0:
			index -= 1
		v_box_container.get_child(index)._inspectionUI(v_box_container.get_child(index).id)
		
func _on_close_button_released():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.inventoryOpen = false
	animation_player.play("fade_out")
	
func _add_items(idItems:Array, typeItem:String):
	v_box_container = $inventoryContainer/VBoxContainer
	for i in range(idItems.size()):
		var newItem = item.instantiate()
		newItem.id = idItems[i]
		newItem.typeItem = typeItem
		v_box_container.add_child(newItem)

func _close():
	#get_parent().HUDOpen = false
	queue_free()
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		_close()


func _on_use_button_button_up():
	if v_box_container.get_child_count() > 0:
		var items = get_tree().get_nodes_in_group("item_node")
		for item in items:
			if item.selected:
				item._interact(selectedItem.id)
		#var inspection_ui = get_tree().get_first_node_in_group("inspection_ui")
		


func _on_inspection_button_button_up():
	if v_box_container.get_child_count() > 0:
		var inspection_ui = get_tree().get_first_node_in_group("inspection_ui")
		inspection_ui.inspection()
