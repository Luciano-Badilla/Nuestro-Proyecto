extends Node2D

func _on_area_area_entered(area):
	if area.is_in_group("player_interaction"):
		visible = true


func _on_area_area_exited(area):
	if area.is_in_group("player_interaction"):
		visible = false
