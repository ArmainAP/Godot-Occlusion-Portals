class_name PortalSingleton extends Node

static var PlayerWorld = 0

static var _self : PortalSingleton = null
static var _portals := {}

static func register_portal(in_portal : Portal, overwrite := false) -> bool:
	if !is_instance_valid(in_portal):
		return false
	if _portals.has(in_portal.world) && !overwrite:
		return false
	_portals[in_portal.world] = in_portal
	return true


static func unregister_portal(in_portal : Portal) -> bool:
	if !is_instance_valid(in_portal):
		return false
	if !_portals.has(in_portal.world):
		return false
	if _portals[in_portal.world] != in_portal:
		return false;
	_portals.erase(in_portal.world)
	return true


static func get_portal(in_portal_id : int) -> Portal:
	if _portals.has(in_portal_id):
		return _portals[in_portal_id]
	return null
