; safety check, doesn't allow double include!
#ifndef FLEX_INCL_WINFUNCS
#define FLEX_INCL_WINFUNCS ##
/***************
 ***************

windows.inc.csd
  by tgrey

Included with Flex Cabbage:
https://github.com/tgrey1/Flex-Cabbage

THERE ARE NO USER EDITABLE CONFIGS OR DATA IN THIS FILE

This is the file with window function definitions

***************
***************/

#include "includes/settings.inc.csd"

#define WIN_HAMM 	#1#
#define WIN_HANN 	#2#
#define WIN_BART 	#3#
#define WIN_BLACK 	#4#
#define WIN_BH 		#5#
#define WIN_GAUSS 	#6#
#define WIN_KAIS 	#7#
#define WIN_RECT 	#8#
#define WIN_SYNC 	#9#

giWinHamm	ftgen $WIN_FTNUM_OFFSET+$WIN_HAMM	, 0, $TABLE_SIZE, 20, 1, 1
giWinHann	ftgen $WIN_FTNUM_OFFSET+$WIN_HANN	, 0, $TABLE_SIZE, 20, 2, 1
giWinBart	ftgen $WIN_FTNUM_OFFSET+$WIN_BART	, 0, $TABLE_SIZE, 20, 3, 1
giWinBlack	ftgen $WIN_FTNUM_OFFSET+$WIN_BLACK	, 0, $TABLE_SIZE, 20, 4, 1
giWinBH		ftgen $WIN_FTNUM_OFFSET+$WIN_BH		, 0, $TABLE_SIZE, 20, 5, 1
giWinGauss	ftgen $WIN_FTNUM_OFFSET+$WIN_GAUSS	, 0, $TABLE_SIZE, 20, 6, 1, 2 ; opt val?
giWinKais	ftgen $WIN_FTNUM_OFFSET+$WIN_KAIS	, 0, $TABLE_SIZE, 20, 7, 1, 2 ; opt val?
giWinRect	ftgen $WIN_FTNUM_OFFSET+$WIN_RECT	, 0, $TABLE_SIZE, 20, 8, 1
giWinSync	ftgen $WIN_FTNUM_OFFSET+$WIN_SYNC	, 0, $TABLE_SIZE, 20, 9, 1

#endif

