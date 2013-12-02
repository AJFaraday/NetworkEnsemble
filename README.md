Networked Ensemble
------------------
By Andrew Faraday
------------------

An attempt to produce an automated laptop ensemble with PureData and Ruby. The aim is a single sequencer machine and multiple client boxes producing the sound. 

Prerequisites
-------------

* Ruby 1.8 or 1.9
* puredata `sudo apt-get install puredata` or www.puredata.info/downloads

Setup
-----

* `sudo apt-get install puredata`
* `git clone git@github.com/ajfaraday/NetworkEnsemble`
* `cd NetworkEnsemble`
* `cp config/config.yml.template config/config.yml`

Config
------

* profile: a named profile, defined lower in the file, for quick switching of environments

default profiles:

* local: should work out-of-the-box with quartet.pd open
* remote: needs modification, designed to work with multiple computers with single.pd open

profile attributes:

* Connections: An array of pure data client instances
** hostname: IP address of Pure Data listener
** port: port number of Pure Data listener

Testing
-------

* `puredata pd/quartet.pd`
* (in another window) `ruby scripts/test_signals.rb`

You should hear a number of sequences demonstrating the signals and the sounds they produce.

Network (untested)
------------------

To do this you will need 4 separate computers, connected to speakers, on a wired network. One will be the sequencer box, the rest, just sound.

* download puredata (`sudo apt-get install puredata` or www.puredata.info/downloads
* clone the git repo (`git clone git@github.com/ajfaraday/NetworkEnsemble` or use the zip download for windows)
* open single.pd (`puredata pd/single.pd` or navigate from pure data)
* find the ip address and make a note of it (`ifconfig` in linux or mac OS, `ipconfig` in windows command prompt)

On your sequencing box:

* vim config/config.yml (change profile to 'remote' and ip addresses on remote profile to your 4 boxes)
* `ruby scripts/birthday.rb`

All being well, you should receive a delightful birthday treat.


So what do I do now?
--------------------

The next step is to add your own tunes using CSV files, these can be added back into the repo, but keep them in a folder, labelled as yours.

* `mkdir sequences/myname`
* choose a template from sequences/templates
* `cp sequences/templates/quartet-44-16.csv sequences/myname/mytune.csv` 



