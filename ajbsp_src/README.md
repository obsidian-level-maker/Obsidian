
AJBSP 1.01
==========

by Andrew Apted, 2018.


About
-----

AJBSP is a simple nodes builder for modern DOOM source ports.
It can build standard DOOM nodes, GL-Nodes, and XNOD format nodes.
The code is based on the BSP code in Eureka DOOM Editor, which
was based on the code from glBSP but with significant changes.

AJBSP is a command-line tool.  It can handle multiple wad files,
and modifies each file in-place.  There is an option to backup each
file first.  The output to the terminal is fairly terse, but greater
verbosity can be enabled.  Generally all the maps in a wad will
processed, but this can be limited to a specific set.


Main Site
---------

https://gitlab.com/andwj/ajbsp


Binary Packages
---------------

https://gitlab.com/andwj/ajbsp/tags/v1.01


Legalese
--------

AJBSP is Copyright &copy; 2018 Andrew Apted, Colin Reed, and
Lee Killough, et al.

AJBSP is Free Software, under the terms of the GNU General Public
License, version 2 or (at your option) any later version.
See the [LICENSE.txt](LICENSE.txt) file for the complete text.

AJBSP comes with NO WARRANTY of any kind, express or implied.
Please read the license for full details.


Compiling
---------

Please see the [INSTALL.md](INSTALL.md) document.


Usage
-----

AJBSP must be run from a terminal (Linux) or the command shell
(cmd.exe in Win32).  The command-line arguments are either files
to process or options.  Where options are placed does not matter,
the set of given options is applied to every given file.

Short options always begin with a hyphen ('-'), followed by one
or more letters, where each letter is a distinct option (i.e. short
options may be mixed).  Long options begin with two hyphens ('--')
followed by a whole word.

When an option needs a value, it should be placed in the next argument,
i.e. separated by the option name by a space.  For short options which
take a number, like '-c', the number can be mixed in immediately
after the letter, such as '-c23'.

The special option '--' causes all following arguments to be
interpreted as filenames.  This allows specifying a file which
begins with a hyphen.

Once invoked, AJBSP will process each wad file.  All the maps in the
file have their nodes rebuilt, unless the --map option is used to
limit which maps are visited.  The normal behavior is to keep the
output to the terminal fairly terse, only showing the name of each
map as it being processed, and a simple summary of each file.
More verbose output can be enabled by the --verbose option.

Running AJBSP with no options, or the --help option, will show
some help text, including a summary of all available options.


Option List
-----------

`-v --verbose`  
Produces more verbose output to the terminal.
Some warnings which are normally hidden (except for a final
tally) will be shown when enabled.

`-vv --very-verbose`  
This is equivalent to using --verbose twice, and causes lots of
wonderfully useless information about each level to be displayed.

`-vvv --super-verbose`  
This is the same as using --verbose three times, and enables
the display of all the minor issues (such as unclosed subsectors).

`-b --backup`  
Backs up each input file before processing it.
The backup files will have the ".bak" extension
(replacing the ".wad" extension).  If the backup
file already exists, it will be silently overwritten.

`-f --fast`  
Enables a faster method for selecting partition lines.
On large maps this can be significantly faster,
however the BSP tree may not be as good.

`-m --map  NAME(s)`  
Specifies one or more maps to process.
All other maps will be skipped (not touched at all).
The same set of maps applies to every given wad file.
The default behavior is to process every map in the wad.

Map names must be the lump name, like "MAP01" or "E2M3",
and cannot be abbreviated.  A range of maps can be
specified using a hyphen, such as "MAP04-MAP07".
Several map names and/or ranges can be given, using
commas to separate them, such as "MAP01,MAP03,MAP05".

NOTE: spaces cannot be used to separate map names.

`-n --nogl`  
Disables building of GL-Nodes, only the normal nodes
are built.  Any existing GL-Nodes in a visited map
will be removed.

`-g --gl5`  
Forces V5 format of GL-Nodes.  The normal behavior
is to build V2 format, and only switch to V5 format
when the level is too large (e.g. has too many segs).

Unless you are testing a source port, there is almost
no need to use this option.

`-x --xnod`  
Forces XNOD (ZDoom extended) format of normal nodes.
Without this option, normal nodes will be built using
the standard DOOM format, and only switch to XNOD format
when the level is too large (e.g. has too many segs).

Using XNOD format can be better for source ports which
support it, since it provides higher accuracy for seg
splits.  However, it cannot be used with the original
DOOM.EXE or with Chocolate-Doom.

`-c --cost  ##`  
Sets the cost for making seg splits.
The value is a number between 1 and 32.
Larger values try to reduce the number of seg splits,
whereas smaller values produce more balanced BSP trees.
The default value is 11.

NOTE: this option has little effect when the --fast
option is enabled.

`-o --output  FILE`  
This option is provided *only* for compatibility with
existing node builders.  It causes the input file to be
copied to the specified file, and that file is the one
processed.  This option *cannot* be used with multiple
input files, or with the --backup option.

`-h --help`  
Displays a brief help screen, then exits.

`--version`  
Displays the version of AJBSP, then exits.


Exit Codes
----------

- 0 if OK.
- 1 if nothing was built (no matching maps).
- 2 if one or more maps failed to build properly.
- 3 if a fatal error occurred.
