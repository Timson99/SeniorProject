+++
title = "Collector.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [SceneTree](../SceneTree)

## Description

## Method Descriptions

### find\_files

```gdscript
func find_files(dirpath: String = "", patterns: PoolStringArray = [], is_recursive: bool = false, do_skip_hidden: bool = true) -> PoolStringArray
```

### save\_text

```gdscript
func save_text(path: String = "", content: String = "") -> void
```

Saves text to a file.

### get\_reference

```gdscript
func get_reference(files: PoolStringArray = [], refresh_cache: bool = false) -> Dictionary
```

Parses a list of GDScript files and returns a list of dictionaries with the
code reference data.

If `refresh_cache` is true, will refresh Godot's cache and get fresh symbols.

### print\_pretty\_json

```gdscript
func print_pretty_json(reference: Dictionary) -> String
```

