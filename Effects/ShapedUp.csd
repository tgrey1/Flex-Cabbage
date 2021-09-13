/***************
 ***************

ShapedUp.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

Flexible waveshape distortion with customizable waveshapes and 2 filter bands
available both Pre and Post distortion.

Second filter bands can run in parallel or in sequence to first

WARNING: Changing filter mode or depth (recursion) forces a reinit, which may cause clicking.

Filter Controls in I/O section sets which filter variables get reset when filter mode changes.

***************
***************/
<Cabbage>
form size(380, 682), caption("ShapedUp 2"), pluginID("tsu2"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml","plants/flexfilt.xml", "plants/flexfilt_reset.xml", "plants/flexshaper.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In / Out") {
  FlexClip bounds(10,5,25,10), nameSpace("flexclip"), $IN_OL
  FlexClip bounds(325,5,25,10), nameSpace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), nameSpace("collapse")
  FlexPan bounds(304,25,50,50), nameSpace("flexpan"), $MAIN_PAN

  button $BTN bounds(102,25,50,20), $FILT_RESET

  rslider $RED_KNOB $GAIN_RANGE bounds(157, 25, 50, 50), channel("pregain"), text("Pre"), popupPrefix("PreGain:\n"), popupPostfix(" dB")
  rslider $RED_KNOB bounds(200, 25, 50, 50), $MAIN_GAIN
  rslider $BLUE_KNOB bounds(256, 25, 50, 50), channel("drywet"), range(-100, 100, 100, 1, 0.01), $DRYWET
}

; All controls for this groupbox appear later, above a shader layer. 
groupbox $BOX bounds(10, 268, 360, 230), text("Distort")

groupbox $BOX bounds(10, 94, 178, 170) text("Pre-Filt 1") {
  FlexFilt bounds(0,0,178,168), channel("band1-"), nameSpace("flexfilt")
}
groupbox $BOX bounds(193, 94, 178, 170) text("Pre-Filt 2") {
  FlexFilt bounds(0,0,178,168), channel("band2-"), nameSpace("flexfilt")
}
groupbox $BOX bounds(10, 502, 178, 170) text("Post-Filt 1") {
  FlexFilt bounds(0,0,178,168), channel("band3-"), nameSpace("flexfilt")
}
groupbox $BOX bounds(193, 502, 178, 170) text("Post-Filt 2") {
  FlexFilt bounds(0,0,178,168), channel("band4-"), nameSpace("flexfilt")

}

$SHADER bounds(0, 0, $SCREEN_WIDTH, $SCREEN_HEIGHT), identChannel("graph1-tint")

gentable $GRAPH bounds(130, 308, 230, 180), identChannel("graph1-graph"), tableNumber(1), visible(1)
nslider $INVIS_NUM range(0,100,1), channel("graph1-table")

label $TEXT bounds(20, 309, 80, 15), text("WaveShape:")
combobox $COMBO bounds(20, 328, 100, 25), channel("graph1-shape"), $SHAPE_MENU, value(1)
button $BTN bounds(20, 369, 107, 25), channel("graph1-pop"), latched(1), text("Customize"), value(0)
rslider $GREEN_KNOB bounds(30, 400, 90, 90), channel("dist"), range(0, 100, 50, 1, 0.01), text("Distortion"), popupPrefix("Shape Amount: "), popupPostfix(" %")

FlexShaper bounds(10, 62, 360, 240), channel("graph1-"), nameSpace("flexshaper")

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

instr Effect
  ; read I/O widgets
  kPreGainDb = ampdb(chnget:k("pregain"))
  kDryWet = .01*chnget:k("drywet")
  kDryWet = $BI_TO_UNI(kDryWet)

  ; read Distort widgets
  kDist = .01*chnget:k("dist")

  aSigL, aSigR FlexEffectIns

  aDryL = aSigL
  aDryR = aSigR

  aSigL *= kPreGainDb
  aSigR *= kPreGainDb

  ; run filter
  aFiltL, aFiltR FlexFilt aSigL, aSigR, "band1-"
  aSigL, aSigR FlexFilt aFiltL, aFiltR, aSigL, aSigR, "band2-"

  aSigL distort aSigL, kDist, 1
  aSigR distort aSigR, kDist, 1

  ; run filter
  aFiltL, aFiltR FlexFilt aSigL, aSigR, "band3-"
  aSigL, aSigR FlexFilt aFiltL, aFiltR, aSigL, aSigR, "band4-"

  aSigL = ntrpol(aDryL,aSigL,kDryWet)
  aSigR = ntrpol(aDryR,aSigR,kDryWet)

  FlexEffectOuts aSigL, aSigR
endin

instr Gui
  FlexShaperMon "graph1-", "Waveshaping Table"
endin
</CsInstruments>  
<CsScore>
</CsScore>
</CsoundSynthesizer>
