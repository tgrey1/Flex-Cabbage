/***************
 ***************


EXAMPLE_MIDI.csd
  by tgrey
REPL_VERSION
REPL_DATE

A simple instrument for testing the base level "GUI" functionality
All basics of a gui should be present, and audio is passed... but nothing happens.

This can also be the good basis for a new instrument.

; TODO: better / more up to date documentation, make this an example for other users to learn from!
; TODO: wet/dry as example
***************
***************/

<Cabbage>
form caption("Example") size(380,294), pluginID("test"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml", "plants/debug.xml"), $ROOT

  $GROUPBOX bounds(10, 10, 360, 80), text("In / Out"), plant("io") {
    FlexClip bounds(10,5,25,10), channel("inOL-"), namespace("flexclip")
    FlexClip bounds(325,5,25,10), channel("outOL-"), namespace("flexclip")
    StereoCollapse bounds(8,55,100,18), namespace("collapse")
    $GAIN_KNOB $GAIN_RANGE bounds(254, 25, 50, 50), channel("gain"), text("Gain"), popupprefix("Gain: "), popuppostfix(" dB")
  }

  $GROUPBOX bounds(10, 94, 360, 190), text("GUI"), plant("controls") {

  }
$BYPASS_SHADER size( $SCREEN_WIDTH, $SCREEN_HEIGHT)
TestButtons bounds(56,12,126,18), namespace("test_audio")
$GREEN_CCB bounds(20, 35, 90, 25), channel("bypass"), text("Bypass","Bypassed")

Debug bounds(0,274,400,10), namespace("debug")


</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>
#include "includes/standards.inc.csd"

instr Midi
endin

; this instr handles all gui changes
instr Gui
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
