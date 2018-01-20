(* ::Package:: *)

(* Mathematica Package *)

(*: Name : ErrorBarLogPlots` *)
(*: Title : Log scale plots of data with error bars *)
(*: Summary :
	This package extends the capability provided by the standard package
	"ErrorBarPlots`" by adding functions for plots with log scales similar
	to ErrorListPlot.
  *)
(*: Context : ErrorBarLogPlots` *)
(*: Package Version : 2.0.2 *)
(*: Author : Frank Rice *)

(*: Copyright : 
Original code from ErrorBarPlots.m copyright (c) 1988-2007 Wolfram Research, Inc.

Additions and modifications to code Copyright (c) 2007,2011 California Institute of Technology, Pasadena, CA
All rights reserved.

Redistribution and use in source and binary forms for noncommercial
purposes are permitted provided that the above copyright notice and
this paragraph are duplicated in all such forms and that any
documentation and other materials related to such distribution and
use acknowledge that the software was developed by California
Institute of Technology (Caltech). Redistribution and/or use in source
or binary forms is not permitted for any commercial purpose. Use of
this software does not include a permitted use of the Institute's
name or trademark for any purpose.

DISCLAIMER:
THIS SOFTWARE AND/OR RELATED MATERIALS ARE PROVIDED "AS-IS" WITHOUT
WARRANTY OF ANY KIND INCLUDING ANY WARRANTIES OF PERFORMANCE OR
MERCHANTABILITY OR FITNESS FOR A PARTICULAR USE OR PURPOSE (AS SET
FORTH IN UCC 23212-2313) OR FOR ANY PURPOSE WHATSOEVER, FOR THE
LICENSED PRODUCT, HOWEVER USED.  IN NO EVENT SHALL CALTECH BE
LIABLE FOR ANY DAMAGES AND/OR COSTS, INCLUDING BUT NOT LIMITED TO
INCIDENTAL OR CONSEQUENTIAL DAMAGES OF ANY KIND, INCLUDING ECONOMIC
DAMAGE OR INJURY TO PROPERTY AND LOST PROFITS, REGARDLESS OF
WHETHER CALTECH SHALL BE ADVISED, HAVE REASON TO KNOW, OR IN
FACT SHALL KNOW OF THE POSSIBILITY.  THE USER BEARS ALL RISK
RELATING TO QUALITY AND PERFORMANCE OF THE SOFTWARE AND/OR RELATED
MATERIALS.
*)

(*: History :
      Version 1.0 by Frank Rice 2007
      Version 2.0 by Frank Rice 2010
      Version 2.0.1 By Frank Rice 2011: fixed dologs so that
        0-length error bars are not drawn
      Version 2.0.2 By Frank Rice 2011: commented out Remove[] lines at beginning
  *)

(*: Keywords : plot, 2D graphics, error bars, log *)
(*: Mathematica Version : 6.0 or later *)

(* Created by the Wolfram Workbench Dec 22, 2010 *)

BeginPackage["ErrorBarLogPlots`",{"ErrorBarPlots`"}];

(* Remove all symbols which may already have been defined in this context *)
(*
Quiet[Remove["ErrorBarLogPlots`*"]];
Quiet[Remove["ErrorBarLogPlots`Private`*"]];
*)

ErrorListLogPlot::usage = "ErrorListLogPlot[{{{\!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], 
StyleBox[\"1\", \"TR\"]]\),\!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], 
StyleBox[\"1\", \"TR\"]]\)},ErrorBar[\!\(\*SubscriptBox[
StyleBox[\"err\", \"TI\"], \"1\"]\)]},{{\!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\),\!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\)},ErrorBar[\!\(\*SubscriptBox[
StyleBox[\"err\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\)]},\!\(\*
StyleBox[\"\[Ellipsis]\", \"TR\"]\)}] makes a log plot of points with \
specified \!\(\*
StyleBox[\"x\", \"TI\"]\) and \!\(\*
StyleBox[\"y\", \"TI\"]\) coordinates and error magnitudes. To use \
this function you must load the ErrorBarLogPlots package.";
	
ErrorListLogLinearPlot::usage = "ErrorListLogLinearPlot[{{{\!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], 
StyleBox[\"1\", \"TR\"]]\),\!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], 
StyleBox[\"1\", \"TR\"]]\)},ErrorBar[\!\(\*SubscriptBox[
StyleBox[\"err\", \"TI\"], \"1\"]\)]},{{\!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\),\!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\)},ErrorBar[\!\(\*SubscriptBox[
StyleBox[\"err\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\)]},\!\(\*
StyleBox[\"\[Ellipsis]\", \"TR\"]\)}] makes a log(\!\(\*
StyleBox[\"x\", \"TI\"]\))-linear(\!\(\*
StyleBox[\"y\", \"TI\"]\)) plot of points with specified \!\(\*
StyleBox[\"x\", \"TI\"]\) and \!\(\*
StyleBox[\"y\", \"TI\"]\) coordinates and error magnitudes. To use \
this function you must load the ErrorBarLogPlots package.";

ErrorListLogLogPlot::usage = "ErrorListLogLogPlot[{{{\!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], 
StyleBox[\"1\", \"TR\"]]\),\!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], 
StyleBox[\"1\", \"TR\"]]\)},ErrorBar[\!\(\*SubscriptBox[
StyleBox[\"err\", \"TI\"], \"1\"]\)]},{{\!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\),\!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\)},ErrorBar[\!\(\*SubscriptBox[
StyleBox[\"err\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\)]},\!\(\*
StyleBox[\"\[Ellipsis]\", \"TR\"]\)}] makes a log-log plot of points \
with specified \!\(\*
StyleBox[\"x\", \"TI\"]\) and \!\(\*
StyleBox[\"y\", \"TI\"]\) coordinates and error magnitudes. To use \
this function you must load the ErrorBarLogPlots package.";

ErrorBarScale::usage = "ErrorBarScale[\!\(\*
StyleBox[\"xscale\", \"TI\"]\), \!\(\*
StyleBox[\"yscale\", \"TI\"]\)] may be supplied as a value for the \
ErrorBarFunction option of the ErrorListPlot family. It scales \!\(\*
StyleBox[\"x\", \"TI\"]\) and \!\(\*
StyleBox[\"y\", \"TI\"]\) error bar sizes by the supplied factors to \
make them more visible in a plot. To use this function you must load \
the ErrorBarLogPlots package.";

ErrorBarMapping::usage = "ErrorBarMapping is an option of the ErrorListLogPlot family which controls how error bar lengths "<>
	"are mapped onto Log-scale axes. The default value is Automatic. Other option values include the strings "<>
	"\"Simple\" and \"Exact\". To use this function you must load "<>
	"the ErrorBarLogPlots package.";
	
ErrorBarStyle::usage = "ErrorBarStyle is an option of the ErrorListLogPlot family which may be used to control the style of "<>
	"default error bars independently of the option PlotStyle. The default is Automatic, which makes the error bar style "<>
	"match that set by the option PlotStyle. To use this function you must load "<>
	"the ErrorBarLogPlots package.";


Begin["`Private`"];

(* Remove any global symbols which may shadow the package symbols *)
Quiet[Remove @@ (("Global`" <> #) & /@ Names["ErrorBarLogPlots`*"])];

Options[ErrorListLogLogPlot] =
Options[ErrorListLogLinearPlot] = 
Options[ErrorListLogPlot] = 
Options[elplot] = Options[ErrorBarPlots`ErrorListPlot] = Join[
	Complement[Options[ListLinePlot],{MaxPlotPoints->Infinity}],
	{ErrorBarFunction -> Automatic, ErrorBarStyle -> Automatic, ErrorBarMapping -> Automatic}
];

ErrorListLogPlot[dat_, opts:OptionsPattern[]] := elplot[{False,True}, dat, opts]
ErrorListLogLinearPlot[dat_, opts:OptionsPattern[]] := elplot[{True,False}, dat, opts]
ErrorListLogLogPlot[dat_, opts:OptionsPattern[]] := elplot[{True,True}, dat, opts]

(* Redefine this function from ErrorBarPlots` to use the methods of this package *)
ErrorBarPlots`ErrorListPlot[dat_, opts:OptionsPattern[]] := elplot[{False,False}, dat, opts]

ErrorBarScale[xscale_?NumericQ, yscale_?NumericQ] :=
	Function[{coords, errs},ebarfun[coords, ErrorBar[xscale errs[[1]], yscale errs[[2]] ]]]
ErrorBarScale[scale_?NumericQ] :=
	Function[{coords, errs}, ebarfun[coords, ErrorBar[scale errs[[1]], scale errs[[2]] ]]]


(* this is the function which does all the work of log plotting *)
elplot[{xflag_,yflag_}, dat_, opts:OptionsPattern[]] :=
	Block[
		{xf=xflag, yf=yflag, newdat, newopts, p, error, ebfunc, range, mapmode, ebstyle, 
			pr, prx={Infinity,-Infinity}, pry={Infinity,-Infinity}},

		{ebfunc, range, mapmode, ebstyle, pr} = 
			OptionValue[{ErrorBarFunction, DataRange, ErrorBarMapping, ErrorBarStyle, PlotRange}];
	
		If[ebfunc === Automatic, ebfunc = ebarfun];
		ebstyle = (ebstyle /. Automatic -> {});
	
		(* Process data sets consisting of only y's so that all points become {x,y} pairs. *)
		If[range === All, 
			(* This bit handles the rare case where multiple data sets each consist of only 2 y's *)
			newdat = dat /. {
				a_/;VectorQ[a, (NumericQ[#]||Head[#]===PlusMinus||Head[#]===ErrorBar)&] :>
				Transpose[{Range[Length[a]], a}]},

			newdat = dat /. {	
				a_/;VectorQ[a, MatchQ[#1, {_?NumericQ, _?NumericQ}] &] :>
					MapIndexed[Prepend[#,First[#2]]&, a],
				a_/;(VectorQ[a] && Length[a]>3) :> Transpose[{Range[Length[a]], a}]
				}	
			]; 
	
		(* Now pull out all error specifications, leaving only {x,y} pairs suitable for List...Plot. 
		   The error information for each point is processed by dologs[] and saved in error[]
		   definitions. *)
		newdat = newdat /. {
			(* this first case handles output from the processing above *)
			{x_?NumericQ, y_?NumericQ, e_?NumericQ} :> dologs[x,y, ErrorBar[{0,0},{-e,e}]],
			{{x_,y_}, e_ErrorBar} :> dologs[x,y, makeError[e]],
			{x_/; Head[x] =!= List, y_/; Head[y] =!= List} :> handlePlusMinus[{x,y}]
			};

		(* Finally, clean up the data set by removing any empty lists. *)
		newdat = newdat //. {a___,{},b___} :> {a,b};
		
		(* note that only explicit options in the argument list will be in newopts *)
		newopts = FilterRules[{opts}, Options[ListPlot]];	

		(* Part of dologs[] tasking is to determine the x and y ranges of the data 
		   including the error bars. This bit will then fix up the plot range to display 
		   the entire error bar lengths. *)
		If[ pr === Automatic || pr === All || pr === Full,
			newopts = Switch[{xf,yf},
				{False,True},  Prepend[newopts, PlotRange -> {prx, Exp[pry]}],
				{True,True},   Prepend[newopts, PlotRange -> {Exp[prx], Exp[pry]}],
				{True,False},  Prepend[newopts, PlotRange -> {Exp[prx], pry}], 
				{False,False}, Prepend[newopts, PlotRange -> {prx, pry}] 
			];
			newopts = 
				Prepend[newopts, PlotRangePadding -> (OptionValue[PlotRangePadding] /. Automatic -> Scaled[0.02])];
		];
		
		(* Default values for options come from the corresponding List...Plot[],
		   not from Options[ErrorList...Plot]. This is probably a bug, but is
		   consistent with the definition of ErrorListPlot[], which uses ListPlot. *)
		p = Switch[{xf,yf},
			{False,True},  ListLogPlot[newdat, newopts],
			{True,False},  ListLogLinearPlot[newdat, newopts], 
			{True,True},   ListLogLogPlot[newdat, newopts],
			{False,False}, ListPlot[newdat, newopts] 
			];

		(* Generally, dologs[] will set error[{x,y}] = ErrorBar[...] for each of the
		   points {x,y} in the data set. The following definition is needed to handle
		   additional points introduced by clipping when Joined->True. *)
		error[_] := ErrorBar[{0,0},{0,0}];

		(* Add the error bars to the graphics, and we're finished. *)
		p = p /. {
			g_GraphicsComplex :> markErrors[g, ebfunc],
			l_Line :> markErrors[l, ebfunc],
			p_Point :> markErrors[p, ebfunc],
			i_Inset :> markErrors[i, ebfunc]
		};
		p
	]


(* This code makes all properly-formatted error specifications into full 
   ErrorBar[{xm, xp},{ym,yp}] format. *)
makeError[ErrorBar[y_]] := ErrorBar[{0,0}, eb[y]]
makeError[ErrorBar[x_,y_]] := ErrorBar[eb[x],eb[y]]
eb[n_?Positive] := {-n,n}
eb[{n_?NumericQ, p_?NumericQ}] := {n,p}
eb[_]:={0,0}

(* The undocumented {x +- ex, y +- ey} format is processed by handlePlusMinus[]. *)
handlePlusMinus[{x_?NumericQ, y_?NumericQ}] := 
	dologs[x,y,ErrorBar[{0,0},{0,0}]]
handlePlusMinus[{PlusMinus[x_,e_], y_?NumericQ}] := 
	dologs[x,y,ErrorBar[{-e,e},{0,0}]]
handlePlusMinus[{PlusMinus[x_,ex_], PlusMinus[y_,ey_]}] := 
	dologs[x,y,ErrorBar[{-ex,ex},{-ey,ey}]]
handlePlusMinus[{x_?NumericQ, PlusMinus[y_,ey_]}] := 
	dologs[x,y,ErrorBar[{0,0},{-ey,ey}]]
handlePlusMinus[a_] := a


(* This function is used by dologs to map error bars into the proper lengths on a log scale,
   using ErrorBarMapping option *)
errormap[v_,{m_,p_}]:=
	If[{m,p}=={0,0}, 
		{0,0},
		Switch[mapmode,
			"Simple",  {m/v, p/v},
			"Exact",   {If[-m/v < 0.99, Log[1.0 + 1.0 m/v], Indeterminate, 0], Log[1.0 + 1.0 p/v]},
			Automatic, {If[-m/v < 0.9, Log[1.0 + 1.0 m/v], m/v, 0], Log[1.0 + 1.0 p/v]},
			_ ,        {m/v, p/v}  (* assume "Simple" if option value is unrecognized *)
		],
		{0,0}
	]
errormap[_]:= {0,0}


(* the dologs[] function performs the following:
	(1) removes any points with negative coordinates which can't be plotted on a log scale
	(2) maps error bar lengths and saves error bar info for each point in a definition of error[]
	(3) removes error bar specifications from the data set, returning just the {x,y} pairs 
	(4) determines the data ranges of x and y including error bars so the plot range may be set *)
dologs[x_,y_, ErrorBar[ex_,ey_]]:=
	Block[{newx = 1.0 x, newy = 1.0 y, 
		newxe = If[ex === {0,0}, ex, 1.0 ex, 1.0 ex], 
		newye = If[ey === {0,0}, ey,1.0 ey,1.0 ey], 
		ok = True, xmin, xmax, ymin, ymax},
		If[xf, If[x > 0, newx = Log[1.0 x]; newxe = errormap[x,ex], ok = False]];
		If[yf, If[y > 0, newy = Log[1.0 y]; newye = errormap[y,ey], ok = False]];
		If[ok, 
			(error[N[{newx,newy}]] = ErrorBar[newxe,newye]);
			{xmin,xmax} = newx+newxe; {ymin,ymax} = newy+newye;
			prx = 1.0 {Min[First[prx],If[xmin =!= Indeterminate,xmin,newx-1.0,newx-1.0]], Max[Last[prx],xmax]};
			pry = 1.0 {Min[First[pry],If[ymin =!= Indeterminate,ymin,newy-1.0,newy-1.0]], Max[Last[pry],ymax]};
			{x,y},
			{}
		]
	]


(* markErrors actually inserts the graphics for the error bars into the plot, calling the ErrorBarFunction. *)
markErrors[GraphicsComplex[pts_, prims_, opts___], ebfunc_] := 
	GraphicsComplex[pts, prims /. {
		Line[l:{__Integer}]      :> {(ebfunc[pts[[#]], error[pts[[#]]]]& /@ l), Line[l]},
		Line[l:{{__Integer}..}]  :> {(ebfunc[pts[[#]], error[pts[[#]]]]& /@ Flatten[l]), Line[l]},
		Point[l:{__Integer}]     :> {(ebfunc[pts[[#]], error[pts[[#]]]]& /@ l),Point[l]},
		Point[l:{{__Integer}..}] :> {(ebfunc[pts[[#]], error[pts[[#]]]]& /@ Flatten[l]),Point[l]},
	   (l:Inset[obj_, pos_, a___]) :> {ebfunc[pts[[pos]], error[pts[[pos]]]], l}		
	}, opts]

markErrors[l_Line, ebfunc_] := 
	{(ebfunc[#, error[#]]& /@ Cases[l, {_?NumericQ, _?NumericQ}, Infinity]), l}

markErrors[l_Point, ebfunc_] := 
	{(ebfunc[#, error[#]]& /@ Cases[l, {_?NumericQ, _?NumericQ}, Infinity]), l}

markErrors[l:Inset[obj_, pos_, a___], ebfunc_] := 
	{ebfunc[pos, error[pos]], l}


(* This is the default ErrorBarFunction. Error bars are drawn using the style from ErrorBarStyle. *)
ebarfun[pt : {x_, y_}, 
  ErrorBar[{xmin_, xmax_}, {ymin_, ymax_}]] :=
    Block[ {xline, yline},
        xline =
         Which[
          xmin === 0 && xmax === 0,
              {},
          xmin === Indeterminate || !Element[xmin, Reals],
              {Line[{Offset[{0, 1.5}, {x + xmax, y}], 
             Offset[{0, -1.5}, {x + xmax, y}]}], Line[{{x + xmax, y},{x, y}}],
               Arrow[{{x, y}, {First[prx], y}}]},
          
          True,
              {Line[{{x + xmax, y}, {x, y}, {x + xmin, y}}],
               Line[{Offset[{0, 1.5}, {x + xmax, y}], 
             Offset[{0, -1.5}, {x + xmax, y}]}],
               Line[{Offset[{0, 1.5}, {x + xmin, y}], 
             Offset[{0, -1.5}, {x + xmin, y}]}]}
          ];
          
        yline =
         Which[
          ymin === 0 && ymax === 0,
              {},
          ymin === Indeterminate || !Element[ymin, Reals],
              {Line[{Offset[{1.5, 0}, {x, y + ymax}], 
                 Offset[{-1.5, 0}, {x, y + ymax}]}], Line[{{x, y + ymax},{x, y}}],
               Arrow[{{x, y}, {x,First[pry]}}]},
          True,
              {Line[{{x, y + ymax}, {x, y}, {x, y + ymin}}],
               Line[{Offset[{1.5, 0}, {x, y + ymax}], 
                 Offset[{-1.5, 0}, {x, y + ymax}]}],
               Line[{Offset[{1.5, 0}, {x, y + ymin}], 
                 Offset[{-1.5, 0}, {x, y + ymin}]}]}
          ];
          
        Style[Join[xline, yline], Arrowheads[.03], ebstyle]
    ]

    
End[]; (* Private *)

EndPackage[];
