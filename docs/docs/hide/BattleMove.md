+++
title = "BattleMove"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Object](../Object)

## Description

## Property Descriptions

### agent

```gdscript
var agent
```

Object Ref to agent (has its stats, skills (for lookup) and itesm (for lookup), status effects

### target

```gdscript
var target
```

Object Ref to agent (has its stats, skills (for lookup) and itesm (for lookup), status effects

### type

```gdscript
var type
```

Type of Move, can be Attack, Skill, Item, Run, Defend

### skill\_id

```gdscript
var skill_id
```

### item\_id

```gdscript
var item_id
```

### skill\_cost

```gdscript
var skill_cost
```

### skill\_ref

```gdscript
var skill_ref
```

### item\_ref

```gdscript
var item_ref
```

## Method Descriptions

### \_init

```gdscript
func _init(agent, type, target = null, special_id = "")
```

### to\_dict

```gdscript
func to_dict()
```

### to\_string

```gdscript
func to_string()
```

