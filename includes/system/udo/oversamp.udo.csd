; safety check, doesn't allow double include!
#ifndef FLEX_UDO_OVERSAMP
#define FLEX_UDO_OVERSAMP ##
/***************
 ***************

oversamp.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This file adds a UDO to oversamp a channel to a-rate 
while still allowing it to be controlled at a krate

***************
***************/

; this is the order files are included:
#include "includes/settings.inc.csd"

; Read in a channel at oversampled krate
; Alternate method for a-rate channels without having to pre-declare
; The idea here is to allow reading channels
opcode OverSamp,a,S
  SChanName xin
  setksmps 1
  kIn chnget SChanName
  xout a(kIn)
endop

#endif

