+++
title = "EnemyHandler.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Node](../Node)

## Description

## Property Descriptions

### Enemies

```gdscript
var Enemies
```

### random\_num\_generator

```gdscript
var random_num_generator
```

### generated\_enemy\_id

```gdscript
export var generated_enemy_id: int = 1
```

### num\_of\_enemies

```gdscript
export var num_of_enemies: int = 0
```

### max\_enemies

```gdscript
export var max_enemies: int = 0
```

### enemy\_variations

```gdscript
export var enemy_variations: Array = []
```

### target\_player

```gdscript
var target_player: KinematicBody2D
```

### player\_view

```gdscript
var player_view: Vector2
```

### scene\_node

```gdscript
var scene_node: Node
```

### spawn\_points

```gdscript
var spawn_points: Array
```

### spawn\_locations

```gdscript
var spawn_locations: Array
```

### spawner\_balancer

```gdscript
var spawner_balancer: Dictionary
```

### existing\_enemy\_data

```gdscript
var existing_enemy_data: Dictionary
```

### queued\_battle\_enemies

```gdscript
var queued_battle_enemies: Array
```

### queued\_battle\_ids

```gdscript
var queued_battle_ids: Array
```

### can\_spawn

```gdscript
var can_spawn: bool
```

### spawning\_launched

```gdscript
var spawning_launched
```

### spawning\_locked

```gdscript
var spawning_locked: bool
```

### enemy\_spawner\_ratio

```gdscript
var enemy_spawner_ratio: float
```

## Method Descriptions

### check\_if\_spawning\_possible

```gdscript
func check_if_spawning_possible()
```

Called whenever a new scene is loaded; checks if explore root of the
new scene permits enemy spawning (i.e. in exploration mode).

### initialize\_spawner\_info

```gdscript
func initialize_spawner_info()
```

If enemies can be spawned, information about where enemies can spawn is
gathered from the children nodes of the current explore scene.

### block\_spawning

```gdscript
func block_spawning()
```

### enable\_spawning

```gdscript
func enable_spawning()
```

### spawn\_enemy

```gdscript
func spawn_enemy()
```

### get\_spawn\_position

```gdscript
func get_spawn_position()
```

### create\_enemy\_instance

```gdscript
func create_enemy_instance(id: int, enemy_type: String, spawn_position: Vector2, respawn: bool)
```

### add\_enemy\_data

```gdscript
func add_enemy_data(id, enemy_obj)
```

### clear\_existing\_enemy\_data

```gdscript
func clear_existing_enemy_data()
```

### get\_enemy\_data

```gdscript
func get_enemy_data(id: int)
```

### add\_to\_battle\_queue

```gdscript
func add_to_battle_queue(enemy_type: String)
```

### collect\_battle\_enemy\_ids

```gdscript
func collect_battle_enemy_ids(id: int)
```

### retain\_enemy\_data

```gdscript
func retain_enemy_data()
```

Non-boss enemies are not persistent; existing enemies must be preserved
whenever the player engages in a battle.

### freeze\_all\_nonplayers

```gdscript
func freeze_all_nonplayers()
```

### unfreeze\_all\_nonplayers

```gdscript
func unfreeze_all_nonplayers()
```

### readd\_previously\_instanced\_enemies

```gdscript
func readd_previously_instanced_enemies()
```

After a battle concludes, all enemies are returned to the overworld in their
pre-battle positions. Defeated enemies are deleted after playing death animations.

### despawn\_on

```gdscript
func despawn_on()
```

Called if goto_saved is used

### despawn\_off

```gdscript
func despawn_off()
```

### clear\_queued\_enemies

```gdscript
func clear_queued_enemies()
```

### despawn\_defeated\_enemies

```gdscript
func despawn_defeated_enemies()
```

Called for battle victory or fleeing

### launch\_spawning\_loop

```gdscript
func launch_spawning_loop()
```

If enemies can be spawned and the target player character has been located,
loops indefinitely to spawn a balanced distribution of enemies in overworld.

## Signals

- signal spawn_func_completed(): 
