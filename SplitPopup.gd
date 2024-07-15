extends Control

@onready var split_nucleus_title = %SplitNucleusTitle
@onready var split_nucleus_description = %SplitNucleusDescription
@onready var split_label = %SplitLabel
@onready var confirm_split_button = %ConfirmSplitButton
@onready var cancel_split_button = %CancelSplitButton
@onready var exit_split_button = %ExitSplitButton
@onready var split_nuclei_container = %SplitNucleiContainer
@onready var neutrons = %Neutrons

const NUCLEUS = preload("res://nucleus.tscn")

var fusion
var nuclei = []
var selected_nuclei = []
var fusion_nuclei_to_split_nuclei = {}

func _ready():
    hide()
    exit_split_button.pressed.connect(close)
    cancel_split_button.pressed.connect(close)
    confirm_split_button.disabled = true
    confirm_split_button.pressed.connect(split_nuclei)

func split_nuclei():
    neutrons.add_neutrons(get_value())
    for nucleus in selected_nuclei:
        var fusion_nucleus = fusion_nuclei_to_split_nuclei[nucleus]
        fusion.remove_nucleus(fusion_nucleus)
        nuclei.erase(nucleus)
        nucleus.queue_free()
    selected_nuclei.clear()
    confirm_split_button.disabled = true
    clear_description()

func close():
    selected_nuclei.clear()
    nuclei.clear()
    hide()

func display():
    for child in split_nuclei_container.get_children():
        child.queue_free()
    var i = 0
    for nucleus in fusion.nuclei:
        var nucleus_data = {}
        nucleus.save_data(nucleus_data)
        var new_nucleus = generate_nucleus(nucleus.def, i)
        new_nucleus.load_data(nucleus_data)
        i+=1
        fusion_nuclei_to_split_nuclei[new_nucleus] = nucleus
    show()
    split_label.text = "Split nuclei for"
    clear_description()

func generate_nucleus(def, i):
    var nucleus = NUCLEUS.instantiate()
    nucleus.def = def
    nucleus.selected.connect(nucleus_selected.bind(nucleus))
    nucleus.fade_time = min(i * 0.02, 1.0)
    split_nuclei_container.add_child(nucleus)
    nuclei.append(nucleus)
    return nucleus

func nucleus_selected(nucleus):
    if nucleus.is_selected():
        nucleus.set_deselected()
        selected_nuclei.erase(nucleus)
        clear_description()
    else:
        nucleus.set_selected()
        update_description(nucleus)

    var num_selected = selected_nuclei.size()
    var recycle_value = get_value()
    split_label.text = "Splitting %s Nuclei for %s" % [num_selected, recycle_value]
    confirm_split_button.disabled = num_selected == 0

func update_description(nucleus):
    split_nucleus_title.text = nucleus.def.name
    split_nucleus_description.text = Utils.apply_tags_instance(nucleus.def.description, nucleus.def, nucleus)
    selected_nuclei.append(nucleus)

func clear_description():
    split_nucleus_title.text = ""
    split_nucleus_description.text = ""

func get_value():
    return selected_nuclei.reduce(func(x, y): return x + y.get_level(), 0.0)
