; safety check, doesn't allow double include!
#ifndef FLEX_UDO_RELIMITER
#define FLEX_UDO_RELIMITER ##
/***************
 ***************

relimiter.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

Custom limit/mirror/wrap wrapper by tgrey

***************
***************/

opcode ReLimiter,aa,aakkk
  aSigL, aSigR, kMode, kLow, kHigh xin

  if (kMode!=0) then
    if (kMode==1) then
      aSigL limit aSigL, kLow, kHigh
      aSigR limit aSigR, kLow, kHigh
    elseif (kMode==2) then
      aSigL mirror aSigL, kLow, kHigh
      aSigR mirror aSigR, kLow, kHigh
    elseif (kMode==3) then
      aSigL wrap aSigL, kLow, kHigh
      aSigR wrap aSigR, kLow, kHigh
    endif

    aSigL dcblock2 aSigL
    aSigR dcblock2 aSigR
  endif

  xout aSigL, aSigR
endop

opcode ReLimiter,a,akkk
  aSig, kMode, kLow, kHigh xin

  if (kMode!=0) then
    if (kMode==1) then
      aSig limit aSig, kLow, kHigh
    elseif (kMode==2) then
      aSig mirror aSig, kLow, kHigh
    elseif (kMode==3) then
      aSig wrap aSig, kLow, kHigh
    endif

    aSig dcblock2 aSig
  endif

  xout aSig
endop

#endif
