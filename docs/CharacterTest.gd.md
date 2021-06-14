+++
title = "CharacterTest.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [KinematicBody2D](../KinematicBody2D)

## Description

## Property Descriptions

### speed

```gdscript
export var speed: int = 60
```

### persistence\_id

```gdscript
export var persistence_id: String = "C1"
```

Can't be a number or mistakeable for a non string type

### input\_id

```gdscript
export var input_id: String = "Player"
```

Don't overwrite in UI

### actor\_id

```gdscript
export var actor_id: String = "PChar"
```

### alive

```gdscript
export var alive: bool = true
```

### party\_data

```gdscript
var party_data: Dictionary
```

Party Vars, set by party

### velocity

```gdscript
var velocity: Vector2
```

Movement Vars

### isMoving

```gdscript
var isMoving: bool
```

### current\_dir

```gdscript
var current_dir
```

### dir\_anims

```gdscript
var dir_anims: Dictionary
```

### destination

```gdscript
var destination
```

Test Vars

## Method Descriptions

### explore

```gdscript
func explore(delta: float)
```

### activate\_player

```gdscript
func activate_player()
```

When leader, player input is activate,

### deactivate\_player

```gdscript
func deactivate_player()
```

When followed or incapacitated, player is an AI follower

### move\_up

```gdscript
func move_up()
```

Input Receiver Methods

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

### down\_just\_released

```gdscript
func down_just_released()
```

### up\_just\_pressed

```gdscript
func up_just_pressed()
```

### test\_command

```gdscript
func test_command()
```

### save\_game

```gdscript
func save_game()
```

### change\_scene

```gdscript
func change_scene()
```

### change\_sequenced\_follow\_formation

```gdscript
func change_sequenced_follow_formation(formation: String)
```

### move\_to\_position

```gdscript
func move_to_position(new_position: Vector2)
```

### save

```gdscript
func save()
```

Persistent Object Method

### follow

```gdscript
func follow(delta: float)
```

