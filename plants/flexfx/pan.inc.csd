; Common included predel elements
#ifndef FLEXPAN_INCL
 #define FLEXPAN_INCL ##


; these are used for determining pan mode button order
; changing numeric assignments changes order
#define FLEXPAN_MODE_SUB #0#
#define FLEXPAN_MODE_CON #1#
#define FLEXPAN_MODE_WIDTH #2#
#define FLEXPAN_MODE_BYPASS #3#

; used for looping through modes, should match highest pan mode
#define MAX_PAN_MODE #3#

#include "includes/settings.inc.csd"

; just in case this is deleted/commented from user settings
#ifndef DEFAULT_PAN_MODE
  #define DEFAULT_PAN_MODE #$FLEXPAN_MODE_BYPASS#
#endif

; overloaded version for mono inputs
opcode FlexPan,aa,aS
  aSig, SChanPrefix xin

  aOutL, aOutR FlexPan aSig, aSig, SChanPrefix
  xout aOutL, aOutR
endop

; for easily changing pan behavior of all instruments/effects
; TODO - this is not irate/note compatible (see thekicker)
; always reinits to first mode
opcode FlexPan,aa,aaS
  aSigL, aSigR, SChanPrefix xin

  kPan chnget strcat(SChanPrefix, "pan-val")
  kPan *= .01
  kPan limit kPan, -1, 1

  kButton chnget strcat(SChanPrefix, "pan-mode")
  kMode init $DEFAULT_PAN_MODE
  kInit init 0
  if(changed(kButton)==1 && kButton==1) || kInit==0 then
    kMode = (kMode+(1*kInit)) % ($MAX_PAN_MODE+1)
    kInit = 1

    chnset sprintfk("visible(%d)",kMode==$FLEXPAN_MODE_BYPASS ? 0 : 1), strcat(SChanPrefix,"pan-val-c")
    if (kMode==$FLEXPAN_MODE_BYPASS) then
      SMsg strcpyk "No Pan"
    elseif(kMode==$FLEXPAN_MODE_CON) then
      SMsg strcpyk "Balance"
    elseif(kMode==$FLEXPAN_MODE_SUB) then
      SMsg strcpyk "Pan"
    elseif(kMode==$FLEXPAN_MODE_WIDTH) then
      SMsg strcpyk "Width"
    endif
    chnset sprintfk("text(%s)",SMsg), strcat(SChanPrefix,"pan-mode-c")
  endif

  if (kMode==$FLEXPAN_MODE_BYPASS) then
    aOutL = aSigL
    aOutR = aSigR
  elseif (kMode==$FLEXPAN_MODE_SUB) then
    kPan = $BI_TO_UNI(kPan)

    aOutL = aSigL * (1-kPan)
    aOutR = aSigR * kPan

; analysis not needed due to limit above, if it works... test!!!
;    aOutL = aSigL * min(abs(kPan-1),1)
;    aOutR = aSigR * min(abs(kPan+1),1)
; ; TODO: analyze this! is this better?
; #define PANL(s'p) #$s*min(abs($p-1),1)#
; #define PANR(s'p) #$s*min(abs($p+1),1)#

  elseif (kMode==$FLEXPAN_MODE_WIDTH) then
    kPan = $BI_TO_UNI(kPan)

    aleftL = aSigL*kPan
    aleftR = aSigL*(1-kPan)
    arightL = aSigR*(1-kPan)
    arightR = aSigR*kPan

    aOutL = aleftL+arightL
    aOutR = aleftR+arightR
  else ; fall through to $FLEXPAN_MODE_CON

; TODO work these back in and grep out other pan/bal macros elsewhere

;    aOutL = $BALL(aSigL'aSigR'kPan)
;    aOutR = $BALR(aSigL'aSigR'kPan)
;    aOutL = $PANL(aSigL'kPan)  *.75+(aSigR*max(0,(kPan*-.25)))
;    aOutR = $PANR(aSigR'kPan)  *.75+(aSigL*max(0,(kPan*.25)))

    aOutL = (aSigL*abs((kPan-1)*.5 ))  *.75+(aSigR*max(0,(kPan*-.25)))
    aOutR = (aSigR*abs((kPan+1)*.5))  *.75+(aSigL*max(0,(kPan*.25)))
  endif

  xout aOutL, aOutR
endop

; overloaded stereo version for no channel name
opcode FlexPan,aa,aa
  aSigL, aSigR xin
  aOutL, aOutR FlexPan aSigL, aSigR, ""
  xout aOutL, aOutR
endop

; a version of FlexPan that splits the gui and processing, meant for
; irate instruments like synths etc
; overloaded version for mono inputs
opcode FlexPanInstr,aa,aS
  aSig, SChanPrefix xin

  aOutL, aOutR FlexPanInstr aSig, aSig, SChanPrefix
  xout aOutL, aOutR
endop

opcode FlexPanInstr,aa,aaS
  aSigL, aSigR, SChanPrefix xin

  kPan chnget strcat(SChanPrefix, "pan-val")
  kPan *= .01

  kMode chnget strcat(SChanPrefix,"pan-currentmode")

  if (kMode==$FLEXPAN_MODE_BYPASS) then
    aOutL = aSigL
    aOutR = aSigR
  elseif (kMode==$FLEXPAN_MODE_SUB) then
    kPan = $BI_TO_UNI(kPan)

    aOutL = aSigL * (1-kPan)
    aOutR = aSigR * kPan
  elseif (kMode==$FLEXPAN_MODE_WIDTH) then
    kPan = $BI_TO_UNI(kPan)

    aleftL = aSigL*kPan
    aleftR = aSigL*(1-kPan)
    arightL = aSigR*(1-kPan)
    arightR = aSigR*kPan

    aOutL = aleftL+arightL
    aOutR = aleftR+arightR
  else
  ; fall through to $FLEXPAN_MODE_CON

; TODO work these back in and grep out pan/bal macros elsewhere

;    aOutL = $BALL(aSigL'aSigR'kPan)
;    aOutR = $BALR(aSigL'aSigR'kPan)
;    aOutL = $PANL(aSigL'kPan)  *.75+(aSigR*max(0,(kPan*-.25)))
;    aOutR = $PANR(aSigR'kPan)  *.75+(aSigL*max(0,(kPan*.25)))

    aOutL = (aSigL*abs((kPan-1)*.5 ))  *.75+(aSigR*max(0,(kPan*-.25)))
    aOutR = (aSigR*abs((kPan+1)*.5))  *.75+(aSigL*max(0,(kPan*.25)))
  endif

  xout aOutL, aOutR
endop

opcode FlexPanInstr,aa,aa
  aSigL, aSigR xin
  aSigL, aSigR FlexPanInstr aSigL, aSigR, ""
  xout aSigL, aSigR
endop

; this is the GUI monitor part of the irate friendly FlexPanInstr
; meant for synths and stuff, only needed if not using FlexPan for FX returns in gui instr
opcode FlexPanMon,0,S
 SChanPrefix xin
  kButton chnget strcat(SChanPrefix, "pan-mode")
  kMode init $DEFAULT_PAN_MODE
  kInit init 0
  if(changed(kButton)==1 && kButton==1) || kInit==0 then
    kMode = (kMode+(1*kInit)) % ($MAX_PAN_MODE+1)
    kInit = 1

    chnset sprintfk("visible(%d)",kMode==$FLEXPAN_MODE_BYPASS ? 0 : 1), strcat(SChanPrefix,"pan-val-c")
    if (kMode==$FLEXPAN_MODE_BYPASS) then
      SMsg strcpyk "No Pan"
    elseif(kMode==$FLEXPAN_MODE_CON) then
      SMsg strcpyk "Balance"
    elseif(kMode==$FLEXPAN_MODE_SUB) then
      SMsg strcpyk "Pan"
    elseif(kMode==$FLEXPAN_MODE_WIDTH) then
      SMsg strcpyk "Width"
    endif
    chnset sprintfk("text(%s)",SMsg), strcat(SChanPrefix,"pan-mode-c")
    chnset kMode, strcat(SChanPrefix,"pan-currentmode")
  endif
endop

#endif

