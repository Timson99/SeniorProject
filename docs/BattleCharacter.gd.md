+++
title = "BattleCharacter.gd"
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
var current_mode
```

## Property Descriptions

### persistence\_id

```gdscript
export var persistence_id: String = "C1"
```

Can't be a number or mistakeable for a non string type

### input\_id

```gdscript
var input_id: String
```

### battle\_brain

```gdscript
var battle_brain
```

### menu

```gdscript
var menu
```

### animated\_sprite

```gdscript
var animated_sprite
```

### animation\_player

```gdscript
var animation_player
```

### name\_label

```gdscript
var name_label
```

### HP\_Bar

```gdscript
var HP_Bar: ProgressBar
```

### SP\_Bar

```gdscript
var SP_Bar: ProgressBar
```

### alive

```gdscript
export var alive: bool = true
```

### defending

```gdscript
var defending
```

### skills

```gdscript
export var skills = {}
```

"Skill" : Num_LP

### equipped\_skill

```gdscript
export var equipped_skill: String = ""
```

### stats

```gdscript
var stats: EntityStats
```

### battle\_stats

```gdscript
var battle_stats: EntityStats
```

### screen\_name

```gdscript
var screen_name
```

### module\_rise

```gdscript
var module_rise: int
```

### party

```gdscript
var party
```

### enemy\_select\_mode

```gdscript
var enemy_select_mode
```

### current\_mode

```gdscript
var current_mode
```

### saved\_command

```gdscript
var saved_command
```

## Method Descriptions

### on\_load

```gdscript
func on_load()
```

### kill\_character

```gdscript
func kill_character()
```

### take\_damage

```gdscript
func take_damage(damage)
```

### heal

```gdscript
func heal(damage)
```

### test\_command1

```gdscript
func test_command1()
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

### release\_up

```gdscript
func release_up()
```

### release\_down

```gdscript
func release_down()
```

### release\_left

```gdscript
func release_left()
```

### release\_right

```gdscript
func release_right()
```

### activate\_player

```gdscript
func activate_player()
```

### deactivate\_player

```gdscript
func deactivate_player()
```

When followed or incapacitated, player is an AI follower

### save

```gdscript
func save()
```

### select

```gdscript
func select()
```

### deselect

```gdscript
func deselect()
```

## Signals

- signal move(move): 
