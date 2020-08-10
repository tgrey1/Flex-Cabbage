; safety check, doesn't allow double include!
#ifndef FLEX_UDO_DELAYSAMP
#define FLEX_UDO_DELAYSAMP ##
/***************
 ***************

delaysamp.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is a file to include sample level delay line UDOs

***************
***************/

; UDO to delay by a specific number of samples
; krate versions with internal reinits
opcode DelaySamp,aa,aak
  aSigL, aSigR, kSamples xin
  setksmps 1

  if(changed(kSamples)==1) then
    reinit DelaySampReinit
  endif

  DelaySampReinit:
  iSamples = round(i(kSamples))
  if (iSamples>0) then
    kBufL[] init iSamples
    kBufR[] init iSamples

    aOutL shiftout kBufL
    aOutR shiftout kBufR

    kBufL shiftin aSigL
    kBufR shiftin aSigR
  else
    aOutL = aSigL
    aOutR = aSigR
  endif
  xout aOutL, aOutR
endop

opcode DelaySamp,a,ak
  aSig, kSamples xin
  setksmps 1

  if(changed(kSamples)==1) then
    reinit DelaySampReinit
  endif

  DelaySampReinit:
  iSamples = round(i(kSamples))
  if (iSamples>0) then
    kBuf[] init iSamples

    aOut shiftout kBuf

    kBuf shiftin aSig
  else
    aOut = aSig
  endif
  xout aOut
endop

; UDO to delay by a specific number of samples
; irate versions without reinits
opcode DelaySamp,aa,aai
  aSigL, aSigR, iSamples xin
  setksmps 1

  iSamples = round(i(iSamples))
  if (iSamples>0) then
    kBufL[] init iSamples
    kBufR[] init iSamples

    aOutL shiftout kBufL
    aOutR shiftout kBufR

    kBufL shiftin aSigL
    kBufR shiftin aSigR
  else
    aOutL = aSigL
    aOutR = aSigR
  endif
  xout aOutL, aOutR
endop

opcode DelaySamp,a,ai
  aSig, iSamples xin
  setksmps 1

  iSamples = round(i(iSamples))
  if (iSamples>0) then
    kBuf[] init iSamples

    aOut shiftout kBuf

    kBuf shiftin aSig
  else
    aOut = aSig
  endif
  xout aOut
endop

#endif
