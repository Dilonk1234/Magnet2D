@icon("uid://ddp133fouxljn") # magnet2d.svg
extends Area2D
class_name Magnet2D

## A Magnet2D will attract RigidBodys to its target.

@export var target : Node2D ## The target a RigidBody will move be pulled towards.
@export var strength := 20.0 ## The strength of the force pulling the RigidBody.
@export var damping_strength := 5.0 ## The strength of the damping

func _physics_process(delta: float) -> void:
	if not target:
		push_error(get_path(), " Needs a target. Magnet will do nothing.")
		return
	
	for x: PhysicsBody2D in get_overlapping_bodies():
		if not x is RigidBody2D:
			continue
		
		var direction := target.global_position - x.global_position
		var distance := direction.length()
		var damping : Vector2 = -x.linear_velocity * damping_strength
		if distance > 0:
			var force := direction * strength
			x.apply_force(force + damping)
