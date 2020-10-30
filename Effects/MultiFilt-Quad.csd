/***************
 ***************

Multi-Filt_Quad.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

A four band recursive multi filter plugin

Additional bands can run in parallel or in a concurrent sequence to first

WARNING: Changing filter mode or depth (recursion) forces a reinit, which may cause clicking.

Filter Controls in I/O section sets which filter variables get reset when filter mode changes.

***************
***************/
<Cabbage>
form size(747, 274), caption("Multi-Filt Quad"), pluginID("tfq1"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml","plants/flexfilt.xml", "plants/flexfilt_reset.xml"), $ROOT

groupbox $BOX bounds(10, 10, 727, 80), text("In / Out") {
  FlexClip bounds(10,5,25,10), namespace("flexclip"), $IN_OL
  FlexClip bounds(692,5,25,10), namespace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), namespace("collapse")
  FlexPan bounds(671,25,50,50), namespace("flexpan"), $MAIN_PAN
  button $BTN bounds(110,25,50,20), $FILT_RESET
  rslider $RED_KNOB bounds(555, 25, 50, 50), $MAIN_GAIN
  rslider $BLUE_KNOB bounds(613, 25, 50, 50), channel("drywet"), range(-100, 100, 100, 1, 0.01), $DRYWET
}

groupbox $BOX bounds(10, 94, 178, 170), text("Band 1") {
  FlexFilt bounds(0,0,178,168), channel("band1-"), namespace("flexfilt")
}
groupbox $BOX bounds(193, 94, 178, 170), text("Band 2") {
  FlexFilt bounds(0,0,178,168), channel("band2-"), namespace("flexfilt")
}
groupbox $BOX bounds(376, 94, 178, 170), text("Band 3") {
  FlexFilt bounds(0,0,178,168), channel("band3-"), namespace("flexfilt")
}
groupbox $BOX bounds(559, 94, 178, 170), text("Band 4") {
  FlexFilt bounds(0,0,178,168), channel("band4-"), namespace("flexfilt")
}

$SHADER bounds(0, 0, $SCREEN_WIDTH, $SCREEN_HEIGHT), identchannel("reset-tint")
FlexFiltReset bounds(244,67,258,170), namespace("flexfilt")

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
  kDryWet = .01*chnget:k("drywet")
  kDryWet = $BI_TO_UNI(kDryWet)

  aSigL, aSigR FlexEffectIns

  aDryL = aSigL
  aDryR = aSigR
    
  aFiltL, aFiltR FlexFilt aSigL, aSigR, "band1-"
  aFiltL, aFiltR FlexFilt aFiltL, aFiltR, aSigL, aSigR, "band2-"
  aFiltL, aFiltR FlexFilt aFiltL, aFiltR, aSigL, aSigR, "band3-"
  aSigL, aSigR FlexFilt aFiltL, aFiltR, aSigL, aSigR, "band4-"

  aSigL = ntrpol(aDryL,aSigL,kDryWet)
  aSigR = ntrpol(aDryR,aSigR,kDryWet)
  
  FlexEffectOuts aSigL, aSigR
endin
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
