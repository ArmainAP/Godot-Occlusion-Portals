class_name PortalSingleton extends Node

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
