#pragma once

#include "godot_cpp/classes/node.hpp"

class HaruClass : public godot::Node {
    GDCLASS(HaruClass, godot::Node)

public:
    HaruClass() = default;

protected:
    static void _bind_methods() {};
};