extends Panel

# public variables (these are defined in init_slot())
var ITEM_NAME = null
var ITEM_CATEGORY = null
var IS_ACTIVE = null
var HP_POINTS = null # used only for weapons

@onready var inventory_slot_sprite = $InventorySlotSprite
@onready var indicator_sprite = $IndicatorSprite
@onready var thumbnail_sprite = $ThumbnailSprite
@onready var inventory_health_bar = $InventoryHealthBar

func _set_up_health_bar():
	if ITEM_CATEGORY == "weapon":
		var health_bar_value = (HP_POINTS/WeaponManager.get_props_for_weapon(ITEM_NAME)["hp_points"]) * 100
		inventory_health_bar.value = health_bar_value
		inventory_health_bar.visible = true
	else:
		inventory_health_bar.visible = false

func init_slot(item_name: String, item_category: String, is_active: bool, hp_points: float):
	ITEM_NAME = item_name
	ITEM_CATEGORY = item_category
	IS_ACTIVE = is_active
	HP_POINTS = hp_points

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(ITEM_NAME != null, "Please intialise the slot using init_slot()")
	if ITEM_NAME == "":
		inventory_slot_sprite.animation = "empty"
		thumbnail_sprite.animation = "empty"
	else:
		inventory_slot_sprite.animation = ITEM_CATEGORY
		thumbnail_sprite.animation = ITEM_NAME
	if IS_ACTIVE:
		indicator_sprite.visible = true
	else:
		indicator_sprite.visible = false
	_set_up_health_bar()
