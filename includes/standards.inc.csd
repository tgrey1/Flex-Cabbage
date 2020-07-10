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
#include "system/user_settings.inc.csd"
#include "system/midi_cc.inc.csd"
#include "system/defines.inc.csd"
#include "system/midi.work.csd"

; commonly used and available UDOs
#include "system/udo/arrays.udo.csd"
#include "system/udo/chans.udo.csd"
#include "system/udo/audio.udo.csd"

; todo: part these out appropriately to effects and isntr
#include "system/udo/testaudio.udo.csd"
#include "system/udo/collapse.udo.csd"
#include "system/udo/clip.udo.csd"

; should this stuff get copied to both effect and synth.inc.csd?
; leaves standards for places like includes and xml files etc
#ifdef RENDER_QUAL
  #undef DEFAULT_KSMPS
  #define DEFAULT_KSMPS #1#
  #undef UI_TICKS
  #define UI_TICKS #1#
#endif

#ifdef DEFAULT_SR
  sr = $DEFAULT_SR
#endif
ksmps = $DEFAULT_KSMPS
nchnls = 2
0dbfs=$DEFAULT_0DBFS

alwayson "Init"
alwayson "Gui"
alwayson "Effect"

; disable all automatic midi sends
; these will be reset in synth.inc.csd
massign 0, 0

; Read in a channel at oversampled krate
; Alternate method for a-rate channels without having to pre-declare
opcode OverSamp,a,S
  SChanName xin
  setksmps 1
  kIn chnget SChanName
  xout a(kIn)
endop

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


; TODO: this can probably get replaced by ftset once that opcode makes it to main?
; if it ever does... hope so, nice opcode!
opcode OldInitTable,0,ij
  iFTNum, iShape xin
  iTmp ftgen iFTNum, 0, $TABLE_SIZE, 10, 1
  ; iTmp ftgen iFTNum, 0, $TABLE_SIZE, 7, 0, $TABLE_SIZE, 0
endop


; Opcode to init tables to the default $TABLE_SIZE for safe overwriting later
opcode InitTable,i,io
  iFTNum, iSize xin

  iSize = (iSize==0) ? $TABLE_SIZE : iSize
  iTmp ftgen iFTNum, 0, iSize, 10, 1
  ; iTmp ftgen iFTNum, 0, $TABLE_SIZE, 7, 0, $TABLE_SIZE, 0
  xout iTmp  
endop

opcode InitTable,0,io
  iFTNum, iSize xin

  iSize = (iSize==0) ? $TABLE_SIZE : iSize
  iTmp ftgen iFTNum, 0, iSize, 10, 1
  ; iTmp ftgen iFTNum, 0, $TABLE_SIZE, 7, 0, $TABLE_SIZE, 0
endop

; Opcode to init array tables
opcode InitTables,0,i[]o
  iFTArray[], iSize xin
  iSize = (iSize==0) ? $TABLE_SIZE : iSize

  iIndex=0
  iLen = lenarray(iFTArray)
  while (iIndex < iLen) do
    InitTable iFTArray[iIndex], iSize
    iIndex+=1
  od
endop

opcode OldInitTables,0,i[]
  iFTArray[] xin
  iIndex=0
  iLen = lenarray(iFTArray)
  while (iIndex < iLen) do
    InitTable iFTArray[iIndex]
    iIndex+=1
  od
endop

; opcode OnZero,k,S

; endop

; opcode OnZero,a,S

; endop

; opcode OnOne,k,S

; endop

; opcode OnOne,a,S

; endop



; TODO: report bug, if this code appears *after* version with output, it fails
opcode SnapBackPort,0,iiS
  iDefaultValue,iPortTime,SChanName xin
  kMouseDown chnget "MOUSE_DOWN_LEFT"
  kHold chnget strcat(SChanName,"hold")

  kValue init iDefaultValue
  if kMouseDown == 1 || kHold == 1 then
      kValue = chnget:k(SChanName)
      kSend = 0
  else
      kValue = iDefaultValue
      kSend = 1
  endif   
  kValue port kValue, iPortTime
  if kSend==1 then
    chnset kValue, SChanName
  endif
endop

opcode SnapBack,0,iS
  iDefaultValue,SChanName xin
  kMouseDown chnget "MOUSE_DOWN_LEFT"
  kHold chnget strcat(SChanName,"hold")
  if changed(kMouseDown,kHold)==1 && kMouseDown==0 && kHold==0 then
      chnset k(iDefaultValue), SChanName
  endif
endop







opcode SnapBack,k,iS
  iDefaultValue,SChanName xin
  kMouseDown chnget "MOUSE_DOWN_LEFT"
  kHold chnget strcat(SChanName,"hold")
  kValue init iDefaultValue
  if kMouseDown == 1 || kHold == 1 then
      kValue = chnget:k(SChanName)
  else
      chnset k(iDefaultValue), SChanName
      kValue = iDefaultValue
  endif   
  xout kValue
endop

opcode SnapBackPort,k,iiS
  iDefaultValue,iPortTime,SChanName xin
  kMouseDown chnget "MOUSE_DOWN_LEFT"
  kHold chnget strcat(SChanName,"hold")
  kValue init iDefaultValue
  if kMouseDown == 1 || kHold == 1 then
      kValue = chnget:k(SChanName)
      kSend = 0
  else
      kValue = iDefaultValue
      kSend = 1
  endif   
  kValue port kValue, iPortTime
  if kSend==1 then
    chnset kValue, SChanName
  endif

  xout kValue
endop
opcode SnapBackPort,a,iiS
  iDefaultValue,iPortTime,SChanName xin
  kMouseDown chnget "MOUSE_DOWN_LEFT"
  kHold chnget strcat(SChanName,"hold")
  aValue init iDefaultValue
  if kMouseDown == 1 || kHold == 1 then
      kValue = chnget:k(SChanName)
      aValue = a(kValue)
      kSend = 0
  else
      kValue = iDefaultValue
      kSend = 1
  endif   

  kValue port kValue, iPortTime
  aValue interp kValue
  if kSend==1 then
    chnset kValue, SChanName
  endif

  xout aValue
endop


#endif

