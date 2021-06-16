+++
title = "CharacterChoice.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [CanvasLayer](../CanvasLayer)

## Description

## Constants Descriptions

### condition\_stats

```gdscript
const condition_stats: Array = ["HP","MAX_HP","SP","MAX_SP"]
```

The following information should be stored in game state

### gen\_stats

```gdscript
const gen_stats: Array = ["ATTACK","DEFENSE","LUCK","WILLPOWER","SPEED","WAVE_ATTACK","WAVE_DEFENSE"]
```

## Property Descriptions

### submenu

```gdscript
var submenu
```

### parent

```gdscript
var parent
```

### button\_path

```gdscript
var button_path
```

### forward

```gdscript
var forward
```

### sprites

```gdscript
var sprites
```

### button\_container

```gdscript
var button_container
```

### stats

```gdscript
var stats
```

### party\_group

```gdscript
var party_group: Array
```

the character ids here are persistence ids

### curr\_party

```gdscript
var curr_party
```

### curr\_party\_names

```gdscript
var curr_party_names: Array
```

### curr\_party\_stats

```gdscript
var curr_party_stats: Array
```

### buttons

```gdscript
var buttons
```

### focused

```gdscript
var focused
```

## Method Descriptions

### refocus

```gdscript
func refocus(to)
```

### unfocus

```gdscript
func unfocus()
```

### back

```gdscript
func back()
```

### accept

```gdscript
func accept()
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

### r\_trig

```gdscript
func r_trig()
```

### l\_trig

```gdscript
func l_trig()
```

