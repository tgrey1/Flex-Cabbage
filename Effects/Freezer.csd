/***************
 ***************

Freezer.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

Freeze delay effect with subtly different "delay" modes
Options to "lock" on, and to include dry signal

; TODO: can this be made to be tempo synced? (in progress)

***************
***************/

<Cabbage>
; form caption("Freezer") size(380,294), pluginID("test"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml", "plants/flexsyncdel.xml", "plants/flexsyncknob.xml"), $ROOT
form caption("Freezer") size(380,294), pluginID("test"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_audio.xml","plants/collapse.xml","plants/flexpan.xml"), $ROOT

  groupbox $BOX bounds(10, 10, 360, 80), text("In / Out") {
    FlexClip bounds(10,5,25,10), namespace("flexclip"), $IN_OL
    FlexClip bounds(325,5,25,10), namespace("flexclip"), $OUT_OL
    StereoCollapse bounds(8,55,100,18), namespace("collapse")
    rslider $RED_KNOB bounds(254, 25, 50, 50), $MAIN_GAIN
    FlexPan bounds(304,25,50,50), namespace("flexpan"), $MAIN_PAN
  }

  groupbox $BOX bounds(10, 94, 360, 190), text("Freezer") {
    ; FlexSyncKnob bounds(0,20,120,120), channel("sync"), namespace("flexsyncknob")
    rslider $GREEN_KNOB bounds(0,20,120,120), range(1,250,50,1,.01), text("Time"), channel("time"), popupprefix("Loop time:\n"), popuppostfix(" ms"), valuetextbox(1)
    rslider $GREEN_KNOB bounds(100,20,120,120), range(0,100,100,1,.01), text("Feedback"), channel("fb"), popupprefix("Feedback:\n"), popuppostfix(" %"), valuetextbox(1)
    combobox $COMBO bounds(250,30,100,25), items("deltap", "deltapi", "deltap3", "vdelay","vdelay3"), channel("mode")
    ; FlexSyncDel bounds(250,75,100,100), namespace("flexsyncdel"), channel("TEST")
    button $HG_BTN bounds(10,150,60,30), text("Freeze","Frozen"), latched(0), channel("freeze"), identchannel("freeze-id"), popuptext("Freeze Audio")
    button $HY_BTN bounds(80,150,60,30), text("Instant","Toggle"), latched(1), channel("toggle"), popuptext("Latch or unlatch freeze controls")
    button $HR_BTN bounds(150,150,60,30), text("Excluded","Included"), latched(1), channel("include"), popuptext("Include or exclude audio source while freezing")
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

opcode FreezeDel,aa,aaS
  aInL, aInR, SChanPrefix xin
  kFB = .01*chnget:k(strcat(SChanPrefix,"fb"))
  kFreeze chnget strcat(SChanPrefix,"freeze")
  kMode chnget strcat(SChanPrefix,"mode")
  kInclude chnget strcat(SChanPrefix,"include")

  ; Make this dynamic based off flexsync widgets
  ; which will need comments about 
  kTime chnget strcat(SChanPrefix,"time")
  ; kTime2 FlexSyncDel "TEST", "TESTDEL"
  ; printk2 kTime2

  ; reinit and turn off freeze when mode changes
  if(changed(kMode)==1) then
    reinit MyReinit
    chnset k(0), strcat(SChanPrefix,"freeze")
  endif

  MyReinit:
  iMode = i(kMode)

  aFBL init 0
  aFBR init 0
  kFB = kFreeze*kFB

  ; if freeze is on, aSigs will be empty, nothing new fed into delay line
  aSigL, aSigR Bypass aInL, aInR, kFreeze

  if(iMode==1) then
    kTime *= .001
    aBufL delayr .251
    aTapL deltap kTime
    delayw aSigL+aFBL

    aBufR delayr .251
    aTapR deltap kTime
    delayw aSigR+aFBR
  elseif(iMode==2) then
    kTime *= .001
    aBufL delayr .251
    aTapL deltapi kTime
    delayw aSigL+aFBL

    aBufR delayr .251
    aTapR deltapi kTime
    delayw aSigR+aFBR
  elseif(iMode==3) then
    kTime *= .001
    aBufL delayr .251
    aTapL deltap3 kTime
    delayw aSigL+aFBL

    aBufR delayr .251
    aTapR deltap3 kTime
    delayw aSigR+aFBR

  elseif(iMode==4) then
    aTapL vdelay aSigL+aFBL, kTime, 251
    aTapR vdelay aSigR+aFBR, kTime, 251
  else
    aTapL vdelay3 aSigL+aFBL, kTime, 251
    aTapR vdelay3 aSigR+aFBR, kTime, 251
  endif

  ; copy over to feedback buffer, including kFB amount
  aFBL = aTapL*kFB
  aFBR = aTapR*kFB

  ; if freeze is off, feed nothing out.  needed since line is constantly fed when not frozen
  aTapL, aTapR Bypass aTapL+(aInL*kInclude), aTapR+(aInR*kInclude), aInL, aInR, kFreeze

  xout aTapL, aTapR
endop

instr Effect
  kToggle chnget "toggle"
  kInclude chnget "include"
  kMode chnget "mode"
  kFreeze chnget "freeze"

  ; control "freeze" latch() behavior based on toggle button
  if (changed(kToggle)==1) then
    chnset sprintfk("latched(%d)",kToggle), "freeze-id"
    if (kToggle==0) then
      chnset k(0), "freeze"
    endif
  endif

  aSigL, aSigR FlexEffectIns
  aSigL, aSigR MonoCollapse aSigL, aSigR

  aSigL, aSigR FreezeDel aSigL, aSigR, ""
  
  FlexEffectOuts aSigL, aSigR
endin
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
