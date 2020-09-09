/***************
 ***************

CrunchBox.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

Limit/Mirror/Wrap distortion, including assymetric with DC offset correction and 2 filter bands
available both Pre and Post distortion.

Second filter bands can run in parallel or in sequence to first

WARNING: Changing filter mode or depth (recursion) forces a reinit, which may cause clicking.

Filter Controls in I/O section sets which filter variables get reset when filter mode changes.

; TODO: recursion for times through distortion phase?????
; would require distortion offloaded into UDO.  doable?
; perhaps "mlimit" or "limitless"

; TODO: distmix not useful?  does it really just present an inversion, i think so...
; get rid of it?

***************
***************/
<Cabbage>
form size(380, 638), caption("CrunchBox 2"), pluginID("tcr2"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml","plants/flexfilt.xml", "plants/flexfilt_reset.xml", "plants/flexfilt_warn.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In / Out") {
  FlexClip bounds(10,5,25,10), namespace("flexclip"), $IN_OL
  FlexClip bounds(325,5,25,10), namespace("flexclip"), $OUT_OL
  StereoCollapse bounds(8,55,100,18), namespace("collapse")
  FlexPan bounds(304,25,50,50), namespace("flexpan"), $MAIN_PAN

  button $BTN bounds(102,25,50,20), $FILT_RESET

  rslider $RED_KNOB bounds(188, 25, 50, 50), $MAIN_GAIN
  rslider $BLUE_KNOB bounds(246, 25, 50, 50), channel("drywet"), range(-100, 100, 100, 1, 0.01), $DRYWET
}

groupbox $BOX bounds(10, 94, 178, 170), text("Pre-Filt 1") {
  FlexFilt bounds(0,0,178,168), channel("band1-"), namespace("flexfilt")
}
groupbox $BOX bounds(193, 94, 178, 170), text("Pre-Filt 2") {
  FlexFilt bounds(0,0,178,168), channel("band2-"), namespace("flexfilt")
}
groupbox $BOX bounds(10, 462, 178, 170), text("Post-Filt 1") {
  FlexFilt bounds(0,0,178,168), channel("band3-"), namespace("flexfilt")
}
groupbox $BOX bounds(193, 462, 178, 170), text("Post-Filt 2") {
  FlexFilt bounds(0,0,178,168), channel("band4-"), namespace("flexfilt")  
}

groupbox $BOX bounds(10, 268, 360, 190), text("Crunchbox") {
  label $TEXT bounds(10,33,45,16), text("Mode:")
	combobox $COMBO bounds(60, 30, 70, 20), channel("mode"), channeltype("number"), text("Bypass","Limit", "Mirror", "Wrap"), value(2)
	
  rslider $RED_KNOB $GAIN_RANGE bounds(150, 25, 70, 100), channel("pregain"), text("Pre"), popupprefix("PreGain:\n"), popuppostfix(" dB"), valuetextbox(1)
  rslider $RED_KNOB $GAIN_RANGE bounds(220, 25, 70, 100), channel("postgain"), text("Post"), popupprefix("PostGain:\n"), popuppostfix(" dB"), valuetextbox(1)
  rslider $BLUE_KNOB bounds(290, 25, 70, 100), channel("mix"), range(-100, 100, 100, 1, 0.01), text("Mix"), popupprefix("Mix:\n"), popuppostfix(" %"), valuetextbox(1)

	hrange $RANGE bounds(10, 130, 340, 40), range(-100,100,-100:100,1,.01), channel("rmin","rmax")
  label $TEXT bounds(10, 170, 20, 10), text("Min")
  label $TEXT bounds(330, 170, 20, 10), text("Max")
  label $TEXT bounds(10, 165, 340, 13), text("Bounds")
}

$SHADER bounds(0, 0, $SCREEN_WIDTH, $SCREEN_HEIGHT), identchannel("reset-tint")
FlexFiltReset bounds(61,87,258,170), namespace("flexfilt")

$SHADER bounds(0, 0, $SCREEN_WIDTH, $SCREEN_HEIGHT), identchannel("fwarn-tint")
FlexFiltWarn bounds(15,87,350,130), namespace("flexfilt")

$BYPASS_SHADER size( $SCREEN_WIDTH, $SCREEN_HEIGHT)
TestButtons bounds(56,12,126,18), namespace("test_audio")
checkbox $GREEN_CC bounds(20, 35, 90, 25), $MAIN_BYPASS

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0
</CsOptions>
<CsInstruments>
#include "includes/effect.inc.csd"
#include "includes/udo/relimiter.udo.csd"

instr Effect
  kLow = .01*chnget:k("rmin")
  kHigh = .01*chnget:k("rmax")
  kPreGainDb = ampdb(chnget:k("pregain"))
  kPostGainDb = ampdb(chnget:k("postgain"))

  kMix = .01*chnget:k("mix")
  kMix = $BI_TO_UNI(kMix)
  kDryWet = .01*chnget:k("drywet")
  kDryWet = $BI_TO_UNI(kDryWet)

  aSigL, aSigR FlexEffectIns
  aSigL, aSigR MonoCollapse aSigL, aSigR

  aDryL = aSigL
  aDryR = aSigR

; temporarily disable filters until they're completed and added
; ; run filter
;   aF1L, aF1R, aSeqL, aSeqR FlexFilt aSigL, aSigR, "band1-"
;   aF2L, aF2R, aSeqL, aSeqR FlexFilt aSigL, aSigR, aSeqL, aSeqR, "band2-"

;   aSigL = aSeqL + aF1L + aF2L
;   aSigR = aSeqR + aF1R + aF2R

  aSigL *= kPreGainDb
  aSigR *= kPreGainDb

  ; subtract 1, so that the first choice returns 0 instead of 1... 0 causes bypass.
  kMode = chnget:k("mode")-1

  aOutL, aOutR ReLimiter aSigL, aSigR, kMode, kLow, kHigh

  ; bypass dist fixes click on load... hrm
  ; aOutL = 0
  ; aOutR = 0

  aSigL = ntrpol(aSigL,aOutL,kMix)
  aSigR = ntrpol(aSigR,aOutR,kMix)

  aSigL *= kPostGainDb
  aSigR *= kPostGainDb

; temporarily disable filters until they're completed and added
; ; run filter
;   aF3L, aF3R, aSeqL, aSeqR FlexFilt aSigL, aSigR, "band3-"
;   aF4L, aF4R, aSeqL, aSeqR FlexFilt aSigL, aSigR, aSeqL, aSeqR, "band4-"
;   aSigL = aSeqL + aF3L + aF4L
;   aSigR = aSeqR + aF3R + aF4R

  aSigL = ntrpol(aDryL,aSigL,kDryWet)
  aSigR = ntrpol(aDryR,aSigR,kDryWet)

  ; fade on over .1 second, just in case
  kClick linseg 0, .1, 1, 1, 1
  aSigL *= kClick
  aSigR *= kClick

  FlexEffectOuts aSigL, aSigR
endin
</CsInstruments>  
<CsScore>
</CsScore>
</CsoundSynthesizer>