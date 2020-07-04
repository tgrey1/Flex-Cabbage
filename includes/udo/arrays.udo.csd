; safety check, doesn't allow double include!
#ifndef FLEX_UDO_ARRAYS
#define FLEX_UDO_ARRAYS ##
/***************
 ***************

arrays.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the array UDO file, it typically gets included automatically
These are UDOs related to dealing with arrays

***************
***************/

opcode InArray,i,ii[]
  iNeedle, iInArray[] xin
  iLen lenarray iInArray
  iIndx = 0
  iFound = 0
  while (iIndx<iLen) do
    if (iNeedle == iInArray[iIndx]) then
      iFound = iFound+1
      iIndx=iLen ; exit early!
    endif
    iIndx = iIndx+1
  od
  xout iFound
endop

opcode InArray,k,ki[]
  kNeedle, iInArray[] xin
  kLen lenarray iInArray
  kIndx = 0
  kFound = 0
  while (kIndx<kLen) do
    if (kNeedle == iInArray[kIndx]) then
      kFound = kFound+1
      kIndx=kLen ; exit early!
    endif
    kIndx = kIndx+1
  od
  xout kFound
endop

opcode InArray,k,kk[]
  kNeedle, kInArray[] xin
  kLen lenarray kInArray
  kIndx = 0
  kFound = 0
  while (kIndx<kLen) do
    if (kNeedle == kInArray[kIndx]) then
      kFound = kFound+1
      kIndx=kLen ; exit early!
    endif
    kIndx = kIndx+1
  od
  xout kFound
endop


opcode ArrElCnt,k,ki[]
  kNeedle, iInArr[] xin
  kLen lenarray iInArr
  kIndx = 0
  kFound = 0
  while (kIndx<kLen) do
    if (kNeedle == iInArr[kIndx]) then
      kFound = kFound+1
    endif
    kIndx = kIndx+1
  od
  xout kFound
endop

opcode ArrElCnt,k,kk[]
  kNeedle, kInArray[] xin
  kLen lenarray kInArray
  kIndx = 0
  kFound = 0
  while (kIndx<kLen) do
    if (kNeedle == kInArray[kIndx]) then
      kFound = kFound+1
    endif
    kIndx = kIndx+1
  od
  xout kFound
endop

opcode ArrElCnt,i,ii[]
  iNeedle, iInArr[] xin
  iLen lenarray iInArr
  iIndex = 0
  iFound = 0
  while (iIndex<iLen) do
    if (iNeedle == iInArr[iIndex]) then
      iFound = iFound+1
    endif
    iIndex = iIndex+1
  od
  xout iFound
endop

#endif
