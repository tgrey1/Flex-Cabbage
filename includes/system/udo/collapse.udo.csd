; safety check, doesn't allow double include!
#ifndef FLEX_UDO_COLLAPSE
#define FLEX_UDO_COLLAPSE ##
/***************
 ***************

collapse.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the collapse UDO file, it typically gets included automatically
These are UDOs that collapse the stereo stream in different ways

***************
***************/

; Overloaded version to allow for no channel name called
; TODO: should this be cut for optimizaton
; opcode MonoCollapse,aa,aa
;   aSigL, aSigR xin

;   aSigL, aSigR MonoCollapse aSigL, aSigR, ""

;   xout aSigL, aSigR
; endop

; Version that loads global widgets
opcode MonoCollapse,aa,aa
  aInL, aInR xin

  kStereo chnget "mono-st"
  kInvert chnget "mono-inv"
  kLR chnget "mono-lr"
  kLeft chnget "mono-l"
  kRight chnget "mono-r"

  aSigL = aInL
  aSigR = aInR

  if (kInvert==1) then
    aSigR = aInL
    aSigL = aInR
  elseif (kLR==1) then
    aSigL = (aSigL+aSigR)*.5
    aSigR = aSigL
  elseif (kLeft==1) then
    aSigR = aSigL
  elseif (kRight==1) then
    aSigL = aSigR
  endif

  xout aSigL, aSigR
endop

; Version that loads named channel widgets
opcode MonoCollapse,aa,aaS
  aInL, aInR, SChanPrefix xin

  kStereo chnget strcat(SChanPrefix,"mono-st")
  kInvert chnget strcat(SChanPrefix,"mono-inv")
  kLR chnget strcat(SChanPrefix,"mono-lr")
  kLeft chnget strcat(SChanPrefix,"mono-l")
  kRight chnget strcat(SChanPrefix,"mono-r")

  aSigL = aInL
  aSigR = aInR

  if (kInvert==1) then
    aSigR = aInL
    aSigL = aInR
  elseif (kLR==1) then
    aSigL = (aSigL+aSigR)*.5
    aSigR = aSigL
  elseif (kLeft==1) then
    aSigR = aSigL
  elseif (kRight==1) then
    aSigL = aSigR
  endif

  xout aSigL, aSigR
endop

#endif

