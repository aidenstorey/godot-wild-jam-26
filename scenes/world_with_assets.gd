extends ViewportContainer

var time_elapsed = 0.0
var time_elapsed_2 = 0.0

func _process( delta: float ) -> void:
	self.time_elapsed += delta
	self.time_elapsed_2 += delta * 10.0
	self.material.set_shader_param( 'time_elapsed_2', time_elapsed_2 )
	self.material.set_shader_param( 'time_elapsed', time_elapsed )
	
