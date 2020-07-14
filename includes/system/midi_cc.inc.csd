; safety check, doesn't allow double include!
#ifndef FLEX_INCL_MIDICC
#define FLEX_INCL_MIDICC ##
/***************
 ***************

midi_cc.inc.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

This is the midi cc# definitions file, it typically gets included automatically

ALL user editable data about MIDI cc#s is in here... take a look around
Any CC# can be changed, but everything defined here *MUST* exist.  Commenting
or deleting anything here will break things!

***************
***************/

; This isn't really needed, but is a dummy reminder of what I use as
; a palceholder on my control surfaces.  This CC should route nowhere!
#define MIDICC_NULL #9#

; CC number to respond to modwheel data on
#define MIDICC_MODWHEEL #1#

; General MIDI CCs:
#define MIDICC_BYPASS #3#
#define MIDICC_PREGAIN #14#
#define MIDICC_VELCURVE #14#
#define MIDICC_GAIN #7#
#define MIDICC_POSTGAIN #7#
#define MIDICC_DRYWET #9#
#define MIDICC_PAN #10#

; FlexFX MIDI CCs:
#define MIDICC_FLEXDIST_ON #16#
#define MIDICC_FLEXMOD_ON #17#
#define MIDICC_FLEXDEL_ON #18#
#define MIDICC_FLEXREV_ON #19#

; FlexFX Common Send/Mix CCs:
#define MIDICC_FLEXDIST_MIX #91#
#define MIDICC_FLEXMOD_MIX #92#
#define MIDICC_FLEXDEL_SEND #93#
#define MIDICC_FLEXREV_SEND #94#

; FlexADSR MIDI CCs:
#define MIDICC_FLEXADSR_A #73#
#define MIDICC_FLEXADSR_D #75#
#define MIDICC_FLEXADSR_S_LEV #70#
#define MIDICC_FLEXADSR_R #72#
#define MIDICC_FLEXADSR_A_SHAPE #85#
#define MIDICC_FLEXADSR_D_SHAPE #86#
#define MIDICC_FLEXADSR_S_LEN #90#
#define MIDICC_FLEXADSR_R_SHAPE #87#

; TODO: Both of these aren't implemented yet.
#define MIDICC_FLEXADSR_MODE #5#
#define MIDICC_FLEXADSR_TYPE ##

; FlexShaper MIDI CCs:
#define MIDICC_FLEXSHAPER_1 #20#
#define MIDICC_FLEXSHAPER_2 #21#
#define MIDICC_FLEXSHAPER_3 #22#
#define MIDICC_FLEXSHAPER_4 #23#
#define MIDICC_FLEXSHAPER_5 #24#
#define MIDICC_FLEXSHAPER_6 #25#
#define MIDICC_FLEXSHAPER_7 #26#
#define MIDICC_FLEXSHAPER_8 #27#
#define MIDICC_FLEXSHAPER_NORM #28#
#define MIDICC_FLEXSHAPER_RESET #29#

#define MIDICC_FLEXDEL_CLEAR #110#
#define MIDICC_FLEXDEL_TIME #106#
#define MIDICC_FLEXDEL_FB #107#

#define MIDICC_FLEXREV_TIME #108#
#define MIDICC_FLEXREV_DAMP #109#

#define MIDICC_FLEXMOD_DEPTH #104#
#define MIDICC_FLEXMOD_RATE #105#

; routes del taps into reverb
#define MIDICC_FLEXFX_CASCADE #15#

#endif
