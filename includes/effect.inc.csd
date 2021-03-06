; safety check, doesn't allow double include!
#ifndef FLEX_INCL_EFFECT
#define FLEX_INCL_EFFECT ##
/***************
 ***************

effect.inc.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the effect file with specialzed functions for effects

***************
***************/

;
; better doc of what to do / how to use goes here...
;
;
;

; Make sure standards are already included
#include "includes/standards.inc.csd"

; commonly used and available UDOs
#include "includes/system/udo/arrays.udo.csd"
#include "includes/system/udo/chans.udo.csd"
#include "includes/system/udo/audio.udo.csd"
#include "includes/system/gui.inc.csd"

; todo: part these out appropriately to effects and isntr
#include "includes/system/udo/testaudio.udo.csd"
#include "includes/system/udo/collapse.udo.csd"
#include "includes/system/udo/clip.udo.csd"

; This is needed because FlexEffectOut[s] uses FlexPan opcode
; TODO: move FlexPan code into global udo so it always works
#include "plants/flexfx/pan.inc.csd"


alwayson "Init"
alwayson "Gui"
alwayson "Effect"


opcode FlexEffectOut,0,a
  aSig xin
  ; TODO: make mono copy eventually
endop

opcode FlexEffectOuts,0,aa
  aSigL, aSigR xin

  ; Midi control macros only expand if midi is enabled
  ; Having them here has them run for *ALL* instruments that include synth.inc.csd
  $GAIN_MIDI($MIDICC_GAIN'"MainGain")
  $PAN_MIDI($MIDICC_PAN'"MainPan")
  $DRYWET_MIDI($MIDICC_DRYWET'"MainDryWet")

  kGainDb = ampdb(chnget:k("MainGain"))
  aDryL chnget "DryLeft"
  aDryR chnget "DryRight"
  chnclear "DryLeft"
  chnclear "DryRight"

  kBypass chnget "bypass"
  FadeUI "bypass-shader", kBypass

  aSigL *= kGainDb
  aSigR *= kGainDb

  aSigL, aSigR FlexPan aSigL, aSigR, "MainPan"
  aSigL, aSigR FlexClip aSigL, aSigR, "outOL-"
  aOutL, aOutR Bypass aDryL, aDryR, aSigL, aSigR
  outs aOutL, aOutR
endop

; For effects that require stereo input
; this guarantees collapse by default, or selection via widget
opcode FlexEffectIns,aa,0
  #ifdef DISABLE_AUDIO_INPUT
    aSigL = a(0)
    aSigR = a(0)
  #else
    aSigL inch $INPUT_DEVICE_LEFT
    aSigR inch $INPUT_DEVICE_RIGHT
  #endif

  #ifdef TEST_AUDIO
    aSigL, aSigR TestAudio aSigL, aSigR
  #endif

  aSigL, aSigR FlexCollapse aSigL, aSigR, ""
  aSigL, aSigR FlexClip aSigL, aSigR, "inOL-"

  chnset  aSigL, "DryLeft"
  chnset  aSigR, "DryRight"
  xout aSigL,aSigR
endop

; For effects that require mono input
; this guarantees collapse by default, or selection via widget
opcode FlexEffectIn,a,0
  #ifdef DISABLE_AUDIO_INPUT
    aSigL = a(0)
    aSigR = a(0)
  #else
    aSigL inch $INPUT_DEVICE_LEFT
    aSigR inch $INPUT_DEVICE_RIGHT
  #endif

  #ifdef TEST_AUDIO
    aSigL, aSigR TestAudio aSigL, aSigR
  #endif

  aSig FlexCollapse aSigL, aSigR, ""
  aSig FlexClip aSig, "inOL-"

  chnset  aSig, "DryLeft"
  chnset  aSig, "DryRight"
  xout aSig
endop

; For effects that require mono input, but will end up stereo
; this guarantees collapse by default, or selection via widget
opcode FlexEffectIn,aa,0
  #ifdef DISABLE_AUDIO_INPUT
    aSigL = a(0)
    aSigR = a(0)
  #else
    aSigL inch $INPUT_DEVICE_LEFT
    aSigR inch $INPUT_DEVICE_RIGHT
  #endif

  #ifdef TEST_AUDIO
    aSigL, aSigR TestAudio aSigL, aSigR
  #endif

  aSig FlexCollapse aSigL, aSigR, ""
  aSig FlexClip aSig, "inOL-"

  chnset  aSig, "DryLeft"
  chnset  aSig, "DryRight"
  xout aSig, aSig
endop

#endif
