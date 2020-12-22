# formgrosc
formant grain oscillator cabbage

* install Cabbage (this will also install csound) cabbageaudio.com/download/
* clone this repo
* open Cabbage and open the file formgrosc.csd for editing
* as long as you clones the entire repo as-is (including the directory with the wavetable files) the synth should be fully functional without making any changes - just hit the play button in Cabbage and the GUI should pop up. You can use your keyboard to play notes or click on the virtual keyboard (you should also be able to set up MIDI input in Settings). 
* However, if you want to export the program as a standalone app or plugin, there will be a problem with the wavetable files, which requires a slight modification of the code to make the program work - see below.

## How to get ready to export (sounds more complicated than it really is)
* you must edit the file so that csound can find your wavetable file. see notes near the bottom of formgrosc.csd. you must change the path to reflect wherever your wavetables are located. note that a relative file path will work fine when running the program from the Cabbage IDE, but if you want to export the program as a standalone or plugin, only an absolute path will work. if you export without fixing this, your exported program will not work because csound will not be able to open the wavetable file.
* when exporting, Cabbage asks you what you want to name the app or plugin. the app must have the same name as the .csd file or it won't work. that means you should name the app/plugin "formgrosc" or it won't work. also, formgrosc.csd must be in the same directory as the app/plugin (so if you move the plugin to your system's plugin folder, move formgrosc.csd there too).
* if you have problems with latency or dropouts (audio glitching) you may need to change the software and hardware buffer sizes. See the comments in the \<CsOptions\> section. Removing the -b and -B flags entirely may be a good way to go too, as Csound will then default to system-specific defaults that may be "good enough"

## Changing wavetables
In the real Virus synth, users can modulate between wavetables in-real time, in addition to being able to modulate the wavetable index to select different single-cycle waveforms ("frames") from within a given wavetable. In this synth, you can modulate the wavetable index to select the different single-cycle waveforms in real-time, but you are limited to a single wavetable. By default that wavetable is "Sundial 2". 

However, if you want to change what wavetable you are using, you can do this by altering the code. This is achieved by altering the same line of code as in the previous section, i.e. the line that includes a path to the wavetable file. For example, if you replace the text "ACVSTI Sundial 2.wav" with "ACVSTI Fibonasty.wav", the synth will use the Fibonasty wavetable instead of the Sundial 2 wavetable. 

Eventually, I will implement a feature that allows the user to avoid the inconvenience and select different wavetables on the fly in addition to selecting different frames from within a wavetable.

Another thing to note is that for now, the synth assumes that the wavetable contains only 100 different frames. If the wavetable contains more than 100 frames, only the first 100 frames will be used, and the rest will not be available. Note that if you use a wavetable with *less* than 100 frames, this will probably cause Csound to crash. All of the included Virus wavetables have at least 100 frames, but if you import your own wavetables, beware. Of course, it's not too difficult to accomodate a wavetable with less than 100 frames, but it requires a couple of alterations to the code.

## Disclaimer
This is not intended to be a full-fledged synth for professional use. It is only a proof-of-concept demonstrating my attempt to reverse-engineer the Virus grain/formant oscillators. It is lacking many features that are needed to make the synth useable for actual audio production - most notably, ADSR envelope controls. I hope to add such features in future releases.

