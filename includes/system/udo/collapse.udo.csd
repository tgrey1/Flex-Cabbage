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

; Stereo version can collapse or flip
opcode FlexCollapse,aa,aaS
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

; Mono version always collapses
opcode FlexCollapse,a,aaS
  aInL, aInR, SChanPrefix xin

  kLeft chnget strcat(SChanPrefix,"mono-l")
  kRight chnget strcat(SChanPrefix,"mono-r")

  if (kLeft==1) then
    aSig = aInL
  elseif (kRight==1) then
    aSig = aInR
  else
    aSig = (aInL+aInR)*.5
  endif

  xout aSig
endop

#endif

