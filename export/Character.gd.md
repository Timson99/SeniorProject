+++
title = "Character.gd"
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

### speed

```gdscript
var speed: float
```

- **Setter**: `set_speed`

### screen\_name

```gdscript
export var screen_name: String = "placeholder"
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

### exploring

```gdscript
var exploring: bool
```

### skills

```gdscript
var skills
```

"Skill" : Num_LP

### equipped\_skill

```gdscript
export var equipped_skill = ""
```

### equipped\_wpn

```gdscript
var equipped_wpn
```

### equipeed\_arm

```gdscript
var equipeed_arm
```

### stats

```gdscript
var stats: EntityStats
```

### skins

```gdscript
var skins
```

### current\_skin

```gdscript
var current_skin
```

### animations

```gdscript
var animations
```

### interact\_areas

```gdscript
var interact_areas: Array
```

Array oof objects that are currently interactable

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

### on\_load

```gdscript
func on_load()
```

### play\_anim

```gdscript
func play_anim(anim_str)
```

### set\_anim

```gdscript
func set_anim(anim_str)
```

### flip\_horizontal

```gdscript
func flip_horizontal(flip: bool)
```

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

### set\_collision

```gdscript
func set_collision(is_enabled: bool)
```

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

### open\_menu

```gdscript
func open_menu()
```

### test\_command1

```gdscript
func test_command1()
```

##################################################

### test\_command2

```gdscript
func test_command2()
```

### test\_command3

```gdscript
func test_command3()
```

### save\_game

```gdscript
func save_game()
```

### change\_scene

```gdscript
func change_scene()
```

###################################################

### interact

```gdscript
func interact()
```

Interactions with Interactables (Box Openings, Dialogue Starters)
Should add functionality to change direction toward thing being interacted with

### change\_follow

```gdscript
func change_follow(formation: String)
```

### set\_speed

```gdscript
func set_speed(new_speed: float)
```

### restore\_speed

```gdscript
func restore_speed()
```

### scale\_anim\_speed

```gdscript
func scale_anim_speed(scale: float)
```

### restore\_anim\_speed

```gdscript
func restore_anim_speed()
```

### change\_skin

```gdscript
func change_skin(skin_id)
```

### move\_to\_position

```gdscript
func move_to_position(new_position: Vector2, global = true)
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

## Signals

- signal command_completed(): 
