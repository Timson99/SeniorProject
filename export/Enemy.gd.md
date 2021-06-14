+++
title = "Enemy.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

## Enumerations

### Mode

```gdscript
const Mode: Dictionary = {"Battle":4,"Chase":1,"Defeated":5,"Patrol":3,"Stationary":0,"Wander":2}
```

## Property Descriptions

### player\_party

```gdscript
var player_party
```

### target\_player

```gdscript
var target_player
```

### current\_mode

```gdscript
export var current_mode: int = 2
```

### data\_id

```gdscript
export var data_id: int = 1
```

### alive

```gdscript
export var alive: bool = true
```

### is\_boss

```gdscript
export var is_boss: bool = false
```

### battle\_sprite

```gdscript
var battle_sprite
```

### key

```gdscript
var key: String
```

### spawn\_balancer\_id

```gdscript
var spawn_balancer_id: int
```

### allies

```gdscript
var allies: Array
```

## Method Descriptions

### initiate\_battle

```gdscript
func initiate_battle()
```

### move\_toward\_player

```gdscript
func move_toward_player()
```

### begin\_chasing

```gdscript
func begin_chasing(body: Node)
```

### stop\_chasing

```gdscript
func stop_chasing(body: Node)
```

### freeze\_in\_place

```gdscript
func freeze_in_place()
```

### unfreeze

```gdscript
func unfreeze()
```

### post\_battle

```gdscript
func post_battle()
```

### add\_allies\_to\_gang

```gdscript
func add_allies_to_gang(area: Area2D)
```

Overlapping enemy Area2Ds throw enemies into array that may be instanced in battle later

### remove\_allies\_from\_gang

```gdscript
func remove_allies_from_gang(area: Area2D)
```

Corresponding removal function for "add_to_gang"