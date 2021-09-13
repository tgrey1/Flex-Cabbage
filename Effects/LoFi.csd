/***************
 ***************

LoFi.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

Bit crushing (via pow) and sample rate reduction (via folding).
This was once an original UDO using a different method (manual bit crush,
but no sample rate fold), but this became a wrapper for Iain's LoFi UDO
when I saw he had already done it better.

***************
***************/

<Cabbage>
form size(380, 400), caption("LoFi"), pluginID("tlfi"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In/Out") {
  FlexClip bounds(10,5,25,10), nameSpace("flexclip"), $IN_OL
  FlexClip bounds(325,5,25,10), nameSpace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), nameSpace("collapse")
  FlexPan bounds(304,25,50,50), nameSpace("flexpan"), $MAIN_PAN

  rslider $RED_KNOB bounds(190, 25, 50, 50), $MAIN_GAIN
  rslider $BLUE_KNOB bounds(256, 25, 50, 50), channel("drywet"), range(-100, 100, 100, 1, 0.01), $DRYWET
}

groupbox $BOX bounds(10, 94, 360, 295), text("LoFi") {

  label $TEXT bounds(10,50,50,15), text("Bits")
  label $TEXT bounds(290,50,50,15), text("Bits")

  nslider $NSLIDER bounds(10,70,50,30), channel("bit1"), range(0,16,16,1,.01), popupText(0)
  nslider $NSLIDER bounds(290,70,50,30), channel("bit2"), range(0,16,0,1,.01), popupText(0)

  hslider $SLIDER bounds(10, 100, 340, 60), channel("bits"), range(0, 1, 0, 1, 0.01), popupText(0)
  hslider $SLIDER bounds(10, 150, 340, 60), channel("resample"), range(0, 100, 0, .3, 0.01), popupText(0)
  
  label $TEXT $HIGHLIGHT bounds(60,40,160,35), text("---"), identChannel("main-label1-c")
  label $TEXT $HIGHLIGHT bounds(85,230,160,35), text("---"), identChannel("main-label2-c")

  checkbox $GREEN_CC bounds(140, 80, 15, 15), channel("int_bits"), popupText("Round Integers")
  label $TEXT bounds(140, 97, 16, 10), text("INT")

  label $TEXT $HIGHLIGHT bounds(105,80,160,20), text("Bits")
  label $TEXT $HIGHLIGHT bounds(100,205,160,20), text("Sample Rate")
  checkbox $GREEN_CC bounds(95, 205, 15, 15), channel("int_resample"), popupText("Round Integers")
  label $TEXT bounds(95, 222, 16, 10), text("INT")

  nslider $NSLIDER bounds(10,210,60,30), channel("sr1"), range(1,44100,44100,1,.01), popupText(0)
  nslider $NSLIDER bounds(280,210,60,30), channel("sr2"), range(1,44100,500,1,.01), popupText(0)

  label $TEXT bounds(10,245,60,15), text("SR")
  label $TEXT bounds(280,245,60,15), text("SR")
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
#include "includes/udo/lofi.udo.csd"

instr Effect
  kResample = .01*chnget:k("resample")
  kDryWet = .01*chnget:k("drywet")
  kDryWet = $BI_TO_UNI(kDryWet)
  kRange chnget "sr2"
  kBits chnget "bits"
  kBit2 chnget "bit2"
  kBit1 chnget "bit1"
  kOffset chnget "sr1"
  kIntResample chnget "int_resample"
  kIntBits chnget "int_bits"

  kRange = sr/kRange
  kOffset = sr/kOffset

  aSigL, aSigR FlexEffectIns

  aDryL = aSigL
  aDryR = aSigR

  ; calculate bits based off of L & R, and whether to round
  kBits ntrpol kBit1, kBit2, kBits
  kBits = (kIntBits==1) ? round(kBits) : kBits

  ; calculate alias based off of , and whether to round
  kResample ntrpol kOffset, kRange, kResample
  kResample = (kIntResample==1) ? round(kResample) : kResample

  kNewSR divz sr, kResample, -99
  kMin divz sr, kOffset, -99
  kMax divz sr, kRange, -99

  GenLabels kBits, kNewSR, "main"

  aSigL, aSigR LoFi aSigL, aSigR, kBits, kResample

  aSigL = ntrpol(aDryL,aSigL,kDryWet)
  aSigR = ntrpol(aDryR,aSigR,kDryWet)

  FlexEffectOuts aSigL, aSigR
endin
</CsInstruments>  
<CsScore>
</CsScore>
</CsoundSynthesizer>
