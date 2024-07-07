extends PanelContainer

signal switch_dimension

@onready var current_ui = %CurrentUI
@onready var dimensions_container = %DimensionsContainer

const DIMENSION = preload("res://dimension.tscn")

var dimensions = []
var get_by_def = {}

func _ready():
    for dimension in Registries.dimensions:
        var new_dimension = DIMENSION.instantiate()
        new_dimension.def = dimension
        new_dimension.switch_dimension.connect(_switch_dimension.bind(new_dimension))
        dimensions_container.add_child(new_dimension)
        dimensions.append(new_dimension)
        get_by_def[new_dimension.def] = new_dimension

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
