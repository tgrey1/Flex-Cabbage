/***************
 ***************


EXAMPLE_INSTR.csd
  by tgrey
REPL_VERSION
REPL_DATE

An advanced instrument for testing full level "GUI" functionality
All elements of a gui should be present, and audio is passed... but nothing happens.

This can also be the good basis for a new instrument.

; TODO: better / more up to date documentation, make this an example for other users to learn from!

***************
***************/

<Cabbage>
form caption("Advanced Example") size(1047,484), pluginID("test"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_midi.xml","plants/flexpan.xml","plants/flexadsr.xml","plants/flexsynthctl.xml", "plants/flexfx.xml"), $ROOT
; form caption("Advanced Example") size(1047,484), pluginID("test"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_midi.xml","plants/flexpan.xml", "plants/debug.xml","plants/flexadsr.xml", "plants/flexfx.xml"), $ROOT

  $GROUPBOX bounds(10,10,180,464) text("Pitch/Mod Wheel") {
    FlexSynthCtl bounds(0,0,180,464), namespace("flexsynthctl")
  }
  $GROUPBOX bounds(194, 10, 609, 80), text("In / Out"), plant("io") {
TestButtons bounds(10,2,126,18), namespace("test_midi")

    FlexClip bounds(325,5,25,10), channel("outOL-"), namespace("flexclip")
    $GAIN_KNOB bounds(200, 25, 50, 50), channel("velcurve"), range(-100, 100, 25, 1, 0.01), text("Vel")
    $GAIN_KNOB $GAIN_RANGE, bounds(254, 25, 50, 50), channel("gain"), text("Gain"), popupprefix("Gain: "), popuppostfix(" dB")
    FlexPan bounds(304,25,50,50), namespace("flexpan")
  }

  $GROUPBOX bounds(194, 94, 360, 296), text("GUI"), plant("controls") {
  }

  $GROUPBOX bounds(558, 94, 245, 296), text("Envelope Ctrl"), plant("env") {
    ADSR bounds(10,30,225,256), channel("MainEnv"), namespace("ADSR")
  },

  $GROUPBOX bounds(807,10,230,464), text(" FX:") {
    FlexFX bounds(0,0,230,464), channel("flexfx-"), namespace("flexfx")
  }

  $KEYBOARD bounds(194,394,609,80)

Debug bounds(0,274,400,10), namespace("debug")


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

; Initialize a table to "graph size" for use in ADSR display
; graph size is far smaller than shape size
; to save cycles on tables getting displayed only
InitTable 1, $GRAPH_SIZE

instr Synth,1
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
  
  ; Call output of FlexADSR widgets with a channel name of "MainEnv"
  aEnv FlexADSR "MainEnv"

  ; apply ADSR envelope and cut volume in half since it's going to be routed to both left and right
  aSig *= aEnv*.5

  ; Mixing output into channels "SynthLeft" and "SynthRight" sends out to the global accumulator
  ; Clipping and overall gain is automatically handled here
  ; Optional FlexFX sends and FlexPan are automatically handled here too
  chnmix aSig, "SynthLeft"
  chnmix aSig, "SynthRight"
 endin

; Optional Gui instrument to handle background changes.
; This instrument (because it is named "Gui") will automatically be started with alwayson if it exists
; For synths, this allows the Gui to update even when notes aren't playing
; For effects, this allows code related to gui updating to be organized separately from audio/processing code
instr Gui
  FlexADSR_Mon "MainEnv", 1
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
