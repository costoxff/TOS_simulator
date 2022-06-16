extends Area2D

signal not_selected(gem)
signal is_selected(gem)
signal gem_contact(gem_hold, gem_contact)

# texture pre-load
var blue_gem = preload("res://myAsset/Texture2D/gems/normalGems/bule.png")
var red_gem = preload("res://myAsset/Texture2D/gems/normalGems/red.png")
var green_gem = preload("res://myAsset/Texture2D/gems/normalGems/green.png")
var dark_gem = preload("res://myAsset/Texture2D/gems/normalGems/dark.png")
var yellow_gem = preload("res://myAsset/Texture2D/gems/normalGems/yellow.png")
var pink_gem = preload("res://myAsset/Texture2D/gems/normalGems/pink.png")
# texture list
var GEM_TYPE_L = [blue_gem, red_gem, green_gem, yellow_gem, dark_gem, pink_gem]

enum{BLUE, RED, GREEN, YELLOW, DARK, PINK}

# attribute
var selected = false
var current_position = null
var type = null
var drag_speed = 45
var last_info = {
	"selected": false,
	"tile_pos": [0, 0],
	"type": 0,
	"pos": Vector2(0, 0)}


func _ready():
	# random texture
	randomize()
	# randi(): Generates a pseudo-random 32-bit unsigned integer between 0 and 4294967295 (inclusive)
	# [ 4294967295 % 6 = 3 ] mean there are 4 redundant number that is  0, 1, 2, 3
	# the range is 0 ~ (4294967295 - 4)
	var type_tmp = GEM_TYPE_L[(randi() - 4) % 6]
	$Sprite.texture = type_tmp
	
	if type_tmp == blue_gem:
		type = BLUE
	elif type_tmp == red_gem:
		type = RED
	elif type_tmp == green_gem:
		type = GREEN
	elif type_tmp == yellow_gem:
		type = YELLOW
	elif type_tmp == dark_gem:
		type = DARK
	else:
		type = PINK
		
	current_position = position

func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), drag_speed * delta)

# signal
func _on_Gem_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			selected = true
			emit_signal("is_selected", self)
		else:
			# FIXME 
			# when mouse input release out of the region of collisionshape
			# gem instance stick on mouse cursor.
			selected = false
			emit_signal("not_selected", self)


func _on_Gem_area_entered(area):
#	print(area, self)
	emit_signal("gem_contact", self, area)
