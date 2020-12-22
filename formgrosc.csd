
<Cabbage>
form caption("CabbageGUI") size(800, 300), colour(58, 110, 82), pluginid("def1") style("modern") 
keyboard bounds(10, 158, 381, 95) keypressbaseoctave(4)
rslider bounds(10, 90, 80, 60) range(-64, 64, 0, 1, 0.005) channel("formant_shift") text("F-shift")
rslider bounds(70, 90, 80, 60) range(0, 12, 0, 1, 0.0005) channel("formant_spread") text("F-spread")
rslider bounds(308, 90, 80, 60) range(0, 99, 0, 1, 0.05) channel("wavetable_index") text("Wavetable Index")
signaldisplay bounds(10, 5, 381, 80) displaytype("spectroscope") signalvariable("aDisp") colour("lime") backgroundcolour("black")
csoundoutput bounds(410,10,380,280)
label bounds(170, 90, 120, 15) text("Grain mode") align("left") fontstyle("plain") size(14)
label bounds(170, 122, 120, 15) text("Formant mode") align("left") fontstyle("plain")
checkbox bounds(140, 90, 30, 30) radiogroup(1) channel("grain_mode")
checkbox bounds(140, 122, 30, 30) radiogroup(1) channel("formant_mode")
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-+rtmidi=NULL -M0 -m0d --midi-key-cps=5 --midi-velocity-amp=4 
--displays ;required to let Csound display spectrum
; Note: the following settings change the software buffer (-b) and hardware buffer (-B)
;       in an attempt to reduce latency without causing dropouts (glitches). However, the success of
;       this is system dependent. If you experience problems with latency or dropouts, you
;       may need to change these options and/or change ksmps (below).
-b16    ;-b: software buffer (# of samples). Should be a negative power of two of ksmps
-B1024  ;-B: hardware buffer (# of samples). should be a power of two.
; Documentation about optimizing buffer settings: http://www.csounds.com/manual/html/UsingOptimizing.html

</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32 
nchnls = 2
0dbfs = 1
alwayson 100

zakinit 4, 4                           ;initialize zak patchbay (z-space)

 opcode formgrosc, a, ikiiiOO           ;the opcode that does all the synthesis
icps, kform, imode, iwavendxfn, iwaveresfn, kwavendx, kspread xin ;input parameters
kband = abs(kform*4)                   ;grain env. gets more extreme as kform increases
iform_base = (imode==0 ? cpspch(7) : icps) ;mode setting decides how formant gets calculated
kform = iform_base*semitone(kform)     ;convert kform from semitones to Hz
iris = 0.25/icps                       ;attack time of grain env. (skirtwidth of formants)
idec = iris                            ;decay time of grain env.
idur = 1.25/icps                       ;duration of each grain (grains slightly overlap)
aspread = semitone(oscil(kspread, icps/2, 35)) ;lfo which implements f-spread
ftmorf int(kwavendx), iwavendxfn, iwaveresfn ;interpolate between the different waveforms
aOut1   fof     1, icps, kform*aspread, 0, kband, iris, idur, idec, 10000, iwaveresfn, 33, 100    
xout aOut1                             ;output signal
 endop

;instrument will be triggered by keyboard widget
        instr   1
imode   zir     0                       ;retrieve mode setting from z-space *at i-time only*
kEnv    madsr   0.001, 0, 1, .005       ;generate adsr envelope (release triggered by noteoff)
kEnv    *=      ampdbfs(-42)            ;gain
kform   chnget  "formant_shift"         ;get f-shift from GUI (actually controls formant SCALING)
kspread chnget  "formant_spread"        ;get f-spread from GUI
kwtndx  chnget  "wavetable_index"       ;get wavetable index from GUI
kform   portk   kform, .002             ;smooth control signal
aOut1 formgrosc p5, kform, imode, 98, 99, kwtndx, kspread
aOut1 *= kEnv 
        zawm    aOut1, 0 ;send audio signal to z-space
        endin
        
        instr 100
kmode   chnget  "grain_mode"             ;get oscillator mode from GUI (0=formant, 1=grain)
        zkw     kmode, 0                ;send oscillator mode setting to z-space
ain     zar     0                       ;retrieve audio signal from z-space
        zacl    0, 0                    ;clear z-variable #0. otherwise audio will blow up
        outs    ain, ain                ;output
aDisp   =       ain*600                 ;rescale output to look better in spectroscope
        dispfft aDisp, .05, 2048        ;analyze spectrum and send to GUI for display
        endin
        
</CsInstruments>

<CsScore>

;causes Csound to run for about 7000 years...
f0 z

;sigmoid rise (grain attack envelope)
f33 0 16384 -19 .5 .5 270 .5 

;bipolar square (for f-spread)
f35 0 16384 -7 -1 8192 -1 0 1 8192 1 

;tables 98 and 99 used for ftmorf opcode (wavetable interp.)
f98 0 128 -7 100 99 199 29 199  ;reference
f99 0 2048 -2 0 ;buffer

; load 100 waveforms from wavetable WAV file
; NOTE: If the wavetable contains more than 100 single-cycle waveforms, only the first 100 will be loaded
; Single-cycle waveforms must be 2048 samples each.
; NOTE: For some reason, when exporting to a standalone application (and likely when exporting to plugin as well),
;       Csound cannot find the wavetable file unless it is given an absolute path. Therefore, unless you change the
;       line below to have an absolute path, your exported program or plugin will not work.
{100 t
;NOTE: The file name in the line below must be altered in order to select a different wavetable.
f [100+$t] 0 2048 1 "AC_Virus_TI2_Wavetables/ACVSTI Sundial 2.wav" [$t*2048/44100] 0 1 ;load a waveform
;Future releases should implement a feature allowing the user to change wavetables in real time.
} ;end of loop

</CsScore>
</CsoundSynthesizer>
