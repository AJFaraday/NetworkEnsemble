CSV File Content Reference
--------------------------
 
The sequence folder contains CSV files with musical sequences. In this file X is the number of parts, so far all of these are for quartets. 
The very first cell is an instruction for the number of parts in the piece. Other than this, the top row just displays column mappings and is not read.

To make a new sequence pick a template from sequences/templates and move it to sequences/tunes, for instance:

`cp sequences/templates/quartet-44-16.csv sequences/tunes/bohemian-rhapsody.csv`

The column mappings are as follows:

* One void column, used to mark time, can include section markers.
* X note columns
* One master data column, information for the sequencer, not the pure data instances.
* X command columns
* X event columns

All columns other than notes can include multiple values by separating these with a semicolon (;)

Column types
------------

Note columns contain a note, expressed by a note name (A to G), an optional accidental (# or b) and an octave number (0 to 9), then a space, and a note value, the number of rows this note is to be played for until it ends.

examples:

* C4 4 (middle C)
* D#6 2
* Bb3 2

The master column contains instructions for the sequencer, NOT the Pure Data synthesizers.
Master instructions all contain a name, and a value. 
Available master data values:

* time - Time signature, separated with a forward slash (/), e.g.: 4/4, 6/8, 3/4 (multiples of 3 on the top are assumed to be compound time, otherwise, simple)
* resolution - The note value from one row to the next (e.g. 4 (crotchet), 8 (quaver), 16 (semiquaver))
* bpm - the number of beats in a minute (compound time: 3 of the bottom line, simple time: 1 of bottom line) 
* master_volume - a secondary volume level for all synths at the same time

Command columns are instructions to the synthesizers, they consist of a name, then a value. The value is either 'on' or 'off' or a number from 0 to 100. For a full reference of commands look at COMMAND_REFERENCE.md (listed there as attributes and booleans).

examples:

* volume 100
* portamento on

Event columns are markers for one-time events. For a full list look at COMMAND_REFERENCE.md, where they are listed as events. They consist of a name and nothing else. 

examples: 
* kick
* snare
