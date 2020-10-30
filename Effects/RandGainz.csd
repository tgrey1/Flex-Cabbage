/***************
 ***************

RandGainz.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

This is a **VERY** rough effect.  Use with caution, it will change!

Effect to generate random changes to volume.
Rate and quantization of the effect can be adjusted, along
with the speed of interpolation between values

  ; TODO: a rate is better, but xRand1 or xRand2?  Stereo?
  ; better randomization needed for sure.  multiple randi or jitter?
 
***************
***************/

<Cabbage>
form caption("Rand Gainz") size(380,434), pluginID("tbg1"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In / Out") {
  FlexClip bounds(10,5,25,10), namespace("flexclip"), $IN_OL
  FlexClip bounds(325,5,25,10), namespace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), namespace("collapse")
  rslider $RED_KNOB bounds(304, 25, 50, 50), $MAIN_GAIN
  FlexPan bounds(225,25,50,50), namespace("flexpan"), $MAIN_PAN
}

groupbox $BOX bounds(10, 94, 360, 330), text("Rand Gainz") {
  rslider $GREEN_KNOB pos(24, 25), size(140, 140), channel("rate"), range(.01, 40, 10, 1, 0.01), text("Rate"), popupprefix("Rate:\n"), popuppostfix(" Hz"), valuetextbox(1)
  rslider $GREEN_KNOB pos(196, 25), size(140, 140), channel("depth"), range(0, 100, 0, 1, 1), text("Depth"), popupprefix("Depth:\n"), popuppostfix(" %"), valuetextbox(1)
  rslider $CYAN_KNOB pos(24, 180), size(140, 140), channel("time"), range(.001, .1, .025, 1, 0.001), text("Port Time"), popupprefix("Port Time:\n"), popuppostfix(" sec"), valuetextbox(1)
  rslider $RED_KNOB pos(196, 180), size(140, 140), channel("steps"), range(2, 256, 80, 1, 1), text("Quantization Steps") popupprefix("Steps:\n"), valuetextbox(1)
}

$BYPASS_SHADER size( $SCREEN_WIDTH, $SCREEN_HEIGHT)
TestButtons bounds(56,12,126,18), namespace("test_audio")
checkbox $GREEN_CC bounds(20, 35, 90, 25), $MAIN_BYPASS

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
#include "includes/effect.inc.csd"

instr Effect
  kRate chnget "rate"
  kDepth = .01*chnget:k("depth")
  kPortTime chnget "time"
  kSteps chnget "steps"
  kSteps -=1 

  ; randi scales rate from 40%-100%, at 1hz
  kRandi randi .4, 1, .5, 0, .6
  kRand randh  .5, kRate*kRandi, .5, 0, .5

  ; Apply depth and take away from 100%
  kRand *= kDepth
  kRand = 1-kRand

  ; Quantize into step sizes
  kRand = round(kRand*kSteps)*(1/kSteps)

  ; Apply port
  kRand portk kRand, kPortTime

  ; randi scales rate from 40%-100%, at 1hz
  kRandi2 randi .4, 1, .6, 0, .6
  kRand2 randh  .5, kRate*kRandi2, .6, 0, .5

  ; Apply depth and take away from 100%
  kRand2 *= kDepth
  kRand2 = 1-kRand2

  ; Quantize into step sizes
  kRand2 = round(kRand2*kSteps)*(1/kSteps)

  ; Apply port
  kRand2 portk kRand2, kPortTime

  aSigL, aSigR FlexEffectIns

  aRand interp kRand
  aRand2 interp kRand2

  aSigL *= aRand
  aSigR *= aRand

  FlexEffectOuts aSigL, aSigR
endin
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
