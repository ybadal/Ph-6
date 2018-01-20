======================================================================
 CurveFit application package for Mathematica

 Copyright 1997-2016 by 
 California Inst. of Technology, Pasadena, CA.

 CurveFit v1.95  / ErrorBarLogPlots 3.0 for Mathematica 10.x and later
 CurveFit v1.91a / ErrorBarLogPlots 2.0.2 for Mathematica 7.x - 9.x

======================================================================
 How to install CurveFit for Mathematica v.7 or later:
----------------------------------------------------------------------

This distribution will install or update two new Mathematica 
packages:

	CurveFit
	ErrorBarLogPlots


DO NOT EXECUTE THE INSTALLER NOTEBOOK FROM INSIDE THE ZIP FILE! IT
WILL NOT BE ABLE TO ACCESS THE OTHER FILES INSIDE THE ZIP, SO THE
INSTALLATION WILL FAIL!

Download the zip file onto your computer's desktop, and then extract the 
files there; it will create a new folder named CurveFit.distribution on 
your desktop.
 
Navigate into this new folder until you find the Installer.nb notebook. 
To install the packages automatically to the proper Mathematica 
Applications directory, launch the Installer.nb notebook.

The installer will execute when loaded by the Mathematica front-end 
(you will be prompted to run the initialization cells - you should 
allow it to do so). The notebook will copy the files into the 
appropriate folders for Mathematica to be able to find them.

----------------------------------------------------------------------
  You may need Administrator or Root privileges to install the
  packages for all users; if the installation fails, close and
  reopen the installer notebook and try installing just for yourself.
----------------------------------------------------------------------

The installer will also create a CurveFit folder in your local 
documents folder. Inside this folder are a couple of suplementary 
notebooks and a subfolder containing sample data files you may use to play 
around with CurveFit.

The installed notebooks:
 Launch.nb: will load and start CurveFit and open a new, blank notebook
 FitAnyFunction.nb: code

Once installed, you may load and launch the CurveFit package during 
any Mathematica session using (note the ` in the command, which is
NOT on the same key as "):

	<< CurveFit`

Once loaded, you may open or reopen the CurveFit palettes by 
simply evaluating:

	CurveFit

To close the palettes and remove the data you have loaded:

	QuitCurveFit

If you want to generate log-scale list plots with error bars
without loading the CurveFit package, then use:

	Needs["ErrorBarLogPlots`"]

IMPORTANT NOTE: If you have multiple versions of Mathematica 
installed, be careful! This package will not work with 
Mathematica 6.x or earlier.


----------------------------------------------------------------------
Version History
----------------------------------------------------------------------
1.95 (1/2016): Compatible with Mathematica v10.x. Uses the new
ErrorBarLogPlots v3.0. Installation files include a legacy 
installation of CurveFit v1.91a and ErrorBarLogPlots v2.0.2 for 
Mathematica v9 or earlier.

1.91a (1/2016): Updated 1/2016 to increase default error bar 
thickness to Medium. Intended to be used as part of the legacy 
installation package as an alternative to the Mathematica 10 
compliant CurveFit (1.95).

1.91 (1/2015): Check for Mathematica v10 and abort package install. 
Changed example in "Fit any function.nb" to fit decaying sinusoid. 
Commented out load of PlotLegends package in Plots.m.

1.9 (3/2014): Added scatter plot function for Compton scattering
experiment data files (x channel v. y channel).

1.8 (1/2014): Fixed problem with some dialog boxes appearing too
large with certain laptop monitor display aspect ratios.

1.7 (1/2013): Added several algebraic manipulations to the Transform
sub-palette.

1.6 (5/2012): Added LoadTekFile[]. Removed "E" default comment delimiter.
Fixed file load error message if there is no file header.

1.5 (12/2011): Various fixes and tweaks. Significant expansion of the
interactive loading and manipulation of data sets and the undo stack.
Support for only Mathematica v7 and later.

1.4 (5/2009): Fixed problem with MakePoisson[] on unsorted data.
Added SortData[].

1.3 (3/2009): Added data manipulations for gamma ray spectra.
Changed exponential fits so that non-positive Y values don't
abort the fits. Added capability to input USB-20 .tsv files.

1.2 (1/2009): Added resonance phase fit. Many palette cosmetic
changes. Removed RC filter fits, as they seem buggy. Miscellaneous 
minor improvements.

1.1 (3/2008): Included input parsing for Spectrum Techniques .TSV 
gamma-ray spectrum files, as well as enhancements for processing
multichannel analyzer count data. Some other minor improvements.

1.0 (1/2008): First port of CurveFit to Mathematica v6.x. 
Incorporated several enhancements over CurveFit for Mathematica 5.