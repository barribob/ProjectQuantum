@tool
extends EditorPlugin

#var quick_open

func _enter_tree() -> void:
    scene_changed.connect(_scene_changed)
    #for child in EditorInterface.get_base_control().get_children():
        #if child is Window and child.title.contains("Quick Open"):
            #child.confirmed.connect(confirmed)
            #quick_open = child
#
#func confirmed():
    #print("hello?")
    #for child in quick_open.get_children():
        #for child2 in child.get_children():
            #if child2 is MarginContainer:
                #for child3 in child2.get_children():
                    #if child3 is Tree:
                        #var item = child3.get_selected()
                        #var path = "res://" + item.get_text(0)
                        #var scene_extensions = ResourceLoader.get_recognized_extensions_for_type("PackedScene")
                        #print(path)
                        #if path.get_extension() in scene_extensions:
                            #if EditorInterface.get_edited_scene_root() is Node3D:
                                #EditorInterface.set_main_screen_editor("3D")
                            #else:
                                #EditorInterface.set_main_screen_editor("2D")

func _scene_changed(node):
    if node is Node3D:
        EditorInterface.set_main_screen_editor("3D")
    else:
        EditorInterface.set_main_screen_editor("2D")
    EditorInterface.edit_node(node)
