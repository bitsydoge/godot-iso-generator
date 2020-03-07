extends Control

# Texture
onready var top_text = $UI/Top/Preview.texture
onready var left_text = $UI/Left/Preview.texture
onready var right_text = $UI/Right/Preview.texture
var black_text

# 
onready var size = $UI/TopOptions/Size
onready var height = $UI/TopOptions/Height
onready var uv_adapt = $UI/TopOptions/UV_Adapt
onready var top_color = $UI/Top/Color
onready var left_color = $UI/Left/Color
onready var right_color = $UI/Right/Color
onready var antialiasing = $UI/Antialiasing

# Window
onready var load_window = $FileDialog
onready var save_window = $SaveDialog

# Result
onready var viewport = $Viewport
onready var iso = $Viewport/IsoGenerator
onready var result = $Result

var current_load : int

func _ready():
	var test_args = [
		"C:\\tempo\\1.jpg", # text top
		"C:\\tempo\\forest_face.png", # text left
		"C:\\tempo\\grass_face.png", # text right
		"#ffffff", # color top
		"#ffffff", # color left
		"#ffffff", # color right
		"32", # size
		"0.5", # height
		"1", # uv_adapt
		"1", # antialiasing
		"C:\\tempo\\new_test_1.png" # save test
		]
	
	if OS.get_cmdline_args().size() == 11:
		call_deferred("args_gen_10", OS.get_cmdline_args())
	else:	
		_generate()

func args_gen_10(args):
	var image = Image.new()
	image.load(args[0])
	iso.top_texture = ImageTexture.new()
	iso.top_texture.create_from_image(image)
	image = Image.new()
	image.load(args[1])
	iso.left_texture = ImageTexture.new()
	iso.left_texture.create_from_image(image)
	image = Image.new()
	image.load(args[2])
	iso.right_texture = ImageTexture.new()
	iso.right_texture.create_from_image(image)
	
	######
	
	size.value = float(args[6])
	height.value = float(args[7])
	uv_adapt.selected = int(args[8])
	top_color.color = Color(args[3])
	left_color.color = Color(args[4])
	right_color.color = Color(args[5])
	antialiasing.pressed = bool(int(args[9]))
	
	_generate()
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	viewport.get_texture().get_data().save_png(args[10])
	
	get_tree().quit()
	
func _on_Load_Top_pressed():
	load_window.popup()
	current_load = 0

func _on_Load_Left_pressed():
	load_window.popup()
	current_load = 1

func _on_Load_Right_pressed():
	load_window.popup()
	current_load = 2

func _on_FileDialog_file_selected(path):
	var image = Image.new()
	image.load(path)
	match(current_load):
		0:
			iso.top_texture = top_text
			top_text.create_from_image(image)
		1:
			iso.left_texture = left_text
			left_text.create_from_image(image)
		2:
			iso.right_texture = right_text
			right_text.create_from_image(image)
	_generate()
	
func _generate():
	# Iso Update
	iso.top_color = top_color.color
	iso.left_color = left_color.color
	iso.right_color = right_color.color
	iso.height = height.value
	iso.antialiasing = antialiasing.pressed
	iso.rect_size.x = size.value*2
	iso.rect_size.y = size.value*2 #sqrt(pow(size.value,2)+pow(size.value*2,2))/2.0
	
	match(uv_adapt.get_selected_id()):
		0:
			iso.adapt_uv = IsoGenerator.UvAdaptMode.NONE
		1:
			iso.adapt_uv = IsoGenerator.UvAdaptMode.TOP
		2:
			iso.adapt_uv = IsoGenerator.UvAdaptMode.BOTTOM
	
	# Viewport Update
	viewport.size.x = size.value*2
	viewport.size.y = size.value*2#sqrt(pow(size.value,2)+pow(size.value*2,2))/2.0
	
	yield(get_tree(), "idle_frame")
	
	result.update()

func _on_Color_changed(color):
	_generate()

func _on_SaveDialog_file_selected(path):
	viewport.get_texture().get_data().save_png(path)

func _on_SaveButton_pressed():
	save_window.popup()

#Updated per type
func _on_Value_Change(color):
	_generate()
