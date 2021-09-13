; safety check, doesn't allow double include!
#ifndef FLEX_UDO_TABLE
#define FLEX_UDO_TABLE ##
/***************
 ***************

table.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the file with specialzed functions related to table
initializing and altering

***************
***************/
;
; better doc of what to do to use goes here...
;
;
;

#include "includes/settings.inc.csd"

; opcode to normalize min and max of a table
opcode TableNorm,0,i
  iFT xin
  iLen ftlen iFT
  iIndex init 0
  iMaxVal init 0
  loop_start:
    iVal table iIndex, iFT, 0
    iMaxVal = iVal > iMaxVal ? iVal : iMaxVal
  loop_lt iIndex, 1, iLen, loop_start

  ; calculate multiplier here
  iGain = 1/iMaxVal
  print iGain

  iIndex2 init 0
  loop_start2:
    iVal table iIndex2, iFT, 0
    tableiw iVal*iGain, iIndex2, iFT
  loop_lt iIndex2, 1, iLen, loop_start2
endop

; opcode to limit min and max of a table, and reScale it afterwards
opcode TableCopy,0,ii
  iFtSrc, iFtDest xin
  iLen ftlen iFtSrc
  iIndex init 0
  loop_start:
    iVal table iIndex, iFtSrc, 0
    tableiw iVal, iIndex, iFtDest
  loop_lt iIndex, 1, iLen, loop_start
endop

; opcode to convert table from 0/1 to -1/1
; used for noise table
opcode TableUniToBi,0,i
  iFT xin
  iLen ftlen iFT
  iIndex init 0
  loop_start:
    iVal table iIndex, iFT, 0
    iVal = (iVal*2)-1
    tableiw iVal, iIndex, iFT
  loop_lt iIndex, 1, iLen, loop_start
endop

; opcode to limit min and max of a table, and apply post-reScale
opcode TableLimit,0,iiii
  iFT, iMin, iMax, iScale xin
  iLen ftlen iFT
  iIndex init 0
  loop_start:
    iVal table iIndex, iFT, 0
    iVal limit iVal, iMin, iMax
    iVal limit iVal*iScale, -1, 1
    tableiw iVal, iIndex, iFT
  loop_lt iIndex, 1, iLen, loop_start
endop

opcode TableMod,0,iii
  iFT, iMode, iAmt xin
  iAmt = (1-iAmt)
  iMakeup = 1/iAmt
  iLen ftlen iFT
  iIndex init 0
  loop_start:
    iVal table iIndex, iFT, 0
    if(iMode==2) then
      iVal mirror iVal, -iAmt, iAmt
    elseif(iMode==3) then
      iVal wrap iVal, -iAmt, iAmt
    else
      ; this hacky bypass section is to workaround noise from wrap even at -1:1
 ;     ioval=iVal
      iMakeup=1
    endif

    tableiw iVal*iMakeup, iIndex, iFT
  loop_lt iIndex, 1, iLen, loop_start
endop

; TODO: this can probably get replaced by ftset once that opcode makes it to main?
; if it ever does... hope so, nice opcode!

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

#endif

