extends Node

@onready var waveforms = %Waveforms
@onready var energy = %Energy
@onready var main_buttons = %MainButtons
@onready var unlocks = %Unlocks
@onready var dimensions = %Dimensions
@onready var entanglements = %Entanglements
@onready var world = %World
@onready var ions = %Ions

func start_run():
    pass

func save_data(data):
    var sd = func(key, obj):
        data[key] = {}
        obj.save_data(data[key])

    sd.call("waveforms", waveforms)
    sd.call("energy", energy)
    sd.call("main_buttons", main_buttons)
    sd.call("unlocks", unlocks)
    sd.call("dimensions", dimensions)
    sd.call("entanglements", entanglements)
    sd.call("world", world)
    sd.call("ions", ions)

func load_game(data):
    var ld = func(key, obj):
        if key in data:
            obj.load_data(data[key])

    ld.call("waveforms", waveforms)
    ld.call("energy", energy)
    ld.call("main_buttons", main_buttons)
    ld.call("unlocks", unlocks)
    ld.call("dimensions", dimensions)
    ld.call("entanglements", entanglements)
    ld.call("world", world)
    ld.call("ions", ions)
