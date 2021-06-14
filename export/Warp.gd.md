+++
title = "Warp.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Area2D](../Area2D)

## Description

## Constants Descriptions

### player\_relative\_box

```gdscript
const player_relative_box: Dictionary = {"0":"(0, 0)","1":"(0, 8)","2":"(-8, 4)","3":"(8, 4)"}
```

### square\_size

```gdscript
const square_size: Vector2 = "(16, 16)"
```

Size of iternal warp scene collision square being scaled

## Property Descriptions

### warp\_id

```gdscript
export var warp_id = "None"
```

### warp\_destination\_id

```gdscript
export var warp_destination_id = "None"
```

### warp\_scene\_id

```gdscript
export var warp_scene_id = ""
```

### exit\_direction

```gdscript
export var exit_direction = 0
```

### one\_way

```gdscript
export var one_way = false
```

### entrance\_point

```gdscript
var entrance_point: Vector2
```

Vector directions to align center of right, left, up, or
down edges of the player collision box with the player's
register point

## Method Descriptions

### calculate\_exit

```gdscript
func calculate_exit()
```

## Signals

- signal play_sound_effect(): 
