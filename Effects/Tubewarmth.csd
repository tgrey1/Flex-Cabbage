/***************
 ***************

Tubewarmth.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

This is a simple cabbage wrapper around Steven Yi's
tap_tubewarmth UDO, which was in turn based off of
Tom Szilagyi's TAP TubeWarmth LADSPA plugin.

See includes/udo/tubewarmth.udo.csd for more information.

***************
***************/
<Cabbage>
form size(380, 304), caption("Tubewarmth"), pluginID("ttb2"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In/Out") {
  FlexClip bounds(10,5,25,10), nameSpace("flexclip"), $IN_OL
  FlexClip bounds(325,5,25,10), nameSpace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), nameSpace("collapse")
  FlexPan bounds(304,25,50,50), nameSpace("flexpan"), $MAIN_PAN

  rslider $RED_KNOB $GAIN_RANGE bounds(160, 25, 50, 50), channel("pregain"), text("Pre"), popupPrefix("PreGain:\n"), popupPostfix(" dB")
  rslider $RED_KNOB bounds(208, 25, 50, 50), $MAIN_GAIN
  rslider $BLUE_KNOB bounds(256, 25, 50, 50), channel("drywet"), range(-100, 100, 100, 1, 0.01), $DRYWET
}

groupbox $BOX bounds(10, 94, 360, 200), text("Tubewarmth") {
  rslider $GREEN_KNOB bounds(15, 30, 150, 150), channel("drive"), range(0, 11, 0, 1, .01), text("Drive"), popupPrefix("Drive:\n")
  rslider $GREEN_KNOB bounds(195, 30, 150, 150), channel("blend"), range(-100, 100, 0, 1, .01), text("Blend"), popupPrefix("Blend:\n"), popupPostfix(" %")
  label $TEXT bounds(190,140,23,10), text("Tape")
  label $TEXT bounds(330,140,23,10), text("Tube")
}

$BYPASS_SHADER size( $SCREEN_WIDTH, $SCREEN_HEIGHT)
TestButtons bounds(56,12,126,18), nameSpace("test_audio")
checkbox $GREEN_CC bounds(20, 35, 90, 25), $MAIN_BYPASS

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>
#include "includes/effect.inc.csd"
#include "includes/udo/tubewarmth.udo.csd"

instr Effect
  kPreGainDb = ampdb(chnget:k("pregain"))
  kDrive chnget "drive"
  kBlend = .1*chnget:k("blend")

  kDryWet = .01*chnget:k("drywet")
  kDryWet = $BI_TO_UNI(kDryWet)

  aSigL, aSigR FlexEffectIns

  aDryL = aSigL
  aDryR = aSigR

  aSigL *= kPreGainDb
  aSigR *= kPreGainDb

  aSigL tap_tubewarmth aSigL, kDrive, kBlend
  aSigR tap_tubewarmth aSigR, kDrive, kBlend

  aSigL = ntrpol(aDryL,aSigL,kDryWet)
  aSigR = ntrpol(aDryR,aSigR,kDryWet)

  FlexEffectOuts aSigL, aSigR
endin
</CsInstruments>  
<CsScore>
</CsScore>
</CsoundSynthesizer>