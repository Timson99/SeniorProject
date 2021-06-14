+++
title = "Party.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Node2D](../Node2D)

## Description

## Property Descriptions

### actor\_id

```gdscript
export var actor_id: String = "Party"
```

### C2\_in\_party

```gdscript
export var C2_in_party = true
```

export var C1_in_party = true

### C3\_in\_party

```gdscript
export var C3_in_party = true
```

### active\_player

```gdscript
var active_player
```

### party

```gdscript
var party: Array
```

### incapacitated

```gdscript
var incapacitated: Array
```

### items

```gdscript
var items: Array
```

var items := ["Bomb","Bomb", "Crappy Spatula", "Leaf Bag", "Milk Carton", "Peach Iced Tea","Leaf Bag"]

### money

```gdscript
var money: int = 0
```

### spacing

```gdscript
var spacing: float
```

### persistence\_id

```gdscript
var persistence_id: String
```

### tween

```gdscript
var tween
```

## Method Descriptions

### sort\_characters

```gdscript
func sort_characters(a, b)
```

### sort\_alive

```gdscript
func sort_alive(a, _b)
```

### init\_in\_party

```gdscript
func init_in_party(condition, character_scene, name)
```

### on\_load

```gdscript
func on_load()
```

Called when the node enters the scene tree for the first time.

### reposition

```gdscript
func reposition(new_position: Vector2, new_direction)
```

### tween\_pos

```gdscript
func tween_pos(destination, duration)
```

### tween\_pos\_relative

```gdscript
func tween_pos_relative(mod, duration)
```

### save

```gdscript
func save()
```

### change\_sequenced\_follow\_formation

```gdscript
func change_sequenced_follow_formation(formation: String)
```

## Signals

- signal tween_pos_completed(): 
