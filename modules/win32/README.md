# Nulib Win32 Module

This module provides bindings to Win32 using the windows-d code generator, linking to nulib instead.

The module covers less API than windows-d mainly to keep the scope of everything down, and to reduce compile times.

## Using the Win32 module

Just add nulib:win32 as a dependency; while the code is generated with wind, the 

## Directory Structure
 * `gen/` - Files used during code generation.
 * `wind/` - Patched wind code generator.
 * `source/` - The generated source.

## Changes compared to upstream windows-d
 * Fixed bugs that prevented wind compiling with newer DLang versions.
 * Added --coremod to declare which module the core file resides in.
 * Added support for ending wildcard filter to replace.cfg
 * Added extra fallbacks for new types added to the windows def.
 * Added more detailed header for every file.
 * Added string escaping handling to prevent variables escaping strings when writing Windows path seperators.
 * Added version tags for `SupportedArchitectureAttribute`

## TODO:
Generally `wind` is very messy and when I have more time I wish to completely redo it.