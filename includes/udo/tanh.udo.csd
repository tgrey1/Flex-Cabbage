; safety check, doesn't allow double include!
#ifndef FLEX_UDO_TANH
#define FLEX_UDO_TANH ##
/***************
 ***************

tanh.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is a file to include a simple tanh wrapper

***************
***************/


; The pre and post define how much presence the distortion has
; and how loud it will be.  It's a delicate balancing act.
; These default defines seem reasonable, and equate to:
; kTanPreDb = ampdb(ntrpol(-3, 50, kTanDrive))
; kTanPostDb = ampdb(ntrpol(3, -27, kTanDrive))
#define TANH_PRE_MIN #-3#
#define TANH_PRE_MAX #50#

#define TANH_POST_MIN #3#
#define TANH_POST_MAX #-27#

opcode TanH,aa,aak
  aSigL, aSigR, kTanDrive xin

    ; get drive val, calculate pre/post from it
    ; "0" gives a 3db cut at pre, and a 3db boost at post to reduce chance of clipping
    ; kTanDrive = .01*chnget:k(strcat(SChanPrefix,"dist-tanh"))
    kTanPreDb = ampdb(ntrpol($TANH_PRE_MIN, $TANH_PRE_MAX, kTanDrive))
    kTanPostDb = ampdb(ntrpol($TANH_POST_MIN, $TANH_POST_MAX, kTanDrive))

    ; this is an attempt at balancing the signal automagically
    aSigL *= kTanPreDb
    aSigR *= kTanPreDb

    aSigL tanh aSigL
    aSigR tanh aSigR

    ; post balancing too
    aSigL *= kTanPostDb
    aSigR *= kTanPostDb

  xout aSigL, aSigR
endop

opcode TanH,a,ak
  aSig, kTanDrive xin

    ; get drive val, calculate pre/post from it
    ; "0" gives a 3db cut at pre, and a 3db boost at post to reduce chance of clipping
    ; kTanDrive = .01*chnget:k(strcat(SChanPrefix,"dist-tanh"))
    kTanPreDb = ampdb(ntrpol($TANH_PRE_MIN, $TANH_PRE_MAX, kTanDrive))
    kTanPostDb = ampdb(ntrpol($TANH_POST_MIN, $TANH_POST_MAX, kTanDrive))

    ; this is an attempt at balancing the signal automagically
    aSig *= kTanPreDb

    aSig tanh aSig

    ; post balancing too
    aSig *= kTanPostDb

  xout aSig
endop

#endif
