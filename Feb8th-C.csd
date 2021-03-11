/*
  * First time using the directory opcode to get an array
  * of filenames by searching a directory.
*/

<Cabbage>
form caption("Untitled") size(1050, 400), colour(255, 185, 150), pluginid("def1")
texteditor wrap(1) bounds(0, 0, 1050, 100) colour(3,160,250) fontcolour("white") channel("textedit") ;file("~/Downloads/jimscsoundnotebook/Feb8th.txt")
csoundoutput bounds(0, 100, 1050, 80) colour(14,48,64) fontcolour(0,255,190)
keyboard bounds(0,300,1050,100) keywidth(20)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1

;instrument will be triggered by keyboard widget
instr 1
icount = 0
SFil[] directory "/Users/nicoleschmidt/Downloads", ".wav"
ilen lenarray SFil
Aloop:
if icount<ilen then
printf_i "%s\n\n\n\n", (1), SFil[icount]
icount += 1
igoto Aloop
endif
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
</CsScore>
</CsoundSynthesizer>
