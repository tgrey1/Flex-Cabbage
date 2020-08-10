; safety check, doesn't allow double include!
#ifndef FLEX_UDO_ROUND
#define FLEX_UDO_ROUND ##
/***************
 ***************

round.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

UDO to round, since round() can not be relied upon across systems and versions
first argument gets rounded based on the mode of optional second argument
if second argument is omitted or is 0, use system's default round() behavior
any positive value as second argument will make .5 always round up
any negative value as second argument will make .5 always round down

***************
***************/

; i-rate
opcode Round,i,io
    iVal, iRoundType xin
    if iRoundType>0 then
        iVal = (frac(iVal) < 0.5 ? int(iVal) : int(iVal) + 1)
    elseif iRoundType<0 then
        iVal = (frac(iVal) <= 0.5 ? int(iVal) : int(iVal) + 1)
    else
        iVal = round(iVal)
    endif
    xout iVal
endop

; k-rate
opcode Round,k,ko
    kVal, iRoundType xin
    if iRoundType>0 then
        kVal = (frac(kVal) < 0.5 ? int(kVal) : int(kVal) + 1)
    elseif iRoundType<0 then
        kVal = (frac(kVal) <= 0.5 ? int(kVal) : int(kVal) + 1)
    else
        kVal = round(kVal)
    endif
    xout kVal
endop

#endif
