; safety check, doesn't allow double include!
#ifndef FLEX_UDO_MULTIFILT
#define FLEX_UDO_MULTIFILT ##
/***************
 ***************

multifilt.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the filter udo file for an "easy" recursive
flexible filter/eq system.

Contains both mono and stereo versions, and required macro definitions

; Mode is any of the filter modes defined below
; Frequencies are in Hz
; Q/Res input is scaled from 0-1 to match each filter type
; Gain is used for EQ filters, and is in dB
; Gain can also be used for filters with "distortion" (k35nl, lpf18, etc), and is scaled from 0-1
; Loops is how many recursive passes through the filter

***************
***************/

; These are modes for MultiFilt UDO
; They are also used in flexfilt.xml (a cabbage wrapper for this)
#define F_BYPASS #0#
#define F_LSHELF #1#
#define F_HSHELF #2#
#define F_PEAK #3#
#define F_BUTTHP #4#
#define F_BUTTLP #5#
#define F_BUTTBP #6#
#define F_BUTTBR #7#
#define F_TONE #8#
#define F_ATONE #9#
#define F_MOOGLADDER #10#
#define F_REZZYHP #11#
#define F_REZZYLP #12#
#define F_LPF18 #13#
#define F_RESON #14#
#define F_RESONR #15#
#define F_RESONZ #16#
#define F_MOOGVCF2 #18#

#define F_MOOGLADDER2 #19#
#define F_MVC_1 #20#
#define F_MVC_2 #21#
#define F_MVC_3 #22#
#define F_MVC_HP #23#

; bqrez
#define F_BQR_LP #24#
#define F_BQR_HP #25#
#define F_BQR_BP #26#
#define F_BQR_BR #27#
#define F_BQRREZ_AP #28#

; statevar
#define F_SVAR_LP #29#
#define F_SVAR_HP #30#
#define F_SVAR_BP #31#
#define F_SVAR_BR #32#

; k35
#define F_K35_LPF #33#
#define F_K35_HPF #34#
#define F_K35_LPF_NL #35#
#define F_K35_HPF_NL #36#

#define F_LOWRESX #37#
#define F_DIODELADDER #38#
#define F_DIODELADDER1 #39#
#define F_DIODELADDER2 #40#
#define F_BOB #41#

; flexible recursive filter
; mono version first
opcode MultiFilt,a,akkkkp
  aSigL, kMode, kFreq, kQ, kGain, iLoops xin

  if (iLoops==0) then
    goto filt_skip
  endif

  if (changed(kMode)==1) then
    reinit MultiFiltReinit
  endif
  MultiFiltReinit:
  iMode=i(kMode)

  if (iMode==$F_BUTTHP) then
    aSigL butterhp aSigL, kFreq
  elseif (iMode==$F_BUTTLP) then
    aSigL butterlp aSigL, kFreq
  elseif (iMode==$F_BUTTBP) then
    aSigL butterbp aSigL, kFreq, abs(kQ-1)*(kFreq/2)
  elseif (iMode==$F_BUTTBR) then
    aSigL butterbr aSigL, kFreq, abs(kQ-1)*(kFreq/2)
  elseif (iMode==$F_LSHELF) then
    aSigL pareq aSigL, kFreq, kGain, max(kQ,.01), 1
  elseif (iMode==$F_HSHELF) then
    aSigL pareq aSigL, kFreq, kGain, max(kQ,.01), 2
  elseif (iMode==$F_PEAK) then
    aSigL pareq aSigL, kFreq, kGain, max(kQ,.01), 0
  elseif (iMode==$F_REZZYHP) then
    aSigL rezzy aSigL, kFreq, (kQ*99)+1, 1
  elseif (iMode==$F_REZZYLP) then
    aSigL rezzy aSigL, kFreq, (kQ*99)+1, 0
  elseif (iMode==$F_MOOGLADDER) then
    aSigL moogladder aSigL, kFreq, kQ
  elseif (iMode==$F_MOOGLADDER2) then
    aSigL moogladder2 aSigL, kFreq, kQ
  elseif (iMode==$F_ATONE) then
    aSigL atone aSigL, kFreq
  elseif (iMode==$F_TONE) then
    aSigL tone aSigL, kFreq
  elseif (iMode==$F_LPF18) then
    aSigL lpf18 aSigL, kFreq, kQ, kGain*5
  elseif (iMode==$F_RESON) then
    aSigL reson aSigL, kFreq, abs(kQ-1)*(kFreq/2), 1
  elseif (iMode==$F_RESONR) then
    aSigL resonr aSigL, kFreq, abs(kQ-1)*(kFreq/2), 1
  elseif (iMode==$F_RESONZ) then
    aSigL resonz aSigL, kFreq, abs(kQ-1)*(kFreq/2), 1
  elseif (iMode==$F_MOOGVCF2) then
    aSigL moogvcf2 aSigL, kFreq, kQ
  elseif (iMode==$F_BOB) then
    kGain = 1-(kGain*.99)
    kGain += .01
    kQ *= 4
    aSigL bob aSigL, kFreq, kQ, kGain
    ; apply makeup gain... this could be much better!
    kMakeup ntrpol 3, 1, kGain
    aSigL *= kMakeup
  elseif (iMode==$F_MVC_1) then
    aSigL mvclpf1 aSigL, kFreq, kQ
  elseif (iMode==$F_MVC_2) then
    aSigL mvclpf2 aSigL, kFreq, kQ
  elseif (iMode==$F_MVC_3) then
    aSigL mvclpf3 aSigL, kFreq, kQ
   elseif (iMode==$F_MVC_HP) then
     aSigL mvchpf aSigL, kFreq
   elseif (iMode==$F_BQR_LP) then
     aSigL bqrez aSigL, kFreq, (kQ*99)+1, 0
     aSigL = aSigL*.5
   elseif (iMode==$F_BQR_HP) then
     aSigL bqrez aSigL, kFreq, (kQ*99)+1, 1
     aSigL = aSigL*.5
   elseif (iMode==$F_BQR_BP) then
     aSigL bqrez aSigL, kFreq, (kQ*99)+1, 2
     aSigL = aSigL*.5
   elseif (iMode==$F_BQR_BR) then
     aSigL bqrez aSigL, kFreq, (kQ*99)+1, 3
  elseif (iMode==$F_SVAR_HP || iMode==$F_SVAR_LP || iMode==$F_SVAR_BP || iMode==$F_SVAR_BR) then
     aHPL, aLPL, aBPL, aBRL statevar aSigL, kFreq, kQ
     aSigL = (iMode==$F_SVAR_HP) ? aHPL : (iMode==$F_SVAR_LP) ? aLPL : (iMode==$F_SVAR_BP) ? aBPL : (iMode==$F_SVAR_BR) ? aBRL : a(0)
  elseif (iMode==$F_LOWRESX) then
    ; TODO kFreq and q aren't scaled properly for lowres, needs some massaging
    aSigL lowres aSigL, kFreq, (kQ*9)
 elseif (iMode==$F_K35_LPF) then
    aSigL K35_lpf aSigL, kFreq, (kQ*9)+1, 0, (kGain*4)+1
  elseif (iMode==$F_K35_HPF) then
    aSigL K35_hpf aSigL, kFreq, (kQ*9)+1, 0, (kGain*4)+1
 elseif (iMode==$F_K35_LPF_NL) then
    aSigL K35_lpf aSigL, kFreq, (kQ*9)+1, 1, (kGain*4)+1
  elseif (iMode==$F_K35_HPF_NL) then
    aSigL K35_hpf aSigL, kFreq, (kQ*9)+1, 1, (kGain*4)+1
  elseif (iMode==$F_DIODELADDER || iMode==$F_DIODELADDER1 || iMode==$F_DIODELADDER2) then
    iNonLinMode = (iMode==$F_DIODELADDER1) ? 1 : (iMode==$F_DIODELADDER2) ? 2 : 0
    aSigL diode_ladder aSigL, kFreq, (kQ*17), iNonLinMode, (kGain*9.9)+.1
  endif

  if (iLoops<=1) then
    kgoto filt_skip
  else
    aSigL MultiFilt aSigL, iMode, kFreq, kQ, kGain, iLoops-1
  endif
  filt_skip:
  xout aSigL
endop

; stereo version
opcode MultiFilt,aa,aakkkkp
  aSigL, aSigR, kMode, kFreq, kQ, kGain, iLoops xin
  
  if (iLoops==0) then
    goto filt_skip
  endif

  if (changed(kMode)==1) then
    reinit StMultiFiltReinit
  endif
  StMultiFiltReinit:
  iMode=i(kMode)

  if (iMode==$F_BUTTHP) then
    aSigL butterhp aSigL, kFreq
    aSigR butterhp aSigR, kFreq
  elseif (iMode==$F_BUTTLP) then
    aSigL butterlp aSigL, kFreq
    aSigR butterlp aSigR, kFreq
  elseif (iMode==$F_BUTTBP) then
    aSigL butterbp aSigL, kFreq, abs(kQ-1)*(kFreq/2)
    aSigR butterbp aSigR, kFreq, abs(kQ-1)*(kFreq/2)
  elseif (iMode==$F_BUTTBR) then
    aSigL butterbr aSigL, kFreq, abs(kQ-1)*(kFreq/2)
    aSigR butterbr aSigR, kFreq, abs(kQ-1)*(kFreq/2)
  elseif (iMode==$F_LSHELF) then
    aSigL pareq aSigL, kFreq, kGain, max(kQ,.01), 1
    aSigR pareq aSigR, kFreq, kGain, max(kQ,.01), 1
  elseif (iMode==$F_HSHELF) then
    aSigL pareq aSigL, kFreq, kGain, max(kQ,.01), 2
    aSigR pareq aSigR, kFreq, kGain, max(kQ,.01), 2
  elseif (iMode==$F_PEAK) then
    aSigL pareq aSigL, kFreq, kGain, max(kQ,.01), 0
    aSigR pareq aSigR, kFreq, kGain, max(kQ,.01), 0
  elseif (iMode==$F_REZZYHP) then
    aSigL rezzy aSigL, kFreq, (kQ*99)+1, 1
    aSigR rezzy aSigR, kFreq, (kQ*99)+1, 1
  elseif (iMode==$F_REZZYLP) then
    aSigL rezzy aSigL, kFreq, (kQ*99)+1, 0
    aSigR rezzy aSigR, kFreq, (kQ*99)+1, 0
  elseif (iMode==$F_MOOGLADDER) then
    aSigL moogladder aSigL, kFreq, kQ
    aSigR moogladder aSigR, kFreq, kQ
  elseif (iMode==$F_MOOGLADDER2) then
    aSigL moogladder2 aSigL, kFreq, kQ
    aSigR moogladder2 aSigR, kFreq, kQ
  elseif (iMode==$F_ATONE) then
    aSigL atone aSigL, kFreq
    aSigR atone aSigR, kFreq
  elseif (iMode==$F_TONE) then
    aSigL tone aSigL, kFreq
    aSigR tone aSigR, kFreq
  elseif (iMode==$F_LPF18) then
    aSigL lpf18 aSigL, kFreq, kQ, kGain*5
    aSigR lpf18 aSigR, kFreq, kQ, kGain*5
  elseif (iMode==$F_RESON) then
    aSigL reson aSigL, kFreq, abs(kQ-1)*(kFreq/2), 1
    aSigR reson aSigR, kFreq, abs(kQ-1)*(kFreq/2), 1
  elseif (iMode==$F_RESONR) then
    aSigL resonr aSigL, kFreq, abs(kQ-1)*(kFreq/2), 1
    aSigR resonr aSigR, kFreq, abs(kQ-1)*(kFreq/2), 1
  elseif (iMode==$F_RESONZ) then
    aSigL resonz aSigL, kFreq, abs(kQ-1)*(kFreq/2), 1
    aSigR resonz aSigR, kFreq, abs(kQ-1)*(kFreq/2), 1
  elseif (iMode==$F_MOOGVCF2) then
    aSigL moogvcf2 aSigL, kFreq, kQ
    aSigR moogvcf2 aSigR, kFreq, kQ
  elseif (iMode==$F_BOB) then
    kGain = 1-(kGain*.99)
    kGain += .01
    kQ *= 4
    aSigL bob aSigL, kFreq, kQ, kGain
    aSigR bob aSigR, kFreq, kQ, kGain
    ; apply makeup gain... this could be much better!
    kMakeup ntrpol 3, 1, kGain
    aSigL *= kMakeup
    aSigR *= kMakeup
  elseif (iMode==$F_MVC_1) then
    aSigL mvclpf1 aSigL, kFreq, kQ
    aSigR mvclpf1 aSigR, kFreq, kQ
  elseif (iMode==$F_MVC_2) then
    aSigL mvclpf2 aSigL, kFreq, kQ
    aSigR mvclpf2 aSigR, kFreq, kQ
  elseif (iMode==$F_MVC_3) then
    aSigL mvclpf3 aSigL, kFreq, kQ
    aSigR mvclpf3 aSigR, kFreq, kQ
   elseif (iMode==$F_MVC_HP) then
     aSigL mvchpf aSigL, kFreq
     aSigR mvchpf aSigR, kFreq
   elseif (iMode==$F_BQR_LP) then
     aSigL bqrez aSigL, kFreq, (kQ*99)+1, 0
     aSigR bqrez aSigR, kFreq, (kQ*99)+1, 0
     aSigL = aSigL*.5
     aSigR = aSigR*.5
   elseif (iMode==$F_BQR_HP) then
     aSigL bqrez aSigL, kFreq, (kQ*99)+1, 1
     aSigR bqrez aSigR, kFreq, (kQ*99)+1, 1
     aSigL = aSigL*.5
     aSigR = aSigR*.5
   elseif (iMode==$F_BQR_BP) then
     aSigL bqrez aSigL, kFreq, (kQ*99)+1, 2
     aSigR bqrez aSigR, kFreq, (kQ*99)+1, 2
     aSigL = aSigL*.5
     aSigR = aSigR*.5
   elseif (iMode==$F_BQR_BR) then
     aSigL bqrez aSigL, kFreq, (kQ*99)+1, 3
     aSigR bqrez aSigR, kFreq, (kQ*99)+1, 3     
  elseif (iMode==$F_SVAR_HP || iMode==$F_SVAR_LP || iMode==$F_SVAR_BP || iMode==$F_SVAR_BR) then
     aHPL, aLPL, aBPL, aBRL statevar aSigL, kFreq, kQ
     aHPR, aLPR, aBPR, aBRR statevar aSigR, kFreq, kQ

     aSigL = (iMode==$F_SVAR_HP) ? aHPL : (iMode==$F_SVAR_LP) ? aLPL : (iMode==$F_SVAR_BP) ? aBPL : (iMode==$F_SVAR_BR) ? aBRL : a(0)
     aSigR = (iMode==$F_SVAR_HP) ? aHPR : (iMode==$F_SVAR_LP) ? aLPR : (iMode==$F_SVAR_BP) ? aBPR : (iMode==$F_SVAR_BR) ? aBRR : a(0)
  elseif (iMode==$F_LOWRESX) then
    ; TODO kFreq and q aren't scaled properly for lowres, needs some massaging
    aSigL lowres aSigL, kFreq, (kQ*9)
    aSigR lowres aSigR, kFreq, (kQ*9)

 elseif (iMode==$F_K35_LPF) then
    aSigL K35_lpf aSigL, kFreq, (kQ*9)+1, 0, (kGain*4)+1
    aSigR K35_lpf aSigR, kFreq, (kQ*9)+1, 0, (kGain*4)+1
  elseif (iMode==$F_K35_HPF) then
    aSigL K35_hpf aSigL, kFreq, (kQ*9)+1, 0, (kGain*4)+1
    aSigR K35_hpf aSigR, kFreq, (kQ*9)+1, 0, (kGain*4)+1
 elseif (iMode==$F_K35_LPF_NL) then
    aSigL K35_lpf aSigL, kFreq, (kQ*9)+1, 1, (kGain*4)+1
    aSigR K35_lpf aSigR, kFreq, (kQ*9)+1, 1, (kGain*4)+1
  elseif (iMode==$F_K35_HPF_NL) then
    aSigL K35_hpf aSigL, kFreq, (kQ*9)+1, 1, (kGain*4)+1
    aSigR K35_hpf aSigR, kFreq, (kQ*9)+1, 1, (kGain*4)+1
  elseif (iMode==$F_DIODELADDER || iMode==$F_DIODELADDER1 || iMode==$F_DIODELADDER2) then
    iNonLinMode = (iMode==$F_DIODELADDER1) ? 1 : (iMode==$F_DIODELADDER2) ? 2 : 0
    aSigL diode_ladder aSigL, kFreq, (kQ*17), iNonLinMode, (kGain*9.9)+.1
    aSigR diode_ladder aSigR, kFreq, (kQ*17), iNonLinMode, (kGain*9.9)+.1
  endif

  if (iLoops<=1) then
    kgoto filt_skip
  else
    aSigL, aSigR MultiFilt aSigL, aSigR, iMode, kFreq, kQ, kGain, iLoops-1
  endif
  filt_skip:
  xout aSigL, aSigR
endop

#endif

