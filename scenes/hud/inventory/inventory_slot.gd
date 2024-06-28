extends Panel

# public variables (these are defined in init_slot())
var ITEM_NAME = null
var ITEM_CATEGORY = null
var IS_ACTIVE = null

@onready var inventory_slot_sprite = $InventorySlotSprite
@onready var indicator_sprite = $IndicatorSprite
@onready var thumbnail_sprite = $ThumbnailSprite

func init_slot(item_name: String, item_category: String, is_active: bool):
	ITEM_NAME = item_name
	ITEM_CATEGORY = item_category
	IS_ACTIVE = is_active

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
