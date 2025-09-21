extends Node

## Meta signals
signal scheme_parser_ready(parser: SchemeParser, content: Dictionary)

## Window signals
signal thread_swap_in_progress(thread: XStitchThread)
signal thread_swap_requested(thread: XStitchThread)

## UI signals
signal canvas_focus_changed(focused: bool)
signal toast_notification(message: String)
signal thread_button_clicked(thread: XStitchThread, button: ThreadButton, container: ThreadButtonContainer)

## Tool signals
signal brush_size_changed(size: int)

## Content swapping signals
signal save_requested(filename: String)
signal load_requested(filename: String)


## Layer signals
signal layer_selected(layer: XStitchMasterLayer)

## Command signals
signal command_created(command: Command)
