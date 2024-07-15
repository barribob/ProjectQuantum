class_name Utils extends Node

static func format_number(num: float) -> String:
    num = round(num)

    if num < 1000:
        return "%1.0f" % num

    var exponent = 0
    while num >= 10.0:
        num /= 10.0
        exponent += 1
    return ("%1.2f" % num) + "e" + str(exponent)

static func apply_tags_instance(tooltip: String, resource, instance):
    var regex = RegEx.new()
    regex.compile("{[^{}]*}")
    var results = regex.search_all(tooltip)
    for result in results:
        var string_result = result.get_string()
        var json_object: Dictionary = JSON.parse_string(string_result)
        var value_property = json_object["value"]
        var value = Utils.parse_meta(value_property, resource)
        var replace = json_object["replace"]
        var format_percent = false
        if json_object.has("fmt"):
            if json_object["fmt"] == "%":
                value *= 100
                format_percent = true
        if json_object.has("scale_with_level"):
            value *= instance.get_level()

        tooltip = tooltip.replace(string_result, "")
        tooltip = tooltip.replace(replace, str(value) + ("%" if format_percent else ""))
    return tooltip

static func apply_tags(tooltip: String, resource):
    var regex = RegEx.new()
    regex.compile("{[^{}]*}")
    var results = regex.search_all(tooltip)
    for result in results:
        var string_result = result.get_string()
        var json_object: Dictionary = JSON.parse_string(string_result)
        var value_property = json_object["value"]
        var value = Utils.parse_meta(value_property, resource)
        var replace = json_object["replace"]
        var format_percent = false
        if json_object.has("fmt"):
            if json_object["fmt"] == "%":
                value *= 100
                format_percent = true

        tooltip = tooltip.replace(string_result, "")
        tooltip = tooltip.replace(replace, str(value) + ("%" if format_percent else ""))
    return tooltip

static func parse_meta(tag_value, resource: Resource):
    if tag_value.contains("."):
        var tag_values = tag_value.split(".")
        var tag_meta = resource.get_meta(tag_values[0])
        var object_value = tag_meta[tag_values[1]]
        return object_value
    else:
        var tag_meta = resource.get_meta(tag_value, "")
        return tag_meta

static func geq(f1: float, f2: float):
    return f1 > f2 || is_equal_approx(f1, f2)

static func leq(f1: float, f2: float):
    return f1 < f2 || is_equal_approx(f1, f2)

static func generate_circle_positions(count: int, radius: float = 100.0, center: Vector2 = Vector2.ZERO) -> Array[Vector2]:
    var positions: Array[Vector2] = []

    if count <= 0:
        return positions

    for i in range(count):
        var angle = (2 * PI / count) * i
        var x = center.x + radius * cos(angle)
        var y = center.y + radius * sin(angle)
        positions.append(Vector2(x, y))

    return positions
