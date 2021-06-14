+++
title = "LevelUpSystem"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Object](../Object)

## Description

## Constants Descriptions

### c1\_stat\_growth

```gdscript
const c1_stat_growth: Dictionary = {"ATTACK":0.9,"DEFENSE":0.6,"HP":1.2,"LEVEL":1,"LUCK":0.45,"MAX_HP":1.2,"MAX_SP":1.4,"SP":1.4,"SPEED":0.5,"WAVE_ATTACK":0.95,"WAVE_DEFENSE":0.68,"WILLPOWER":0.65}
```

### c2\_stat\_growth

```gdscript
const c2_stat_growth: Dictionary = {"ATTACK":0.6,"DEFENSE":0.3,"HP":1.05,"LEVEL":1,"LUCK":0.8,"MAX_HP":1.05,"MAX_SP":1.45,"SP":1.45,"SPEED":0.65,"WAVE_ATTACK":0.65,"WAVE_DEFENSE":0.5,"WILLPOWER":0.65}
```

### c3\_stat\_growth

```gdscript
const c3_stat_growth: Dictionary = {"ATTACK":0.7,"DEFENSE":0.9,"HP":1.25,"LEVEL":1,"LUCK":0.5,"MAX_HP":1.25,"MAX_SP":1.05,"SP":1.05,"SPEED":0.2,"WAVE_ATTACK":0.75,"WAVE_DEFENSE":0.95,"WILLPOWER":0.5}
```

## Property Descriptions

### stat\_rng

```gdscript
var stat_rng
```

### c1\_stats

```gdscript
var c1_stats
```

### c2\_stats

```gdscript
var c2_stats
```

### c3\_stats

```gdscript
var c3_stats
```

### c1\_xp

```gdscript
var c1_xp: int
```

### c2\_xp

```gdscript
var c2_xp: int
```

### c3\_xp

```gdscript
var c3_xp: int
```

### c1\_to\_next\_level

```gdscript
var c1_to_next_level: int
```

### c2\_to\_next\_level

```gdscript
var c2_to_next_level: int
```

### c3\_to\_next\_level

```gdscript
var c3_to_next_level: int
```

### xp

```gdscript
var xp: Dictionary
```

### to\_next\_level

```gdscript
var to_next_level: Dictionary
```

### stat\_growths

```gdscript
var stat_growths: Dictionary
```

### stats

```gdscript
var stats: Dictionary
```

## Method Descriptions

### give\_xp

```gdscript
func give_xp(id: String, earned_xp: int)
```

### level\_up

```gdscript
func level_up(id: String) -> EntityStats
```

### crossed\_lv\_xp\_threshold

```gdscript
func crossed_lv_xp_threshold(id: String) -> bool
```

### get\_stats

```gdscript
func get_stats(id: String) -> EntityStats
```

### get\_xp\_for

```gdscript
func get_xp_for(id: String) -> int
```

### get\_to\_next\_lv\_for

```gdscript
func get_to_next_lv_for(id: String) -> int
```

### calculate\_needed\_xp

```gdscript
func calculate_needed_xp(id: String) -> int
```

