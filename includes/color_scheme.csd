/***************
 ***************

color_scheme.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

This is a placeholder color/theme config file.

***************
***************/

; TODO: these get moved into widgets, once they exist. And make sure they match default arrays!
#define FILT_MENU  text("Bypass", "[HP] Atone", "[HP] BQRez", "[HP] Butter", "[HP] Mvc HP", "[HP] Rezzy [!!WARNING!!!]", "[HP] Statevar", "[HP] Kork 35", "[HP] K35 Non-Linear", "[Eq] Low Shelf", "[Eq] High Shelf", "[Eq] Peak", "[BP] BQRez", "[BP] Butter", "[BP] Reson", "[BP] Resonr", "[BP] Resonz", "[BP] Statevar", "[BR] BQRez", "[BR] Butter", "[BR] Statevar", "[LP] BQRez", "[LP] Butter", "[LP] LowRes", "[LP] LPF18", "[LP] Moog Ladder", "[LP] Moog Ladder 2", "[LP] Moog VCF 2", "[LP] Bob Filt", "[LP] Mvc 1", "[LP] Mvc 2", "[LP] Mvc 3", "[LP] Rezzy [!!WARNING!!]", "[LP] Statevar", "[LP] Tone", "[LP] Korg 35", "[LP] K35 Non-Linear", "[LP] Diode Ladder", "[LP] Diode Ladder Non-Linear 1", "[LP] Diode Ladder Non-Linear 2")
#define SHAPE_MENU items("Sine [8 partials]", "Line [1 seg]", "Pyramid [2 seg]", "Triangle [3 seg]", "Square [3 Seg]", "Pulse [Width]", "Saw [3 Seg]", "Reverse Saw [3 Seg]", "Even Harmonics", "Odd Harmonics", "Ext.Sine [2^7 partials]", "Gen 13 Polynom", "Gen14 Polynom", "Noise", "Morph")

/***************
***************

This color config is *NOT* generated by ColorPicker.csd
TODO URGENT: make ColorPicker output match this, including order.  comments not needed, there will be a commented example!
Look at the default color config file for documentation

***************
***************/

; These utility macros allow the common global controls to be accessed without having to remember channel name or having to reset up the range or popup styles
; Also allows easy changing/renaming across all instances if needed!
#define MAIN_GAIN range(-90,90,0,1,.01), channel("MainGain"), text("Gain") popupprefix("Main Gain:\n"), popuppostfix(" dB")
#define MAIN_VEL channel("MainVelCurve"), range(-100, 100, 25, 1, 0.01), text("Vel"), popupprefix("Velocity Offset:\n"), popuppostfix(" %")
#define MAIN_PAN channel("MainPan")
#define IN_OL channel("inOL-")
#define OUT_OL channel("outOL-")
#define MAIN_DRYWET channel("MainDryWet"), text("Dry/Wet"), popupprefix("Dry/Wet:\n"), popuppostfix(" %")
#define DRYWET text("Dry/Wet"), popupprefix("Dry/Wet:\n"), popuppostfix(" %")
#define DRY text("Dry"), popupprefix("Dry:\n"), popuppostfix(" dB")
#define WET text("Wet"), popupprefix("Wet:\n"), popuppostfix(" dB")
#define SEND text("Send"), popupprefix("Send:\n"), popuppostfix(" dB")
#define MAIN_BYPASS channel("bypass"), text("Bypass","Bypassed")
#define FILT_RESET text("Filt.Ctl","Hide"), channel("mf_showresets"), popuptext("Toggle the filter reset control panel"), identchannel("show-c")
#define GAIN_RANGE range(-90, 90, 0, 1, 0.01)
#define SYNTHCTL_BTN channel("SynthCtlPop"), text(">"), popuptext("Toggle Synth Control Panel")
#define FXCTL_BTN channel("FXCtlPop"), text("<"), popuptext("Toggle FX Control Panel")

; meant for use with image widgets to create invisible containers for other widgets
#define INVIS colour(0,0,0,0), mouseinteraction(0)

; SHADER and BYPASS_SHADER style
; SHADER and BYPASS_SHADER keep image widget calls, so they "disappear" if the color file hasn't defined them
#define OLDSHADER image colour(5,0,20,200), visible(0)
#define SHADER image colour(5,0,20,200), mouseinteraction(0), alpha(0), pos(0,0)
; mouseinteraction(0) allows control of widgets underneath when bypass is enabled!
#define BYPASS_SHADER image colour(5,0,20,200), mouseinteraction(0), identchannel("bypass-shader"), pos(0,0), alpha(0)


; This defines the color for the main window
#define ROOT colour(30,20,40,255)

; these ones are experimental, not really complete yet
#define ENCODER colour(100,100,100,255), trackercolour(120,255,120,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(120,255,120,255)
#define VMETER overlaycolour(20, 0, 50, 255) metercolour:0(200, 0, 170, 255) metercolour:1(100, 0, 100, 255) metercolour:2(40, 0, 40, 255) outlinethickness(2), outlinecolour(80,80,80,255)

; all container styles
#define BOX colour(60,60,60,255), fontcolour(180,180,180,255)
#define BYPASSED_BOX colour(40,40,40,255), fontcolour(120,120,120,255)
; TODO: these two with mouseinteraction(0) still pass mouse underneath, but they shouldn't?  test more.
#define POPUP_BOX colour(60,60,60,200), fontcolour(180,180,180,255), mouseinteraction(0)
#define WARN_BOX colour(40,0,0,220), fontcolour(255,140,140,255), mouseinteraction(0)
#define PANEL colour(80,80,80,255), corners(5)

; knob styles
#define RED_KNOB colour(100,100,100,255), trackercolour(255,80,80,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(255,80,80,255)
#define YELLOW_KNOB colour(100,100,100,255), trackercolour(255,255,120,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(255,255,120,255)
#define GREEN_KNOB colour(100,100,100,255), trackercolour(120,255,120,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(120,255,120,255)
#define BLUE_KNOB colour(100,100,100,255), trackercolour(0,150,255,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(0,150,255,255)
#define CYAN_KNOB colour(100,100,100,255), trackercolour(120,255,255,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(120,255,255,255)
#define WHITE_KNOB colour(100,100,100,255), trackercolour(255,255,255,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(255,255,255,255)

; slider and range styles
#define SLIDER colour(180,180,180,255), trackercolour(140,0,240,255), fontcolour(180,180,180,255), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255)
#define BLANK_SLIDER colour(180,180,180,255), trackercolour(0,0,0,0), fontcolour(180,180,180,255), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255)
#define NSLIDER colour(70,70,70,255), outlinecolour(80,80,80,255), fontcolour(180,180,180,255)
#define RANGE colour(180,180,180,255), trackercolour(140,0,240,255), fontcolour(180,180,180,255)

; meant to be used with nslider to create invisible settings...
; TODO: find a better way to do this
#define INVIS_NUM bounds(1,1,1,1), active(0), visible(0), colour(255,0,0,255)

; combobox style
#define COMBO colour(70,70,70,255), fontcolour(180,180,180,255), outlinecolour(90,90,90,255), outlinethickness(4)

; checkbox and checkcircle styles
#define GREEN_CC colour:0(40,10,40,255), colour:1(150,0,255,255), fontcolour(180,180,180,255), shape("circle")
#define GREEN_CB colour:0(40,10,40,255), colour:1(150,0,255,255), fontcolour(180,180,180,255), shape("square")
#define RED_CC colour:0(40,10,10,255), colour:1(255,0,0,255), fontcolour(180,180,180,255), shape("circle")
#define RED_CB colour:0(40,10,10,255), colour:1(255,0,0,255), fontcolour(180,180,180,255), shape("square")

; button styles
#define BTN colour:0(80,80,80,255), colour:1(130,130,130,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(90,90,90,255), outlinethickness(2)
#define HG_BTN colour:0(80,80,80,255), colour:1(80,200,80,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(60,100,60,255), outlinethickness(2)
#define HY_BTN colour:0(80,80,80,255), colour:1(160,160,60,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(120,120,60,255), outlinethickness(2)
#define HR_BTN colour:0(80,80,80,255), colour:1(200,80,80,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(100,60,60,255), outlinethickness(2)
#define FG_BTN colour:0(0,60,0,255), colour:1(80,200,80,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(60,100,60,255), outlinethickness(2)
#define FY_BTN colour:0(80,80,0,255), colour:1(160,160,60,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(120,120,60,255), outlinethickness(2)
#define FR_BTN colour:0(80,0,0,255), colour:1(200,80,80,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(100,60,60,255), outlinethickness(2)
#define TAB_BTN colour:0(70,70,70,255), colour:1(100,100,100,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255)
#define FILE_BTN colour:0(80,80,80,255), colour:1(160,160,160,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(90,90,90,255), outlinethickness(4)
#define GFILE_BTN colour:0(80,80,80,55), colour:1(150,0,255,100), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(150,0,255,100), outlinethickness(2)

; graph, graph text, soudfiles, and scrubbers
; the graph file button is above with the buttons!
#define GRAPH tablecolour(100,0,200,95), tablebackgroundcolour(0,0,0,255), tablegridcolour(30,0,60,240), zoom(-1)
#define GRAPH_TEXT colour(0,0,0,0), fontcolour(150,0,255,100) align("right")
#define SOUNDFILE colour(100,0,200,95), tablebackgroundcolour(0,0,0,255)
#define SCRUBBER colour(150,0,255,255)
#define PHASE_SCRUBBER colour(255,0,0,255)

; LED styles
; TODO: can these be converted into checkboxes?  probably!
#define R_LED_OFF colour(40,10,10,255), corners(2)
#define R_LED_ON colour(255,0,0,255), corners(2)
#define G_LED_OFF colour(10,40,10,255), corners(2)
#define G_LED_ON colour(50,255,50,255), corners(2)
#define Y_LED_OFF colour(40,40,0,255), corners(2)
#define Y_LED_ON colour(220,220,120,255), corners(2)

; keyboard style
#define KBD keydowncolour("100,0,200,195"), mouseoverkeycolour("100,0,200,195"), whitenotecolour("255,255,255,255"), blacknotecolour("0,0,0,255"), arrowcolour("60,60,60,255"), arrowbackgroundcolour("180,180,180,255"), value(36)

; text widget styles
#define TEXT colour(0,0,0,0), fontcolour(180,180,180,255), fontstyle("normal")
#define HEADER colour(100,100,100,255), fontcolour(180,180,180,255), fontstyle("normal")
#define TEXTBOX colour(70,70,70,255), outlinecolour(250,80,80,255), fontcolour(180,180,180,255)

; text widgets for warning windows
#define WARN_HEAD colour(0,0,0,0), fontcolour(255,140,140,255), fontstyle("normal")
#define WARN_TEXT colour(0,0,0,0), fontcolour(200,200,200,255), fontstyle("normal")

; does not set a color, use with TEXT, HEADER, or almost any other widget!
#define HIGHLIGHT fontcolour(180,160,255,255), fontstyle("bold")
#define REINIT_TEXT  fontcolour(255,0,0,255), textcolour(255,0,0,255)

;;;;;;;;;;;;;;;;;;;;;;

; TODO: these won't expand in csopts section, feature request perhaps?
; https://forum.cabbageaudio.com/t/idea-allow-macro-expansion-tokenization-of-csoptions/2098
#define CSOPTS -d -+rtmidi=NULL -M0
#define CSMIDIOPTS -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
#define FLEX_PATH ../
; #define FLEX_PATH /Users/tgrey/Documents/GitHub/Flex-Cabbage/
