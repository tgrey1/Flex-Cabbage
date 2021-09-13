/***************
 ***************

MidSide.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

Mid-side encoding/decoding with separate controls for middle and side channels
Uses a Mid-side codec written by Steven Yi: http://www.csounds.com/udo/displayOpcode.php?opcode_id=44

; TODO URGENT: is this working correct?  not familiar with mid-side processing techniques, need examples

***************
***************/

<Cabbage>
form caption("Mid-Side") size(380,294), pluginID("tms1"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In / Out"), visible(1) {
  FlexClip bounds(10,5,25,10), nameSpace("flexclip"), $IN_OL
  FlexClip bounds(325,5,25,10), nameSpace("flexclip"), $OUT_OL
  rslider $RED_KNOB bounds(304, 25, 50, 50), $MAIN_GAIN
}

groupbox $BOX bounds(10, 94, 360, 190), text("Mid-Side") {
  rslider $GREEN_KNOB $GAIN_RANGE bounds(240, 30, 100, 100), channel("side"), text("Side"), popupPrefix("Side Gain:\n"), popupPostfix(" dB")
  rslider $GREEN_KNOB $GAIN_RANGE bounds(130, 30, 100, 100), channel("middle"), text("Middle"), popupPrefix("Mid Gain:\n"), popupPostfix(" dB")
  button $HY_BTN bounds(130, 140, 107, 25), channel("recombine"), latched(1), text("Recombine","Recombined"), value(1)
}

$BYPASS_SHADER size( $SCREEN_WIDTH, $SCREEN_HEIGHT)
TestButtons bounds(56,12,126,18), nameSpace("test_audio")
checkbox $GREEN_CC bounds(20, 35, 90, 25), $MAIN_BYPASS

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
#include "includes/effect.inc.csd"
#include "includes/udo/stereoms.udo.csd"

instr Effect
  kSideDb = ampdb(chnget:k("side"))
  kMiddleDb = ampdb(chnget:k("middle"))
  kRecombine chnget "recombine"

  aSigL, aSigR FlexEffectIns
  aSigL, aSigR stereoMS aSigL, aSigR

  aSigL*=kMiddleDb
  aSigR*=kSideDb

  if(kRecombine==1) then
    aSigL, aSigR stereoMS aSigL, aSigR
  endif

  FlexEffectOuts aSigL, aSigR
endin
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
