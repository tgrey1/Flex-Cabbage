; safety check, doesn't allow double include!
#ifndef FLEX_UDO_AUDIO
#define FLEX_UDO_AUDIO ##
/***************
 ***************

audio.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the audio UDO file, it typically gets included automatically
These are UDOs related to dealing with audio

***************
***************/

; include common audio stuff here, clip, collapse, etc
; move most of these to their own UDO files.  move this to system in the end?

#ifndef BYPASS_TIME
  #define BYPASS_TIME #.005#
#endif

opcode SimpleWidth,aa,aak
  aSigL, aSigR, kWidth xin

    kWidth = (kWidth*.5)+.5

    aleftL = aSigL*kWidth
    aleftR = aSigL*(1-kWidth)
    arightL = aSigR*(1-kWidth)
    arightR = aSigR*kWidth

    aOutL = aleftL+arightL
    aOutR = aleftR+arightR

  xout aOutL, aOutR
endop


; for easily changing pan behavior of all instruments/effects
; always reinits to first mode
; version for mono inputs
opcode SimplePanHandler,aa,aS
  aSig, SChanName xin

  kPan = .01*chnget:k(SChanName)
  kPan = (kPan*.5)+.5

  aOutL = aSig * (1-kPan)
  aOutR = aSig * kPan
  xout aOutL, aOutR
endop

; version for stereo inputs
opcode SimplePanHandler,aa,aaS
  aSigL, aSigR, SChanName xin

  kPan = .01*chnget:k(SChanName)
  kPan = (kPan*.5)+.5

  aOutL = aSigL * (1-kPan)
  aOutR = aSigR * kPan
  xout aOutL, aOutR
endop

;krate versions too!!!
; version for mono inputs
opcode SimplePanHandler,aa,ak
  aSig, kPan xin

  kPan = (kPan*.01*.5)+.5

  aOutL = aSig * (1-kPan)
  aOutR = aSig * kPan
  xout aOutL, aOutR
endop

; for easily changing pan behavior of all instruments/effects
; TODO - this is not irate/note compatible (see thekicker)
; always reinits to first mode
opcode SimplePanHandler,aa,aak
  aSigL, aSigR, kPan xin

  kPan = (kPan*.01*.5)+.5

  aOutL = aSigL * (1-kPan)
  aOutR = aSigR * kPan
  xout aOutL, aOutR
endop

; smooth xover function, opposite inputs as bypass
; first audio or pair of audio are default
; second takeover when bypass is "ON"
; eg: aSig smoothx aSig, a(0), kmute
opcode SmoothX,a,aakj
  aIn1, aIn2, kBypass, iTime xin

  iTime = (iTime<0) ? $BYPASS_TIME : iTime
  kBypass port kBypass, iTime
  aBypass interp kBypass
  aSig = (aIn2*aBypass)+(aIn1*(1-aBypass))
  xout aSig
endop

; reimplmenet stereo version to share the port&interpolation
opcode SmoothX,aa,aaaakj
  aIn1L, aIn1R, aIn2L, aIn2R, kBypass, iTime xin

  iTime = (iTime<0) ? $BYPASS_TIME : iTime
  kBypass port kBypass, iTime
  aBypass interp kBypass
  aSigL = (aIn2L*aBypass)+(aIn1L*(1-aBypass))
  aSigR = (aIn2R*aBypass)+(aIn1R*(1-aBypass))
  xout aSigL, aSigR
endop

; these need to be renamed... EVERYWHERE!
opcode RSmoothX,a,aakj
  aIn1, aIn2, kBypass, iTime xin

  iTime = (iTime<0) ? $BYPASS_TIME : iTime
  kBypass port kBypass, iTime
  aBypass interp kBypass
  aSig = (aIn1*aBypass)+(aIn2*(1-aBypass))
  xout aSig
endop

; reimplmenet stereo version to share the port&interpolation
opcode RSmoothX,aa,aaaakj
  aIn1L, aIn1R, aIn2L, aIn2R, kBypass, iTime xin

  iTime = (iTime<0) ? $BYPASS_TIME : iTime
  kBypass port kBypass, iTime
  aBypass interp kBypass
  aSigL = (aIn1L*aBypass)+(aIn2L*(1-aBypass))
  aSigR = (aIn1R*aBypass)+(aIn2R*(1-aBypass))
  xout aSigL, aSigR
endop

;
;
;

; UDO versions with match input and output counts
; This means swap to 0 on bypass, since no alternate input is given
; these are useful to disable sends on effect inputs
; for example, stopping input into a delay line
opcode Bypass,a,a
  aSig1 xin
  kBypass chnget "bypass"
  kBypass port kBypass, $BYPASS_TIME
  aBypass interp kBypass
  aSig = (0*aBypass)+(aSig1*(1-aBypass))
  xout aSig
endop

opcode Bypass,aa,aa
  aSig1L, aSig1R xin
  kBypass chnget "bypass"
  kBypass port kBypass, $BYPASS_TIME
  aBypass interp kBypass
  aSigL = (0*aBypass)+(aSig1L*(1-aBypass))
  aSigR = (0*aBypass)+(aSig1R*(1-aBypass))
  xout aSigL, aSigR
endop

opcode Bypass,a,ak
  aSig1, kBypass xin
  kBypass port kBypass, $BYPASS_TIME
  aBypass interp kBypass
  aSig = (0*aBypass)+(aSig1*(1-aBypass))
  xout aSig
endop

opcode Bypass,aa,aak
  aSig1L, aSig1R, kBypass xin
  kBypass port kBypass, $BYPASS_TIME
  aBypass interp kBypass
  aSigL = (0*aBypass)+(aSig1L*(1-aBypass))
  aSigR = (0*aBypass)+(aSig1R*(1-aBypass))
  xout aSigL, aSigR
endop


;;;;;;;;;;
;
;  these version swap between two sets of inputs based on bypass state
;  these are useful to swap output between dry input and fx out
;

opcode Bypass,a,aa
  aSig1, aSig2 xin
  kBypass chnget "bypass"
  kBypass port kBypass, $BYPASS_TIME
  aBypass interp kBypass
  aSig = (aSig1*aBypass)+(aSig2*(1-aBypass))
  xout aSig
endop

opcode Bypass,aa,aaaa
  aSig1L, aSig1R, aSig2L, aSig2R xin
  kBypass chnget "bypass"
  kBypass port kBypass, $BYPASS_TIME
  aBypass interp kBypass
  aSigL = (aSig1L*aBypass)+(aSig2L*(1-aBypass))
  aSigR = (aSig1R*aBypass)+(aSig2R*(1-aBypass))
  xout aSigL, aSigR
endop

opcode Bypass,a,aak
  aSig1, aSig2, kBypass xin
  kBypass port kBypass, $BYPASS_TIME
  aBypass interp kBypass
  aSig = (aSig1*aBypass)+(aSig2*(1-aBypass))
  xout aSig
endop

opcode Bypass,aa,aaaak
  aSig1L, aSig1R, aSig2L, aSig2R, kBypass xin
  kBypass port kBypass, $BYPASS_TIME
  aBypass interp kBypass
  aSigL = (aSig1L*aBypass)+(aSig2L*(1-aBypass))
  aSigR = (aSig1R*aBypass)+(aSig2R*(1-aBypass))
  xout aSigL, aSigR
endop

#endif
