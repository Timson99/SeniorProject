+++
title = "Sequencer.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Node](../Node)

## Description

## Property Descriptions

### in\_control

```gdscript
var in_control
```

### Events

```gdscript
var Events
```

### active\_event

```gdscript
var active_event
```

### current\_instruction

```gdscript
var current_instruction
```

### last\_actor\_instruction\_type

```gdscript
var last_actor_instruction_type
```

## Method Descriptions

### assume\_control

```gdscript
func assume_control()
```

### end\_control

```gdscript
func end_control()
```

### execute\_instructions

```gdscript
func execute_instructions(event)
```

### execute\_event

```gdscript
func execute_event(event_id: String)
```

### actor\_async\_instruction

```gdscript
func actor_async_instruction(params: Array)
```

### actor\_sync\_instruction

```gdscript
func actor_sync_instruction(params: Array)
```

### bg\_audio\_instruction

```gdscript
func bg_audio_instruction(params: Array)
```

### dialogue\_instruction

```gdscript
func dialogue_instruction(dialogue_id: String)
```

Open Dialogue, No Coroutine

### battle\_instruction

```gdscript
func battle_instruction(scene_id: String)
```

Begin Battle, No Coroutine, Last Instruction

### scene\_instruction

```gdscript
func scene_instruction(scene_id: String, warp_id: String)
```

Change Scene, No Coroutine, Last Instruction

### delay\_instruction

```gdscript
func delay_instruction(time: float)
```

### signal\_instruction

```gdscript
func signal_instruction(obj_id: String, signal_name)
```

### enemy\_instruction

```gdscript
func enemy_instruction(empty_value)
```

