<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 24
nchnls = 1

 opcode formgrosc, a, ikiiiOO           ;the opcode that does all the synthesis
icps, kform, imode, iwavendxfn, iwaveresfn, kwavendx, kspread xin ;input parameters
kband = abs(kform*12)                   ;grain env. gets more extreme as kform increases
iform_base = (imode==0 ? cpspch(7) : icps) ;mode setting decides how formant gets calculated
kform = iform_base*semitone(kform)     ;convert kform from semitones to Hz
iris = 0.25/icps                       ;attack time of grain env. (skirtwidth of formants)
idec = iris                            ;decay time of grain env.
idur = 5/icps                       ;duration of each grain (grains slightly overlap)
aspread = semitone(oscil(kspread, icps/2, 35)) ;lfo which implements f-spread
ftmorf int(kwavendx), iwavendxfn, iwaveresfn ;interpolate between the different waveforms
aOut1   fof     1, icps, kform*aspread, 0, kband, iris, idur, idec, 10000, iwaveresfn, 33, 100    
xout aOut1                             ;output signal
 endop

 opcode ftload_virus_waves, i, i
ift_first xin ;input param. selects what the first f-table loaded will be
icount = 0
loop:
if (icount<100) then ;load a total of 100 frames from the wavetable. additional frames will be ignored
ift ftgenonce (ift_first+icount), 0, 2048, 1, "AC_Virus_TI2_Wavetables/ACVSTI Sundial 1.wav", (2048*icount)/44100, 0, 1
icount += 1
igoto loop
endif
xout ift ;output the final f-table number just in case you want to double-check
 endop

giftmorf ftgen 300, 0, 128, -7, 100, 99, 199, 29, 199  ;ftmorf reference
gibuf    ftgen 301, 0, 2048, -2, 0                     ;ftmorf buffer

         ;f-table 33 must be a "attack shape" for formgrosc
giatk    ftgen 33, 0, 16384, -19, .5, .5, 270, .5
         ;f-tabel 35 must be a bipolar square for formgrosc
gisqr    ftgen 35, 0, 16384, -7, -1, 8192, -1, 0, 1, 8192, 1

 instr 1
ires ftload_virus_waves 100        ;load the waveforms starting at f-table 100
icps = cpspch(7.07)                ;pitch (fundamental) = low G
itempo = 4*144/60                  ;speed of random lfos - 16th notes @ 144bpm
kform randomh 6, 25, itempo        ;random f-shift between +6 and +25
kspread init 6                     ;f-spread
kwave randomh 0, 99, itempo         ;random wavetable index
ares formgrosc icps, kform, 1, giftmorf, gibuf, kwave, kspread
aenv adsr 0.01, 0, 1, 0.01         ;declicking envelope
ares *= aenv*ampdbfs(-28)          ;formgrosc tends to run pretty loud
out ares
 endin
</CsInstruments>
<CsScore>
i 1 0 12 ;play a note with instrument 1 for 12 seconds
</CsScore>
</CsoundSynthesizer>


