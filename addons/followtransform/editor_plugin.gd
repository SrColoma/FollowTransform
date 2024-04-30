@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"FollowTransform",
		"Node",
		preload("src/FollowTransform.gd"),
		preload("icons/FollowTransform.svg")
	)


func _exit_tree():
	remove_custom_type("FollowTransform")
