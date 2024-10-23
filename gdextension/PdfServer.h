#pragma once

#include "godot_cpp/classes/node.hpp"

class PdfServer : public godot::Node {
    GDCLASS(PdfServer, godot::Node)

public:
    PdfServer() = default;

protected:
    static void _bind_methods() {};
};