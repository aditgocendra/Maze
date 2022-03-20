extends MeshInstance





func _on_Area_body_shape_entered(body_id, body, body_shape, area_shape):
	print(body.name)


