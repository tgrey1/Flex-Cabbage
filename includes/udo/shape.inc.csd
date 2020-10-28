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

This is the shape file that creates standard shape tables

***************
***************/
;
; better doc of what to do to use goes here...
;
;
;

#include "includes/settings.inc.csd"

; Basic "Pure" Waveforms for simple LFO and util use
giSine      ftgen   $SHAPE_FTNUM_OFFSET   , 0, $TABLE_SIZE, 10, 1
giTriangle  ftgen   $SHAPE_FTNUM_OFFSET+1 , 0, $TABLE_SIZE, 7, 0, $TABLE_QUARTER_SIZE, 1, $TABLE_HALF_SIZE, -1, $TABLE_QUARTER_SIZE, 0
giSaw       ftgen   $SHAPE_FTNUM_OFFSET+2 , 0, $TABLE_SIZE, 7, 0, $TABLE_HALF_SIZE, 1, 0, -1, $TABLE_HALF_SIZE, 0
giSquare    ftgen   $SHAPE_FTNUM_OFFSET+3 , 0, $TABLE_SIZE, 7, 1, $TABLE_HALF_SIZE, 1, 0, -1, $TABLE_HALF_SIZE, -1
giPulse     ftgen   $SHAPE_FTNUM_OFFSET+4 , 0, $TABLE_SIZE, 7, 1, $TABLE_HALF_SIZE, 1, 0, -1, $TABLE_HALF_SIZE, -1
giRSaw      ftgen   $SHAPE_FTNUM_OFFSET+5 , 0, $TABLE_SIZE, 7, 0, $TABLE_HALF_SIZE, -1, 0, 1, $TABLE_HALF_SIZE, 0
; giLine11 ftgen $SHAPE_FTNUM_OFFSET+$W_LINE, 0, $TABLE_SIZE, 7, -1, $TABLE_SIZE, 1
; giLine01 ftgen $SHAPE_FTNUM_OFFSET+8, 0, $TABLE_SIZE, 7, 0, $TABLE_SIZE, 1



; should this be included somewhere?  how does it sound?
; TODO: if keeping, make it size dynamic
;Tube Distortion from Hans Mikelson\\\'s multi-effects
; borrowed from http://www.csounds.com/udo/displayOpcode.php?opcode_id=57
giTube ftgen 66, 0,  8193, 7, -.8, 934, -.79, 934, -.77, 934, -.64, 1034, -.48, 520, .47, 2300, .48, 1536, .48 

#endif

