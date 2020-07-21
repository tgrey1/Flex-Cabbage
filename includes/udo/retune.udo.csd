; safety check, doesn't allow double include!
#ifndef FLEX_UDO_RETUNE
#define FLEX_UDO_RETUNE ##
/***************
 ***************

retune.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the retune UDO file
These are UDOs related to dealing with retuning frequencies

***************
***************/

; TODO: look at the names of these UDOs, some may need to be renamed
; TODO: look at supporting midi note numbers too?  maybe pch notation?

opcode RetuneFreq,i,iS
  iFreq,SChanPrefix xin

  iOctave = 1200*chnget:i(strcat(SChanPrefix,"octave"))
  iCoarse = 100*chnget:i(strcat(SChanPrefix,"coarse"))
  iFine = chnget:i(strcat(SChanPrefix,"fine"))

  xout iFreq*cent(iOctave+iCoarse+iFine)
endop

opcode RetuneFreq,i,i
  iFreq xin

  iOctave = 1200*chnget:i("octave")
  iCoarse = 100*chnget:i("coarse")
  iFine = chnget:i("fine")

  xout iFreq*cent(iOctave+iCoarse+iFine)
endop

opcode RetuneFreq,k,iS
  iFreq,SChanPrefix xin

  kOctave = 1200*chnget:k(strcat(SChanPrefix,"octave"))
  kCoarse = 100*chnget:k(strcat(SChanPrefix,"coarse"))
  kFine = chnget:k(strcat(SChanPrefix,"fine"))

  xout iFreq*cent(kOctave+kCoarse+kFine)
endop

opcode RetuneFreq,k,i
  iFreq xin

  kOctave = 1200*chnget:k("octave")
  kCoarse = 100*chnget:k("coarse")
  kFine = chnget:k("fine")

  xout iFreq*cent(kOctave+kCoarse+kFine)
endop

opcode RetuneFreq,k,kS
  kFreq,SChanPrefix xin

  kOctave = 1200*chnget:k(strcat(SChanPrefix,"octave"))
  kCoarse = 100*chnget:k(strcat(SChanPrefix,"coarse"))
  kFine = chnget:k(strcat(SChanPrefix,"fine"))

  xout kFreq*cent(kOctave+kCoarse+kFine)
endop

opcode RetuneFreq,k,k
  kFreq xin

  kOctave = 1200*chnget:k("octave")
  kCoarse = 100*chnget:k("coarse")
  kFine = chnget:k("fine")

  xout kFreq*cent(kOctave+kCoarse+kFine)
endop

#endif
