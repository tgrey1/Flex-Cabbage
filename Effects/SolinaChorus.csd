/***************
 ***************

SolinaChorus.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

This is a simple cabbage wrapper around Steven Yi's
Solina Chorus UDO

***************
***************/
<Cabbage>
form size(380, 368), caption("Solina Chorus 2"), pluginID("tsc2"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In/Out") {
  FlexClip bounds(10,5,25,10), namespace("flexclip"), $IN_OL
  FlexClip bounds(325,5,25,10), namespace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), namespace("collapse")

  rslider $RED_KNOB bounds(208, 25, 50, 50), $MAIN_GAIN
  rslider $BLUE_KNOB bounds(256, 25, 50, 50), channel("drywet"), range(-100, 100, 0, 1, 0.01), $DRYWET
  FlexPan bounds(304,25,50,50), namespace("flexpan"), $MAIN_PAN
}

groupbox $BOX bounds(10, 94, 360, 130), text("Controls") {
  rslider $GREEN_KNOB bounds(5, 30, 80, 80), channel("fscale"), range(.01, 20000, 1, .2), text("Base Freq"), valuetextbox(1), popupprefix("Base Freq:\n"), popuppostfix(" Hz")
  rslider $GREEN_KNOB bounds(93, 30, 80, 80), channel("ascale"), range(.01, 100, 1, .2), text("Base Amp"), valuetextbox(1), popupprefix("Base Amp:\n"), popuppostfix(" %")
  checkbox $GREEN_CC bounds(200, 85, 112, 25), channel("split"), text("Mono Del","Stereo Del"), value(1)
}

groupbox $BOX bounds(10, 228, 178, 130), text("LFO 1") {
  rslider $YELLOW_KNOB bounds(5, 30, 80, 80), channel("freq1"), range(.01, 100, 50), text("Freq"), valuetextbox(1), popupprefix("LFO 1\nFreq Scale:\n"), popuppostfix(" %")
  rslider $YELLOW_KNOB bounds(93, 30, 80, 80), channel("amp1"), range(0, 100, 50), text("Amp"), valuetextbox(1), popupprefix("LFO 1\nAmp Scale:\n"), popuppostfix(" %")
}

groupbox $BOX bounds(192, 228, 178, 130), text("LFO 2") {
  rslider $YELLOW_KNOB bounds(5, 30, 80, 80), channel("freq2"), range(.01, 100, 75), text("Freq"), valuetextbox(1), popupprefix("LFO 2\nFreq Scale:\n"), popuppostfix(" %")
  rslider $YELLOW_KNOB bounds(93, 30, 80, 80), channel("amp2"), range(0, 100, 25), text("Amp"), valuetextbox(1), popupprefix("LFO 2\nAmp Scale:\n"), popuppostfix(" %")
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
#include "includes/udo/solina.udo.csd"

instr Effect
  kDryWet = .01*chnget:k("drywet")
  kDryWet = $BI_TO_UNI(kDryWet)

  kFScale chnget "fscale"
  kAScale chnget "ascale"
  kSplit chnget "split"
  kFreq1 = .01*chnget:k("freq1")*kFScale
  kFreq2 = .01*chnget:k("freq2")*kFScale
  kAmp1 = .01*chnget:k("amp1")*kAScale
  kAmp2 = .01*chnget:k("amp2")*kAScale

  aSigL, aSigR FlexEffectIns

  aDryL = aSigL
  aDryR = aSigR

  aSigL, aSigR SolinaChorusStereo aSigL, aSigR, kFreq1, kAmp1, kFreq2, kAmp2, kSplit

  aSigL = ntrpol(aDryL,aSigL,kDryWet)
  aSigR = ntrpol(aDryR,aSigR,kDryWet)

  FlexEffectOuts aSigL, aSigR
endin
</CsInstruments>  
<CsScore>
</CsScore>
</CsoundSynthesizer>