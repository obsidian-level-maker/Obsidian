# Contributing Guidelines

Although based on Oblige 7.70, this repo is now incompatible with all versions of Oblige due to the move to vanilla Lua and changes to the GUI widget system.

No other versions will be supported. If support is desired for something from an older version of Oblige, it must be ported forward to the current codebase.

## Code standards
* Code must remain GPL compliant through changes (see LICENSE).
* Code must be readable, deobfuscated, and thoroughly-commented where possible.
* New code should match existing code in style, indentation, naming conventions, capitalization, etc.
* Do not use the code repository as a corkboard (To-do's, ideas, wishlists, notes, Fix-Me's, etc).
  * Yes, Andrew did this in many places. No, that doesn't make it okay.
  * "Cleanup" patches to remove existing commentary will be accepted ONLY if the removed material is first documented on the Wiki.

## Patch submission
* Patches must be submitted via pull request on GitHub. If you don't know how to do this, ask for help.
* Patches must be single-purpose. If you want to do two separate things, make two separate pull requests. 
* Patches must be based on or cleanly ported to the current master branch.
* Patches must compile and work as intended on both Windows and Linux. If you cannot test a change, ask someone else to do it for you. 
