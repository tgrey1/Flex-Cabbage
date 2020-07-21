; safety check, doesn't allow double include!
#ifndef FLEX_INCL_SETTINGS
#define FLEX_INCL_SETTINGS ## ; COMMENT LINE TO UNSET VARIABLE
/***************
 ***************

settings.inc.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

This is the settings file, it typically gets included automatically

ALL user editable data will be in here... take a look around
Only the first section is meant to be user configuration, use
caution making changes beyond that!

***************
***************/

; TODO: delete these?  make sure all are safe first... but no real point in being able to rename these here?
; These are string names for auxillary instruments
; They can be named anything, but need to be unique
; These are just overriding the default values set for each
#define SEG_INSTR #FlexSegInstr#
#define ADSR_INSTR #FlexAdsrInstr#
#define FILE_INSTR #FlexFileInstr#
#define DELCLEAR_INSTR #FlexDelClearInstr#
#define SYNTH_OUT_INSTR #FlexSynthOut#
#define SHAPER_INSTR #FlexShaperInstr#

; TODO pick a better ihp val ;)
; RMSHP used during flexclip
#define RMSHP #50#


; These offsets help prevent stepping on user-space for custom tables
; Shape function tables will start at 100
#define SHAPE_FTNUM_OFFSET #100#
; Window function tables will start at 200
#define WIN_FTNUM_OFFSET #200#



/***************
 ***************

This first section is all user editable settings.
If not already, any setting in this section should
be able to be removed entirely, with a reasonable
default being set elsewhere.

***************
***************/


		; this will force ksmps=1 among other things:
		; #define RENDER_QUAL #1#


		; set debug for testing
		; automatically disabled in an exported plugin
		#define DEBUG ## ; COMMENT LINE TO UNSET VARIABLE


		; This is the channel MIDI data will be read from
		#define MIDI_INPUT_CHAN #1#

		; Table to be used for mapping pitchwheel
		#define FLEX_PCHBEND_TABLE #999#


		; if defined, offer use of balance2 instead of balance in multifilt filters
		#define USE_BALANCE2 ## ; COMMENT LINE TO UNSET VARIABLE

		; if defined, metronomes for UI_TICK and INSTR_TICK will be global variables
		; if not defined, each metronome will be independently calculated
		#define USE_GLOBAL_METRO ## ; COMMENT LINE TO UNSET VARIABLE

		; value substituted when an exponential value reaches 0
		#define EXPN_MIN #.00001#

		; this is used in places like pulse.xml etc to declick sudden changes
		#define DECLICK_ENV #.001#

		; default time spent swapping signals in a "bypass", usually ~.05
		#define BYPASS_TIME #.005#

		; time used for port smoothing of delay shifts
		#define DEL_PORT_TIME #.1#

		; how much extra time (1 is none) the clear button
		; stays on past the delay time (recommended 3 or more)
		#define CLEAR_OVERAGE #2.5#
		; #define CLEAR_OVERAGE #3.5#

		; show buttons for test audio, always overriden to 1 if DEBUG==1
		#define TEST_AUDIO ## ; COMMENT LINE TO UNSET VARIABLE

		; show buttons for test midi, always overriden to 1 if DEBUG==1
		#define TEST_MIDI ## ; COMMENT LINE TO UNSET VARIABLE

		; which file gets played in a mono test
		; if none is defined, white noise at -3db will be generated
		#define TEST_MONO_FILE #"includes/data/beats.wav"#
		; #define TEST_MONO_FILE #"includes/data/fox.wav"#

		; which file gets played in a stereo test
		; if none is defined, stereo white noise at -3db will be generated
		#define TEST_STEREO_FILE #"includes/data/stereotest.wav"#

		; frequency in Hz for the test L|C|R oscillator buttons
		; if none is defined, 440hz will be used
		#define TEST_OSC_FREQ #440#

		; if set, this will prevent mic input from passing during test_audio opcode
		; useful for testing with test buttons generated audio without headphones
		; automatically disabled in an exported plugin
		; This automatically gets disabled when exported, so hosts can always pass audio.
		#define DISABLE_AUDIO_INPUT ## ; COMMENT LINE TO UNSET VARIABLE

		; default sample rate, usually 44100
		; leave undefined to allow cabbage override of SR
		#define DEFAULT_SR #44100#

		; default ksmps, usually 32.
		; needs to be a power of 2 number!
		; TODO: is this note wrong?
		#define DEFAULT_KSMPS #20#

		; THESE CAN'T BE SLOWER THAN THE MAIN :(
		; a much slower ksmps used only in opcodes that are strictly GUI
		; NOT SUPPORTED YET
		#define GUI_KSMPS #32#

		; changing 0DBFS is **NOT** supported yet!!!
		; but when it is, this is where you would set it ;)
		; default for 0dbfs is 1
		; NOT SUPPORTED YET
		#define DEFAULT_0DBFS #1#

		; times per second to update UI elements, 10-20 is decent
		; default is 20
		; THIS ELEMENT GETS MODIFIED WITH RENDER_QUAL TO BE LOWER
		#define UI_TICKS #20#

		; times per second to update background instruments elements, 10-20 is decent
		; default is 20
		; this element doesn't get altered with RENDER_QUAL
		#define INSTR_TICKS #20#


		; default level (in dB) to clip at, should be negative but near 0
		; can also be positive, in which case treated as an amp
		#define CLIP_LEV #-.0125#
		; #define CLIP_LEV #.95#

		; selects the clipping method. The default is 0. The methods are:
		; 0 = Bram de Jong method (default)
		; 1 = sine clipping
		; 2 = tanh clipping
		#define CLIP_TYPE #2#


		; Choose default pan mode
		; if none are define, bypass will be assumed
			; constructive acts as a stereo balancing
			; #define DEFAULT_PAN_MODE #$PAN_CON#
			; subtractive mode acts as a traditional pan knob
			; #define DEFAULT_PAN_MODE #$PAN_SUB#
			; width mode acts as a variable stereo/mono collapse
			; #define DEFAULT_PAN_MODE #$PAN_WIDTH#
			; bypass mode means panning does nothing
			; #define DEFAULT_PAN_MODE #$PAN_BYPASS#

		; Default BPM only used when host mode and the host provides
		; no BPM
		; defaults, BPM: 60, Meter: 4
		#define DEFAULT_BPM #60#
		#define DEFAULT_METER #4#


		; This is the table size used by opcodes in shape.inc.csd
		; it has to match the table size set in all isntruments orc sections.
		; bad things happen if you overwrite a table with a table of a new size!
		; Originally set to 8192
		#define TABLE_SIZE #8193#
		;#define TABLE_SIZE #32768#

		; This is a lower quality size used for visual representations
		#define GRAPH_SIZE #513#


/***************
 ***************

This second section contains settings that can be changed,
changing the code behavior, but will also require matching
changes in included widgets to make sense, otherwise bounds
might be exceeded etc. and things could behave erratically.

***************
***************/

		; These only affect code handling, any widgets will need to be changed to match
		; defaults, BPM: 40-280, Meter: 1-32
		#define MIN_BPM #40#
		#define MAX_BPM #280#
		#define MIN_METER #1#
		#define MAX_METER #32#

/***************
 ***************

This third section is all default settings that take
effect if the user hasn't already set them.

***************
***************/
		#ifndef DEFAULT_SR
			#define DEFAULT_SR #44100#
		#endif

		#ifndef MIDI_INPUT_CHAN
			#define MIDI_INPUT_CHAN #1#
		#endif

		#ifndef UI_TICKS
			#define UI_TICKS #20#
		#endif

		#ifndef TABLE_SIZE
			#define TABLE_SIZE #8193#
		#endif

		#ifndef SHAPE_FTNUM_OFFSET
			#define SHAPE_FTNUM_OFFSET #500#
		#endif

		#define NYQUIST #sr*.5#

		; a simple linear +/- velocity curve adjustment
		#define VELCURVE(c'v) #($c >= 0) ? ntrpol($c, 1, $v) : ntrpol(0,1+$c, $v)#

		; util definitions
		#define BI_TO_UNI(s) #($s*.5)+.5# ; -1:1 -> 0:1
		#define UNI_TO_BI(s) #($s*2)-1# ; 0:1 -> -1:1


/***************
 ***************

This fourth section is all protected settings.
These should not be edited, but are derived from
user or default settings already declared.

***************
***************/

		; disable all automatic midi sends
		; these will be reset in synth.inc.csd
		massign 0, 0

		#include "system/midi_cc.inc.csd"
		#include "system/midi.work.csd"

		; used for HRTF opcodes...
		; TODO: make this based on sample rate somehow?
		#define HRTF_LEFT  #"includes/data/hrtf-44100-left.dat"#
		#define HRTF_RIGHT #"includes/data/hrtf-44100-right.dat"#

		; based on $TABLE_SIZE set in settings.inc.csd
		#define TABLE_HALF_SIZE #$TABLE_SIZE*.5#
		#define TABLE_QUARTER_SIZE #$TABLE_SIZE*.25#
		#define TABLE_THIRD_SIZE #$TABLE_SIZE*.33#

		; These are used to create tables to display, not for audio tables
		#define GRAPH_HALF_SIZE #$GRAPH_SIZE*.5#
		#define GRAPH_QUARTER_SIZE #$GRAPH_SIZE*.25#
		#define GRAPH_THIRD_SIZE #$GRAPH_SIZE*.33#


		; This sets up the ON_UI_TICK and ON_INSTR_TICK macros
		; TODO: finish this doc
		  ; for example:
		  ; if $ON_UI_TICK then
		  ;   printk2 kFoo
		  ; endif
		#ifdef USE_GLOBAL_METRO
			; global metronome instrument
			; once running, genrates a tick for UI updates and INSTR updates
			alwayson "Global_UI_Tick"
			instr Global_UI_Tick
				gkUI_TICK metro $UI_TICKS
				gkINSTR_TICK metro $INSTR_TICKS
			endin
			; define to make use of gk values from metronome instrument
			#define ON_UI_TICK # (gkUI_TICK==1) #
			#define ON_INSTR_TICK # (gkINSTR_TICK==1) #
		#else
			; define local / in place metronomes instead
			#define ON_UI_TICK # (metro($UI_TICKS)==1) #
			#define ON_INSTR_TICK # (metro($INSTR_TICKS)==1) #
		#endif

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

		; should this stuff get copied to both effect and synth.inc.csd?
		; leaves standards for places like includes and xml files etc
		#ifdef RENDER_QUAL
		  #undef DEFAULT_KSMPS
		  #define DEFAULT_KSMPS #1#
		  #undef UI_TICKS
		  #define UI_TICKS #1#
		#endif

#endif
