; safety check, doesn't allow double include!
#ifndef FLEX_INCL_SYNTH
#define FLEX_INCL_SYNTH ##
/***************
 ***************

synth.inc.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the synth file with specialzed functions for synths

***************
***************/

; This tells FlexFX to use the synth out instrument accumulator
#define USE_SYNTH_OUT ##

; Make sure standards are already included
#include "standards.inc.csd"

#ifndef MIDI_INPUT_CHAN
  #define MIDI_INPUT_CHAN #1#
#endif

; send the configured midi channel to the instr named "Synth"
massign $MIDI_INPUT_CHAN, "Synth"

; initialize global variables for pitch and mod wheel
gkPchBend init 1
gkModAux init 1
gkModAmp init 1
gkModWheel init 0

; initialize defaults so everything works even without widgets
chnset 12, "BendUpAmt"
chnset 12, "BendDownAmt"
chnset 5, "LFORate"
chnset 50, "DCO"
chnset 50, "VCA"
chnset 50, "AUX"
chnset 1, "ModDCO"
chnset 1, "ModVCA"
chnset 1, "ModAUX"

; automatically spawn instrument instance if included
alwayson "FlexSynthAutoMon"

; take in a p-field velocity and apply a curve to it
; using global velocity control
opcode FlexBaseAmp,i,i
  iAmp xin

  iAmp = $VELCURVE(.01*chnget("velcurve")'iAmp)

  ; kAmp = iAmp * gkModAmp

  ; TODO: these are tests for moving VELCURVE to ampmidicurve
  ; iAmp = ampmidicurve(p5,1,iVelCrv)
  ; iAmp ampmidicurve p5,1,iVelCrv

  xout iAmp
endop

opcode FlexVelAmp,i,ii
  iVel, iAmp xin

  ; iVel = limit(iVel,-1,1)
  iAmp = $VELCURVE(iVel'iAmp)

  xout iAmp
endop

; You *probably* don't want irate, but it's here just in case!
opcode FlexBaseFreq,i,i
  iFreq xin
  xout iFreq*i(gkPchBend)
endop

opcode FlexBaseFreq,k,i
  iFreq xin
  xout iFreq*gkPchBend
endop

opcode FlexBaseFreq,k,k
  kFreq xin
  xout kFreq*gkPchBend
endop

; TODO: this is probably useless, can it be deleted?
; higher res out than variables... maybe interpolate?
opcode FlexBaseFreq,a,i
  iFreq xin
  xout a(iFreq*gkPchBend)
endop

opcode FlexBaseFreq,a,k
  kFreq xin
  xout a(kFreq*gkPchBend)
endop

opcode FlexBaseFreq,a,a
  aFreq xin
  xout aFreq*gkPchBend
endop

#ifndef SYNTH_OUT_INSTR
  #define SYNTH_OUT_INSTR #FlexSynthOut#
#endif

#include "plants/flexfx/pan.inc.csd"

gkModAmp init 1

#ifndef SYNTH_FXOUT_INSTR
alwayson "$SYNTH_OUT_INSTR"

instr $SYNTH_OUT_INSTR
  aSigL chnget "SynthLeft"
  aSigR chnget "SynthRight"
  chnclear "SynthLeft"
  chnclear "SynthRight"

  kGainDb = ampdb(chnget:k("gain"))

  ; apply Pan and gain
  aSigL, aSigR FlexPan aSigL, aSigR
  aSigL *= kGainDb
  aSigR *= kGainDb

  ; apply VCA LFO from synth controls
  aSigL *= a(gkModAmp)
  aSigR *= a(gkModAmp)

  ; clip signal and LED
  aSigL, aSigR FlexClip aSigL, aSigR, "outOL-"

  outs aSigL, aSigR
endin
#endif

instr FlexSynthAutoMon
  ; init to .5, so prior to data wheel is "centered"
  kMidiBend init .5
  kMidiMod init 0

  ; read in midi data
  kMidiStatus, kMidiChan, kMidiData1, kMidiData2 midiin

  if (kMidiStatus==$MIDISTATUS_PCHBEND) then
    ; combine MSB and LSB to create 14bit value, then scale to 0/1
    kMidiBend = ((kMidiData2 << 7) | kMidiData1)/16384
  endif
 
  if(kMidiStatus==$MIDISTATUS_CC && kMidiData1==$MIDICC_MODWHEEL) then
    ; scale ctroller 1 (mod wheel) 0/1
    kMidiMod = (kMidiData2/127)
  endif

  ; watch for changes to start reinit for table regeneration
  kBendMax chnget "BendUpAmt"
  kBendMin chnget "BendDownAmt"
  if(changed(kBendMax,kBendMin)==1) then
    reinit ReinitRemapTable
  endif

  ReinitRemapTable:
    iBendMax = semitone(chnget("BendUpAmt"))
    iBendMin = semitone(-1*chnget("BendDownAmt"))

    ; generate and apply remap function table

    ; iTable ftgenonce $FLEX_PCHBEND_TABLE, 0, 129, -7, .5, 64, 1, 64, 2

    ; linear table for bend
    iTable ftgentmp $FLEX_PCHBEND_TABLE, 0, 8193, -7, iBendMin, 4096, 1, 4096, iBendMax

    ; exponential table for bend
    ; iTable ftgentmp $FLEX_PCHBEND_TABLE, 0, 8193, -5, iBendMin, 4096, 1, 4096, iBendMax

    ; terminate the reinit section
    rireturn

  kBend tablei kMidiBend, iTable, 1

  kDCO = .01*chnget:k("DCO")
  kVCA = .01*chnget:k("VCA")
  kAUX = .01*chnget:k("AUX")

  kModDCO chnget "ModDCO"
  kModVCA chnget "ModVCA"
  kModAUX chnget "ModAUX"
  kModLFO chnget "ModLFO"
  printk2 kDCO
  kLFORate chnget "LFORate"
  kLFOShape chnget "LFOShape"

  ; printk2 kModLFO
  kLFORate = (kLFORate*kMidiMod*kModLFO)+(kLFORate*(1-kModLFO))
  kLFORate = max(.01, kLFORate)

  if(changed(kLFOShape)==1) then
    reinit ReinitLFO
  endif

  ReinitLFO:
    iLFOShape chnget "LFOShape"
    iLFOShape = iLFOShape>0 ? iLFOShape-1 : 0
    print iLFOShape
    kLFO lfo .5, kLFORate, iLFOShape
    ; aLFO lfo .5 kLFORate, iLFOShape
    rireturn

  ; grab DCO first so it scales to +/- .5
  kModDCO ntrpol 1-(kDCO*kLFO), 1-(kLFO*kDCO*kMidiMod), kModDCO

  ; now scale to 0/1
  kLFO+=.5

  gkModAmp ntrpol 1-(kVCA*kLFO), 1-(kLFO*kVCA*kMidiMod), kModVCA
  gkModAux ntrpol 1-(kAUX*kLFO), 1-(kLFO*kAUX*kMidiMod), kModAUX

  kTuneOctaves chnget "octaves"
  kTuneSemitones chnget "semitones"
  kTuneCents  chnget "cents"
  kTuneCombo = cent(kTuneCents+(kTuneSemitones*100)+(kTuneOctaves*1200))
  gkPchBend = kModDCO*kBend*kTuneCombo

  ; gkPchBend = kBend*(1-(kLFO*kDCO*kMidiMod))
  ; gkModAmp = 1-(kLFO*kVCA*kMidiMod)
  ; gkModAux = 1-(kLFO*kAUX*kMidiMod)
  gkModWheel = kMidiMod

  ; printk .1, gkModAux
  ; printk .1, kLFORate
endin

#endif

