extends HBoxContainer

@onready var upgrade_button = $UpgradeButton
@onready var dimension_button = $DimensionButton
@onready var unlocks_button = $UnlocksButton

@onready var upgrades = %Upgrades
@onready var dimensions = %Dimensions
@onready var unlocks = %Unlocks

var buttons_to_screens: Dictionary
var current_button = null

func _ready():
    Console.add_command("ushow", unlocks_button.show)
    upgrade_button.pressed.connect(func(): toggle_screen(upgrade_button))
    dimension_button.pressed.connect(func(): toggle_screen(dimension_button))
    unlocks_button.pressed.connect(func(): toggle_screen(unlocks_button))

    buttons_to_screens = {
        upgrade_button: upgrades,
        dimension_button: dimensions,
        unlocks_button: unlocks
    }

    for screen in buttons_to_screens.values():
        screen.hide()
    for button in buttons_to_screens:
        button.hide()

    update_button_states()

func toggle_screen(button):
    if current_button == button:
        buttons_to_screens[button].hide()
        current_button = null
    else:
        if current_button != null:
            buttons_to_screens[current_button].hide()
        buttons_to_screens[button].show()
        current_button = button

    update_button_states()

func update_button_states():
    for button in buttons_to_screens:
        update_button_alignment(button)

func update_button_alignment(button: Button):
    var is_selected = current_button == button
    if is_selected:
        button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
    else:
        button.vertical_icon_alignment = VERTICAL_ALIGNMENT_BOTTOM
