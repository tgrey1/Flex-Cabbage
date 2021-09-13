/***************
 ***************


ReRea.csd
  by tgrey
REPL_VERSION
REPL_DATE

A reimagining of ReaSynth from Reaper DAW.
Simple mixing of waveforms

***************
***************/

<Cabbage>
form caption("ReRea Synth") size(579,484), pluginID("trea"), import("includes/color_scheme.csd","plants/flexclip.xml","plants/test_midi.xml","plants/flexpan.xml","plants/flexadsr.xml", "plants/flexfx.xml", "plants/flexsynthctl.xml", "plants/midimon.xml"), $ROOT

  groupbox $BOX bounds(20, 10, 539, 80), text("In / Out") {
    MidiMon bounds(10,5,35,10) nameSpace("midimon")
    TestButtons bounds(60,2,126,18), nameSpace("test_midi")
    FlexClip bounds(504,5,25,10), nameSpace("flexclip"), $OUT_OL
    rslider $RED_KNOB bounds(399, 25, 50, 50), $MAIN_VEL
    rslider $RED_KNOB bounds(439, 25, 50, 50), $MAIN_GAIN
    FlexPan bounds(479,25,50,50), nameSpace("flexpan"), $MAIN_PAN
  }

  groupbox $BOX bounds(20, 94, 290, 296), text("ReRea Synth") {
    hslider $SLIDER pos(5,20), size(275,40), range(0,100,0,1,.01), channel("SquareMix"), popupPrefix("Square Mix\n"), popupPostfix(" %"), valueTextBox(1)
    hslider $SLIDER pos(5,60), size(275,40), range(1,50,50,1,.01), channel("PulseWidth"), popupPrefix("Pulse Width\n"), popupPostfix(" %"), valueTextBox(1)
    hslider $SLIDER pos(5,100), size(275,40), range(0,100,0,1,.01), channel("SawMix"), popupPrefix("Saw Mix\n"), popupPostfix(" %"), valueTextBox(1)
    hslider $SLIDER pos(5,140), size(275,40), range(0,100,0,1,.01), channel("TriMix"), popupPrefix("Triangle Mix\n"), popupPostfix(" %"), valueTextBox(1)
    hslider $SLIDER pos(5,180), size(275,40), range(0,100,0,1,.01), channel("SineMix"), popupPrefix("Extra Sine Mix\n"), popupPostfix(" %"), valueTextBox(1)
    hslider $SLIDER pos(5,220), size(275,40), range(-2400,2400,0,1,1), channel("SineTune"), popupPrefix("Extra Sine Fine Tune\n"), popupPostfix(" cents"), valueTextBox(1)
    hslider $SLIDER pos(5,260), size(275,40), range(0,100,0,1,.01), channel("NoiseMix"), popupPrefix("Noise Mix\n"), popupPostfix(" %"), valueTextBox(1)
  }

groupbox $BOX bounds(314, 94, 245, 296), text("Envelope Ctrl") {
  FlexADSR bounds(10,30,225,256), channel("env-"), nameSpace("flexadsr")
},


keyboard $KBD bounds(20, 394, 539, 80)

$SHADER size( $SCREEN_WIDTH, $SCREEN_HEIGHT), identChannel("button-tint")

groupbox $BOX bounds(-220,10,220,464) text("Pitch/Mod Wheel"), identChannel("synthctl"), mouseInteraction(1) {
  FlexSynthCtl bounds(10,0,210,464), nameSpace("flexsynthctl")
}

groupbox $BOX bounds(569,10,255,464), text(" FX:"), identChannel("fxctl"), mouseInteraction(1) {
  FlexFX bounds(0,0,245,464), channel("flexfx-"), nameSpace("flexfx")
}

button $HR_BTN bounds(0,10,10,464), $SYNTHCTL_BTN
button $HR_BTN bounds(569,10,10,464), $FXCTL_BTN

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
#include "includes/synth.inc.csd"

instr Synth,1
  iAmp FlexBaseAmp p5
  aEnv FlexADSR "env-"

  kFreq FlexBaseFreq p4

  kSquareMix = .01*chnget:k("SquareMix")
  kPulseWidth = .01*chnget:k("PulseWidth")
  kTriMix = .01*chnget:k("TriMix")
  kSawMix = .01*chnget:k("SawMix")
  kExtSineMix = .01*chnget:k("SineMix")
  kSineTune chnget "SineTune"
  kSineTune = cent(kSineTune)
  kNoiseMix = .01*chnget:k("NoiseMix")

  iAmp *= .25

  kSineMix = max(0,1-(kSquareMix+kTriMix+kSawMix+kNoiseMix))

  aSine poscil iAmp*kSineMix, kFreq
  aExtSine poscil iAmp*kExtSineMix, kFreq*kSineTune

  aSquare vco2 iAmp*kSquareMix, kFreq, 2, kPulseWidth
  aTri vco2 iAmp*kTriMix, kFreq, 12
  aSaw vco2 iAmp*kSawMix, kFreq, 0
  aNoise rand iAmp*kNoiseMix

  ; simple accumulation for now... this *CAN"T* be this simple... can it?
  aSig = aSine+aSquare+aTri+aSaw+aExtSine+aNoise

  ; apply ADSR env and any LFO amp modulation
  aSig *= aEnv*.5

  chnmix aSig, "SynthLeft"
  chnmix aSig, "SynthRight"
endin

; this instr handles all gui changes
instr Gui
  FlexADSR_Mon "env-", 1

  kSynthPop chnget "SynthCtlPop"
  kFXPop chnget "FXCtlPop"
  SlideUI "synthctl", kSynthPop, -220,10,0,10
  SlideUI "fxctl", kFXPop, 579,10,324,10
  ChanXOR "SynthCtlPop", "FXCtlPop"
  FadeUI "button-tint", kSynthPop | kFXPop
endin
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
