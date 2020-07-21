; safety check, doesn't allow double include!
#ifndef FLEX_INCL_SHAPE
#define FLEX_INCL_SHAPE ##
/***************
 ***************

shape.inc.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the shape file with specialzed functions for generating
  shapes and tracking them visually as LFO/VCOs

***************
***************/
;
; better doc of what to do to use goes here...
;
;
;
; TODO: should some of the table UDOs be split out to table.udo.csd etc to keep this simple, like window.inc.csd?
; TODO: some of this can also be moved into shaper.xml stuff...

#include "includes/settings.inc.csd"

gkPulseWidth init 50

; Shape values, these should match the order of combobox options
#define W_SINE      #1#
#define W_LINE      #2#
#define W_PYRAMID   #3#
#define W_TRIANGLE  #4#
#define W_PULSE     #5#
#define W_SAW       #6#
#define W_RSAW      #7#
#define W_SINEEXT   #8#
#define W_G13POLY   #9#
#define W_G14POLY   #10#
#define W_EVEN      #11#
#define W_ODD       #12#
#define W_808       #13#
#define W_808EXT    #14#
#define W_SQUARE    #15#
#define W_NOISE     #16#
#define W_MORPH     #17#

; Util tables - these need to be numbered, but shouldn't appear in a combobox.  used for internal purposes.
#define W_MORPHLIST #18#
#define W_MORPH1    #19#
#define W_MORPH2    #20#
#define W_MORPH3    #21#
#define W_MORPH4    #22#

#define W_TEMP      #23#


; TODO: a lot of this should get moved into shaper
gigen10shapes[]         fillarray $W_SINE, $W_808
; gigen9shapes[]          fillarray $W_EVEN, $W_ODD, $W_SINEEXT, $W_808EXT
gi1segshapes[]          fillarray $W_LINE
gi2segshapes[]          fillarray $W_PYRAMID
gi3segshapes[]          fillarray $W_TRIANGLE, $W_SQUARE, $W_SAW, $W_RSAW

gishape_menu_default[]  fillarray 0, $W_SINE, $W_LINE, $W_PYRAMID, $W_TRIANGLE, $W_SQUARE, \
  $W_PULSE, $W_SAW, $W_RSAW, $W_EVEN, $W_ODD, $W_SINEEXT, $W_G13POLY, $W_G14POLY, $W_NOISE, \
  $W_MORPH

; Basic "Pure" Waveforms for simple LFO and util use
giSine      ftgen   $SHAPE_FTNUM_OFFSET+$W_SINE       , 0, $TABLE_SIZE, 10, 1
giTriangle  ftgen   $SHAPE_FTNUM_OFFSET+$W_TRIANGLE   , 0, $TABLE_SIZE, 7, 0, $TABLE_QUARTER_SIZE, 1, $TABLE_HALF_SIZE, -1, $TABLE_QUARTER_SIZE, 0
giSaw       ftgen   $SHAPE_FTNUM_OFFSET+$W_SAW        , 0, $TABLE_SIZE, 7, 0, $TABLE_HALF_SIZE, 1, 0, -1, $TABLE_HALF_SIZE, 0
giSquare    ftgen   $SHAPE_FTNUM_OFFSET+$W_SQUARE     , 0, $TABLE_SIZE, 7, 1, $TABLE_HALF_SIZE, 1, 0, -1, $TABLE_HALF_SIZE, -1
giPulse     ftgen   $SHAPE_FTNUM_OFFSET+$W_PULSE      , 0, $TABLE_SIZE, 7, 1, $TABLE_HALF_SIZE, 1, 0, -1, $TABLE_HALF_SIZE, -1
giRSaw      ftgen   $SHAPE_FTNUM_OFFSET+$W_RSAW       , 0, $TABLE_SIZE, 7, 0, $TABLE_HALF_SIZE, -1, 0, 1, $TABLE_HALF_SIZE, 0
; giLine11 ftgen $SHAPE_FTNUM_OFFSET+$W_LINE, 0, $TABLE_SIZE, 7, -1, $TABLE_SIZE, 1
; giLine01 ftgen $SHAPE_FTNUM_OFFSET+8, 0, $TABLE_SIZE, 7, 0, $TABLE_SIZE, 1

giMorphList ftgen   $SHAPE_FTNUM_OFFSET+$W_MORPHLIST  , 0, 4, -2, giSine, giTriangle, giSaw, giSquare

; Temp table is only used for shaper... should probably be moved there.
giTempTable ftgen   $SHAPE_FTNUM_OFFSET+$W_TEMP       , 0, $TABLE_SIZE, 10, 1

; matrix array of tables used for morphing
giMorph1    ftgen   $SHAPE_FTNUM_OFFSET+$W_MORPH1     , 0, 8, -2, giSine, giSine, giSine, giTriangle, giSine, giSaw, giSine, giSquare
giMorph2    ftgen   $SHAPE_FTNUM_OFFSET+$W_MORPH2     , 0, 8, -2, giTriangle, giSine, giTriangle, giTriangle, giTriangle, giSaw, giTriangle, giSquare
giMorph3    ftgen   $SHAPE_FTNUM_OFFSET+$W_MORPH3     , 0, 8, -2, giSaw, giSine, giSaw, giTriangle, giSaw, giSaw, giSaw, giSquare
giMorph4    ftgen   $SHAPE_FTNUM_OFFSET+$W_MORPH4     , 0, 8, -2, giSquare, giSine, giSquare, giTriangle, giSquare, giSaw, giSquare, giSquare


; should this be included somewhere?  how does it sound?
; TODO: if keeping, make it size dynamic
;Tube Distortion from Hans Mikelson\\\'s multi-effects
; borrowed from http://www.csounds.com/udo/displayOpcode.php?opcode_id=57
giTube ftgen 66, 0,  8193, 7, -.8, 934, -.79, 934, -.77, 934, -.64, 1034, -.48, 520, .47, 2300, .48, 1536, .48 


; TODO: should these be moved to a table.udo file?  probably!
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

  ; calc multiplier here
  iGain = 1/iMaxVal
  print iGain

  iIndex2 init 0
  loop_start2:
    iVal table iIndex2, iFT, 0
    tableiw iVal*iGain, iIndex2, iFT
  loop_lt iIndex2, 1, iLen, loop_start2
endop

; opcode to limit min and max of a table, and rescale it afterwards
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

; opcode to limit min and max of a table, and rescale it afterwards
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

#endif

