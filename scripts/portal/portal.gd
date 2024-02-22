class_name Portal extends Node3D

signal player_passed

@export var world := 0

@onready var camera : Camera3D = get_viewport().get_camera_3d()
@onready var portal_area : PortalArea3D = $Area3D

@onready var corners := {
	"A": $A,
	"B": $B,
	"C": $C,
	"D": $D
}


var _last_dot_product : float = 0.0
var _last_is_backside : bool = false


func _ready() -> void:
	PortalSingleton.register_portal(self)


func _process(delta : float) -> void:
	if not camera: camera = get_viewport().get_camera_3d()
	check_backside()


# Converts a floating point number to an integer which is further from zero, "larger" in absolute value: 0.1 becomes 1, -0.1 becomes -1
static func round_from_zero(in_float : float) -> float:
	if in_float < 0:
		return floorf(in_float)
	else:
		return ceilf(in_float)


# A value bigger than 0 means that the player has crossed the portal. 
static func dot_product(portal : Portal, node : Node3D) -> float:
	if portal and node:
		var delta_safe_normal : Vector3 = (node.get_global_position() - portal.get_global_position()).normalized()
		var portal_forward_vector : Vector3 = portal.global_transform.basis.z
		return portal_forward_vector.dot(delta_safe_normal)
	return 0


func check_backside() -> void:
	_last_dot_product = dot_product(self, camera)
	var is_backside := round_from_zero(_last_dot_product) > 0
	if _last_is_backside != is_backside:
		_last_is_backside = is_backside
		if portal_area.is_overlapping_player:
			player_passed.emit()
