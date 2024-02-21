extends Node


@export var world := 0

var parent_shader : ShaderMaterial

func _ready() -> void:
	var parent_mesh = get_parent() as MeshInstance3D 
	parent_shader = parent_mesh.get_active_material(0) as ShaderMaterial

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not parent_shader: return
	var portal : Portal = PortalSingleton.get_portal(world)
	if not portal: return
	parent_shader.set_shader_parameter("A", portal.corners.A.get_global_position())
	parent_shader.set_shader_parameter("B", portal.corners.B.get_global_position())
	parent_shader.set_shader_parameter("C", portal.corners.C.get_global_position())
	parent_shader.set_shader_parameter("D", portal.corners.D.get_global_position())
	parent_shader.set_shader_parameter("IsSameWorld", world == PortalSingleton.PlayerWorld)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray
	var parent := get_parent() as MeshInstance3D
	if not parent:
		warnings.append("Parent expected to be MeshInstance3D")
	if not (parent.get_active_material(0) as ShaderMaterial):
		warnings.append("Parent expected to have a Shader Material")
	return warnings
