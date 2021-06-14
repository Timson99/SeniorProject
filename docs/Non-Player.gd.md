+++
title = "Non-Player.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [KinematicBody2D](../KinematicBody2D)

## Description

## Constants Descriptions

### default\_speed

```gdscript
const default_speed: float = 60
```

### pixel\_per\_frame

```gdscript
const pixel_per_frame: int = 1
```

## Property Descriptions

### animations

```gdscript
var animations
```

### party

```gdscript
var party: Array
```

### pathing\_coordinates

```gdscript
export var pathing_coordinates = []
```

### speed

```gdscript
var speed: float
```

### velocity

```gdscript
var velocity
```

### current\_dir

```gdscript
var current_dir
```

### isMoving

```gdscript
var isMoving: bool
```

### dir\_anims

```gdscript
var dir_anims: Dictionary
```

### initial\_mode

```gdscript
var initial_mode
```

### rand\_num\_generator

```gdscript
var rand_num_generator
```

### wander\_timer

```gdscript
var wander_timer: SceneTreeTimer
```

### wait\_timer

```gdscript
var wait_timer: SceneTreeTimer
```

### next\_movement

```gdscript
var next_movement: String = ""
```

### target\_path\_index

```gdscript
var target_path_index
```

## Method Descriptions

### animate\_movement

```gdscript
func animate_movement()
```

### move\_up

```gdscript
func move_up()
```

### move\_down

```gdscript
func move_down()
```

### move\_right

```gdscript
func move_right()
```

### move\_left

```gdscript
func move_left()
```

### pause\_movement

```gdscript
func pause_movement()
```

### freeze\_in\_place

```gdscript
func freeze_in_place()
```

### unfreeze

```gdscript
func unfreeze()
```

### wander

```gdscript
func wander(current_movement: String)
```

### follow\_path

```gdscript
func follow_path(pathing_coordinates: Array)
```

### get\_next\_move

```gdscript
func get_next_move(current_position: Vector2, target_loc: Vector2)
```

