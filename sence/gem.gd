extends Area2D

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
var selected = false
var current_position = null
var type = null
var gem_drag_speed = 45


func send_argument(kwarg: Dictionary):
	var gem_type = kwarg["gem_type"]

	
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
		global_position = lerp(global_position, get_global_mouse_position(), gem_drag_speed * delta)

func position_exchange():
	pass

# signal
func _on_Gem_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			selected = true
		else:
			# FIXME 
			# when mouse input release out of the region of collisionshape
			# gem instance stick on mouse cursor.
			selected = false
