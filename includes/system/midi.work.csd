; this should be in user settings
; This is where you select which modules will use midi
; They may be commented out to disable
#define FLEXFX_USEMIDI ##
#define FLEXADSR_USEMIDI ##
#define GAIN_USEMIDI ##
#define PAN_USEMIDI ##
#define DRYWET_USEMIDI ##
#define FLEXSHAPER_USEMIDI ##
#define VEL_USEMIDI ##

; this should be in settings:
	; MIDI status bytes, to be used in if comparisons for easy readability
	#define MIDISTATUS_NOTEON #144#
	#define MIDISTATUS_NOTEOFF #128#
	#define MIDISTATUS_PAFT #160#
	#define MIDISTATUS_CC #176#
	#define MIDISTATUS_PROG #192#
	#define MIDISTATUS_CAFT #208#
	#define MIDISTATUS_PCHBEND #224#
	#define MIDISTATUS_EMPTY #0#

	#ifdef GAIN_USEMIDI
		#define GAIN_MIDI(ccnum'channame) #
		  iMidiGain chnget $channame
		  ; ivalue = (initial_value - min) / (max - min)
		  initc7 $MIDI_INPUT_CHAN, $ccnum, (iMidiGain+90)/180
		  kMidiGain ctrl7 $MIDI_INPUT_CHAN, $ccnum, -90, 90
		  if(changed(kMidiGain)==1) then
		    chnset kMidiGain, $channame
		  endif
		  #
	#else
		#define GAIN_MIDI(ccnum'channame) ##
	#endif

	#ifdef PAN_USEMIDI
		#define PAN_MIDI(ccnum'channame) #
		  iMidiPan chnget strcat($channame,"pan-val")
		  ; ivalue = (initial_value - min) / (max - min)
		  initc7 $MIDI_INPUT_CHAN, $ccnum, (iMidiPan+100)/200
		  kMidiPan ctrl7 $MIDI_INPUT_CHAN, $ccnum, -100, 100
		  if(changed(kMidiPan)==1) then
		    chnset kMidiPan, strcat($channame,"pan-val")
		  endif
		  #
	#else
		#define PAN_MIDI(ccnum'channame) ##
	#endif

	#ifdef DRYWET_USEMIDI
		#define DRYWET_MIDI(ccnum'channame) #
		  iMidiDryWet chnget $channame
		  ; iMidiDryWet chnget "drywet"
		  ; ivalue = (initial_value - min) / (max - min)
		  initc7 $MIDI_INPUT_CHAN, $ccnum, (iMidiDryWet+100)/200
		  kMidiDryWet ctrl7 $MIDI_INPUT_CHAN, $ccnum, -100, 100
		  if(changed(kMidiDryWet)==1) then
		    chnset kMidiDryWet, $channame
		  endif
		  printk2 kMidiDryWet
		  #
	#else
		#define DRYWET_MIDI(ccnum'channame) ##
	#endif

	#ifdef VEL_USEMIDI
		#define VEL_MIDI(ccnum'channame) #
		  iMidiVel chnget $channame
		  ; ivalue = (initial_value - min) / (max - min)
		  initc7 $MIDI_INPUT_CHAN, $ccnum, (iMidiVel+100)/200
		  kMidiVel ctrl7 $MIDI_INPUT_CHAN, $ccnum, -100, 100
		  if(changed(kMidiVel)==1) then
		    chnset kMidiVel, $channame
		  endif
		  #
	#else
		#define VEL_MIDI(ccnum'channame) ##
	#endif

