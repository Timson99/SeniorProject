+++
title = "ControlLayout.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [CanvasLayer](../CanvasLayer)

## Description

## Property Descriptions

### is\_intro\_screen

```gdscript
export var is_intro_screen: bool = true
```

### dialogue\_node

```gdscript
var dialogue_node
```

### remapping\_text

```gdscript
var remapping_text
```

### input\_type

```gdscript
var input_type
```

### submenu

```gdscript
var submenu
```

### parent

```gdscript
var parent
```

### intro\_layer

```gdscript
var intro_layer
```

### menu\_layer

```gdscript
var menu_layer
```

### uic

```gdscript
var uic
```

### remapping

```gdscript
var remapping
```

### correct\_input

```gdscript
var correct_input
```

### confirm\_cancel

```gdscript
var confirm_cancel
```

## Method Descriptions

### change\_control\_layout

```gdscript
func change_control_layout()
```

### adjust\_margins

```gdscript
func adjust_margins(parent: Node)
```

### get\_readable\_input

```gdscript
func get_readable_input(event)
```

### join\_input\_strings

```gdscript
func join_input_strings(inputs: Array)
```

### remap\_button

```gdscript
func remap_button(ui_control: String)
```

### remap

```gdscript
func remap(event: InputEvent)
```

### up

```gdscript
func up()
```

### down

```gdscript
func down()
```

### left

```gdscript
func left()
```

### right

```gdscript
func right()
```

### accept

```gdscript
func accept()
```

### back

```gdscript
func back()
```

### open\_menu

```gdscript
func open_menu()
```

## Signals

- signal remapping_complete(): 
