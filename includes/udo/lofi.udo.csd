; safety check, doesn't allow double include!
#ifndef FLEX_UDO_LOFI
#define FLEX_UDO_LOFI ##
/***************
 ***************

lofi.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is a file to include Iain McCurdy's LoFi UDO into Flex
Included is a stereo version as well, adapted by tgrey

***************
***************/

; This is Iain's opcode:
opcode  LoFi,a,akk
  aIn,kBits,kFold xin                 ;READ IN INPUT ARGUMENTS
  kValues   pow   2, kBits          ;RAISES 2 TO THE POWER OF kbitdepth. THE OUTPUT VALUE REPRESENTS THE NUMBER OF POSSIBLE VALUES AT THAT PARTICULAR BIT DEPTH
  aOut    = (int((aIn/0dbfs)*kValues))/kValues  ;BIT DEPTH REDUCE AUDIO SIGNAL
  aOut    fold  aOut, kFold             ;APPLY SAMPLING RATE FOLDOVER
    xout  aOut                  ;SEND AUDIO BACK TO CALLER INSTRUMENT
endop

; Modified stereo version:
opcode  LoFi,aa,aakk
  aInL, aInR,kBits,kFold xin                 ;READ IN INPUT ARGUMENTS
  kValues   pow   2, kBits          ;RAISES 2 TO THE POWER OF kbitdepth. THE OUTPUT VALUE REPRESENTS THE NUMBER OF POSSIBLE VALUES AT THAT PARTICULAR BIT DEPTH
  aOutL    = (int((aInL/0dbfs)*kValues))/kValues  ;BIT DEPTH REDUCE AUDIO SIGNAL
  aOutR    = (int((aInR/0dbfs)*kValues))/kValues  ;BIT DEPTH REDUCE AUDIO SIGNAL
  aOutL    fold  aOutL, kFold             ;APPLY SAMPLING RATE FOLDOVER
  aOutR    fold  aOutR, kFold             ;APPLY SAMPLING RATE FOLDOVER
    xout  aOutL, aOutR                  ;SEND AUDIO BACK TO CALLER INSTRUMENT
endop

#endif
