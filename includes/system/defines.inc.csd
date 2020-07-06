; safety check, doesn't allow double include!
#ifndef FLEX_INCL_DEFINES
#define FLEX_INCL_DEFINES ##
/***************
 ***************

defines.inc.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the defines file, it typically gets included automatically
user_settings.inc.csd *MUST* be included first, one way or another

***************
***************/

#define NYQUIST #sr*.5#

; safety defines for any settings not set:
#ifndef UI_TICKS
	#define UI_TICKS #20#
#endif
; This sets up the ON_UI_TICK and ON_INSTR_TICK macros
; TODO: finish this doc
  ; for example:
  ; if $ON_UI_TICK then
  ;   printk2 kFoo
  ; endif
#ifdef USE_GLOBAL_METRO
	; global metronome instrument
	; once running, genrates a tick for UI updates and INSTR updates
	instr Global_UI_Tick
		gkUI_TICK metro $UI_TICKS
		gkINSTR_TICK metro $INSTR_TICKS
	endin

	; autolaunch global metronome instrument
	event_i "i", "Global_UI_Tick", 0, -1
	#define ON_UI_TICK # (gkUI_TICK==1) #
	#define ON_INSTR_TICK # (gkINSTR_TICK==1) #
#else
	; define local / in place metronomes instead
	#define ON_UI_TICK # (metro($UI_TICKS)==1) #
	#define ON_INSTR_TICK # (metro($INSTR_TICKS)==1) #
#endif


; a simple linear +/- velocity curve adjustment
#define VELCURVE(c'v) #($c >= 0) ? ntrpol($c, 1, $v) : ntrpol(0,1+$c, $v)#

; util definitions
#define BI_TO_UNI(s) #($s*.5)+.5# ; -1:1 -> 0:1
#define UNI_TO_BI(s) #($s*2)-1# ; 0:1 -> -1:1

; These are string names for auxillary instruments
; They can be named anything, but need to be unique
; These are just overriding the default values set for each
#define SEG_INSTR #FlexSegInstr#
#define ADSR_INSTR #FlexAdsrInstr#
#define FILE_INSTR #FlexFileInstr#
#define DELCLEAR_INSTR #FlexDelClearInstr#
#define SYNTH_OUT_INSTR #FlexSynthOut#

; These offsets help prevent stepping on user-space for custom tables
; Shape function tables will start at 100
#define SHAPE_FTNUM_OFFSET #100#
; Window function tables will start at 200
#define WIN_FTNUM_OFFSET #200#

; These are used to create tables to display, not for audio tables
#define GRAPH_HALF_SIZE #$GRAPH_SIZE*.5#
#define GRAPH_QUARTER_SIZE #$GRAPH_SIZE*.25#
#define GRAPH_THIRD_SIZE #$GRAPH_SIZE*.33#

; used for HRTF opcodes...
; TODO: make this based on sample rate somehow?
#define HRTF_LEFT  #"includes/data/hrtf-44100-left.dat"#
#define HRTF_RIGHT #"includes/data/hrtf-44100-right.dat"#

; automatically turn off debugging and disabled input if a plugin
#ifdef IS_A_PLUGIN
	#ifdef DISABLE_AUDIO_INPUT
		#undef DISABLE_AUDIO_INPUT
	#endif
	#ifdef DEBUG
		#undef DEBUG
	#endif
#endif

; automatically turn on test_audio if debugging
#ifdef DEBUG
	#ifndef TEST_AUDIO
		#define TEST_AUDIO ##
	#endif
	#ifndef TEST_MIDI
		#define TEST_MIDI ##
	#endif
#endif

#endif
