extends Node

## Meta signals
signal scheme_parser_ready(parser: SchemeParser, content: Dictionary)

## Window signals
signal palette_ui_changed(palette: Palette)
signal layer_ui_changed()
signal thread_swap_requested(thread: XStitchThread)

## View signals
signal canvas_focus_changed(focused: bool)
signal toast_notification(message: String)

## Tool signals
signal thread_selected(thread: XStitchThread)
signal thread_added_to_palette(thread: XStitchThread)
signal thread_swapped(old_thread: XStitchThread, new_thread: XStitchThread)
signal thread_removed_from_palette(thread: XStitchThread)
signal symbol_swapped(thread: XStitchThread, old_symbol: Symbol, new_symbol: Symbol)
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
