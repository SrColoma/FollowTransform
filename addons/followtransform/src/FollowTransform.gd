@icon("icons/FollowTransform.svg")
@tool
class_name FollowTransform
extends Node

## A node used to establish a [FollowTransform].
##
## FollowTransform is a node that performs the inverse operation 
## of the Remote Transform node in Godot Engine.
## It enables one object to follow the transformations of another object.

## [b]user_node[/b] is the parent of this node.
var user_node : Node

## [b]target_node[/b] is the node that [b]user_node[/b] will follow transformations of.
var target_node : Node

## [b]Target[/b] is the path to which [b]user_node[/b] will follow transformations.
@export_node_path("Node3D","Node2D") var Target:
	set(new_target):
		if new_target == Target:
			return
		Target = new_target
		if is_inside_tree():
			_update_cache()
			_update_transform()
		update_configuration_warnings()

## [b]use_global_coordinates[/b] configures whether to use global or local coordinates.
@export var use_global_coordinates : bool = true:
	set(newval):
		use_global_coordinates = newval
		_update_cache()


@export_group("Follow")

## Configures whether to follow position of [b]target_node[/b].
@export var follow_Position : bool = true:
	set(newVal):
		follow_Position = newVal
		_update_cache()

## Configures whether to follow rotation of [b]target_node[/b].
@export var follow_Rotation : bool = true:
	set(newVal):
		follow_Rotation = newVal
		_update_cache()

## Configures whether to follow scale of [b]target_node[/b].
@export var follow_Scale : bool = true:
	set(newVal):
		follow_Scale = newVal
		_update_cache()


## Updates when the target path changes.
func _update_cache():
	if not Target:
		update_configuration_warnings()
		return
		
	if has_node(Target):
		var node : Node = get_node(Target)
		var u_node : Node = get_parent()
		if not node or node == u_node or node.is_ancestor_of(u_node) or is_ancestor_of(node):
			return
		target_node = node
		user_node = u_node
		

## Updates the transformation of user_node.
func _update_transform():
		
	if not is_inside_tree():
		return
		
	if not target_node:
		return
		
	if not target_node.is_inside_tree():
		return
	
		
	if use_global_coordinates:
		if follow_Position and follow_Rotation and follow_Scale:
			user_node.global_transform = target_node.global_transform
		else:
			if follow_Position:
				user_node.global_position = target_node.global_position
			if follow_Rotation:
				user_node.global_rotation = target_node.global_rotation
			if follow_Scale:
				user_node.scale = target_node.scale
	else:
		if follow_Position and follow_Rotation and follow_Scale:
			user_node.transform = target_node.transform
		else:
			if follow_Position:
				user_node.position = target_node.position
			if follow_Rotation:
				user_node.rotation = target_node.rotation
			if follow_Scale:
				user_node.scale = target_node.scale


## Validates if a target_node exists.
func _validate_transform_changed():
	if not is_inside_tree():
		return
	if target_node:
		_update_transform()


func _get_configuration_warnings():
	var warnings = []
	if not Target:
		warnings.push_back("The \"Target\" property must point to a valid Node3D or Node2D node to work.")
	return warnings


func _process(delta):
	_validate_transform_changed()


func  _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			_update_cache()
			update_configuration_warnings()
