extends Node2D

@export var UI_enable: bool
@export_enum("en_EN","es_ES") var Language: String
@onready var ui = %ui

func _ready():
	ui.visible = UI_enable
	TranslationServer.set_locale(Language)
	
