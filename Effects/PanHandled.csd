/***************
 ***************

PanHandled.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

Pan utility allows left and right channels to have individual controls over
  muting, phase inversion, gain, and pan placement

Gain is linkable between channels
Pan placement is reverse linkable between channels (creating a "width" effect)

***************
***************/

<Cabbage>
form size(230, 630), caption("Pan Handled"), pluginID("tpn1"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml"), $ROOT

groupbox $BOX bounds(10, 10, 210, 80), text("In/Out") {
  FlexClip bounds(10,5,25,10), namespace("flexclip"), $IN_OL
  FlexClip bounds(173,5,25,10), namespace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), namespace("collapse")
  rslider $RED_KNOB bounds(158, 25, 50, 50), $MAIN_GAIN
}

groupbox $BOX bounds(10, 94, 210, 526), text("Pan Handling") {

  label $TEXT bounds(10,25,90,18) text("Left")
  label $TEXT bounds(110,25,90,18) text("Right")

  button $HR_BTN bounds(10, 45, 80, 22), channel("left-mute"), text("Mute","Muted"), popuptext("Mute")
  button $HY_BTN bounds(10, 70, 80, 22), channel("left-phase"), text("Phase","Inverted"), popuptext("Invert Phase")

  button $HR_BTN bounds(93, 45, 24, 22), channel("toggle-mute"), text("X"), popuptext("Toggle Mutes"), latched(0)
  button $HY_BTN bounds(93, 70, 24, 22), channel("toggle-phase"), text("X"), popuptext("Toggle Phases"), latched(0)

  rslider $RED_KNOB $GAIN_RANGE bounds(15, 100, 80, 100), channel("left-gain"), text("L Gain"), popupprefix("Left Gain:\n"), popuppostfix(" dB"), valuetextbox(1)
  rslider $RED_KNOB $GAIN_RANGE bounds(115, 100, 80, 100), channel("right-gain"), text("R Gain"), popupprefix("Right Gain:\n"), popuppostfix(" dB"), valuetextbox(1)
  button $HG_BTN bounds(10, 210, 190, 22), channel("link-gain"), text("Link Gain","Linked Gain"), popuptext("Link Gain")
  button $HR_BTN bounds(120, 45, 80, 22), channel("right-mute"), text("Mute","Muted"), popuptext("Mute")
  button $HY_BTN bounds(120, 70, 80, 22), channel("right-phase"), text("Phase","Inverted"), popuptext("Invert Phase")

  rslider $WHITE_KNOB bounds(15, 240, 80, 100), channel("left-pan"), range(-100, 100, -100, 1, .01), text("L Pan"), popupprefix("Left Pan:\n"), popuppostfix(" %"), valuetextbox(1)
  rslider $WHITE_KNOB bounds(115, 240, 80, 100), channel("right-pan"), range(-100, 100, 100, 1, .01), text("R Pan"), popupprefix("Right Pan:\n"), popuppostfix(" %"), valuetextbox(1)
  button $HG_BTN bounds(10, 350, 190, 22), channel("link-pan"), text("Crosslink Pan","Crosslinked Pan"), popuptext("Crosslink Pan") value(1)

  rslider $GREEN_KNOB $GAIN_RANGE bounds(15, 380, 80, 100), channel("mid-gain"), text("Mid"), popupprefix("Left Pan:\n"), popuppostfix(" dB"), valuetextbox(1)
  rslider $GREEN_KNOB $GAIN_RANGE bounds(115, 380, 80, 100), channel("side-gain"), text("Side"), popupprefix("Right Pan:\n"), popuppostfix(" dB"), valuetextbox(1)
  button $HG_BTN bounds(10, 490, 190, 22), channel("splitMS"), text("Stereo","Mid/Side"), popuptext("Split Mid/Side")
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
#include "includes/udo/stereoms.udo.csd"

instr Effect
  kMid = ampdb(chnget:k("mid-gain"))
  kSide = ampdb(chnget:k("side-gain"))
  kSplitMS = chnget:k("splitMS")
  kLeftGainDb = ampdb(chnget:k("left-gain"))
  kLeftMute chnget "left-mute"
  kLeftPhase chnget "left-phase"

  kRightGainDb = ampdb(chnget:k("right-gain"))
  kRightMute chnget "right-mute"
  kRightPhase chnget "right-phase"

  aSigL, aSigR FlexEffectIns

; phase invert
  ; TODO: URGENT: BUG: this doesn't work anymore? (6.14)
  ; aSigL = (kLeftPhase==1) ? -aSigL : aSigL
  ; aSigR = (kRightPhase==1) ? -aSigR : aSigR
  ; But this does work:
  aSigL *= (kLeftPhase*2)-1
  aSigR *= (kRightPhase*2)-1
; gain
  aSigL *= kLeftGainDb
  aSigR *= kRightGainDb

; mute channels here
  aSigL RSmoothX a(0), aSigL, kLeftMute
  aSigR RSmoothX a(0), aSigR, kRightMute

; pan
  aLeftL, aLeftR SimplePanHandler aSigL, "left-pan"
  aRightL, aRightR SimplePanHandler aSigR, "right-pan"

  aSigL = aLeftL+aRightL
  aSigR = aLeftR+aRightR

  aSigL, aSigR stereoMS aSigL, aSigR
  aSigL *= kMid
  aSigR *= kSide
  printk2 kSplitMS
  if(kSplitMS==0) then
    aSigL, aSigR stereoMS aSigL, aSigR
  endif
  FlexEffectOuts aSigL, aSigR
endin

instr Gui
  LinkChans "left-gain", "right-gain", "link-gain"
  RevLinkChans "left-pan", "right-pan", "link-pan"
  ToggleChans "toggle-mute", fillarray("left-mute","right-mute")
  ToggleChans "toggle-phase", fillarray("left-phase","right-phase")
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>