+++
title = "BattleDialogue.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Control](../Control)

## Description

## Enumerations

### Mode

```gdscript
var mode
```

## Property Descriptions

### input\_id

```gdscript
var input_id
```

InputEngine

### text\_node

```gdscript
var text_node
```

### message

```gdscript
var message
```

### scroll\_time

```gdscript
var scroll_time: float
```

Can't be faster than a frame, 1/60

### character\_jump

```gdscript
var character_jump
```

### breath\_pause

```gdscript
var breath_pause
```

### breath\_char

```gdscript
var breath_char
```

### mode

```gdscript
var mode
```

## Method Descriptions

### ui\_accept\_pressed

```gdscript
func ui_accept_pressed()
```

either skips scroll, advances to next line, or selects option

### display\_message

```gdscript
func display_message(message_param, input = false, scroll_time = 0, character_jump = 1000)
```

### clear

```gdscript
func clear()
```

## Signals

- signal begin(): 
- signal page_complete(): 
- signal page_over(): 
- signal end(): 
