extends PanelContainer

signal switch_dimension

@onready var current_ui = %CurrentUI
@onready var dimensions_container = %DimensionsContainer

const DIMENSION = preload("res://dimension.tscn")
const BLANK_DIMENSION = preload("res://blank_dimension.tscn")

var dimensions = []
var get_by_def = {}
var blanks = []

func _ready():
    Console.add_command("dimension", func(d): _switch_dimension(get_by_def[Registries.ids_to_dimensions[d]]), 1)
    for dimension in Registries.dimensions:
        var new_dimension = DIMENSION.instantiate()
        new_dimension.def = dimension
        new_dimension.switch_dimension.connect(_switch_dimension.bind(new_dimension))
        dimensions_container.add_child(new_dimension)
        dimensions.append(new_dimension)
        get_by_def[new_dimension.def] = new_dimension

    var i = dimensions_container.get_child_count()
    for _j in range(i, 10):
        var new_dimension = BLANK_DIMENSION.instantiate()
        dimensions_container.add_child(new_dimension)
        blanks.append(new_dimension)

    dimensions[0].selected = true
    dimensions[0].unlocked = true
    dimensions[0].update_ui()

func get_current_dimension():
    for dimension in dimensions:
        if dimension.selected:
            return dimension.def
    return null

func _switch_dimension(new_dimension):
    for dimension in dimensions:
        dimension.selected = false
        dimension.update_ui()
    new_dimension.selected = true
    new_dimension.update_ui()
    switch_dimension.emit()

func save_data(data):
    data["dimensions"] = {}
    for dimension in dimensions:
        var dimension_data = {}
        dimension.save_data(dimension_data)
        data["dimensions"][dimension.def.id] = dimension_data

func load_data(data):
    for id in data["dimensions"]:
        var def = Registries.ids_to_dimensions[id]
        if get_by_def.has(def):
            get_by_def[def].load_data(data["dimensions"][id])
    switch_dimension.emit()

func display():
    show()
    var tween = create_tween()
    var time = 0.04
    for dimension in dimensions:
        dimension.modulate.a = 0.0
        tween.tween_property(dimension, "modulate:a", 1.0, time)

    for blank in blanks:
        blank.modulate.a = 0.0
        tween.tween_property(blank, "modulate:a", 1.0, 0.01)
