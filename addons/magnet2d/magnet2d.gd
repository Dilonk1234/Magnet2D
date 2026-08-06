@icon("uid://ddp133fouxljn") # magnet2d.svg
@tool
extends Area2D
class_name Magnet2D

## A Magnet2D will attract RigidBodys to its target.

@export var target : Node2D ## The target a RigidBody will move be pulled towards.
@export var strength := 20.0 ## The strength of the force pulling the RigidBody.
@export var damping_strength := 5.0 ## The strength of the damping.
@export var ignore_x := false ## If set to true, the RigidBodies wont be attracted along the x axis.
@export var ignore_y := false ## If set to true, the RigidBodies wont be attracted along the x axis.

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		update_configuration_warnings()
		return
	
	if not monitoring:
		return
	
	for x: PhysicsBody2D in get_overlapping_bodies():
		if not x is RigidBody2D:
			continue
		
		var direction := target.global_position - x.global_position
		var distance := direction.length()
		var damping : Vector2 = -x.linear_velocity * damping_strength
		var force : Vector2
		
		if distance > 0:
			force = direction * strength
		
		if ignore_x:
			x.apply_force(Vector2(0, force.y) + damping)
		if ignore_y:
			x.apply_force(Vector2(force.x, 0) + damping)
		else:
			x.apply_force(force + damping)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray
	if not target:
		warnings.append("Magnet2D needs a target.")
	return warnings
