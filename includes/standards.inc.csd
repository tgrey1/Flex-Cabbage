; safety check, doesn't allow double include!
#ifndef FLEX_INCL_STANDARDS
#define FLEX_INCL_STANDARDS ##
/***************
 ***************

standards.inc.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the standard header file.
All it does is set sr/kr/ksmps/0dbfs using existing settings

***************
***************/

#include "settings.inc.csd"

sr = $DEFAULT_SR
ksmps = $DEFAULT_KSMPS
nchnls = 2
0dbfs=$DEFAULT_0DBFS

#endif

