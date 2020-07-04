/***************
 ***************

color_scheme.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

This is a placeholder color/theme config file.

***************
***************/

#define ROOT colour(30,20,40,255)

; TODO: these get moved into widgets, once they exist. And make sure they match default arrays!
#define FILT_MENU  text("Bypass", "[HP] Atone", "[HP] BQRez", "[HP] Butter", "[HP] Mvc HP", "[HP] Rezzy [!!WARNING!!!]", "[HP] Statevar", "[HP] Kork 35", "[HP] K35 Non-Linear", "[Eq] Low Shelf", "[Eq] High Shelf", "[Eq] Peak", "[BP] BQRez", "[BP] Butter", "[BP] Reson", "[BP] Resonr", "[BP] Resonz", "[BP] Statevar", "[BR] BQRez", "[BR] Butter", "[BR] Statevar", "[LP] BQRez", "[LP] Butter", "[LP] LowRes", "[LP] LPF18", "[LP] Moog Ladder", "[LP] Moog Ladder 2", "[LP] Moog VCF 2", "[LP] Mvc 1", "[LP] Mvc 2", "[LP] Mvc 3", "[LP] Rezzy [!!WARNING!!]", "[LP] Statevar", "[LP] Tone", "[LP] Korg 35", "[LP] K35 Non-Linear", "[LP] Diode Ladder", "[LP] Diode Ladder Non-Linear 1", "[LP] Diode Ladder Non-Linear 2")
#define SHAPE_MENU items("Sine [8 partials]", "Line [1 seg]", "Pyramid [2 seg]", "Triangle [3 seg]", "Square [3 Seg]", "Pulse [Width]", "Saw [3 Seg]", "Reverse Saw [3 Seg]", "Even Harmonics", "Odd Harmonics", "Ext.Sine [2^7 partials]", "Gen 13 Polynom", "Gen14 Polynom", "Noise", "Morph")

/***************
***************

This color config is generated by ColorPicker.csd
Look at the default color config file for documentation

***************
***************/


#define GROUPBOX groupbox colour(60,60,60,255), fontcolour(180,180,180,255)
#define BYPASSED_GROUPBOX groupbox colour(40,40,40,255), fontcolour(120,120,120,255)
#define POPUP_GROUPBOX groupbox colour(60,60,60,200), fontcolour(180,180,180,255)
#define WARN_GROUPBOX groupbox colour(40,0,0,220), fontcolour(255,140,140,255)
#define CONTAINER image colour(0,0,0,0)
#define PANEL image colour(80,80,80,255), corners(5)

#define COMBO combobox colour(70,70,70,255), fontcolour(180,180,180,255), outlinecolour(90,90,90,255), outlinethickness(4)

#define NSLIDER nslider colour(70,70,70,255), outlinecolour(80,80,80,255), fontcolour(180,180,180,255)
#define TEXTBOX texteditor colour(70,70,70,255), outlinecolour(250,80,80,255), fontcolour(180,180,180,255)
#define INVIS_NUM nslider bounds(1,1,1,1), active(0), visible(0), colour(255,0,0,255)

#define GAIN_KNOB rslider colour(100,100,100,255), trackercolour(255,80,80,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(255,80,80,255)
#define DW_KNOB rslider colour(100,100,100,255), trackercolour(0,150,255,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(0,150,255,255)
#define ENV_KNOB rslider colour(100,100,100,255), trackercolour(120,255,255,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(120,255,255,255)
#define PAN_KNOB rslider colour(100,100,100,255), trackercolour(255,255,255,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(255,255,255,255)
#define EFF_KNOB rslider colour(100,100,100,255), trackercolour(120,255,120,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(120,255,120,255)
#define FILT_KNOB rslider colour(100,100,100,255), trackercolour(255,255,120,255), fontcolour(180,180,180,255), textcolour(180,180,180,255), trackerinsideradius(0.850), trackeroutsideradius(1.000), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255), markercolour(255,255,120,255)
#define VSLIDER vslider colour(180,180,180,255), trackercolour(140,0,240,255), fontcolour(180,180,180,255), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255)
#define BLANK_VSLIDER vslider colour(180,180,180,255), trackercolour(0,0,0,0), fontcolour(180,180,180,255), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255)
#define HSLIDER hslider colour(180,180,180,255), trackercolour(140,0,240,255), fontcolour(180,180,180,255), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255)
#define BLANK_HSLIDER hslider colour(180,180,180,255), trackercolour(0,0,0,0), fontcolour(180,180,180,255), textboxoutlinecolour(80,80,80,255), textboxcolour(70,70,70,255)

#define VRANGE vrange colour(180,180,180,255), trackercolour(140,0,240,255), fontcolour(180,180,180,255)
#define HRANGE hrange colour(180,180,180,255), trackercolour(140,0,240,255), fontcolour(180,180,180,255)

#define BUTTON button colour:0(80,80,80,255), colour:1(130,130,130,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(90,90,90,255), outlinethickness(2)
#define HG_BUTTON button colour:0(80,80,80,255), colour:1(80,200,80,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(60,100,60,255), outlinethickness(2)
#define HY_BUTTON button colour:0(80,80,80,255), colour:1(160,160,60,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(120,120,60,255), outlinethickness(2)
#define HR_BUTTON button colour:0(80,80,80,255), colour:1(200,80,80,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(100,60,60,255), outlinethickness(2)
#define FG_BUTTON button colour:0(0,60,0,255), colour:1(80,200,80,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(60,100,60,255), outlinethickness(2)
#define FY_BUTTON button colour:0(80,80,0,255), colour:1(160,160,60,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(120,120,60,255), outlinethickness(2)
#define FR_BUTTON button colour:0(80,0,0,255), colour:1(200,80,80,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(100,60,60,255), outlinethickness(2)
#define TAB_BUTTON button colour:0(70,70,70,255), colour:1(100,100,100,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255)

#define FILE_BUTTON filebutton colour:0(80,80,80,255), colour:1(160,160,160,255), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(90,90,90,255), outlinethickness(4)
#define GFILE_BUTTON filebutton colour:0(80,80,80,55), colour:1(150,0,255,100), fontcolour:1(180,180,180,255), fontcolour:0(180,180,180,255), outlinecolour(150,0,255,100), outlinethickness(2)

#define GRAPH gentable tablecolour(100,0,200,95), tablebackgroundcolour(0,0,0,255), tablegridcolour(30,0,60,240), zoom(-1)
#define SOUNDFILE soundfiler colour(100,0,200,95), tablebackgroundcolour(0,0,0,255)
#define GRAPH_TEXT label colour(0,0,0,0), fontcolour(150,0,255,100) align("right")

#define SCRUBBER image colour(150,0,255,255)
#define PHASE_SCRUBBER image colour(255,0,0,255)

#define GREEN_CCB checkbox colour:0(40,10,40,255), colour:1(150,0,255,255), fontcolour(180,180,180,255), shape("circle")
#define GREEN_SCB checkbox colour:0(40,10,40,255), colour:1(150,0,255,255), fontcolour(180,180,180,255), shape("square")
#define RED_CCB checkbox colour:0(40,10,10,255), colour:1(255,0,0,255), fontcolour(180,180,180,255), shape("circle")
#define RED_SCB checkbox colour:0(40,10,10,255), colour:1(255,0,0,255), fontcolour(180,180,180,255), shape("square")

#define SHADER image colour(5,0,20,200), visible(0), mouseinteraction(0)
#define BYPASS_SHADER image colour(5,0,20,200), visible(0), mouseinteraction(0), identchannel("bypass-shader"), pos(0,0)

#define TEXT label colour(0,0,0,0), fontcolour(180,180,180,255), fontstyle("normal")
#define HEADER label colour(100,100,100,255), fontcolour(180,180,180,255), fontstyle("normal")
#define HIGHLIGHT fontcolour(180,160,255,255), fontstyle("bold")
#define WARN_HEAD label colour(0,0,0,0), fontcolour(255,140,140,255), fontstyle("normal")
#define WARN_TEXT label colour(0,0,0,0), fontcolour(200,200,200,255), fontstyle("normal")
#define REINIT_TEXT  fontcolour(255,0,0,255), textcolour(255,0,0,255)

#define R_LED_OFF image colour(40,10,10,255), corners(2)
#define R_LED_ON image colour(255,0,0,255), corners(2)
#define G_LED_OFF image colour(40,10,40,255), corners(2)
#define G_LED_ON image colour(150,0,255,255), corners(2)

#define KEYBOARD keyboard keydowncolour("100,0,200,195"), mouseoverkeycolour("100,0,200,195"), whitenotecolour("255,255,255,255"), blacknotecolour("0,0,0,255"), arrowcolour("60,60,60,255"), arrowbackgroundcolour("180,180,180,255"), value(36)

#define VMETER vmeter overlaycolour(20, 0, 50, 255) metercolour:0(200, 0, 170, 255) metercolour:1(100, 0, 100, 255) metercolour:2(40, 0, 40, 255) outlinethickness(2), outlinecolour(80,80,80,255)
#define GAIN_RANGE range(-90, 90, 0, 1, 0.01)

; TODO: these won't expand in csopts section, feature request perhaps?
#define CSOPTS -d -+rtmidi=NULL -M0
#define CSMIDIOPTS -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5