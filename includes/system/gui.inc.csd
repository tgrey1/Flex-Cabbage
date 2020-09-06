; safety check, doesn't allow double include!
#ifndef FLEX_INCL_GUI
#define FLEX_INCL_GUI ##
/***************
 ***************

gui.inc.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is a gui include file.  It defines common
gui procedures in UDO and instruments

***************
***************/

; this is the order files are included:
#include "includes/settings.inc.csd"

; a manual update
opcode UpdateLabel,0,kS
  kVal,SIdentChanName xin
  if $ON_UI_TICK then
    if changed(kVal)==1 then
      chnset sprintfk("text(%d)",kVal), SIdentChanName
    endif
  endif
endop

opcode UpdateLabel,0,SS
  SVal,SIdentChanName xin
  if $ON_UI_TICK then
    if changed(SVal)==1 then
      chnset sprintfk("text(%s)",SVal), SIdentChanName
    endif
  endif
endop

; same as shape labels, but doesn't stamp "ms" at the end ;)
opcode GenLabels,0,kkS
  kMax,kMin,SChanPrefix xin
  if $ON_UI_TICK then
    if changed(kMax,kMin)==1 then
    ; TODO: work out to remove the - in the chan name
      chnset sprintfk("text(%4.2f)",kMax), strcat(SChanPrefix,"-label1-c")
      chnset sprintfk("text(%4.2f)",kMin), strcat(SChanPrefix,"-label2-c")
    endif
  endif
endop

; swaps widget text based on a channel name
opcode TextSwap,0,SSSS
    SOff, SOn, SChanName, SFlipChan xin
    kFlip chnget SFlipChan
    if $ON_UI_TICK then
      if (changed(kFlip)==1) then
        chnset sprintfk("text(\"%s\")",(kFlip==1) ? strcpyk(SOn) : strcpyk(SOff)), SChanName
      endif
    endif
endop

; swaps widget text based on a krate var
opcode TextSwap,0,SSSk
    SOff, SOn, SChanName, kFlip xin
    if $ON_UI_TICK then
      if (changed(kFlip)==1) then
        chnset sprintfk("text(\"%s\")",(kFlip==1) ? SOn : SOff), SChanName
      endif
    endif
endop

; opcode to change visiblility of a chan based on another chan's status
opcode VisPop,0,SS
  SIdentChanName, SBoolChanName xin

  kBool chnget SBoolChanName
  if $ON_UI_TICK then
    if changed(kBool)==1 then
      chnset sprintfk("visible(%d)",kBool), SIdentChanName
    endif
  endif
endop

; krate version
opcode VisPop,0,Sk
  SIdentChanName, kBool xin

  if $ON_UI_TICK then
    if changed(kBool)==1 then
      chnset sprintfk("visible(%d)",kBool), SIdentChanName
    endif
  endif
endop

#endif

