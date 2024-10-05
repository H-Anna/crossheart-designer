extends Node

## Meta signals
signal scheme_parser_ready(parser: SchemeParser, content: Dictionary)

## Window signals
signal focus_changed(focus_mode: Helpers.MouseFocusMode)

## View signals
#signal zoom_level_changed(value: float)

## Tool signals
signal skein_selected(skein: Skein)
signal skein_added_to_palette(skein: Skein)
signal skein_swapped(old_skein: Skein, new_skein: Skein)
signal skein_removed_from_palette(skein: Skein)
signal palette_ui_changed(palette: Palette)

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
