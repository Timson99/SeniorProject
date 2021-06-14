+++
title = "SceneManager.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Node](../Node)

## Description

## Property Descriptions

### MainScenes

```gdscript
var MainScenes
```

### fade\_screen

```gdscript
var fade_screen
```

### current\_scene

```gdscript
var current_scene
```

### saved\_scene\_path

```gdscript
var saved_scene_path
```

### loader

```gdscript
var loader
```

### wait\_frames

```gdscript
var wait_frames
```

### time\_max

```gdscript
var time_max
```

msec

### fade

```gdscript
var fade
```

### warp\_dest

```gdscript
var warp_dest
```

### ticks

```gdscript
var ticks
```

## Method Descriptions

### goto\_scene

```gdscript
func goto_scene(scene_id: String, warp_destination_id: String = "", save_path = false)
```

Call this function from anywhere to change scene
Example: SceneManager.goto_scene(path_string, warp_destination_id)

### goto\_saved

```gdscript
func goto_saved()
```

### start\_new\_scene

```gdscript
func start_new_scene(s)
```

### update\_progress

```gdscript
func update_progress()
```

## Signals

- signal goto_called(): 
- signal scene_loaded(): 
- signal scene_fully_loaded(): 
