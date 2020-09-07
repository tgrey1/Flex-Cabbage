; safety check, doesn't allow double include!
#ifndef FLEX_UDO_STEREOMS
#define FLEX_UDO_STEREOMS ##
/***************
 ***************

stereoms.udo.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is a file to include Steven Yi's stereMS UDO into Flex
This UDO splits stereo L/R signals into Mid/Side
Using it a second time on the same signals will recombine them back to L/R

***************
***************/

; stereoMS UDO by Steven Yi: http://www.csounds.com/udo/displayOpcode.php?opcode_id=44
opcode stereoMS, aa, aa
  ain1, ain2  xin

  ifac  = .5 * sqrt(2)
  aout1 = ifac * (ain1 + ain2)
  aout2 = ifac * (ain1 - ain2)

  xout aout1, aout2
endop

#endif
