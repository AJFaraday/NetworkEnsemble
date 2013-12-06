Module Reference
----------------

Most synthesizers are what is known as modular, meaning different parts of them have their own individual purpose, and modules can be combined in different ways. The Network Ensembe puredata patch is much the same. A lot of the commands which can be passed to the pure data patch are here listed, grouped into commands which affect the same module. 

Master attributes go in the master column, no surprises there.
Attriubtes and booleans are to be placed in the command columns.
Events need to be placed in the event columns.

Attribute columns are between 0 and 100, unless stated otherwise.


Sequencer
---------

This effects how quickly the sequence is played. 

Master commands:
* time - The time signature, ask the internet what this is if you don`t know. Separated with a forward slash (/). Typical values include 4/4, 3/4, 6/8, 9/8
* resolution - The note value of each row of the CSV file is. (4 is a crotchet, 8, a quaver and 16 is a semiquaver)
* bpm - beats per minute

Volume
------

Affects how loud a synth is.
Attributes:
* volume - how loud a specific synth is. 

Master commands:
* master_volume - changes the volume of all the tracks, relative to their individual volume.

Volume Envelope
---------------

An Attack, Decay, Sustain, Release volume envelope, which affects the shape of the volume over time. These values are in milliseconds, and are not just between 0 and 100, unless stated otherwise.

* attack_time - The amount of time until the note reaches its initial peak
* decay_time - The amount of time after the attack it takes for the note to rest down to its resting volume
* sustain_level - From 0 to 100, how loud a notes resting volume is, where it rests from the end of its decay phase.
* release_time - When a note is over, how long it`ll take to fade out to it`s resting level.

Portamento
----------

NOT YET DEVELOPED

Portamento is a note sliding continuously from one pitch to another. 

Boolean:
* portamento - slide between notes, or not

Attributes:
* portamento_time - The time in milliseconds (not 0 to 100), to move between pitches. 

Sine Synth 
----------

The sine synth is a very simple synthesizer, there are no attributes to vary this, just it`s on/off control. 

If no synths are specified only the sine synth will sound.

Booleans:
* Sine - will the sine synth sound?

FM Synth 
--------

A frequency modulation synthesizer (for more info, http://www.andrewfaraday.com/2013/05/algorithms-of-street-part-1-frequency.html). 

Booleans: 
* fm - will the fm synthesizer be heard?

Attributes:
* fm_depth - How deeply the frequency will be modulated
* fm_frequency - How fast the frequency modulation will happen, as a proportion of the main frequency

Square Wave Synth
-----------------

A square wave is a harsh waveform, this one has the option of a filter to soften and vary its sound.

Booleans:
* square - will the square wave synth be heard or not? 
* sq_filter - will this sound be filtered?

Attribute:
* sq_width: how wide a waveform will get through the filter if it`s on
* sq_freq: the frequency of the filter peak as a proportion of the note pitch, 50 is identical to the note frequency.
* sq_depth: a mix between the raw and filtered sound

Drum Machine
------------

A very simple drum machine, all one-off events. 

events:
* kick - A bass drum sound
* snare - Snare drum
* hat - a hi-hat cymbal
* tom1 - first tom tom
* tom2 - second tom tom
* tom3 - no prizes or guessing this
* beep - random beep

attributes:
* snare_roll - technically an attribute, actually an event - one rows worth of drum roll, followed by the number of strikes (e.g. snare_roll 4 will cram 4 snare hits into a single row)

White Noise
-----------

A filtered white noise generator, just for fun. 

Booleans: 
* noise - turn white noise on and off.

Attributes: 
* noise_attack - amount of time for noise to fade in (milliseconds, not 0-100)
* noise_decay - amount of time for noise to fade out (milliseconds, not 0-100)
* noise_f_freq - a centre freqeuency for the noise filter(Hz, not 0-100)
* noise_f_width - how much noise is heard either side of the centre frequency
* noise_f_mod_freq - a frequency in herz for the filter frequency to wobble (not 0 to 100, 0 to 5 would be good)
* noise_f_mod_depth - how far the filter frequency wobble goes, in herz (not 0 to 100)




