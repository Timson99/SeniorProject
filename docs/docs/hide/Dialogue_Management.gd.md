+++
title = "Dialogue_Management.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [CanvasLayer](../CanvasLayer)

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

### current\_area

```gdscript
var current_area
```

### dialogue\_areas

```gdscript
var dialogue_areas
```

MAKE INTO DIRECTORY FILE

### dialogue\_files

```gdscript
var dialogue_files
```

### mode

```gdscript
var mode
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

### dialogueDictionary

```gdscript
var dialogueDictionary
```

Member variables

### speakerDictionary

```gdscript
var speakerDictionary
```

where arr[0] is main, others are reactive

### displayedID

```gdscript
var displayedID
```

export var ResFile = "Test_Project_Dialogue"

### currentspID

```gdscript
var currentspID
```

### finalWaltz

```gdscript
var finalWaltz
```

### reactiveID

```gdscript
var reactiveID
```

### inOptions

```gdscript
var inOptions
```

Variables for dialogue options

### inOptionTree

```gdscript
var inOptionTree
```

### selectedOption

```gdscript
var selectedOption
```

### totalOptions

```gdscript
var totalOptions
```

### parentBranchNodes

```gdscript
var parentBranchNodes
```

### scrollAudio

```gdscript
var scrollAudio
```

Nodes for ease of access

### optionAudio

```gdscript
var optionAudio
```

### dialogue\_box

```gdscript
var dialogue_box
```

### options\_box

```gdscript
var options_box
```

### textNode

```gdscript
var textNode
```

### textTimer

```gdscript
var textTimer
```

## Method Descriptions

### parse\_res\_file

```gdscript
func parse_res_file()
```

### ui\_accept\_pressed

```gdscript
func ui_accept_pressed()
```

either skips scroll, advances to next line, or selects option

### ui\_down\_pressed

```gdscript
func ui_down_pressed()
```

move up and down in an option

### ui\_up\_pressed

```gdscript
func ui_up_pressed()
```

move up and down in an option

### clear\_options

```gdscript
func clear_options()
```

### item\_message

```gdscript
func item_message(itemId)
```

### custom\_message

```gdscript
func custom_message(message)
```

### transmit\_message

```gdscript
func transmit_message(message_param)
```

### exec\_final\_waltz

```gdscript
func exec_final_waltz()
```

## Signals

- signal begin(): 
- signal page_over(): 
- signal end(): 
