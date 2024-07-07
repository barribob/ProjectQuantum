extends Node

const temp_save_file = "user://temp.tres"

var file_load_callback = JavaScriptBridge.create_callback(load_import_file)
@export var game_scene: PackedScene
@onready var file_dialog = %FileDialog
@onready var options_panel = %Options
var game

func _ready():
    Console.add_command("save", func(path): save_data("user://" + path + ".res"), 1)
    Console.add_command("load", func(path): load_data("user://" + path + ".res"), 1)
    Console.add_command("new_game", new_game)
    Console.add_command("new_save", func():
        if FileAccess.file_exists("user://game.res"):
            DirAccess.remove_absolute("user://game.res")
        try_load())
    Console.add_command("time", func(time): Engine.time_scale = float(time), 1)
    #EventBus.import_game.connect(import_save)
    #EventBus.export_game.connect(export_file)
    #EventBus.reset_game.connect(new_game)
    if OS.get_name() == "Web":
        var window = JavaScriptBridge.get_interface("window")
        window.getFile(file_load_callback)
    else:
        file_dialog.file_selected.connect(load_data)
    var timer = Timer.new()
    timer.autostart = true
    timer.wait_time = 30
    timer.timeout.connect(save_game)
    add_child(timer)
    try_load()

func try_load():
    if not load_data("user://game.res"):
        new_game()

func new_game():
    if game:
        game.queue_free()
    game = game_scene.instantiate()
    add_child(game)
    game.start_run()

func save_game():
    save_data("user://game.res")

func save_data(file_name):
    var game_data = create_save_file()
    var error = ResourceSaver.save(game_data, file_name)
    if error == OK:
        print("saved to " + file_name)
    else:
        print("Error saving graph_data: " + str(error))

func create_save_file():
    var game_data = GameData.new()
    var data = game_data.data
    data["game"] = {}
    game.save_data(data["game"])
    data["options"] = {}
    options_panel.save_data(data["options"])
    game_data.version = ProjectSettings.get_setting("application/config/version")
    return game_data

func load_data(file_name) -> bool:
    if ResourceLoader.exists(file_name):
        var game_data = ResourceLoader.load(file_name)
        if game_data is GameData:
            #DataFixer.fix_data(game_data)
            if game:
                game.queue_free()
            game = game_scene.instantiate()
            add_child(game)
            var data = game_data.data
            if data.has("options"):
                options_panel.load_data(data["options"])
            load_game(data["game"])
            return true
    return false

func load_game(game_data):
    await get_tree().process_frame
    game.load_game(game_data)

func load_import_file(args):
    var array = args[0].to_utf8_buffer()
    if FileAccess.file_exists(temp_save_file):
        DirAccess.remove_absolute(temp_save_file)
    var file = FileAccess.open(temp_save_file, FileAccess.WRITE)
    file.store_buffer(array)
    file.close()
    load_data(temp_save_file)

func export_file():
    var file = create_save_file()
    ResourceSaver.save(file, temp_save_file)
    var bytes = FileAccess.get_file_as_bytes(temp_save_file)
    JavaScriptBridge.download_buffer(bytes, "%s Save.tres" % ProjectSettings.get_setting("application/config/name"))

func import_save():
    if OS.get_name() == "Web":
        var window = JavaScriptBridge.get_interface("window")
        window.input.click()
    else:
        file_dialog.popup()

func _unhandled_input(_event):
    if not OS.get_name() == "Web":
        if Input.is_action_just_pressed("fullscreen"):
            if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
                DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
            else:
                DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
        elif Input.is_action_just_pressed("escape"):
            if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
                DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
