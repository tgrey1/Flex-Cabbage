# Flex-Cabbage
### *by tgrey*

A framework system for easy and flexible development of rich Cabbage effects and instruments

## About

!!! NOTE !!! - This is alpha code.  It's ready for early testing, but many things may not work or might change.

Known Bug: It will not run as exported effects/instruments (yet)!  This is due to a known issue with Cabbage.

Known Bug: Symlinks don't work in windows, so the shared directories aren't available.
This is partially a windows problem, partially a github problem.  I'm not good enough with either yet.

This started as an experiment to have a common color theme easily skinned across all of my Cabbage creations.
Since then the concept has grown along side of Cabbage, as well as with my understanding of it and Csound.  It now acts
as entire system of wrappers, widgets, and macros... with the goal of allowing complex instruments to be written with
very little code and effort having to be put into the common core functionality (inputs, gain, pan, etc).

## Requirements

Cabbage 2.4.0 or greater.
	I will regularly test against this official release, but some functionality may depend on beta builds.
	Cabbage 2.4 Official: https://github.com/rorywalsh/cabbage/releases/tag/v2.4.0
	Beta build instructions: https://forum.cabbageaudio.com/t/latest-beta-packages-available-here-updated-links/

Csound 6.15: https://github.com/csound/csound

## Installing
	Download zip and unpack or clone repository

## Getting Started
	(Windows only): Copy "includes" and "plants" directories into "Effects", "Instruments", and optionally "Examples"
	This is a temporary workaround for lack of symlinks in Windows.
