extends TextureButton

var id
var letterText
var subText

var typeItem:String
var last_touch_position = Vector2()

var is_scrolling = false
var selected = false
@export var playerInventory: CompressedTexture2D
@export var container: CompressedTexture2D

@onready var texture_item = $textureItem
@onready var name_item = $nameItem

@onready var clickSound = $audio/click
@onready var paperSound = $audio/letter
@onready var took_pills = $audio/tookPills
@onready var UI = get_tree().get_first_node_in_group("ui_node")
@onready var animation_player = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("player")

var inspectionZone = ""
#textures ------------------------------------------------------------------
@export var idIconTextures: Array[CompressedTexture2D]
@export var idNameTexts: Array[String]
@export var idLetterTexts: Array[String]
@export var idSubTexts: Array[Array]
@export var nonUsedItems: Array[int]
@export var readItems: Array[int]



func _ready():
	_update_texture_and_text(id)
	match(typeItem):
		"container":
			self.texture_normal = container
		"playerInventory":
			self.texture_normal = playerInventory
	
	letterText = idLetterTexts[id]
	subText = idSubTexts[id]

func _input(event):
	if event is InputEventScreenDrag:
		handle_screen_drag(event)
	elif event is InputEventScreenTouch:
		if event.pressed:
			last_touch_position = event.position
			is_scrolling = false  # Comienza un nuevo toque, aún no es scroll
		else:
			is_scrolling = false  # Termina el toque, y con esto, el scroll

func _process(delta):
	if selected:
		self.modulate = "8c8c8c"
	else:
		self.modulate = "ffffff"
	
	
	if is_scrolling:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_PASS

func _update_texture_and_text(id):
	texture_item.texture = idIconTextures[id]
	name_item.text = tr(idNameTexts[id])

func _on_button_up():
	_inspectionUI(id)
	
func _inspectionUI(id): ##Inspection Button
	for items in get_tree().get_nodes_in_group("item_node"):
		items.selected = false
	
	selected = true
	if typeItem == "container":
		_erase_item_box(id)
		player._add_item_to_inventory(id)
		animation_player.play("queefreeAnimation")
	elif typeItem == "playerInventory": 
		UI.inspectObject(id,letterText,subText)
		match id:
			0: ##Letter0
				paperSound.play()
			1: ##sanityPill
				pass
			2: ##Key
				pass
			3: ##LetterSanityPill
				paperSound.play()
			4: ##PhotoFragmentFlashback, PhotoFragmentNormal
				paperSound.play()

func _interact(id): ##Use Button
	match id:
		0: ##Letter0
			pass
			
		1: ##sanityPill
			_erase_item_player(id)
			player.sanity = 100
			took_pills.play()
		
		2: ##Key
			pass
				
		3: ##LetterSanityPill
			pass
		
		4: ##PhotoFragmentFlashback
			UI._flashback(0)
			
func _erase_item_box(id):
	var countNodes: Array
	var container_ui = get_tree().get_nodes_in_group("container_ui")[0]
	countNodes.append(get_tree().get_nodes_in_group("container"))
	for i in range(countNodes[0].size()):
		var box = get_tree().get_nodes_in_group("container")[i]
		if box.open:
			box.inventory.erase(id)
	animation_player.play("queefreeAnimation")
	

func _erase_item_player(id):
	var playerInv = get_tree().get_first_node_in_group("player_inv")
	player._remove_item_to_inventory(id)
	playerInv.select_next_item(self.get_index())
	self.queue_free()
	
func handle_screen_drag(event):
	var drag_vector = event.position - last_touch_position
	if drag_vector.length() > 5:  # Umbral mínimo de drag para considerarlo scroll
		is_scrolling = true
	last_touch_position = event.position


func _on_animation_player_animation_finished(anim_name):
	queue_free()

func canInspect(id):
	return idSubTexts[id].size() > 0

func canUse(id):
	return !nonUsedItems.has(id)

func isReadItem(id):
	return readItems.has(id)
