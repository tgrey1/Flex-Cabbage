; safety check, doesn't allow double include!
#ifndef FLEX_UDO_SOLINA
#define FLEX_UDO_SOLINA ##
/***************
 ***************

solina.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is a file to include Steven Yi's Solina Chorus UDO into Flex
Also includes a modified "stereo" version modified by tgrey

original: https://github.com/kunstmusik/libsyi/blob/master/solina_chorus.udo

original commentary follows:
;
; Solina Chorus, based on Solina String Ensemble Chorus Module
; 
; based on:
;
; J. Haible: Triple Chorus
; http://jhaible.com/legacy/triple_chorus/triple_chorus.html
;
; Hugo Portillo: Solina-V String Ensemble
; http://www.native-instruments.com/en/reaktor-community/reaktor-user-library/entry/show/4525/ 
;
; Parabola tabled shape borrowed from Iain McCurdy delayStereoChorus.csd:
; http://iainmccurdy.org/CsoundRealtimeExamples/Delays/delayStereoChorus.csd
;
; Author: Steven Yi
; Date: 2016.05.22
;

***************
***************/

gi_solina_parabola ftgen 0, 0, 65537, 19, 0.5, 1, 180, 1 

; original mono version by Steven Yi:
;; 3 sine wave LFOs, 120 degrees out of phase
opcode sol_lfo_3, aaa, kk
  kfreq, kamp xin

  aphs phasor kfreq

  a0   = tablei(aphs, gi_solina_parabola, 1, 0, 1)
  a120 = tablei(aphs, gi_solina_parabola, 1, 0.333, 1)
  a240 = tablei(aphs, gi_solina_parabola, 1, -0.333, 1)

  xout (a0 * kamp), (a120 * kamp), (a240 * kamp)
endop

opcode solina_chorus, a, akkkk

  aLeft, klfo_freq1, klfo_amp1, klfo_freq2, klfo_amp2 xin

  imax = 100

  ;; slow lfo
  as1, as2, as3 sol_lfo_3 klfo_freq1, klfo_amp1

  ;; fast lfo
  af1, af2, af3  sol_lfo_3 klfo_freq2, klfo_amp2

  at1 = limit(as1 + af1 + 5, 0.0, imax)
  at2 = limit(as2 + af2 + 5, 0.0, imax)
  at3 = limit(as3 + af3 + 5, 0.0, imax)
    
  a1 vdelay3 aLeft, at1, imax 
  a2 vdelay3 aLeft, at2, imax 
  a3 vdelay3 aLeft, at3, imax 

  xout (a1 + a2 + a3) / 3
endop

; Stereo-ified version by tgrey:

;; 3 sine wave LFOs, 120 degrees out of phase
opcode SolinaLfo3, aaa, kkk
  kFreq, kAmp, kSplit xin

  aPhs1 phasor kFreq
  aPhs2 phasor kFreq, .5

  ; Can this use bypass function?
  ; smooth switch of kSplit to avoid clicks
  kSplit port kSplit, .0825
  aSplit interp kSplit
  aPhs = (aPhs2*aSplit)+(aPhs1*(1-aSplit))

  a0   = tablei:a(aPhs, gi_solina_parabola, 1, 0, 1)
  a120 = tablei:a(aPhs, gi_solina_parabola, 1, 0.333, 1)
  a240 = tablei:a(aPhs, gi_solina_parabola, 1, -0.333, 1)

  xout (a0 * kAmp), (a120 * kAmp), (a240 * kAmp)
endop

opcode SolinaChorusStereo, aa, aakkkkk

  aLeft, aRight, kLFOFreq1, kLFOAmp1, kLFOFreq2, kLFOAmp2, kSplit xin

  iMax = 100

  ;; slow lfo
  aSL1, aSL2, aSL3 SolinaLfo3 kLFOFreq1, kLFOAmp1, 0

  ;; fast lfo
  aFL1, aFL2, aFL3  SolinaLfo3 kLFOFreq2, kLFOAmp2, 0

;; slow lfo
  aSR1, aSR2, aSR3 SolinaLfo3 kLFOFreq1, kLFOAmp1, kSplit

  ;; fast lfo
  aFR1, aFR2, aFR3  SolinaLfo3 kLFOFreq2, kLFOAmp2, kSplit

  aTL1 = limit(aSL1 + aFL1 + 5, 0.0, iMax)
  aTL2 = limit(aSL2 + aFL2 + 5, 0.0, iMax)
  aTL3 = limit(aSL3 + aFL3 + 5, 0.0, iMax)

  aTR1 = limit(aSR1 + aFR1 + 5, 0.0, iMax)
  aTR2 = limit(aSR2 + aFR2 + 5, 0.0, iMax)
  aTR3 = limit(aSR3 + aFR3 + 5, 0.0, iMax)
    
  aL1 vdelay3 aLeft, aTL1, iMax 
  aL2 vdelay3 aLeft, aTL2, iMax 
  aL3 vdelay3 aLeft, aTL3, iMax 

  aR1 vdelay3 aRight, aTR1, iMax 
  aR2 vdelay3 aRight, aTR2, iMax 
  aR3 vdelay3 aRight, aTR3, iMax 

xout (aL1 + aL2 + aL3) / 3, (aR1 + aR2 + aR3) / 3
endop

#endif
