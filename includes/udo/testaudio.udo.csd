; safety check, doesn't allow double include!
#ifndef FLEX_UDO_TESTAUDIO
#define FLEX_UDO_TESTAUDIO ##
/***************
 ***************

testaudio.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the testaudio UDO file, it typically gets included automatically
These are UDOs that replace the audio stream with test audio

***************
***************/

; TODO: declick env needs to be pulled out

#ifndef TEST_OSC_FREQ
  #define TEST_OSC_FREQ #440#
#endif

; if debugging, generate appropriate test audio
; and make test buttons visible
opcode TestAudio,aa,aaS
  ainL, ainR, Schan_prefix xin

  chnset "visible(1)", strcat(Schan_prefix,"testaudio_box")

  ktest chnget strcat(Schan_prefix,"testaudio_Mono")
  ktestSt chnget strcat(Schan_prefix,"testaudio_Stereo")
  ktestL chnget strcat(Schan_prefix,"testaudio_L")
  ktestC chnget strcat(Schan_prefix,"testaudio_C")
  ktestR chnget strcat(Schan_prefix,"testaudio_R")

  ; play stereo and mono test files based on buttons
  ; if files not defined, generate white noise
  if (ktestSt==1) then
    #ifdef TEST_STEREO_FILE
      ainL, ainR diskin $TEST_STEREO_FILE, 1, 0, 1
    #else
      ainL rand ampdb(-3), 0
      ainR rand ampdb(-3), .1
    #endif
  elseif (ktest==1) then
    #ifdef TEST_MONO_FILE
      ainL diskin $TEST_MONO_FILE, 1, 0, 1
    #else
      ainL rand ampdb(-3)
    #endif
    ainR = ainL
  endif

  ; generate a sine and crossover to channels based on button status
  aosc poscil ampdb(-3), $TEST_OSC_FREQ

  ktestL = ktestL|ktestC
  ktestR = ktestR|ktestC
  ainL = (ainL*(1-ktestL))+(aosc*(ktestL))
  ainR = (ainR*(1-ktestR))+(aosc*(ktestR))
  xout ainL, ainR
endop

opcode TestAudio,aa,aa
  aInL, aInR xin

  aSigL, aSigR TestAudio aInL, aInR, ""

  xout aSigL, aSigR
endop

#endif
