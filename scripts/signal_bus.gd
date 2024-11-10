extends Node

## Meta signals
signal scheme_parser_ready(parser: SchemeParser, content: Dictionary)

## Window signals
signal focus_changed(focus_mode: Helpers.MouseFocusMode)
signal palette_ui_changed(palette: Palette)
signal layer_ui_changed()
signal skein_swap_requested(skein: Skein)

## View signals
#signal zoom_level_changed(value: float)
signal canvas_focus_changed(focused: bool)

## Tool signals
signal skein_selected(skein: Skein)
signal skein_added_to_palette(skein: Skein)
signal skein_swapped(old_skein: Skein, new_skein: Skein)
signal skein_removed_from_palette(skein: Skein)
signal symbol_swapped(skein: Skein, old_symbol: Symbol, new_symbol: Symbol)
signal brush_size_changed(size: int)

## Content swapping signals
signal new_canvas_opened(size: Rect2i)
signal save_menu_opened()
signal load_menu_opened()
signal save_requested(filename: String)
signal load_requested(filename: String)

## Snapshot-manipulating signals
signal undo_pressed()
signal redo_pressed()
signal snapshot_created(snapshot: Snapshot)
signal current_snapshot_changed(snapshot: Snapshot)

## Snapshot-generating signals
signal palette_changed(palette: Palette, new_snapshot: bool)
signal canvas_changed(canvas: Canvas, new_snapshot: bool)
signal canvas_resized(canvas: Canvas, new_snapshot: bool)
signal layer_changed(layer: TileMapLayer, new_snapshot: bool)
signal layer_added(layer: TileMapLayer, new_snapshot: bool)
signal layer_removed(layer: TileMapLayer, new_snapshot: bool)

## Snapshot-generating signals
signal thread_layer_added(layer: ThreadLayer, new_snapshot: bool)
signal thread_layer_removed(layer: ThreadLayer, new_snapshot: bool)

## UI driven signals
signal ui_brush_size_changed(size: int)
