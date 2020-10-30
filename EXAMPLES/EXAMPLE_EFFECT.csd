/***************
 ***************


EXAMPLE_EFFECT.csd
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
;#define COMMON_IMPORTS "includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml"
;form caption("GUI Test") size(380,294), pluginID("tgui"), import($COMMON_IMPORTS), $ROOT

form caption("Example") size(380,294), pluginID("test"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml"), $ROOT

  groupbox $BOX bounds(10, 10, 360, 80), text("In / Out") {  
    FlexClip bounds(10,5,25,10), namespace("flexclip"), $IN_OL
    FlexClip bounds(325,5,25,10), namespace("flexclip"), $OUT_OL
    StereoCollapse bounds(8,55,100,18), namespace("collapse")
    rslider $RED_KNOB bounds(254, 25, 50, 50), $MAIN_GAIN
    FlexPan bounds(304,25,50,50), namespace("flexpan"), $MAIN_PAN
  }

  groupbox $BOX bounds(10, 94, 360, 190), text("GUI") {

  }
$BYPASS_SHADER size( $SCREEN_WIDTH, $SCREEN_HEIGHT)
TestButtons bounds(56,12,126,18), namespace("test_audio")
checkbox $GREEN_CC bounds(20, 35, 90, 25), $MAIN_BYPASS

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>
; All effects should start by including effect.inc.csd
; this starts an audio accumulator for handling global gain, clip, pan, bypass, etc
; This also starts the Bypass monitor, which activates the bypass overlay when the global bypass is enabled.
#include "includes/effect.inc.csd"

instr Effect
  ; mutes audio input for safety if DISABLE_AUDIO_INPUT is set
  ; This macro expands to empty text unless disabling audio input is on in settings
  ; Automatically disabled for exported plugins, no need to change 
  ; collapses to mono options based off buttons
  aInL, aInR FlexEffectIns

  ; TODO: THIS NEEDS TO BE MOVED INTO COMMET ABOVE
  ; enables audio test buttons if TEST_AUDIO is set (which always turns on if DEBUG is set)
  ; then generates test audio if triggered with buttons



  ; these dry backups are used for wet/dry mix
  ; so it will be clipped/collapsed test audio rather than pure input
  aDryL = aSigL
  aDryR = aSigR

  ; dry/wet balance snippet
  ; kDryWet = .01*chnget:k("drywet")
  ; kDryWet = $BI_TO_UNI(kDryWet)
  ; aSigL = ntrpol(aDryL,aSigL,kDryWet)
  ; aSigR = ntrpol(aDryR,aSigR,kDryWet)

  ; This is an output handler for effects.
  ; First it applies pan in there's a global FlexPan widget, if not it acts as "disabled" pan
  ; Next it applies gain based on channel("gain"), pass in decibel numbers, so -3 gives a 3db cut.  if widget isn't there, 0db has no effect.
  ; Next it sends audio to check for clipping, apply a hard limiter for safety, and send clip status to "outOL-" FlexClip widget, if it exists.
  ; Finally, it looks for a channel("bypass"), and when enabled swaps back to the set of "dry" inputs saved with the input.
  ; also activates the bypass overlay, if it exists.
  FlexEffectOuts aSigL, aSigR
endin

; Optional Gui instrument to handle background changes.
; This instrument (because it is named "Gui") will automatically be started with alwayson if it exists
; For synths, this allows the Gui to update even when notes aren't playing
; For effects, this allows code related to gui updating to be organized separately from audio/processing code
; instr Gui
; endin
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
