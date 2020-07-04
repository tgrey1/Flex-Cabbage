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
#include "standards.inc.csd"

; This is needed because FlexEffectOut[s] uses FlexPan opcode
; TODO: move FlexPan code into global udo so it always works
#include "../plants/flexfx/pan.inc.csd"

opcode FlexEffectOut,0,a
  aSig xin
  ; TODO: make mono copy eventually
endop

opcode FlexEffectOuts,0,aa
  aSigL, aSigR xin
  kGainDb = ampdb(chnget:k("gain"))
  aDryL chnget "DryLeft"
  aDryR chnget "DryRight"
  chnclear "DryLeft"
  chnclear "DryRight"

  kBypass chnget "bypass"
  if $ON_UI_TICK then
    if (changed(kBypass)==1) then
      chnset strcpyk((kBypass==1) ? "visible(1)" : "visible(0)"), "bypass-shader"
    endif
  endif

  aSigL *= kGainDb
  aSigR *= kGainDb
  aSigL, aSigR FlexPan aSigL, aSigR
  aSigL, aSigR FlexClip aSigL, aSigR, "outOL-"
  aOutL, aOutR Bypass aDryL, aDryR, aSigL, aSigR
  outs aOutL, aOutR
endop

opcode FlexEffectIns,aa,0
  #ifdef DISABLE_AUDIO_INPUT
    aSigL = a(0)
    aSigR = a(0)
  #else
    aSigL inch 1
    aSigR inch 2
  #endif

  #ifdef TEST_AUDIO
    aSigL, aSigR TestAudio aSigL, aSigR
  #endif

  aSigL, aSigR FlexClip aSigL, aSigR, "inOL-"

  chnset  aSigL, "DryLeft"
  chnset  aSigR, "DryRight"
  xout aSigL,aSigR
endop

opcode FlexEffectIn,a,0
  #ifdef DISABLE_AUDIO_INPUT
    aSigL = a(0)
  #else
    aSigL inch 1
  #endif
  aSigR = aSigL

  #ifdef TEST_AUDIO
    aSigL, aSigR TestAudio aSigL, aSigR
  #endif

  aSigL += aSigR

  aSigL FlexClip aSigL, "inOL-"

  chnset  aSigL, "DryLeft"
  chnset  aSigL, "DryRight"
  xout aSigL
endop

#endif
