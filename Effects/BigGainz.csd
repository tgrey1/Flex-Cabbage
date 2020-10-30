/***************
 ***************

BigGainz.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

Simple gain adjuster with large knobs, range of +-90db
Has separate but linkable controls for each channel.

***************
***************/

<Cabbage>
form caption("Big Gainz") size(380,394), pluginID("tbg1"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml", "plants/collapse.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In / Out") {
  FlexClip bounds(10,5,25,10), namespace("flexclip"), $IN_OL
  FlexClip bounds(325,5,25,10), namespace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), namespace("collapse")
  rslider $RED_KNOB bounds(304, 25, 50, 50), $MAIN_GAIN
}

groupbox $BOX bounds(10, 94, 360, 290), text("Gainz") {
  label $TEXT bounds(64,30,60,20), text("Left")
  label $TEXT bounds(234,30,60,20), text("Right")
  rslider $GREEN_KNOB bounds(4, 55, 180, 180), channel("left"), range(-90, 90, 0, 1, 0.001), popupprefix("Left Gain:\n"), popuppostfix(" dB"), valuetextbox(1)
  rslider $GREEN_KNOB bounds(176, 55, 180, 180), channel("right"), range(-90, 90, 0, 1, 0.001), popupprefix("Right Gain:\n"), popuppostfix(" dB"), valuetextbox(1)
  label $TEXT bounds(64,250,60,20), text("Left")
  label $TEXT bounds(234,250,60,20), text("Right")
  button $HG_BTN bounds(140, 240, 80, 25), channel("link"), latched(1), text("Un-Linked","Linked"), value(1), popuptext("Link L+R")
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
#include "includes/system/udo/oversamp.udo.csd"

instr Effect
  ; TODO: test if this actually helps!
  aLeft OverSamp "left"
  aRight OverSamp "right" 

  aLeft = ampdb(aLeft)
  aRight = ampdb(aRight)

  aSigL, aSigR FlexEffectIns

  aSigL *= aLeft
  aSigR *= aRight

  FlexEffectOuts aSigL, aSigR
endin

instr Gui
  LinkChans "left", "right", "link"
endin
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
