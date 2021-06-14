+++
title = "Area01_Outside_SceneRoot.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [ExploreRoot](../ExploreRoot) < [Node](../Node)

## Description

## Property Descriptions

### persistence\_id

```gdscript
var persistence_id
```

### actor\_id

```gdscript
var actor_id
```

### event\_trigger\_scene

```gdscript
var event_trigger_scene
```

### event\_triggers

```gdscript
var event_triggers: Dictionary
```

### map

```gdscript
var map
```

### houses

```gdscript
var houses
```

### main\_house

```gdscript
var main_house
```

### trees

```gdscript
var trees
```

### bully

```gdscript
var bully
```

### world\_body

```gdscript
var world_body
```

### tween

```gdscript
var tween
```

### exit\_door

```gdscript
var exit_door
```

### glow

```gdscript
var glow
```

### current\_attempt

```gdscript
export var current_attempt = 1
```

### pre\_fight

```gdscript
var pre_fight
```

### first\_post\_fight

```gdscript
var first_post_fight
```

## Method Descriptions

### increment\_attempt

```gdscript
func increment_attempt()
```

### execute\_glow

```gdscript
func execute_glow()
```

### vanish\_world

```gdscript
func vanish_world()
```

### fade\_world

```gdscript
func fade_world(fade_time = 1)
```

### on\_load

```gdscript
func on_load()
```

### create\_vertical\_event\_trigger

```gdscript
func create_vertical_event_trigger(event_key, position, id)
```

### remove\_vertical\_event\_trigger

```gdscript
func remove_vertical_event_trigger(id)
```

### save

```gdscript
func save()
```

## Signals

- signal faded_out(): 
- signal glow_complete(): 
