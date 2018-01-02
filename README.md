# Overview

This is a fork of the pubref kotlin rules. Detailed documentation is
incoming. The `old` directory contains pubref logic and documentation.

## Changes made to the pubref rules.

* The macros have been replaced with three basic rules. These model the java rules as much as possible -- `kotlin_binary`, `kotlin_library` and `kotlin_test`.
* The following concepts were added to the rules `data`, `resource_jars`, `runtime_deps`, `resources`, `resources_strip_prefix`, `exports`.
* The rules should dictate the version of kotlin used for the most case, the libraries are included in the distribution 
compile releases from JB -- pick them up from here (later: make the toolchain configurable).
* Persistent worker support was missing, worker protocol in pubref had other issues.
* The compiler depends on common external dependencies which aren't strictly needed (dagger, guava).


### Next steps:

* `kotlin_import` rule.
* Dependency propagation tests -- use integration test framework from bazelbuild. We need a good set of tests to validate the rules for correctness.
* Compilation profiles: elements of the kotlin compiler should be configurable -- e.g., bytecode target (jdk1.6, jdk1.8), which stdlibs to use (jdk7, jdk8, reflect) etc. The compiler options attributes are currently disabled in the rules.
* kapt and annotation processing. This should be as easy to setup as the java rules.
* Ijars: They do not work with any kotlin code which provides inline definitions -- currently full jars are used.
         Need to come up with a strategy for this, potentially ask JB to add a compiler plugin that will produce ijars.