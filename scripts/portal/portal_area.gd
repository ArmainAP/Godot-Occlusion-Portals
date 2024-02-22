class_name PortalArea3D extends Area3D

var is_overlapping_player := false : 
	get: return is_overlapping_player


func _ready() -> void:
	self.area_entered.connect(_area_entered)
	self.area_exited.connect(_area_exited)


func _area_entered(area: Area3D) -> void:
	if area.get_meta("player_portal_pass", false):
		is_overlapping_player = true


func _area_exited(area: Area3D) -> void:
	if area.get_meta("player_portal_pass", false):
		is_overlapping_player = false
