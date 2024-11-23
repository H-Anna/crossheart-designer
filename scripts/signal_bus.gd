extends Node

## Meta signals
signal scheme_parser_ready(parser: SchemeParser, content: Dictionary)

## Window signals
signal palette_ui_changed(palette: Palette)
signal layer_ui_changed()
signal skein_swap_requested(skein: Skein)

## View signals
signal canvas_focus_changed(focused: bool)
signal toast_notification(message: String)

## Tool signals
signal skein_selected(skein: Skein)
signal skein_added_to_palette(skein: Skein)
signal skein_swapped(old_skein: Skein, new_skein: Skein)
signal skein_removed_from_palette(skein: Skein)
signal symbol_swapped(skein: Skein, old_symbol: Symbol, new_symbol: Symbol)
signal brush_size_changed(size: int)

## Content swapping signals
signal new_canvas_opened(size: Rect2i)
signal save_requested(filename: String)
signal load_requested(filename: String)


## Layer signals
signal layer_selected(layer: XStitchMasterLayer)
signal layer_added(layer: XStitchMasterLayer)
signal layer_changed(layer: TileMapLayer, new_snapshot: bool)
signal layer_removed(layer: TileMapLayer, new_snapshot: bool)

## Command signals
signal command_created(command: Command)
