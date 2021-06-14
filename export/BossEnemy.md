+++
title = "BossEnemy"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [KinematicBody2D](../KinematicBody2D)

## Description

## Property Descriptions

### is\_boss

```gdscript
export var is_boss: bool = true
```

### default\_speed

```gdscript
export var default_speed: int = 60
```

### alive

```gdscript
export var alive: bool = true
```

### persistence\_id

```gdscript
export var persistence_id = ""
```

### actor\_id

```gdscript
export var actor_id = ""
```

### speed

```gdscript
var speed
```

### exploring

```gdscript
var exploring
```

### skins

```gdscript
var skins
```

### animations

```gdscript
var animations
```

### data

```gdscript
var data
```

### battle\_id

```gdscript
var battle_id
```

### dir\_anims

```gdscript
var dir_anims: Dictionary
```

### current\_dir

```gdscript
var current_dir
```

### isMoving

```gdscript
var isMoving: bool
```

### velocity

```gdscript
var velocity
```

## Method Descriptions

### post\_battle

```gdscript
func post_battle()
```

### set\_speed

```gdscript
func set_speed(new_speed: float)
```

### on\_load

```gdscript
func on_load()
```

### explore

```gdscript
func explore(delta: float)
```

### move\_to\_position

```gdscript
func move_to_position(new_position: Vector2, global = true)
```

### flip\_horizontal

```gdscript
func flip_horizontal(flip: bool)
```

### initiate\_battle

```gdscript
func initiate_battle()
```

### change\_anim

```gdscript
func change_anim(anim_string)
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

### save

```gdscript
func save()
```

Persistent data to be saved