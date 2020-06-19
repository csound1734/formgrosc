<Cabbage>
form caption("CabbageGUI") size(400, 300), colour(58, 110, 82), pluginid("def1") style("modern") 
keyboard bounds(10, 158, 381, 95) keypressbaseoctave(4)
rslider bounds(10, 90, 60, 60) range(-64, 64, 0, 1, 0.005) channel("formant_shift") text("F-scale - gran")
rslider bounds(130, 90, 60, 60) range(-12, 14, 0, 1, 0.005) channel("formant_shift2") text("F-shift - pvs")
rslider bounds(70, 90, 60, 60) range(0, 12, 0, 1, 0.0005) channel("formant_spread") text("F-spread - gran")
rslider bounds(328, 90, 60, 60) range(0, 99, 0, 1, 0.05) channel("wavetable_index") text("Index")
signaldisplay bounds(10, 5, 381, 80) displaytype("spectroscope") signalvariable("aDisp") colour("lime") backgroundcolour("black")
combobox bounds(193, 92, 80, 20) text("LifteredCepst", "TrueEnvelope") channel("pvswarp_meth")
rslider bounds(193, 114, 79, 35) min(0) max(212) text("Lowest_Hz_Wazrped") channel("lowest-shift2")
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --midi-key-cps=5 --midi-velocity-amp=4 -b4 -B128 --displays
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32 
nchnls = 2
0dbfs = 1

;instrument will be triggered by keyboard widget
        instr   100
kEnv    madsr   0.001, 0, 1, .005        ;generate adsr envelope (release triggered by noteoff)
kEnv    *=      ampdbfs(-42)            ;gain down
kform   chnget  "formant_shift"         ;get f-shift from GUI (actually controls formant SCALING)
kformsh chnget  "formant_shift2"        ;real formant shifting (implemented with streaming fft)
klowest chnget  "lowest_shift2"         ;warp cutoff
kpvsm   chnget  "pvs_meth"
kspread chnget  "formant_spread"        ;get f-spread from GUI
kwtndx  chnget  "wavetable_index"       ;get wavetable index from GUI
kform   portk   kform, .01              ;smooth control signal
kband   =       abs(kform*4)            ;vary exp. grain env. with formant
kform   =       p5*semitone(kform)      ;convert formant to Hz (key-tracked)
kris    =       0.25/p5                 ;grain env.
kdec    =       kris                    ;grain env.
kdur    =       1.25/p5                 ;grain env.
koct    =       0                       ;not used
aspread =       semitone(oscil(kspread, p5/2, 35))
        ftmorf  int(kwtndx), 98, 99          ;wavetable interpolation
aOut1   fof     kEnv*p4, p5, kform*aspread, koct, kband, kris, kdur, kdec, 10000, 99, 33, 100    
f1      pvsanal aOut1, 1024, 256, 1024, 1
f2      pvswarp f1, 1, powoftwo:k(kformsh), klowest*p4, 1+kpvsm ;control over shift+lowest?
aOut    pvsynth f2
aOut1   =       aOut
        outs    aOut1, aOut1            ;output
aDisp   =       aOut1*600               ;rescale output to look better in spectroscope
        dispfft aDisp, .05, 2048        ;analyze spectrum and send to GUI for display
        endin
        
</CsInstruments>

<CsScore>
;list of macros representing file paths for samples
;must be in the same directory unless INCDIR environmental variable is set
#include "Samp2.txt"

;causes Csound to run for about 7000 years...
f0 z

;sigmoid rise (grain attack envelope)
f33 0 16384 -19 .5 .5 270 .5 

f34 0 16384 10 1 ;sine

;bipolar square (for f-spread)
f35 0 16384 -7 -1 8192 -1 0 1 8192 1 

;tables 98 and 99 used for ftmorf opcode (wavetable interp.)
f98 0 128 -7 100 99 199 29 199  ;reference
f99 0 2048 -2 0 ;buffer

; load 100 waveforms from wavetable WAV file
{100 t ;loop 100x
f [100+$t] 0 2048 1 "$Vir66" [$t*2048/44100] 0 0 ;load a waveform
} ;end of loop

</CsScore>
</CsoundSynthesizer>
