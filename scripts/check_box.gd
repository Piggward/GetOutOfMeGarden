extends Button

@export var unchecked_texture: AtlasTexture
@export var checked_texture: AtlasTexture
@export var initial_value: bool = false

@onready var texture_rect: TextureRect = $Texture

var checked = initial_value # ugh det blir bara värre alltså

func _ready():
	if checked:
		texture_rect.texture = checked_texture
	else:
		texture_rect.texture = unchecked_texture

func _toggle() -> void:
	checked = not checked
	if checked:
		texture_rect.texture = checked_texture
	else:
		texture_rect.texture = unchecked_texture
