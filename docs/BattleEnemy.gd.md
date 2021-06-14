+++
title = "BattleEnemy.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Control](../Control)

## Description

## Property Descriptions

### alive

```gdscript
var alive: bool
```

### selected

```gdscript
var selected
```

### ai

```gdscript
var ai
```

Populated by Party

### stats

```gdscript
var stats
```

### selected\_material

```gdscript
var selected_material: ShaderMaterial
```

### party

```gdscript
var party
```

### tween

```gdscript
var tween: Tween
```

### screen\_name

```gdscript
var screen_name
```

### animation\_player

```gdscript
var animation_player
```

### defending

```gdscript
var defending
```

### moveset

```gdscript
var moveset
```

## Method Descriptions

### on\_load

```gdscript
func on_load()
```

### terminate\_enemy

```gdscript
func terminate_enemy()
```

Called upon enemy's defeat

### make\_move

```gdscript
func make_move() -> BattleMove
```

### take\_damage

```gdscript
func take_damage(damage)
```

### heal

```gdscript
func heal(damage)
```

### select

```gdscript
func select()
```

### deselect

```gdscript
func deselect()
```

