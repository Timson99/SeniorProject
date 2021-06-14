+++
title = "InputEngine.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Node](../Node)

## Description

## Constants Descriptions

### group\_name

```gdscript
const group_name: String = "Input_Receiver"
```

## Property Descriptions

### to\_player\_commands

```gdscript
var to_player_commands: Dictionary
```

### to\_menu\_commands

```gdscript
var to_menu_commands: Dictionary
```

### to\_dialogue\_commands

```gdscript
var to_dialogue_commands: Dictionary
```

### to\_battle\_commands

```gdscript
var to_battle_commands: Dictionary
```

### valid\_receivers

```gdscript
var valid_receivers: Dictionary
```

### pressed\_held\_commands

```gdscript
var pressed_held_commands
```

### input\_disabled

```gdscript
var input_disabled: bool
```

### input\_target

```gdscript
var input_target
```

### prev\_input\_target

```gdscript
var prev_input_target
```

### curr\_input\_receivers

```gdscript
var curr_input_receivers
```

### disabled

```gdscript
var disabled
```

### current\_controls

```gdscript
var current_controls
```

### control\_mapping

```gdscript
var control_mapping
```

## Method Descriptions

### update\_and\_sort\_receivers

```gdscript
func update_and_sort_receivers()
```

### activate\_receiver

```gdscript
func activate_receiver(node)
```

### deactivate\_receiver

```gdscript
func deactivate_receiver(node)
```

### disable\_input

```gdscript
func disable_input()
```

### enable\_input

```gdscript
func enable_input()
```

### disable\_player\_input

```gdscript
func disable_player_input()
```

### enable\_all

```gdscript
func enable_all()
```

### sort\_input\_receivers

```gdscript
func sort_input_receivers(a, b)
```

### process\_input

```gdscript
func process_input(loop)
```

### translate\_and\_execute

```gdscript
func translate_and_execute(input_translator)
```

### get\_input\_event\_type

```gdscript
func get_input_event_type()
```

### define\_control\_inputs

```gdscript
func define_control_inputs(input_type)
```

### get\_current\_controls

```gdscript
func get_current_controls()
```

### get\_control\_mapping

```gdscript
func get_control_mapping()
```

### save

```gdscript
func save()
```

Placeholder for now...remapped control schemes should be persistent

## Signals

- signal control_scheme_gathered(): 
