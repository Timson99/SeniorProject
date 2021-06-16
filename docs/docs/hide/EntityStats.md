+++
title = "EntityStats"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Object](../Object)

## Description

## Enumerations

### stats\_template

```gdscript
const stats_template: Dictionary = {"ATTACK":1,"DEFENSE":1,"HP":1,"LEVEL":1,"LUCK":1,"MAX_HP":1,"MAX_SP":1,"SP":1,"SPEED":1,"WAVE_ATTACK":1,"WAVE_DEFENSE":1,"WILLPOWER":1}
```

## Constants Descriptions

### stat\_keys

```gdscript
const stat_keys: Array = ["LEVEL","HP","MAX_HP","SP","MAX_SP","ATTACK","DEFENSE","WAVE_ATTACK","WAVE_DEFENSE","SPEED","WILLPOWER","LUCK"]
```

## Property Descriptions

### LEVEL

```gdscript
var LEVEL
```

### HP

```gdscript
var HP
```

### MAX\_HP

```gdscript
var MAX_HP
```

### SP

```gdscript
var SP
```

### MAX\_SP

```gdscript
var MAX_SP
```

### ATTACK

```gdscript
var ATTACK
```

### DEFENSE

```gdscript
var DEFENSE
```

### WAVE\_ATTACK

```gdscript
var WAVE_ATTACK
```

### WAVE\_DEFENSE

```gdscript
var WAVE_DEFENSE
```

### SPEED

```gdscript
var SPEED
```

### WILLPOWER

```gdscript
var WILLPOWER
```

### LUCK

```gdscript
var LUCK
```

### status\_effect

```gdscript
var status_effect
```

### stat\_buffs

```gdscript
var stat_buffs
```

### experience\_points

```gdscript
var experience_points
```

### elemental\_data

```gdscript
var elemental_data
```

## Method Descriptions

### \_init

```gdscript
func _init(base_stats: Dictionary, elemental_affinities)
```

### set\_stat

```gdscript
func set_stat(stat_key: String, new_value: int) -> bool
```

Returns true if change, return false is clamped

### to\_dict

```gdscript
func to_dict()
```

