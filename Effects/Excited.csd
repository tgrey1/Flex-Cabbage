/***************
 ***************

Excited.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

Simple Calf Exciter plugin

***************
***************/

<Cabbage>
form caption("Excited") size(380,254), pluginID("tex1"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In / Out") {
  FlexClip bounds(10,5,25,10), namespace("flexclip"), $IN_OL
  FlexClip bounds(325,5,25,10), namespace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), namespace("collapse")
  rslider $BLUE_KNOB bounds(208, 25, 50, 50), channel("drywet"), range(-100, 100, 0, 1, 0.01), $DRYWET
  rslider $RED_KNOB bounds(256,25,50,50), $MAIN_GAIN
  FlexPan bounds(304,25,50,50), namespace("flexpan"), $MAIN_PAN
}

groupbox $BOX bounds(10, 94, 360, 150), text("Stimulation") {
  rslider $GREEN_KNOB bounds(0, 40, 90, 90), channel("hpf"), range(10, 20000, 10, .5, 0.01), text("HPF"), popupprefix("High Pass:\n"), popuppostfix(" Hz")
  rslider $GREEN_KNOB bounds(90, 40, 90, 90), channel("lpf"), range(10, 20000, 20000, .5, 0.01), text("LPF"), popupprefix("Low Pass:\n"), popuppostfix(" Hz")
  rslider $GREEN_KNOB bounds(180, 40, 90, 90), channel("harmonics"), range(1, 100, 5, 1, 0.01), text("Harm"), popupprefix("Harmonics:\n"), popuppostfix(" %")
  rslider $GREEN_KNOB bounds(270, 40, 90, 90), channel("blend"), range(-100, 100, 0, 1, 0.01), text("Blend"), popupprefix("Blend:\n"), popuppostfix(" %")
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
  kHPF chnget "hpf"
  kLPF chnget "lpf"
  kHarmonics = .1*chnget:k("harmonics")
  kBlend  = .1*chnget:k("blend")
  kDryWet = .01*chnget:k("drywet")
  kDryWet = $BI_TO_UNI(kDryWet)

  aSigL, aSigR FlexEffectIns
  aSigL, aSigR MonoCollapse aSigL, aSigR

  aDryL = aSigL
  aDryR = aSigR

  aSigL exciter aSigL, kHPF, kLPF, kHarmonics, kBlend
  aSigR exciter aSigR, kHPF, kLPF, kHarmonics, kBlend

  aSigL = ntrpol(aDryL,aSigL,kDryWet)
  aSigR = ntrpol(aDryR,aSigR,kDryWet)

  FlexEffectOuts aSigL, aSigR
endin
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
