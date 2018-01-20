(* ::Package:: *)

(* Copyright 1997-2007 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Select.m - Dialog windows to select ranges of points *)



(***********************************************************)
(*  *)



(***********************************************************)
(* Usage messages *)

SetX::usage = "SetX[graphics] displays a dialog window to set an "<>
"x value. The supplied graphics argument should be a data plot "<>
"such as LinearDataPlot[]. The function returns the x value chosen or "<>
"$Canceled if something went wrong (or the dialog is canceled). \n\n"<>
"SetX[graphics, Log -> True] must be used if the graphics plot has "<>
"a logarithmic X-axis, such as LogLogDataPlot[]. Otherwise the "<>
"natural log of the x value will be displayed and returned. \n\n"<>
"SetX[graphics, Label -> \"string\"] displays the string near the "<>
"top of the dialog box to give additional info to the user. \n\n "<>
"See also: SetY, SetXRange, SetYRange";
 
SetY::usage = "SetY[graphics] displays a dialog window to set a "<>
"y value. The supplied graphics argument should be a data plot "<>
"such as LinearDataPlot[]. The function returns the y value chosen or "<>
"$Canceled if something went wrong (or the dialog is canceled). \n\n"<>
"SetY[graphics, Log -> True] must be used if the graphics plot has "<>
"a logarithmic Y-axis, such as LogDataPlot[]. Otherwise the "<>
"natural log of the y value will be displayed and returned. \n\n"<>
"SetY[graphics, Label -> \"string\"] displays the string near the "<>
"top of the dialog box to give additional info to the user. \n\n "<>
"See also: SetX, SetYRange, SetXRange";

SetXRange::usage = "SetXRange[graphics] displays a dialog window to "<>
"set a range defined by a pair of "<>
"x values. The supplied graphics argument should be a data plot "<>
"such as LinearDataPlot[]. The function returns the {x1,x2} "<>
"chosen or "<>
"$Canceled if something went wrong (or the dialog is canceled). \n\n"<>
"SetXRange[graphics, Log -> True] must be used if the graphics plot has "<>
"a logarithmic X-axis, such as LogLogDataPlot[]. Otherwise the "<>
"natural logs of the x values will be displayed and returned. \n\n"<>
"SetXRange[graphics, Label -> \"string\"] displays the string near the "<>
"top of the dialog box to give additional info to the user. \n\n "<>
"See also: SetYRange, SetX, SetY";

SetYRange::usage = "SetYRange[graphics] displays a dialog window to "<>
"set a range defined by a pair of "<>
"y values. The supplied graphics argument should be a data plot "<>
"such as LinearDataPlot[]. The function returns the {y1,y2} "<>
"chosen or "<>
"$Canceled if something went wrong (or the dialog is canceled). \n\n"<>
"SetYRange[graphics, Log -> True] must be used if the graphics plot has "<>
"a logarithmic Y-axis, such as LogDataPlot[]. Otherwise the "<>
"natural logs of the y values will be displayed and returned. \n\n"<>
"SetYRange[graphics, Label -> \"string\"] displays the string near the "<>
"top of the dialog box to give additional info to the user. \n\n "<>
"See also: SetYRange, SetX, SetY";



Begin["`Private`"];



(***********************************************************)
(* Error messages *)

SetX::plotrange = "The PlotRange for the graphic is not numeric.";
SetX::badarg = "Bad argument list.";

SetY::plotrange = "The PlotRange for the graphic is not numeric.";
SetY::badarg = "Bad argument list.";

SetXRange::plotrange = "The PlotRange for the graphic is not numeric.";
SetXRange::badarg = "Bad argument list.";

SetYRange::plotrange = "The PlotRange for the graphic is not numeric.";
SetYRange::badarg = "Bad argument list.";



(***********************************************************)
(* SetX[] *) 

SetX[plot_Graphics,OptionsPattern[{Log->False, Label->""}]]:=
Block[{xr,yr,xinit,yinit,value,title,windowopts},

	(* Make sure the plot range is numeric *)
	If[!Check[({xr,yr}=PlotRange/.AbsoluteOptions[plot,PlotRange]),False],
		Message[SetX::plotrange];Return[$Canceled]
	];

	xinit = (Plus@@xr)/2;
	yinit = (Plus@@yr)/2;

	(* Window options depend on Mathematica version *)
	title = "Set X";
	windowopts =
	If[$VersionNumber==6.0 && $ReleaseNumber==0,
		{WindowTitle->title,WindowFloating->True},
		{WindowTitle->title,WindowSize->{Scaled[.5],All},WindowFloating->True}
	];

	DynamicModule[
		{pt={xinit,yinit}, 
			log=OptionValue[Log], prompt=OptionValue[Label], x},
		If[log =!= True, log = False];
		If[!StringQ[prompt], prompt = ""];
		value = 
		If[
			ChoiceDialog[
			Column[{
			prompt,
			Style["\nDrag the red line to set the X value:",
				Larger,Bold],

			Item[
			LocatorPane[Dynamic[pt],
				Show[plot, 
					Background->White, ImageSize->Scaled[1.0]
				],
				Appearance->
					Graphics[{Red,Line[{{0,-1},{0,1}}]},
						ImageSize->Scaled[2]]
			],Frame->True],

			Row[{
				Style["X = ",Larger,Bold],
				Style[
					Dynamic[x=If[log,Exp[pt[[1]]],pt[[1]]]],
					Larger,Bold
				]
			}]
			},Spacings->1.5] (* Column *),
			Sequence@@windowopts
			] (* ChoiceDialog *),

			(* True  *) x,
			(* False *) $Canceled
		] (* If *)
	](* DynamicModule *) ;
	value
]

SetX[___] := (Message[SetX::badarg]; $Canceled)



(***********************************************************)
(* SetY[] *) 

SetY[plot_Graphics,OptionsPattern[{Log->False, Label->""}]]:=
Block[{xr,yr,xinit,yinit,value,title,windowopts},

	(* Make sure the plot range is numeric *)
	If[!Check[({xr,yr}=PlotRange/.AbsoluteOptions[plot,PlotRange]),False],
		Message[SetY::plotrange];Return[$Canceled]
	];

	xinit = (Plus@@xr)/2;
	yinit = (Plus@@yr)/2;

	(* Window options depend on Mathematica version *)
	title = "Set Y";
	windowopts =
	If[$VersionNumber==6.0 && $ReleaseNumber==0,
		{WindowTitle->title,WindowFloating->True},
		{WindowTitle->title,WindowSize->{Scaled[.5],All},WindowFloating->True}
	];

	DynamicModule[
		{pt={xinit,yinit}, 
			log=OptionValue[Log], prompt=OptionValue[Label], y},
		If[log =!= True, log = False];
		If[!StringQ[prompt], prompt = ""];
		value = 
		If[
			ChoiceDialog[
			Column[{
			prompt,
			Style["\nDrag the red line to set the Y value:",
				Larger,Bold],

			Item[
			LocatorPane[Dynamic[pt],
				Show[plot, 
					Background->White, ImageSize->Scaled[1.0]
				],
				Appearance->
					Graphics[{Red,Line[{{-1,0},{1,0}}]},
						ImageSize->Scaled[2]]
			],Frame->True],

			Row[{
				Style["Y = ",Larger,Bold],
				Style[
					Dynamic[y=If[log,Exp[pt[[2]]],pt[[2]]]],
					Larger,Bold
				]
			}]
			},Spacings->1.5] (* Column *),
			Sequence@@windowopts
			] (* ChoiceDialog *),

			(* True  *) y,
			(* False *) $Canceled
		] (* If *)
	](* DynamicModule *) ;
	value
]

SetY[___] := (Message[SetY::badarg]; $Canceled)



(***********************************************************)
(* SetXRange[] *) 

SetXRange[plot_Graphics,OptionsPattern[{Log->False, Label->""}]]:=
Block[{xr,yr,xinit1,yinit1,xinit2,yinit2,value,title,windowopts},

	(* Make sure the plot range is numeric *)
	If[!Check[({xr,yr}=PlotRange/.AbsoluteOptions[plot,PlotRange]),False],
		Message[SetXRange::plotrange];Return[$Canceled]
	];

	xinit1 = ((Plus@@xr)+xr[[1]])/3;
	yinit1 = (Plus@@yr)/2;
	xinit2 = ((Plus@@xr)+xr[[2]])/3;
	yinit2 = (Plus@@yr)/2;

	(* Window options depend on Mathematica version *)
	title = "Set X Range";
	windowopts =
	If[$VersionNumber==6.0 && $ReleaseNumber==0,
		{WindowTitle->title,WindowFloating->True},
		{WindowTitle->title,WindowSize->{Scaled[.5],All},WindowFloating->True}
	];

	DynamicModule[
		{pt={{xinit1,yinit1},{xinit2,yinit2}}, 
			log=OptionValue[Log], prompt=OptionValue[Label], x1, x2},
		If[log =!= True, log = False];
		If[!StringQ[prompt], prompt = ""];
		value = 
		If[
			ChoiceDialog[
			Column[{
			prompt,
			Style["\nDrag the red lines to set the X values:",
				Larger,Bold],

			Item[
			LocatorPane[Dynamic[pt],
				Show[plot, 
					Background->White, ImageSize->Scaled[1.0]
				],
				Appearance->
					Graphics[{Red,Line[{{0,-1},{0,1}}]},
						ImageSize->Scaled[2]]
			],Frame->True],

			Grid[{
				{Style["X1 = ",Larger,Bold],
				Style[
					Dynamic[x1=Min[
						If[log,Exp[pt[[1,1]]],pt[[1,1]]],
						If[log,Exp[pt[[2,1]]],pt[[2,1]]]]
					],
					Larger,Bold
				]},
				{Style["X2 = ",Larger,Bold],
				Style[
					Dynamic[x2=Max[
						If[log,Exp[pt[[1,1]]],pt[[1,1]]],
						If[log,Exp[pt[[2,1]]],pt[[2,1]]]]
					],
					Larger,Bold
				]}
			}]
			},Spacings->1.5] (* Column *),
			Sequence@@windowopts
			] (* ChoiceDialog *),

			(* True  *) {x1,x2},
			(* False *) $Canceled
		] (* If *)
	](* DynamicModule *) ;
	value
]

SetXRange[___] := (Message[SetXRange::badarg]; $Canceled)



(***********************************************************)
(* SetYRange[] *) 

SetYRange[plot_Graphics,OptionsPattern[{Log->False, Label->""}]]:=
Block[{xr,yr,xinit1,yinit1,xinit2,yinit2,value,title,windowopts},

	(* Make sure the plot range is numeric *)
	If[!Check[({xr,yr}=PlotRange/.AbsoluteOptions[plot,PlotRange]),False],
		Message[SetYRange::plotrange];Return[$Canceled]
	];

	xinit1 = (Plus@@xr)/2;
	yinit1 = ((Plus@@yr)+yr[[1]])/3;
	xinit2 = (Plus@@xr)/2;
	yinit2 = ((Plus@@yr)+yr[[2]])/3;

	(* Window options depend on Mathematica version *)
	title = "Set Y Range";
	windowopts =
	If[$VersionNumber==6.0 && $ReleaseNumber==0,
		{WindowTitle->title,WindowFloating->True},
		{WindowTitle->title,WindowSize->{Scaled[.5],All},WindowFloating->True}
	];

	DynamicModule[
		{pt={{xinit1,yinit1},{xinit2,yinit2}}, 
			log=OptionValue[Log], prompt=OptionValue[Label], y1, y2},
		If[log =!= True, log = False];
		If[!StringQ[prompt], prompt = ""];
		value = 
		If[
			ChoiceDialog[
			Column[{
			prompt,
			Style["\nDrag the red lines to set the Y values:",
				Larger,Bold],

			Item[
			LocatorPane[Dynamic[pt],
				Show[plot, 
					Background->White, ImageSize->Scaled[1.0]
				],
				Appearance->
					Graphics[{Red,Line[{{-1,0},{1,0}}]},
						ImageSize->Scaled[2]]
			],Frame->True],

			Grid[{
				{Style["Y1 = ",Larger,Bold],
				Style[
					Dynamic[y1=Min[
						If[log,Exp[pt[[1,2]]],pt[[1,2]]],
						If[log,Exp[pt[[2,2]]],pt[[2,2]]]]
					],
					Larger,Bold
				]},
				{Style["Y2 = ",Larger,Bold],
				Style[
					Dynamic[y2=Max[
						If[log,Exp[pt[[1,2]]],pt[[1,2]]],
						If[log,Exp[pt[[2,2]]],pt[[2,2]]]]
					],
					Larger,Bold
				]}
			}]
			},Spacings->1.5] (* Column *),
			Sequence@@windowopts
			] (* ChoiceDialog *),

			(* True  *) {y1,y2},
			(* False *) $Canceled
		] (* If *)
	](* DynamicModule *) ;
	value
]

SetYRange[___] := (Message[SetYRange::badarg]; $Canceled)



(***********************************************************)
(*  *) 



(***********************************************************)
(*  *) 



(***********************************************************)
End[]; (* `Private` *)

