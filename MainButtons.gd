extends HBoxContainer

@onready var upgrade_button = $UpgradeButton
@onready var dimension_button = $DimensionButton
@onready var unlocks_button = $UnlocksButton

@onready var upgrades = %Upgrades
@onready var dimensions = %Dimensions
@onready var unlocks = %Unlocks

var buttons_to_screens: Dictionary
var ids_to_buttons: Dictionary
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
    ids_to_buttons = {
        "upgrade_button": upgrade_button,
        "dimension_button": dimension_button,
        "unlocks_button": unlocks_button
    }

    for screen in buttons_to_screens.values():
        screen.hide()
    for button in buttons_to_screens:
        button.hide()

    update_button_states()

    unlocks.unlock_bought.connect(unlock_bought)

func unlock_bought():
    if unlocks.is_unlocked(Registries.UNLOCK_UPGRADES):
        upgrade_button.show()

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

func save_data(data):
    for id in ids_to_buttons:
        var button = ids_to_buttons[id]
        data[id] = button.visible

func load_data(data):
    for id in ids_to_buttons:
        if id in data:
            var button = ids_to_buttons[id]
            button.visible = data[id]
