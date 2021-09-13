/***************
 ***************

TanH.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

Simple modified tanh distortion using TanH UDO wrapper and 2 filter bands
available both Pre and Post distortion.

Second filter bands can run in parallel or in sequence to first

WARNING: Changing filter mode or depth (recursion) forces a reinit, which may cause clicking.

Filter Controls in I/O section sets which filter variables get reset when filter mode changes.

***************
***************/
<Cabbage>
form size(380, 638), caption("TanH"), pluginID("ttnh"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml","plants/flexfilt.xml", "plants/flexfilt_reset.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In/Out") {
  FlexClip bounds(10,5,25,10), nameSpace("flexclip") $IN_OL
  FlexClip bounds(325,5,25,10), nameSpace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), nameSpace("collapse")
  FlexPan bounds(304,25,50,50), nameSpace("flexpan"), $MAIN_PAN

  button $BTN bounds(102,25,50,20), $FILT_RESET

  rslider $RED_KNOB $GAIN_RANGE bounds(157, 25, 50, 50), channel("pregain"), text("Pre"), popupPrefix("PreGain:\n"), popupPostfix(" dB")
  rslider $RED_KNOB bounds(200, 25, 50, 50), $MAIN_GAIN
  rslider $BLUE_KNOB bounds(256, 25, 50, 50), channel("drywet"), range(-100, 100, 100, 1, 0.01), $DRYWET
 }

groupbox $BOX bounds(10, 268, 360, 186), text("TanH") {
  rslider $GREEN_KNOB bounds(115, 25, 130, 150), channel("drive"), range(0, 100, 0, 1, 0.01), text("Drive"), popupPrefix("Drive:\n"), popupPostfix(" %"), valueTextBox(1)
}

groupbox $BOX bounds(10, 94, 178, 170), text("Pre-Filt 1") {
  FlexFilt bounds(0,0,178,168), channel("band1-"), nameSpace("flexfilt")
}

groupbox $BOX bounds(193, 94, 178, 170), text("Pre-Filt 2") {
  FlexFilt bounds(0,0,178,168), channel("band2-"), nameSpace("flexfilt")
}

groupbox $BOX bounds(10, 458, 178, 170), text("Post-Filt 1") {
  FlexFilt bounds(0,0,178,168), channel("band3-"), nameSpace("flexfilt")
}

groupbox $BOX bounds(193, 458, 178, 170), text("Post-Filt 2") {
  FlexFilt bounds(0,0,178,168), channel("band4-"), nameSpace("flexfilt")
}

$SHADER bounds(0, 0, $SCREEN_WIDTH, $SCREEN_HEIGHT), identChannel("reset-tint")
FlexFiltReset bounds(61,87,258,170), nameSpace("flexfilt")

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
#include "includes/udo/tanh.udo.csd"

instr Effect
  kPreGainDb = ampdb(chnget:k("pregain"))
  kDrive = .01*chnget:k("drive")
  kDryWet = .01*chnget:k("drywet")
  kDryWet = $BI_TO_UNI(kDryWet)

  aSigL, aSigR FlexEffectIns

  aSigL *= kPreGainDb
  aSigR *= kPreGainDb

  aDryL = aSigL
  aDryR = aSigR
  
  ; run filters
  aF1L, aF1R FlexFilt aSigL, aSigR, "band1-"
  aSigL, aSigR FlexFilt aF1L, aF1R, aSigL, aSigR, "band2-"


  aSigL, aSigR TanH aSigL, aSigR, kDrive

  ; run filters
  aF1L, aF1R FlexFilt aSigL, aSigR, "band3-"
  aSigL, aSigR FlexFilt aF1L, aF1R, aSigL, aSigR, "band4-"


  ; TODO URGENT: what was this, is it ready to be deleted?
  ; ; dry/wet balance snippet
  ; kDryWet = (kDryWet+1)*.5 ;scale to 0:1
  ; aSigL = (aInL*(1-kDryWet))+(asrcL*kDryWet)
  ; aSigR = (aInR*(1-kDryWet))+(asrcR*kDryWet)

  aSigL = ntrpol(aDryL,aSigL,kDryWet)
  aSigR = ntrpol(aDryR,aSigR,kDryWet)

  FlexEffectOuts aSigL, aSigR
endin
</CsInstruments>  
<CsScore>
</CsScore>
</CsoundSynthesizer>