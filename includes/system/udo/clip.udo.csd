; safety check, doesn't allow double include!
#ifndef FLEXFX_UDO_CLIP
#define FLEXFX_UDO_CLIP ##
/***************
 ***************

clip.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the clip UDO file, it typically gets included automatically
These are UDOs related to dealing with clipping audio

***************
***************/

#include "includes/settings.inc.csd"
#include "includes/system/udo/ledtrig.udo.csd"

; This sets the default clip type if nothing has been set by the time this is included
; clip opcode notes:
;   selects the clipping method. The default is 0. The methods are:
;     0 = Bram de Jong method (default)
;     1 = sine clipping
;     2 = tanh clipping
#ifndef CLIP_TYPE
  #define CLIP_TYPE #2#
#endif

; If nothing has been set by the time this is included, clip at 0dbfs
#ifndef CLIP_LEV
  #define CLIP_LEV #0dbfs#
#end

#ifndef RMSHP
  #define RMSHP #50#
#endif

; opcode to clip to a certain level and report back if clipped
; mono version
opcode FlexClip,a,aS
  aSig, SChanPrefix xin
  iClipLev = ($CLIP_LEV<0) ? db($CLIP_LEV) : $CLIP_LEV
  kClip rms aSig, $RMSHP
  kClip = (kClip>=iClipLev) ? 1 : 0
  aSig clip aSig, $CLIP_TYPE, iClipLev
  ; if $ON_UI_TICK then
  ;   if (changed(kClip)==1) then
  ;     chnset sprintfk("visible(%d)",kClip), strcat(SChanPrefix,"clip-c")
  ;   endif
  ; endif
  LEDTrig kClip,strcat(SChanPrefix,"clip-c")
  xout aSig
endop

; opcode to clip to a certain level and report back if clipped
; stereo version
opcode FlexClip,aa,aaS
  aSigL, aSigR, SChanPrefix xin
  iClipLev = ($CLIP_LEV<0) ? db($CLIP_LEV) : $CLIP_LEV
  kClipL rms aSigL, $RMSHP
  kClipR rms aSigR, $RMSHP
  kClip = (kClipL>=iClipLev || kClipR>=iClipLev) ? 1 : 0
  aSigL clip aSigL, $CLIP_TYPE, iClipLev
  aSigR clip aSigR, $CLIP_TYPE, iClipLev
  ; if $ON_UI_TICK then
  ;   if (changed(kClip)==1) then
  ;     chnset sprintfk("visible(%d)",kClip), strcat(SChanPrefix,"clip-c")
  ;   endif
  ; endif
  LEDTrig kClip,strcat(SChanPrefix,"clip-c")

  xout aSigL, aSigR
endop


;;;;;; Versions without widget updates

; mono version
opcode FlexClip,a,a
  aSig xin
  iClipLev = ($CLIP_LEV<0) ? db($CLIP_LEV) : $CLIP_LEV
  aSig clip aSig, $CLIP_TYPE, iClipLev
  xout aSig
endop

; stereo version
opcode FlexClip,aa,aa
  aSigL, aSigR xin
  iClipLev = ($CLIP_LEV<0) ? db($CLIP_LEV) : $CLIP_LEV
  aSigL clip aSigL, $CLIP_TYPE, iClipLev
  aSigR clip aSigR, $CLIP_TYPE, iClipLev
  xout aSigL, aSigR
endop

#endif
