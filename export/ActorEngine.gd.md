+++
title = "ActorEngine.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Node](../Node)

## Description

## Property Descriptions

### actors\_dict

```gdscript
var actors_dict: Dictionary
```

### actors\_array

```gdscript
var actors_array: Array
```

### async\_actors

```gdscript
var async_actors
```

## Method Descriptions

### register\_actor

```gdscript
func register_actor(actor)
```

### get\_party

```gdscript
func get_party()
```

### update\_actors

```gdscript
func update_actors()
```

### call\_command

```gdscript
func call_command(id, func_name, params)
```

### set\_command

```gdscript
func set_command(id: String, property: String, new_value)
```

### sync\_command

```gdscript
func sync_command(id, func_name, params)
```

### async\_command

```gdscript
func async_command(id, func_name, params)
```

## Signals

- signal sync_command_complete(): 
- signal updated_async_actors(): 
