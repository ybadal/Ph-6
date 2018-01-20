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
(*: Package Version : 3.0.0 *)
(*: Author : Frank Rice *)

(*: Copyright : 
Original code from ErrorBarPlots.m copyright (c) 1988-2015 Wolfram Research, Inc.

Additions and modifications to code Copyright (c) 2007,2011,2015 California Institute of Technology, Pasadena, CA
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
      Version 3.0 By Frank Rice 2015: major revision for Mathematica v10 compatibility
  *)

(*: Keywords : plot, 2D graphics, error bars, log *)
(*: Mathematica Version : 10.0 or later *)

BeginPackage["ErrorBarLogPlots`",{"ErrorBarPlots`"}];

(* Remove all symbols which may already have been defined in this context *)
(*
Quiet[Remove["ErrorBarLogPlots`*"]];
Quiet[Remove["ErrorBarLogPlots`Private`*"]];
*)

(* Get the function usage statements *)
Get["ErrorBarLogPlots`Usage`"];

Begin["`Private`"];

(* Remove any global symbols which may shadow the package symbols *)
Quiet[Remove @@ (("Global`" <> #) & /@ Names["ErrorBarLogPlots`*"])];

$ErrorBarStyle = {};
Options[ErrorListLogLogPlot] =
Options[ErrorListLogLinearPlot] = 
Options[ErrorListLogPlot] = 
Options[elplot] = Options[ErrorBarPlots`ErrorListPlot] = Join[
	Complement[Options[ListLinePlot],{MaxPlotPoints->Infinity}],
	{ErrorBarFunction -> Automatic, ErrorBarStyle -> Automatic, ErrorBarMapping -> Automatic}
];

SyntaxInformation[ErrorListLogLogPlot] = {"ArgumentsPattern" -> {{__}, OptionsPattern[]}}
SyntaxInformation[ErrorListLogLinearPlot] = {"ArgumentsPattern" -> {{__}, OptionsPattern[]}}
SyntaxInformation[ErrorListLogPlot] = {"ArgumentsPattern" -> {{__}, OptionsPattern[]}}
SyntaxInformation[ErrorBarPlots`ErrorListPlot] = {"ArgumentsPattern" -> {{__}, OptionsPattern[]}} 

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
		{xf=xflag, yf=yflag, newdat, newopts, p, ep, error, ebfunc, range, mapmode, ebstyle, 
			pr, prp, prx={Infinity,-Infinity}, pry={Infinity,-Infinity}, pr0, ebflag=True},

		{ebfunc, range, mapmode, ebstyle, pr, prp} = 
			OptionValue[{ErrorBarFunction, DataRange, ErrorBarMapping, ErrorBarStyle, PlotRange, PlotRangePadding}];
	
		If[ebfunc === Automatic, ebfunc = ebarfun];
		If[ebstyle === Automatic, ebstyle = $ErrorBarStyle];
		If[prp === Automatic, prp = Scaled[.02]];

		(* Process data sets consisting of only y's so that all points become {x,y} pairs. *)
		(* This code comes from Wolfram's ErrorBarPlots.m *)
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
		
		(* Default values for other options come from the corresponding List...Plot[],
		   not from Options[ErrorList...Plot]. This is probably a bug, but is
		   consistent with the definition of ErrorListPlot[], which uses ListPlot. *)
		p = Switch[{xf,yf},
			{False,True},  ListLogPlot[newdat, newopts],
			{True,False},  ListLogLinearPlot[newdat, newopts], 
			{True,True},   ListLogLogPlot[newdat, newopts],
			{False,False}, ListPlot[newdat, newopts] 
			];
		(* now p contains the graphics commands for the basic data plot (no error bars) *)
		If[ebflag, Return[p] (* no error bars need be drawn, so just return the List..Plot *)];

		(* We next generate a separate plot of just the data points using minimal options.
			In this way we use whatever PlotStyle sequence results when plotting multiple
			data sets. This sequence is needed to properly format error bars. *)
		newopts = Join[{Joined->False, PlotMarkers->None, InterpolationOrder->1, Mesh->None}, newopts];
		ep = Switch[{xf,yf},
			{False,True},  ListLogPlot[newdat, newopts],
			{True,False},  ListLogLinearPlot[newdat, newopts], 
			{True,True},   ListLogLogPlot[newdat, newopts],
			{False,False}, ListPlot[newdat, newopts] 
			];
		(* Now remove any "wrappers" around ep (such as Legended[]) so that it becomes a pure 
			Graphics object *)
		While[Head[ep] =!= Graphics, ep = First[ep]];

		(* ep is a Graphics object whose first argument contains the graphics directives and Point[]
			commands for the various data sets. We replace each Point[{list}] with individual Point[]
			calls for each data point. Then we replace these Point[] commands with error bar graphics
			generated by ebfunc[] using the error bar sizes saved in error[] by dologs[]. *)
		error[_] := ErrorBar[{0,0},{0,0}];
		ep = Graphics[ ep[[1]] /. a_Point :> Thread[a] /. Point[pos_] :> ebfunc[pos,error[pos]] ];

		(* Fix up the plotrange and combine the error bar and List...Plot graphics. *)
		(* First find the required plotrange to include the specified range as well as all error bars *)
		pr0 = PlotRange/.AbsoluteOptions[p,PlotRange];
		{prx,pry} = Block[
					{pranges={PlotRange/.AbsoluteOptions[ep,PlotRange], pr0}},
					{
						{(pranges[[All,1]][[All,1]]//Min),(pranges[[All,1]][[All,2]]//Max)},
						{(pranges[[All,2]][[All,1]]//Min),(pranges[[All,2]][[All,2]]//Max)}
					}
					];
		(* Next substitute in the corresponding limit for any specified as either Automatic, Full, or All *)
		pr = PRexpand[pr];
		pr = PRsubst[pr, pr0, Except[Automatic]]; (* this converts original limit values to logs, if required *)
		pr = PRsubst[pr, {prx,pry}, Automatic];
		
		Show[p,PlotRange->pr, PlotRangePadding->prp, Prolog->List@@ep]
	]


(* This code makes all properly-formatted error specifications into full 
   ErrorBar[{xm, xp},{ym,yp}] format. *)
makeError[ErrorBar[y_?Positive]] := ErrorBar[{0,0}, eb[y]]
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
	(4) sets elplot's prx and pry to the ranges covered by x and y values including error bars.
	(5) clears the elplot flag ebflag if any error bar has a nonzero length
*)
dologs[x_,y_, ErrorBar[ex_,ey_]]:=
	Block[{newx = 1.0 x, newy = 1.0 y, 
		newxe = If[ex === {0,0}, ex, 1.0 ex, 1.0 ex], 
		newye = If[ey === {0,0}, ey,1.0 ey,1.0 ey], 
		ok = True, xmin, xmax, ymin, ymax},
		If[xf, If[x > 0, newx = Log[1.0 x]; newxe = errormap[x,ex], ok = False]];
		If[yf, If[y > 0, newy = Log[1.0 y]; newye = errormap[y,ey], ok = False]];
		If[ok,
			If[newxe!={0,0} || newye!={0,0}, ebflag=False]; (* need to draw an error bar *)
			(error[{newx,newy}] = ErrorBar[newxe,newye]);
			{xmin,xmax} = newx+newxe; {ymin,ymax} = newy+newye;
			prx = 1.0 {Min[First[prx],If[xmin =!= Indeterminate,xmin,newx-1.0,newx-1.0]], Max[Last[prx],xmax]};
			pry = 1.0 {Min[First[pry],If[ymin =!= Indeterminate,ymin,newy-1.0,newy-1.0]], Max[Last[pry],ymax]};
			{x,y},
			{}
		]
	]


(* This function expands a "shorthand" PlotRange specification such as Automatic or {Full,{ymin,Automatic}}
	to a complete, {{xmin,xmax},{ymin,ymax}} format with Automatic inserted into the proper slots. Not that
	it will not properly interpret the {Automatic,a} form for Automatic.
*)
PRexpand[pr_]:=
	Switch[pr,
		Automatic|All|Full, 
			{{Automatic,Automatic},{Automatic,Automatic}},
		Except[_List],
			{{Automatic,Automatic},{0,pr}},
		{Except[_List],Except[_List]},
			{{Automatic,Automatic},pr},
		{Automatic|All|Full,{_,_}},
			{{Automatic,Automatic},Last[pr]},
		{{_,_},Automatic|All|Full},
			{First[pr],{Automatic,Automatic}},
		_,
			pr
	]/.{All->Automatic,Full->Automatic}


(* This function takes a fully-expanded PlotRange specification and substitutes entries from another specification.
	The patt_ argument identifies those elements which should be substituted.
*)
PRsubst[pr_, pr0_, patt_]:=
	Block[
		{pos,vals},
		pos = Position[pr,patt,{2},Heads->False];
		If[pos =={},Return[pr]];
		vals = Extract[pr0,pos];
		ReplacePart[pr,Thread[Rule[pos,vals]]]
	]



(* This is the default ErrorBarFunction. Error bars are drawn using the style from ErrorBarStyle. 
	If a negative-going error bar on a log scale would be very long (errormap[] returned Indeterminate),
	then draw a negative-pointing arrow down to bottom of error-bar plot range.
*)
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
               Arrow[{{x, y}, (*{First[prx], y}*) {{.9,.1}.prx,y}}],
               (* We add this extra line to get ep's PlotRange correct -- it shouldn't be needed *)
               {Opacity[0],Line[{{x, y}, (*{First[prx], y}*) {{.9,.1}.prx,y}}]}},
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
               Arrow[{{x, y}, (*{x,First[pry]}*) {x,{.9,.1}.pry}}],
               (* We add this extra line to get ep's PlotRange correct -- it shouldn't be needed *)
               {Opacity[0],Line[{{x, y}, (*{x,First[pry]}*) {x,{.9,.1}.pry}}]}
               },
          True,
              {Line[{{x, y + ymax}, {x, y}, {x, y + ymin}}],
               Line[{Offset[{1.5, 0}, {x, y + ymax}], 
                 Offset[{-1.5, 0}, {x, y + ymax}]}],
               Line[{Offset[{1.5, 0}, {x, y + ymin}], 
                 Offset[{-1.5, 0}, {x, y + ymin}]}]}
          ];
          
        Style[Join[xline, yline], Arrowheads[.04], ebstyle]
    ]

    
End[]; (* Private *)

EndPackage[];
