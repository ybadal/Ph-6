(* ::Package:: *)

(* :Title: CurveFit Data Analysis Package *)

(* :Author: A. Vayonakis, B. D'Urso, F. Rice,
 California Inst. of Technology *)

(* :Summary:
This package provides tools to visualize, manipulate, and fit 
two-dimensional data with some chosen function. The data may 
have errors on both variables (x,y). *)

(* :Context: CurveFit` *)

(* :Package Version: 1.91a *)

(* :Copyright: Copyright 1997-2016 by 
California Inst. of Technology, Pasadena, CA. *)
(***********************************************************)
(*
              CurveFit for Mathematica v7.x thru v9.x
                    F. Rice, Pasadena, CA

1.91a (1/2016): Updated 1/2016 to increase default error bar thickness to
Medium. Intended to be used as part of the legacy installation package as
an alternative to the Mathematica 10 compliant CurveFit (1.95).

1.91 (1/2015): Check for Mathematica v10 and abort package install. Changed
example in "Fit any function.nb" to fit decaying sinusoid. Commented out 
load of PlotLegends package in Plots.m.

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

*)
(***********************************************************)
(*
                CurveFit written by A. Vayonakis 
	           Initial code was written in Nov. 97

Additions/modifications made on 12/11/07:
Fixed syntax problems with the use of Compile[] in the fitting 
function definitions. No more errors with Mathematica 5, and 
much faster fitting.

Additions/modifications made on 1/25/06:
Replaced the Block with the ReadList function in the LoadFile 
functions, with Import (needs v .4).  Reading large files 
should be much faster.

Additions/modifications made on 2/27/03:
Changed the LoadFile code to be more robust: 
Now, a line whos first non-empty character is any of the user 
chosen delimiters: {"E", "S", etc.}, will be ingored. Also, 
made a separate palette for more options loading the data (eg. 
to have separate button for the E option: selecting 
combinations of columns to define the data.) Added 
MagSecondOrderLowPassFilter, which is has the same functional 
format with resonance curve (N), but with different variable 
definitions.  

Additions/modifications made on 2/25/03:
Added 1st order low-pass, and 1st order high-pass (2nd order 
low-pass filters can use resonance curve (N)) for ph3.
  
Previous additions/modifications were made on 6/06/00.
*)



BeginPackage["CurveFit`",
{"ErrorBarPlots`","ErrorBarLogPlots`"
(*,"Global`"*)}];

(* clear everything first, so the package may be read twice *)
Unprotect["`*"]; 
ClearAll["`*"];

(***********************************************************)
Begin["`Private`"];

Unprotect["`*"]; 
ClearAll["`*"];

(* We want to turn off some messages, 
  but be able to restore them to their original status. *)
spell1Flag = Head[General::spell1] === String;
Off[General::"spell1"]
spellFlag = Head[General::spell] === String;
Off[General::"spell"]
commaFlag = Head[Syntax::com] === String;
Off[Syntax::"com"]
shdwFlag = Head[General::shdw] === String;
Off[General::"shdw"]

End[ ]; (* `Private` *)

(***********************************************************)
(* Load the code. Always get in the order given here *)
Get[ToFileName["CurveFit", "Common.m"]];
Get[ToFileName["CurveFit", "Data.m"]];
Get[ToFileName["CurveFit", "Transform.m"]];
Get[ToFileName["CurveFit", "Phase.m"]];
Get[ToFileName["CurveFit", "FileIO.m"]];
Get[ToFileName["CurveFit", "Gamma.m"]];
Get[ToFileName["CurveFit", "Fit.m"]];
Get[ToFileName["CurveFit", "Plots.m"]];
Get[ToFileName["CurveFit", "Select.m"]];
Get[ToFileName["CurveFit", "1D.m"]];

(* get rid of any Global symbols which shadow CurveFit symbols *)
Remove/@((StringJoin["Global`",#])&)/@
	Names["CurveFit`*"]//Quiet;

(***********************************************************)
Begin["`Private`"];
(* Restore the original status of spelling messages *)
If[spellFlag, On[General::"spell"]]
If[spell1Flag, On[General::"spell1"]]
If[commaFlag, On[Syntax::"com"]]
If[shdwFlag, On[General::"shdw"]]
ClearAll[spellFlag, spell1Flag, commaFlag, shdwFlag]
Remove[spellFlag, spell1Flag, commaFlag, shdwFlag]
End[]; (* `Private` *)

EndPackage[]; (* CurveFit` *)

