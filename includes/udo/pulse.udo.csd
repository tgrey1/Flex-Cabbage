; safety check, doesn't allow double include!
#ifndef FLEX_UDO_PULSE
#define FLEX_UDO_PULSE ##
/***************
 ***************

pulse.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is a file to include automatic pulse width ftable generation

***************
***************/

; Only needed for $GRAPH_SIZE setting
#include "includes/settings.inc.csd"
; Otherwise:
; #define GRAPH_SIZE #8193#

; draws a pure pulse wave given a width and table
; ; draws a pure pulse wave given a width
opcode DrawPulse,i,i
    iWidth xin
    iSeg1 = $GRAPH_SIZE*(iWidth*.01)
    iSeg2 = $GRAPH_SIZE-iSeg1
    iFTNum ftgen 0, 0, $GRAPH_SIZE, 7, 1, iSeg1, 1, 0, 0, iSeg2, 0
    xout iFTNum
endop

; draws a pure pulse wave given a width and table
opcode DrawPulse,i,k
    kWidth xin

    iPulseTable ftgen 0, 0, $GRAPH_SIZE, 10, 1

    if(changed(kWidth)==1) then
      reinit DrawPulseReinit
    endif
    DrawPulseReinit:
    iWidth = i(kWidth)
    iSeg1 = $GRAPH_SIZE*(iWidth*.01)
    iSeg2 = $GRAPH_SIZE-iSeg1
    iFTNum ftgen iPulseTable, 0, $GRAPH_SIZE, 7, 1, iSeg1, 1, 0, 0, iSeg2, 0
    rireturn
    xout iFTNum
endop

; draws a pure pulse wave given a width and table
; this version takes in channel name that will be read for pulse width
opcode DrawPulse,i,S
    SChanName xin

    iPulseTable ftgen 0, 0, $GRAPH_SIZE, 10, 1

    kWidth chnget SChanName
    if(changed(kWidth)==1) then
      reinit DrawPulseReinit
    endif
    DrawPulseReinit:
    iWidth chnget SChanName
    iSeg1 = $GRAPH_SIZE*(iWidth*.01)
    iSeg2 = $GRAPH_SIZE-iSeg1
    iFTNum ftgen iPulseTable, 0, $GRAPH_SIZE, 7, 1, iSeg1, 1, 0, 0, iSeg2, 0
    rireturn
    xout iFTNum
endop

#endif
