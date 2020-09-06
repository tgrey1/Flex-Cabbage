; safety check, doesn't allow double include!
#ifndef FLEX_INCL_STANDARDS
#define FLEX_INCL_STANDARDS ##
/***************
 ***************

standards.inc.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the standard include file, it includes all other generic
files automatically and contains general GUI UDOs used throughout.

***************
***************/

; this is the order files are included:
#include "settings.inc.csd"
#include "system/gui.inc.csd"

; commonly used and available UDOs
; #include "system/udo/arrays.udo.csd"
; #include "system/udo/chans.udo.csd"
; #include "system/udo/audio.udo.csd"

; todo: part these out appropriately to effects and isntr
; #include "system/udo/testaudio.udo.csd"
; #include "system/udo/collapse.udo.csd"
; #include "system/udo/clip.udo.csd"

sr = $DEFAULT_SR
ksmps = $DEFAULT_KSMPS
nchnls = 2
0dbfs=$DEFAULT_0DBFS

#endif

