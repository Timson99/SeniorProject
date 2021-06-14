+++
title = "BattleParty.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [HBoxContainer](../HBoxContainer)

## Description

## Property Descriptions

### battle\_brain

```gdscript
var battle_brain
```

Carry Overs

### persistence\_id

```gdscript
export var persistence_id: String = "main_party"
```

### C2\_in\_party

```gdscript
export var C2_in_party = false
```

### C3\_in\_party

```gdscript
export var C3_in_party = false
```

### items

```gdscript
export var items: Array = []
```

export var items := ["Bomb", "Crappy Spatula", "Leaf Bag", "Milk Carton", "Peach Iced Tea"]

### terminated

```gdscript
var terminated
```

### selected\_material

```gdscript
var selected_material
```

### party

```gdscript
var party
```

### party\_alive

```gdscript
var party_alive
```

### front\_player

```gdscript
var front_player
```

### active\_player

```gdscript
var active_player
```

### selected\_module\_index

```gdscript
var selected_module_index
```

## Method Descriptions

### end\_turn

```gdscript
func end_turn()
```

### check\_alive

```gdscript
func check_alive()
```

### terminate\_input

```gdscript
func terminate_input()
```

### move\_and\_switch

```gdscript
func move_and_switch(move: BattleMove)
```

### switch\_characters

```gdscript
func switch_characters()
```

### cancel\_previous\_character\_move

```gdscript
func cancel_previous_character_move()
```

### sort\_characters

```gdscript
func sort_characters(a, b)
```

### sort\_alive

```gdscript
func sort_alive(a, _b)
```

### on\_load

```gdscript
func on_load()
```

### begin\_turn

```gdscript
func begin_turn()
```

### save

```gdscript
func save()
```

### select\_current

```gdscript
func select_current()
```

### deselect\_current

```gdscript
func deselect_current()
```

### select\_right

```gdscript
func select_right()
```

### select\_left

```gdscript
func select_left()
```

### get\_selected\_character

```gdscript
func get_selected_character()
```

### get\_selected\_character\_name

```gdscript
func get_selected_character_name()
```

## Signals

- signal all_moves_chosen(): 
