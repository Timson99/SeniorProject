+++
title = "NPC.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

## Enumerations

### Mode

```gdscript
export var current_mode = 2
```

## Property Descriptions

### interact\_area

```gdscript
var interact_area
```

### persistence\_id

```gdscript
export var persistence_id: String = "NPC1"
```

### actor\_id

```gdscript
export var actor_id: String = "NPC_name"
```

### present\_in\_scene

```gdscript
export var present_in_scene = true
```

### current\_mode

```gdscript
export var current_mode = 2
```

## Method Descriptions

### interact

```gdscript
func interact()
```

### allow\_interaction

```gdscript
func allow_interaction(body: Node)
```

### restrict\_interaction

```gdscript
func restrict_interaction(body: Node)
```

### set\_speed

```gdscript
func set_speed(new_speed: float)
```

### reset\_speed

```gdscript
func reset_speed()
```

### freeze\_in\_place

```gdscript
func freeze_in_place()
```

### unfreeze

```gdscript
func unfreeze()
```

### move\_to\_position

```gdscript
func move_to_position(new_position: Vector2, global = true)
```

### save

```gdscript
func save()
```

