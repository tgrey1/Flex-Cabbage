/***************
 ***************

SampleShift.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

Simple array based delay shift by a specific number of samples

Changing values causes a reinit/clicking not meant to be adjusted during performance!

***************
***************/

<Cabbage>
form size(380, 254), caption("SampleShift"), pluginID("tsh1"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In/Out") {
  FlexClip bounds(10,5,25,10), namespace("flexclip"), $IN_OL
  FlexClip bounds(325,5,25,10), namespace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), namespace("collapse")
  rslider $RED_KNOB bounds(254, 25, 50, 50), $MAIN_GAIN
  FlexPan bounds(304,25,50,50), namespace("flexpan"), $MAIN_PAN
}

groupbox $BOX bounds(10, 94, 360, 150), text("Shift") {
  nslider $NSLIDER bounds(10,30,130,40), channel("samples"), range(0,44100,0,1,1), popuptext(0), $REINIT_TEXT
  nslider $NSLIDER bounds(220,30,130,40), channel("seconds"), range(0,1,0,1,.00001), popuptext(0), $REINIT_TEXT

  label $TEXT, bounds(10,75,130,15), text("Samples")
  label $TEXT, bounds(220,75,130,15), text("Seconds")

  button $FY_BTN bounds(25,105,100,30), channel("left-out"), text("Left Out","Left In"), latched(1), value(1)
  button $FY_BTN bounds(235,105,100,30), channel("right-out"), text("Right Out","Right In"), latched(1), value(1)
}

$BYPASS_SHADER size( $SCREEN_WIDTH, $SCREEN_HEIGHT)
TestButtons bounds(56,12,126,18), namespace("test_audio")
checkbox $GREEN_CC bounds(20, 35, 90, 25), $MAIN_BYPASS


</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>
#include "includes/effect.inc.csd"
#include "includes/udo/delaysamp.udo.csd"

instr Effect
  kGain chnget "gain"
  kLeftOut chnget "left-out"
  kRightOut chnget "right-out"

  kSamples chnget "samples"
  kSeconds chnget "seconds"

  if(changed(kSamples)==1) then
    kSeconds=kSamples/sr
    chnset kSeconds, "seconds"
  elseif (changed(kSeconds)==1) then
    kSamples=kSeconds*sr
    chnset kSamples, "samples"
  endif

  aDryL, aDryR FlexEffectIns

  aDryL, aDryR Bypass aDryL, aDryR
  aSigL, aSigR DelaySamp aDryL, aDryR, kSamples

  ; Pick whether L and or R channels are it out out
  aSigL RSmoothX aSigL, aDryL, kLeftOut
  aSigR RSmoothX aSigR, aDryR, kRightOut

  FlexEffectOuts aSigL, aSigR
endin

</CsInstruments>  
<CsScore>
</CsScore>
</CsoundSynthesizer>
