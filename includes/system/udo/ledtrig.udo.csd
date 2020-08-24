  ; safety check, doesn't allow double include!
#ifndef FLEX_UDO_LEDTRIG
#define FLEX_UDO_LEDTRIG ##
/***************
 ***************

ledtrig.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

UDO to light an LED widget and keep it lit for a predefined amount of time
This is to make sure widgets stay lit long enough to be seen
Loosely based on Steven Yi's gatesig UDO

***************
***************/

#include "includes/settings.inc.csd"

#ifndef LEDTIME
    #define LEDTIME #.1#
#endif

; original version of gatesig
; outputs:
;   none
; inputs:
;   ktrig: trigger when 1 will start or restart on signal for the hold time
;   SChanName: channel name of LED to light when triggered
opcode LEDTrig,0,kS
    ktrig, SChanName xin

  kcount init 0
  asig init 0

  kndx = 0
  iholdsamps = ($LEDTIME * sr) / ksmps

    if (ktrig == 1) then
      kcount = 0
    endif

    ktrig = (kcount < iholdsamps) ? 1 : 0 

    kndx += 1
    kcount += 1
    if (changed(ktrig)==1) then
        chnset sprintfk("visible(%d)",ktrig), SChanName
    endif
endop

#endif
