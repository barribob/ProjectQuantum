extends Control

@onready var upgrade_nucleus_title = %UpgradeNucleusTitle
@onready var upgrade_nucleus_description = %UpgradeNucleusDescription
@onready var upgrade_slider_description = %UpgradeSliderDescription
@onready var popup_upgrade_button = %PopupUpgradeButton
@onready var popup_upgrade_cancel_button = %PopupUpgradeCancelButton
@onready var exit_upgrade_button = %ExitUpgradeButton
@onready var upgrade_nucleus_visual_position = %UpgradeNucleusVisualPosition
@onready var upgrade_nucleus_level_label = %UpgradeNucleusLevelLabel
@onready var add_neutrons_button = %AddNeutronsButton
@onready var neutrons = %Neutrons

var level: int
var neutrons_added: int
var nucleus: Nucleus

func _ready():
    hide()
    exit_upgrade_button.pressed.connect(close)
    popup_upgrade_button.pressed.connect(upgrade_nucleus)
    popup_upgrade_cancel_button.pressed.connect(close)
    add_neutrons_button.pressed.connect(add_neutrons)

func add_neutrons():
    neutrons_added += 1
    level = nucleus.level + neutrons_added
    update_ui()

func upgrade_nucleus():
    nucleus.level = level
    nucleus.update_ui()
    neutrons.add_neutrons(-neutrons_added)
    close()

func close():
    for child in upgrade_nucleus_visual_position.get_children():
        child.queue_free()
    hide()

func display(selected_nucleus):
    var def = selected_nucleus.def
    var circle_positions = Utils.generate_circle_positions(def.visual_circles, 10)
    for i in def.visual_circles:
        var circle = Nucleus.HOLLOW_CIRCLE.instantiate()
        circle.modulate = def.visual_color
        circle.position = circle_positions[i]
        upgrade_nucleus_visual_position.add_child(circle)
    level = selected_nucleus.level
    upgrade_nucleus_title.text = selected_nucleus.def.name
    nucleus = selected_nucleus
    neutrons_added = 0
    update_ui()
    show()

func update_ui():
    upgrade_nucleus_level_label.text = "Lv. " + Utils.format_number(level)
    upgrade_nucleus_description.text = Utils.apply_tags_level(nucleus.def.description, nucleus.def, level)
    upgrade_slider_description.text = "Upgrade to level %s will use %s" % [level, Utils.format_number(neutrons_added)]
    popup_upgrade_button.disabled = neutrons_added == 0
    if Utils.leq(neutrons.neutrons, neutrons_added):
        add_neutrons_button.disable()
    else:
        add_neutrons_button.disabled = false
