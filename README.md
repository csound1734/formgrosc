# formgrosc
formant grain oscillator cabbage

* install Cabbage (this will also install csound) cabbageaudio.com/download/
* clone this repo
* open Cabbage and open the file formgrosc.csd for editing
* you must edit the file so that csound can find your wavetable file. see notes near the bottom of formgrosc.csd. you must change the path to reflect wherever your wavetables are located. note that a relative file path will work fine when running the program from the Cabbage IDE, but if you want to export the program as a standalone or plugin, only an absolute path will work. if you export without fixing this, your exported program will not work because csound will not be able to open the wavetable file.
* assuming the wavetable file path issue mentioned above is dealt with, you may press play in the Cabbage IDE to play with your synth, or export to your desired format. the .csd file and the exported app or plugin must have the same name (ignoring the file extension) and be in the same directory or the program will not function. in other words, when you export the program, name it "formgrosc" when prompted unless you have changed the name of the .csd file.

