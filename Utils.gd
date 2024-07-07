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
