/***************
 ***************


EXAMPLE_INSTR.csd
  by tgrey
REPL_VERSION
REPL_DATE

A simple instrument for testing the base level "GUI" functionality
All basics of a gui should be present, and audio is passed... but nothing happens.

This can also be the good basis for a new instrument.

; TODO: better / more up to date documentation, make this an example for other users to learn from!

***************
***************/

<Cabbage>
form caption("Example") size(380,294), pluginID("test"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_midi.xml","plants/flexpan.xml"), $ROOT

  $GROUPBOX bounds(10, 10, 360, 80), text("In / Out") {
    TestButtons bounds(10,2,126,18), namespace("test_midi")
    FlexClip bounds(325,5,25,10), namespace("flexclip"), $OUT_OL
    rslider $RED_KNOB bounds(200, 25, 50, 50), $MAIN_VEL
    rslider $RED_KNOB bounds(254, 25, 50, 50), $MAIN_GAIN
    FlexPan bounds(304,25,50,50), namespace("flexpan"), $MAIN_PAN
  }

  $GROUPBOX bounds(10, 94, 360, 190), text("GUI") {
    $KEYBOARD bounds(10,85,340,95)
  }

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; All synths should start by including synth.inc.csd
; this starts an audio accumulator for handling global gain, fx sends, pan, etc
; This also unmaps all midi channels from instruments and remaps only channel 1 to instr named "Synth"
; That will prevent additional instruments from accidentally getting triggered by activity on other channels
#include "includes/synth.inc.csd"

instr Synth
  ; FlexBaseAmp applies a simple linear velocity "curve" for global control
  ; These work even in abscence of widgets, as long as synth.inc.csd is included
  ; Currently opcode is very simple and could be avoided, but this allows for past/future
  ; changes to behavior across all projects using FlexCabbage
  iAmp FlexBaseAmp p5

  ; FlexBaseFreq pulls in global tuning/pitch/mod wheel data based on x-rate input (usually p4)
  ; This works even in abscence of widgets, as long as synth.inc.csd is included
  ; Currently opcode is very simple and could be avoided, but this allows for past/future
  ; changes to behavior across all projects using FlexCabbage
  kFreq FlexBaseFreq p4

  ; Make a signal with vco2, feed in amp and freq outputs from FlexBase opcodes
  aSig vco2 iAmp, kFreq

  ; just cutting volume in half since it's going to be routed to both left and right
  aSig *= .5

  ; Mixing output into channels "SynthLeft" and "SynthRight" sends out to the global accumulator
  ; Clipping and overall gain is automatically handled here
  ; Optional FlexFX sends and FlexPan are automatically handled here too
  chnmix aSig, "SynthLeft"
  chnmix aSig, "SynthRight"
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
