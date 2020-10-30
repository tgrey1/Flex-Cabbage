/***************
 ***************

DeEss.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

; Looks like Iain's source originally at some point... double check?

Band-pass de-esser with listen-in and adjustable bandwidth
Ratios .5:1 to 20:1

***************
***************/

<Cabbage>
form size(380, 284), caption("DeEss"), pluginID("tds1"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml"), $ROOT

groupbox $BOX bounds(10, 10, 360, 80), text("In/Out") {
  FlexClip bounds(325,5,25,10), namespace("flexclip"), $OUT_OL
  rslider $RED_KNOB bounds(208, 25, 50, 50), $MAIN_GAIN
  rslider $BLUE_KNOB bounds(256, 25, 50, 50), channel("drywet"), range(-100, 100, 100, 1, 0.01), $DRYWET
  FlexPan bounds(304,25,50,50), namespace("flexpan"), $MAIN_PAN
}

groupbox $BOX bounds(10, 94, 360, 180), text("DeEss") {
  rslider $GREEN_KNOB bounds(170,30,90,90), range(.5,20,1,1,.01), channel("ratio"), text("Ratio"), popupprefix("Compression:\n"), popuppostfix(":1")
  rslider $GREEN_KNOB bounds(255, 30, 90, 90), range(-120,0,-30,1,.01), channel("thresh"), text("Thresh"), popupprefix("Threshold:\n"), popuppostfix(" dB")
}

$SHADER size( $SCREEN_WIDTH, $SCREEN_HEIGHT), identchannel("filt-tint")
image $INVIS bounds(10,124,175,130), identchannel("filt-controls") {
  rslider $YELLOW_KNOB bounds(0,0,90,90), range(20,20000,6000,.5,.01), channel("center"), text("Center"), popupprefix("Center Freq:\n"), popuppostfix(" Hz")
  rslider $YELLOW_KNOB bounds(85,0,90,90), range(.1,100,10,1,.1), channel("bw"), text("Width"), popupprefix("Filter Width:\n"), popuppostfix(" %")
  button $HR_BTN bounds(60,100,50,30), text("Listen"), channel("listen"), popuptext("Monitor Filter Sidechain")
}

FlexClip bounds(20,15,25,10), namespace("flexclip"), $IN_OL
StereoCollapse bounds(18,65,100,18), namespace("collapse")

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

opcode DeEss,aa,aa
  aSigL, aSigR xin
  setksmps 1

  ; grab a free table
  iTable ftgen 0, 0, 8192, 10, 1
  kCF chnget "center"
  kBW = .01*chnget:k("bw")
  kDepth chnget "depth"
  kListen chnget "listen"

  kRatio chnget "ratio"
  kThresh chnget "thresh"

  ; This section reinits to redraw the compression table if needed
  ; TODO: this might need to be moved, running at ksmps 1?
  if(changed(kRatio)==1 || changed(kThresh)==1) then
    reinit ReDrawTable
  endif
  ReDrawTable:
    iRatio chnget "ratio"
    iThresh chnget "thresh"
    giCompressShape ftgen   iTable,0,-120,-7, 0, 120+iThresh, 0, -iThresh, (-iThresh/iRatio)+iThresh 
  rireturn

  kBW = kCF*kBW

  aSigLFilt  butbp   aSigL, kCF, kBW
  aSigRFilt  butbp   aSigR, kCF, kBW

  ; kInGain  =         1 ; input gain
  kRMSL rms   aSigLFilt;*kInGain
  kRMSR rms   aSigRFilt;*kInGain
  kDBL      =         dbfsamp(kRMSL)     ; convert to decibels 
  kDBR      =         dbfsamp(kRMSR)     ; convert to decibels 
  kIndexL    limit     kDBL,-120,0            ; limit index values
  kIndexR    limit     kDBR,-120,0              ; limit index values
  kFactL   tablei    kIndexL+120,giCompressShape         ; note how kndx is shifted from -120 to 0, to 0 to 120 (the table size is 120 points) 
  kFactR   tablei    kIndexR+120,giCompressShape         ; note how kndx is shifted from -120 to 0, to 0 to 120 (the table size is 120 points) 
   
  aSigL   =         aSigL*ampdbfs(kFactL)        ; convert from dB value to amplitude scaling value       
  aSigR   =         aSigR*ampdbfs(kFactR)        ; convert from dB value to amplitude scaling value       

  aSigL, aSigR SmoothX aSigL, aSigR, aSigLFilt, aSigRFilt, kListen

  xout aSigL, aSigR
endop


instr Effect
  kDryWet = .01*chnget:k("drywet")
  kDryWet = $BI_TO_UNI(kDryWet)
  kListen chnget "listen"

  FadeUI "filt-tint", kListen

  aSigL, aSigR FlexEffectIns

  aDryL = aSigL
  aDryR = aSigR

  aSigL, aSigR DeEss aSigL, aSigR

  ; TODO: find a good way to declick this
  ; force full wet when filter listen is on
  if(kListen==1) then
    kDryWet=1
  endif

  ; dry/wet balance snippet
  aSigL = ntrpol(aDryL,aSigL,kDryWet)
  aSigR = ntrpol(aDryR,aSigR,kDryWet)

  FlexEffectOuts aSigL, aSigR
endin

</CsInstruments>  
<CsScore>
</CsScore>
</CsoundSynthesizer>
