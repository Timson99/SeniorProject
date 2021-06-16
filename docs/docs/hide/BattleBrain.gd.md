+++
title = "BattleBrain.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Control](../Control)

## Description

## Property Descriptions

### character\_party

```gdscript
var character_party
```

### enemy\_party

```gdscript
var enemy_party
```

### dialogue\_node

```gdscript
var dialogue_node
```

### menu

```gdscript
var menu
```

### enemies

```gdscript
var enemies
```

### characters

```gdscript
var characters
```

### character\_move\_dict

```gdscript
var character_move_dict: Dictionary
```

### escaped

```gdscript
var escaped
```

### attempted\_escapes

```gdscript
var attempted_escapes
```

### fighting\_boss

```gdscript
var fighting_boss
```

## Method Descriptions

### turn

```gdscript
func turn()
```

### add\_move

```gdscript
func add_move(screen_name: String, move: BattleMove)
```

### remove\_move

```gdscript
func remove_move(screen_name: String)
```

### battle\_engine

```gdscript
func battle_engine()
```

### sort\_by\_speed

```gdscript
func sort_by_speed(a, b)
```

### sort\_defends

```gdscript
func sort_defends(a, _b)
```

### execute

```gdscript
func execute(moves_made: Array)
```

### calculate\_xp\_payout

```gdscript
func calculate_xp_payout(base_xp: int)
```

Basic XP calculator ~ should likely be tweaked for game balance!

### battle\_victory

```gdscript
func battle_victory()
```

### battle\_failure

```gdscript
func battle_failure()
```

### battle\_escape

```gdscript
func battle_escape()
```

### calculate\_escape\_chance

```gdscript
func calculate_escape_chance(move: BattleMove, enemies: Array, moves_made: Array)
```

