Messages to send to Pure Data
-----------------------------

There are two methods of sending messages to one of the active pure data connections. Where pd is an instance of PureData:

Note:

Tell one of the active connections to produce a note.

pd.send_note(connection_index, note, length)

* connection_index: a 0-index reference for which active connection should produce the note.
* note: A note letter plus octave number
* length: Time in milliseconds before noteoff signal is sent

e.g.

`pd.send_note(0, 'C4', 500)`

--------------

Generic command:

pd.send_command(connection_index, command)

generically sends a message to one of the active pure data connections.

* connection: A 0-index reference for which active connection will receive the command
* command: any string to send into pure data.

e.g. 

`pd.send_command(1, 'volume 100')`

Valid Commands
--------------

Currently speculative, messages which will be accepted by the accompanying Pd patch

Attributes
----------

Attributes will always be a space-separated list. The name of an attribute, then the value from 0 to 100.

`pd.send_command(0, 'volume 50')`

* volume - How loud it goes
* portamento_time - Time to slide between notes
* attack_time - volume envelope start, raising to volume
* decay_time - volume envelope second stage, reducing to sustain_level
* sustain_level - sustain volume, as a proportion of volume
* release_time - volume envelope end, down to zero
* fm_depth - how deep the FM synthesis is (as a proportion of the note frequency)
* fm_frequency - how fast the FM synthesis is (as a proportion of the note frequency)
* sq_width - the width of the waveband on the filter on square wave synth (todo)
* sq_depth - how deep the filter on the square wave synth is
* sq_freq - The centre frequency on the square wave synth filter (proportion of the note, 50 is the same frequency).

Booleans
--------

Booleans are synth settings which are explicitly set on or off. Always the boolean name, then 'on' or 'off'

`pd.send_command(0, 'portamento on')`

* portamento - slide between notes, or not. (TODO)
* noise - turn white noise sound on or off
* sine - simple sine-wave tone generator
* fm - frequency modulation synthesizer
* square - square wave syntheseizer
* sq_filter - turn filter on or off on square wave synth (todo)

Events
------

Events are single, one-off sound events.

`pd.send_command(0, 'kick')`

* kick - bass drum sound
* snare - snare drum sound
* hat - hi-hat sound
* beep - a beep


