/***************
 ***************

DDL630.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

Simple analog style delay, with selectable delay in increments of 10ms ranging from 10-630ms

Left and right channels can be selectively dropped out of the delay line.

***************
***************/

<Cabbage>
form size(380, 224), caption("DDL 630"), pluginID("td61"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In/Out") {
  FlexClip bounds(10,5,25,10), namespace("flexclip"), $IN_OL
  FlexClip bounds(325,5,25,10), namespace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), namespace("collapse")
  rslider $RED_KNOB bounds(208, 25, 50, 50) $MAIN_GAIN
  rslider $BLUE_KNOB bounds(256, 25, 50, 50), channel("drywet"), range(-100, 100, 100, 1, 0.01), $DRYWET
  FlexPan bounds(304,25,50,50), namespace("flexpan"), $MAIN_PAN
}

groupbox $BOX bounds(10, 94, 360, 120), text("DDL-630") {
  button $HG_BTN bounds(30,30,50,30), channel("10"), text("10ms"), latched(1), popuptext("Toggle 10ms delay")
  button $HG_BTN bounds(80,30,50,30), channel("20"), text("20ms"), latched(1), popuptext("Toggle 20ms delay")
  button $HG_BTN bounds(130,30,50,30), channel("40"), text("40ms"), latched(1), popuptext("Toggle 40ms delay")
  button $HG_BTN bounds(180,30,50,30), channel("80"), text("80ms"), latched(1), popuptext("Toggle 80ms delay")
  button $HG_BTN bounds(230,30,50,30), channel("160"), text("160ms"), latched(1), popuptext("Toggle 160ms delay")
  button $HG_BTN bounds(280,30,50,30), channel("320"), text("320ms"), latched(1), popuptext("Toggle 320ms delay")
  button $FY_BTN bounds(30,70,50,30), channel("left-out"), text("L-Out","L-In"), latched(1), value(0), popuptext("Left Channel In/Out")
  button $FY_BTN bounds(280,70,50,30), channel("right-out"), text("R-Out","R-In"), latched(1), value(1), popuptext("Right Channel In/Out")
  label $TEXT align("right"), bounds(120,70,60,35), text("---"), identchannel("delay-label-c")
  label $TEXT align("left"), bounds(185,70,60,35), text("ms")
}

$BYPASS_SHADER size( $SCREEN_WIDTH, $SCREEN_HEIGHT)
TestButtons bounds(56,12,126,18), namespace("test_audio")
checkbox $GREEN_CC bounds(20, 35, 90, 25), $MAIN_BYPASS


</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0
</CsOptions>
<CsInstruments>
#include "includes/effect.inc.csd"

instr Effect
  kDryWet = .01*chnget:k("drywet")
  kDryWet = $BI_TO_UNI(kDryWet)
  kLeftOut chnget "left-out"
  kRightOut chnget "right-out"

  k10 chnget "10"
  k20 chnget "20"
  k40 chnget "40"
  k80 chnget "80"
  k160 chnget "160"
  k320 chnget "320"

  kDel = (10*k10)+(20*k20)+(40*k40)+(80*k80)+(160*k160)+(320*k320)

  UpdateLabel kDel, "delay-label-c"

  aSigL, aSigR FlexEffectIns

  aDryL = aSigL
  aDryR = aSigR

  aSigL vdelay aSigL, kDel, 631
  aSigR vdelay aSigR, kDel, 631

  aSigL RSmoothX aSigL, aDryL, kLeftOut
  aSigR RSmoothX aSigR, aDryR, kRightOut

  aSigL = ntrpol(aDryL,aSigL,kDryWet)
  aSigR = ntrpol(aDryR,aSigR,kDryWet)

  FlexEffectOuts aSigL, aSigR
endin
</CsInstruments>  
<CsScore>
</CsScore>
</CsoundSynthesizer>
