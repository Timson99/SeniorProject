+++
title = "BattleMenu.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [HBoxContainer](../HBoxContainer)

## Description

## Enumerations

### Button

```gdscript
const Button: Dictionary = {"Attack":0,"Defend":3,"Items":2,"Run":4,"Skills":1}
```

## Constants Descriptions

### qscroll\_after\_msec

```gdscript
const qscroll_after_msec: int = 500
```

### quick\_scroll\_sec

```gdscript
const quick_scroll_sec: float = 0.07
```

## Property Descriptions

### icon\_highlight

```gdscript
var icon_highlight
```

### items\_submenu

```gdscript
var items_submenu
```

### skills\_submenu

```gdscript
var skills_submenu
```

### submenu

```gdscript
var submenu
```

### selector

```gdscript
var selector
```

### held\_actions

```gdscript
var held_actions
```

### quick\_scrolling

```gdscript
var quick_scrolling
```

### buttons

```gdscript
var buttons
```

### default\_focused

```gdscript
var default_focused
```

### focused

```gdscript
var focused
```

## Method Descriptions

### instance\_items\_submenu

```gdscript
func instance_items_submenu()
```

### instance\_skills\_submenu

```gdscript
func instance_skills_submenu()
```

### select\_focused

```gdscript
func select_focused()
```

### deselect\_focused

```gdscript
func deselect_focused()
```

### reset

```gdscript
func reset(reset_focused = true)
```

### left

```gdscript
func left()
```

### right

```gdscript
func right()
```

### release\_right

```gdscript
func release_right()
```

### release\_left

```gdscript
func release_left()
```

### release\_up

```gdscript
func release_up()
```

### release\_down

```gdscript
func release_down()
```

### accept

```gdscript
func accept()
```

### back

```gdscript
func back()
```

### up

```gdscript
func up()
```

### down

```gdscript
func down()
```

### quick\_scroll

```gdscript
func quick_scroll(action, start_time)
```

