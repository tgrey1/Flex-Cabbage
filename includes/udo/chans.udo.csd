; safety check, doesn't allow double include!
#ifndef FLEX_UDO_CHANS
#define FLEX_UDO_CHANS ##
/***************
 ***************

chans.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the channel UDO file, it typically gets included automatically
These are UDOs related to dealing with channels

***************
***************/


; opcode to set multiple channels at once, pass in array of chan names
; optional arg defaults to 0, means start at the top of the array, and recurse down
; opcode MultiSetKS,0,kS[]o
;  kVal, Schnls[], iCnt xin
;  chnsetks kVal, Schnls[iCnt]
;  if iCnt < lenarray:i(Schnls)-1 then
;   MultiSetKS kVal, Schnls, iCnt+1
;  endif
; endop

; opcode MultiSetKS,0,aS[]o
;  aVal, Schnls[], iCnt xin
;  chnsetks aVal, Schnls[iCnt]
;  if iCnt < lenarray:i(Schnls)-1 then
;   MultiSetKS aVal, Schnls, iCnt+1
;  endif
; endop

opcode MultiSetKS,0,SS[]o
 SVal, Schnls[], iCnt xin
 chnsetks SVal, Schnls[iCnt]
 if iCnt < lenarray:i(Schnls)-1 then
  MultiSetKS SVal, Schnls, iCnt+1
 endif
endop

opcode MultiSet,0,iS[]o
 iVal, Schnls[], iCnt xin
 chnset iVal, Schnls[iCnt]
 if iCnt < lenarray:i(Schnls)-1 then
  MultiSet iVal, Schnls, iCnt+1
 endif
endop

opcode MultiSet,0,kS[]o
 kVal, Schnls[], iCnt xin
 chnset kVal, Schnls[iCnt]
 if iCnt < lenarray:i(Schnls)-1 then
  MultiSet kVal, Schnls, iCnt+1
 endif
endop

opcode MultiSet,0,aS[]o
 aVal, Schnls[], iCnt xin
 chnset aVal, Schnls[iCnt]
 if iCnt < lenarray:i(Schnls)-1 then
  MultiSet aVal, Schnls, iCnt+1
 endif
endop

opcode MultiSet,0,SS[]o
 SVal, Schnls[], iCnt xin
 chnset SVal, Schnls[iCnt]
 if iCnt < lenarray:i(Schnls)-1 then
  MultiSet SVal, Schnls, iCnt+1
 endif
endop

; link channels with same value
; inputs two chan names (*NOT* ident channels)
; and third argument is channel to link/unlink with
opcode LinkChans,0,SSS
  SChanName1, SChanName2, SLink xin

  kLink chnget SLink
  ; LinkChans SChanName1, SChanName2, kLink
  kChan1 chnget SChanName1
  kChan2 chnget SChanName2

  ; Adjust widgets if linked
  if (kLink==1) then
    if (changed(kChan1)==1 && (kChan1!=kChan2)) then
        chnset kChan1, SChanName2
    elseif (changed(kChan2)==1 && (kChan1!=kChan2)) then
        chnset kChan2, SChanName1
    endif
  endif
endop

opcode LinkChans,0,SSk
  SChanName1, SChanName2, kLink xin

  kChan1 chnget SChanName1
  kChan2 chnget SChanName2

  ; Adjust widgets if linked
  if (kLink==1) then
    if (changed(kChan1)==1 && (kChan1!=kChan2)) then
        chnset kChan1, SChanName2
    elseif (changed(kChan2)==1 && (kChan1!=kChan2)) then
        chnset kChan2, SChanName1
    endif
  endif
endop

; same as LinkChans but sets negative value
; ONLY WORKS WITH A -1:1 ratio (but in any scale) relationship
; of min/max for channels being compared!!!
; eg: -10 -> 10 and 10 -> -10.
opcode RevLinkChans,0,SSS
  SChanName1, SChanName2, SLink xin

  kLink chnget SLink
  ; RevLinkChans SChanName1, SChanName2, kLink

  kChan1 chnget SChanName1
  kChan2 chnget SChanName2

  ; Adjust widgets if linked
  if (kLink==1) then
    if (changed(kChan1)==1 && (kChan1!=-kChan2)) then
        chnset -kChan1, SChanName2
    elseif (changed(kChan2)==1 && (kChan1!=-kChan2)) then
        chnset -kChan2, SChanName1
    endif
  endif
endop


opcode RevLinkChans,0,SSk
  SChanName1, SChanName2, kLink xin

  kChan1 chnget SChanName1
  kChan2 chnget SChanName2

  ; Adjust widgets if linked
  if (kLink==1) then
    if (changed(kChan1)==1 && (kChan1!=-kChan2)) then
        chnset -kChan1, SChanName2
    elseif (changed(kChan2)==1 && (kChan1!=-kChan2)) then
        chnset -kChan2, SChanName1
    endif
  endif
endop



#endif
