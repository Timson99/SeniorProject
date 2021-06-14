+++
title = "CameraManager.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Node2D](../Node2D)

## Description

## Enumerations

### State

```gdscript
var state
```

## Property Descriptions

### camera

```gdscript
var camera: Camera2D
```

### tween

```gdscript
var tween
```

### viewport

```gdscript
var viewport
```

### viewport\_size

```gdscript
var viewport_size
```

### static\_pos

```gdscript
var static_pos
```

### state

```gdscript
var state
```

### actor\_id

```gdscript
var actor_id
```

### y\_cutoff

```gdscript
var y_cutoff: int = 0
```

### vp\_scale

```gdscript
var vp_scale: int = 1
```

## Method Descriptions

### screen\_resize

```gdscript
func screen_resize()
```

### move\_to\_position

```gdscript
func move_to_position(destination: Vector2, time: float = 60)
```

### move\_to\_party

```gdscript
func move_to_party(time: float)
```

### release\_camera

```gdscript
func release_camera()
```

### grab\_camera

```gdscript
func grab_camera()
```

### state\_to\_party

```gdscript
func state_to_party()
```

### state\_to\_static

```gdscript
func state_to_static()
```

### state\_to\_sequenced

```gdscript
func state_to_sequenced()
```

## Signals

- signal complete(): 
