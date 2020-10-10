extends Node
class_name light_source

export var color: Color = Color( "#ffefc4" );
export var radius: float = 64.0;
export (float, 0.0, 1.0, 0.05) var strength: float = 1.0


func _ready() -> void:
	self.add_to_group( "light_source", true );
