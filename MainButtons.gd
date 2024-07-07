extends HBoxContainer

@onready var upgrade_button = $UpgradeButton
@onready var dimension_button = $DimensionButton
@onready var unlocks_button = $UnlocksButton

@onready var upgrades = %Upgrades
@onready var dimensions = %Dimensions
@onready var unlocks = %Unlocks

var screens: Dictionary
var current_screen = null

func _ready():
    upgrade_button.pressed.connect(func(): toggle_screen("upgrade"))
    dimension_button.pressed.connect(func(): toggle_screen("dimension"))
    unlocks_button.pressed.connect(func(): toggle_screen("unlocks"))

    screens = {
        "upgrade": upgrades,
        "dimension": dimensions,
        "unlocks": unlocks
    }

    for screen in screens.values():
        screen.hide()

    update_button_states()

func toggle_screen(screen_name):
    if current_screen == screen_name:
        screens[screen_name].hide()
        current_screen = null
    else:
        if current_screen != null:
            screens[current_screen].hide()
        screens[screen_name].show()
        current_screen = screen_name

    update_button_states()

func update_button_states():
    update_button_alignment(upgrade_button, current_screen == "upgrade")
    update_button_alignment(dimension_button, current_screen == "dimension")
    update_button_alignment(unlocks_button, current_screen == "unlocks")

    upgrade_button.set_pressed_no_signal(current_screen == "upgrade")
    dimension_button.set_pressed_no_signal(current_screen == "dimension")
    unlocks_button.set_pressed_no_signal(current_screen == "unlocks")

func update_button_alignment(button: Button, is_selected: bool):
    if is_selected:
        button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
    else:
        button.vertical_icon_alignment = VERTICAL_ALIGNMENT_BOTTOM
