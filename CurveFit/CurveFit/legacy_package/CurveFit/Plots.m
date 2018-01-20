(* ::Package:: *)

(* Copyright 1997-2016 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Plots.m - Data plotting routines *)
(* Updated 1/2016 to increase default error bar thickness to Medium *)


(***********************************************************)
(* Make sure the following graphics packages are loaded *)

Needs["ErrorBarPlots`"];
Needs["ErrorBarLogPlots`"];
(* Needs["PlotLegends`"]; *)



(***********************************************************)
(* Usage messages *)

LinearDataPlot::usage="LinearDataPlot[ ] Plots the current CurveFit data in "<>
 "Lin(x) - Lin(y) form. Optional arguments may include any graphics "<>
 "option specification accepted by ErrorListPlot or ListPlot.\n\n"<>
 "LinearDataPlot[data] Plots the supplied data in "<>
 "Lin(x) - Lin(y) form. Following the data, the arguments may include any graphics "<>
 "option specification accepted by ErrorListPlot or ListPlot. "<>
 "The required data format is:\n\n"<>
 "{{ {xvalues..}, {yvalues..}, {xsigmas..}, {ysigmas..}, num_of_points}, \"name\" }\n\n"<>
 "The \"name\" string is optional and will be used to label the plot. This data "<>
 "format is compatible with the way data is saved into a variable using Backup[var], "<>
 "so LinearDataPlot[var] will plot data backed up using Backup[var].";

LogDataPlot::usage="LogDataPlot[ ] Plots the current CurveFit data in "<>
 "Lin(x) - Log(y) form. Optional arguments may include any graphics "<>
 "option specification accepted by ErrorListPlot or ListPlot.\n\n"<>
 "LogDataPlot[data] Plots the supplied data in "<>
 "Lin(x) - Log(y) form. Following the data, the arguments may include any graphics "<>
 "option specification accepted by ErrorListPlot or ListPlot. "<>
 "The required data format is:\n\n"<>
 "{{ {xvalues..}, {yvalues..}, {xsigmas..}, {ysigmas..}, num_of_points}, \"name\" }\n\n"<>
 "The \"name\" string is optional and will be used to label the plot. This data "<>
 "format is compatible with the way data is saved into a variable using Backup[var], "<>
 "so LogDataPlot[var] will plot data backed up using Backup[var].";

LogLogDataPlot::usage="LogLogDataPlot[ ] Plots the current CurveFit data in "<>
 "Log(x) - Log(y) form. Optional arguments may include any graphics "<>
 "option specification accepted by ErrorListPlot or ListPlot.\n\n"<>
 "LogLogDataPlot[data] Plots the supplied data in "<>
 "Log(x) - Log(y) form. Following the data, the arguments may include any graphics "<>
 "option specification accepted by ErrorListPlot or ListPlot. "<>
 "The required data format is:\n\n"<>
 "{{ {xvalues..}, {yvalues..}, {xsigmas..}, {ysigmas..}, num_of_points}, \"name\" }\n\n"<>
 "The \"name\" string is optional and will be used to label the plot. This data "<>
 "format is compatible with the way data is saved into a variable using Backup[var], "<>
 "so LogLogDataPlot[var] will plot data backed up using Backup[var].";

LogLinearDataPlot::usage="LogLinearDataPlot[ ] Plots the current CurveFit data in "<>
 "Log(x) - Lin(y) form. Optional arguments may include any graphics "<>
 "option specification accepted by ErrorListPlot or ListPlot.\n\n"<>
 "LogLinearDataPlot[data] Plots the supplied data in "<>
 "Log(x) - Lin(y) form. Following the data, the arguments may include any graphics "<>
 "option specification accepted by ErrorListPlot or ListPlot. "<>
 "The required data format is:\n\n"<>
 "{{ {xvalues..}, {yvalues..}, {xsigmas..}, {ysigmas..}, num_of_points}, \"name\" }\n\n"<>
 "The \"name\" string is optional and will be used to label the plot. This data "<>
 "format is compatible with the way data is saved into a variable using Backup[var], "<>
 "so LogLinearDataPlot[var] will plot data backed up using Backup[var].";

ScatterDataPlot::usage="ScatterDataPlot[ ] Plots the current CurveFit data as "<>
 "a scatter-plot of (x,y) points "<>
 "in Lin(x) - Lin(y) form. No error bars are displayed.";

FitPlot::usage="Output of the first plot (i.e. data fit plot) of the "<>
 "PlotFitResults family.";
DiffPlot::usage="Output of the second plot (i.e. diff. plot) of the "<>
 "PlotFitResults family.";

fitlogscales::usage="A list of two booleans which indicate "<>
 "whether the plots FitPlot and DiffPlot were generated with "<>
 "log scales for the x and y axes (DiffPlot always uses a "<>
 "linear y axis, so only the first element of fitlogscales "<>
 "is relevant for DiffPlot).";

ClearFitPlots::usage="Clears the values of FitPlot, DiffPlot, "<>
 "and fitlogscales.";

LinearDifferencePlot::usage="LinearDifferencePlot[ ] "<>
 "Plots the best fit results in "<>
 "Lin(\!\(x\_i\)) - Lin(\!\(y\_i\)) form, and the difference "<>
 "plot in Lin(\!\(x\_i\)) - Lin(\!\(y\_i\)-y(\!\(x\_i\))) "<>
 "form. The argument list may include any graphics "<>
 "option specification accepted by ErrorListPlot or ListPlot.";

LogDifferencePlot::usage="LogDifferencePlot[ ] "<>
 "Plots the best fit results in "<>
 "Lin(\!\(x\_i\)) - Log(\!\(y\_i\)) form, and the difference "<>
 "plot in Lin(\!\(x\_i\)) - Lin(\!\(y\_i\)-y(\!\(x\_i\))) "<>
 "form. The argument list may include any graphics "<>
 "option specification accepted by ErrorListPlot or ListPlot.";

LogLogDifferencePlot::usage="LogLogDifferencePlot[ ] "<>
 "Plots the best fit results in "<>
 "Log(\!\(x\_i\)) - Log(\!\(y\_i\)) form, and the difference "<>
 "plot in Log(\!\(x\_i\)) - Lin(\!\(y\_i\)-y(\!\(x\_i\))) "<>
 "form. The argument list may include any graphics "<>
 "option specification accepted by ErrorListPlot or ListPlot.";

LogLinearDifferencePlot::usage="LogLinearDifferencePlot[ ] "<>
 "Plots the best fit results in "<>
 "Log(\!\(x\_i\)) - Lin(\!\(y\_i\)) form, and the difference "<>
 "plot in Log(\!\(x\_i\)) - Lin(\!\(y\_i\)-y(\!\(x\_i\))) "<>
 "form. The argument list may include any graphics "<>
 "option specification accepted by ErrorListPlot or ListPlot.";

DifferencePlot::usage = 
 "A shared symbol for fit plot error messages.";

$AspectRatio::usage="This variable determines the value for "<>
 "the option AspectRatio used by all types of plots. If you "<>
 "change the value of this variable, then you must evaluate "<>
 "SetPlotAreaOptions[ ] for the change to take effect.";

$ImageSize::usage="This variable determines the value for "<>
 "the option ImageSize used by all types of plots. If you "<>
 "change the value of this variable, then you must evaluate "<>
 "SetPlotAreaOptions[ ] for the change to take effect.";

$LabelStyle::usage="This variable determines the value for "<>
 "the option LabelStyle used by all types of plots. If you "<>
 "change the value of this variable, then you must evaluate "<>
 "SetPlotAreaOptions[ ] for the change to take effect.";

$GridLines::usage="This variable determines the value for "<>
 "the option GridLines used by all types of plots. If you "<>
 "change the value of this variable, then you must evaluate "<>
 "SetPlotAreaOptions[ ] for the change to take effect.";

$GridLinesStyle::usage="This variable determines the value for "<>
 "the option GridLinesStyle used by all types of plots. If you "<>
 "change the value of this variable, then you must evaluate "<>
 "SetPlotAreaOptions[ ] for the change to take effect.";

$PlotStyle::usage="This variable determines the value for "<>
 "the option PlotStyle used by function plots such as Plot. If you "<>
 "change the value of this variable, then you must evaluate "<>
 "SetPlotAreaOptions[ ] for the change to take effect.";

$ListPlotStyle::usage="This variable determines the value for "<>
 "the option PlotStyle used by point plots such as ListPlot "<>
 "and ErrorListPlot. If you "<>
 "change the value of this variable, then you must evaluate "<>
 "SetPlotAreaOptions[ ] for the change to take effect.";

$ErrorBarStyle::usage="This variable determines the value for "<>
 "the option ErrorBarStyle used by error bar plots such as ErrorListPlot "<>
 "and LinearDataPlot. If you "<>
 "change the value of this variable, then you must evaluate "<>
 "SetPlotAreaOptions[ ] for the change to take effect.";

$PlotMarkers::usage="This variable determines the value for "<>
 "the option PlotMarkers used by point plots such as ListPlot "<>
 "and ErrorListPlot. If you "<>
 "change the value of this variable, then you must evaluate "<>
 "SetPlotAreaOptions[ ] for the change to take effect.";

$PlotAreaOptions::usage="The modified default list of options "<>
 "describing the plot area for all plots. These are general "<>
 "plot options accepted by functions such as Plot, ListPlot, "<>
 "etc. They are only read once, when the CurveFit "<>
 "package is loaded. If you change the value of this variable "<>
 "and want the changes to be implemented for all plotting "<>
 "functions, then run the command SetPlotAreaOptions.";

SetPlotAreaOptions::usage="SetPlotAreaOptions[ ] sets the options "<>
 "listed in $PlotAreaOptions to all plotting functions, "<>
 "so the plots produced will be similar in appearance. It also sets "<>
 "function plots to use $PlotStyle and point plots to use "<>
 "$ListPlotStyle and $PlotMarkers.";

$DataSizeThreshold::usage="Large data sets are displayed slowly "<>
 "in the front-end if the PlotMarker style is not simple or if "<>
 "data point Tooltips are used. $DataSizeThreshold is a list "<>
 "of two numbers: the first number sets the max number of points "<>
 "in a data set which will use the default PlotMarker style; the "<>
 "second number sets the max number of points for which data point "<>
 "Tooltips will be generated. For sets larger than this, plots will "<>
 "show a line from point to point rather than plotting the individual "<>
 "points.";

Tips::usage="An option for data and fit plots (LinearDataPlot[ ], "<>
 "LogDifferencePlot[ ], etc.) controlling the display of Tooltips "<>
 "identifying the data points. \n"<>
 "  Tips \[RightArrow] All : show tooltips \n"<>
 "  Tips \[RightArrow] None : do not show tooltips \n"<>
 "  Tips \[RightArrow] Automatic : show tooltips if the data set is not too big. \n"<>
 "The variable $DataSizeThreshold determines the cutoff set size.";

PlotDataFormat::usage="PlotDataFormat[ ] returns a pattern which "<>
 "defines the data format to use if you wish pass data to be plotted "<>
 "by a function such as LinearDataPlot[ ], rather than plotting the "<>
 "current data set. The data format is compatible with that used by "<>
 "BackupData[var] to save the current data set.";



Begin["`Private`"];



(***********************************************************)
(* Error messages *)

DifferencePlot::uneval = 
"First fit the data, then plot the fit results.";



(***********************************************************)
(* ClearFitPlots *)

ClearFitPlots := Clear[FitPlot, DiffPlot, fitlogscales];


(***********************************************************)
(*Global default plotting options*)

$DataSizeThreshold = {120,300};
$AspectRatio = 1/GoldenRatio;
$ImageSize = 500;
$LabelStyle = Directive[Italic, FontFamily->"Helvetica"];
$GridLines = Automatic;
$GridLinesStyle = GrayLevel[.85];
$PlotStyle = Automatic;
$ListPlotStyle = Automatic;
$ErrorBarStyle = Directive[Medium,Black,Dashing[{}]];
$PlotMarkers = 
{Graphics[{EdgeForm[{RGBColor[2/3, 0, 0]}], 
		FaceForm[RGBColor[1, 1, 0]], Disk[{0, 0}]}], 0.025};

$PlotAreaOptions = {
	AspectRatio -> $AspectRatio,
	ImageSize -> $ImageSize,
	Axes->None,
	Frame->True,
	GridLines -> $GridLines,
	GridLinesStyle -> $GridLinesStyle,
	LabelStyle -> $LabelStyle,
	PlotRange -> All
};



(***********************************************************)
(*Plot Function Lists and SetPlotAreaOptions[]*)

PlotFunctionList = {
	(*Built-In Functions*)
	Plot, LogPlot, LogLinearPlot, LogLogPlot, ParametricPlot
};

ListPlotFunctionList = {
	(*Built-In Functions*)
	ListPlot, ListLogPlot, ListLogLinearPlot, ListLogLogPlot
};

ErrorListPlotFunctionList = {
	(*Functions in ErrorBarPlots`*)
	ErrorListPlot,
	(*Functions in ErrorBarLogPlots`*)
	ErrorListLogPlot, ErrorListLogLogPlot, ErrorListLogLinearPlot
};

SetPlotAreaOptions[] := (
	Scan[
		(SetOptions[#, 
			Sequence@@$PlotAreaOptions, PlotStyle -> $PlotStyle
		]&),
		PlotFunctionList
	];
	Scan[
		(SetOptions[#,
			Sequence@@$PlotAreaOptions,
			PlotMarkers :> $PlotMarkers,
			PlotStyle -> $ListPlotStyle
		]&),
		Union[ListPlotFunctionList,ErrorListPlotFunctionList]
	];
	Scan[
		(SetOptions[#,
		ErrorBarStyle :> $ErrorBarStyle
		]&),
		ErrorListPlotFunctionList
	];
);

SetPlotAreaOptions[];



(***********************************************************)
(*Plot range calculation functions *)

prLinear[z_,sz_]:= Block[{zmin,zmax,r},
	zmin=Min[z-sz];
	zmax=Max[z+sz];
	r=zmax-zmin;
	{zmin-.03r,zmax+.03r}
]

prLog[z_,sz_]:= Block[{zmin,zmax,r},
	zmin=Min[Select[Join[z,z-sz],Positive]];
	zmax=Max[z+sz];
	r=zmax/zmin;
	{zmin r^-0.03,zmax r^0.03}
]


(***********************************************************)
(* PlotDataFormat *)

PlotDataFormat[] = {
{xData_List, yData_List, xSigma_List, ySigma_List, nPoints_Integer},
Optional[name_,None],
___}


(***********************************************************)
(* LinearDataPlot *)

LinearDataPlot[
	opts:OptionsPattern[{Tips->Automatic, ErrorListPlot}]
] := 
Block[{points, epoints, tips = OptionValue[Tips], tiplist, big, style,
	 label = OptionValue[PlotLabel],plot},
If[!CheckLength[], Abort[]];
If[label === None, label = ExtractFileName[]];
big = Map[n > # &, $DataSizeThreshold];

points = Transpose[{xx,yy}];
epoints = Transpose[{points,Apply[ErrorBar,Transpose[{sx,sy}],1]}];

tiplist = If[tips === True || tips === All || (tips === Automatic && !Last[big]),
	MapIndexed[ Tooltip[{Opacity[0.],Point[#1]},{First[#2],#1}]& , points],
	{} (* else no tooltips *)
];

style = If[First[big], 
	{PlotMarkers -> None, PlotStyle -> Darker[Red], ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label},
	{PlotMarkers -> $PlotMarkers, ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label}
	];

If[Last[big],
	plot = ListPlot[points, 
		FilterRules[{opts},Options[ListPlot]], FilterRules[{style},Options[ListPlot]], Joined -> True],
	plot = ErrorListPlot[epoints, FilterRules[{opts},Options[ErrorListPlot]], style]
];
plot[[1]] = {plot[[1]],{tiplist}};
plot
];

LinearDataPlot[{
{xData_List, yData_List, xSigma_List, ySigma_List, nPoints_Integer},
Optional[name_,None],___},
	opts:OptionsPattern[{Tips->Automatic, ErrorListPlot}]
] := 
Block[{points, epoints, tips = OptionValue[Tips], tiplist, big, style,
	 label = OptionValue[PlotLabel],plot},
If[!CheckLength[{xData, yData, xSigma, ySigma, nPoints}], Abort[]];
If[label === None, label = name];
big = Map[nPoints > # &, $DataSizeThreshold];

points = Transpose[{xData,yData}];
epoints = Transpose[{points,Apply[ErrorBar,Transpose[{xSigma,ySigma}],1]}];

tiplist = If[tips === True || tips === All || (tips === Automatic && !Last[big]),
	MapIndexed[ Tooltip[{Opacity[0.],Point[#1]},{First[#2],#1}]& , points],
	{} (* else no tooltips *)
];

style = If[First[big], 
	{PlotMarkers -> None, PlotStyle -> Darker[Red], ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label},
	{PlotMarkers -> $PlotMarkers, ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label}
	];

If[Last[big],
	plot = ListPlot[points, 
		FilterRules[{opts},Options[ListPlot]], FilterRules[{style},Options[ListPlot]], Joined -> True],
	plot = ErrorListPlot[epoints, FilterRules[{opts},Options[ErrorListPlot]], style]
];
plot[[1]] = {plot[[1]],{tiplist}};
plot
];


(***********************************************************)
(* LogDataPlot *) 

LogDataPlot[
	opts:OptionsPattern[{Tips->Automatic, ErrorListLogPlot}]
] := 
Block[{points, epoints,tips = OptionValue[Tips], tiplist, big, style,
	 label = OptionValue[PlotLabel],plot,lpoints},
If[!CheckLength[], Abort[]];
If[label === None, label = ExtractFileName[]];
big = Map[n > # &, $DataSizeThreshold];

points = Transpose[{xx,yy}];
epoints = Transpose[{points,Apply[ErrorBar,Transpose[{sx,sy}],1]}];

tiplist = 
	If[tips === True || tips === All || (tips === Automatic && !Last[big]),
		(ListLogPlot[MapIndexed[ Tooltip[#1,{First[#2],#1}]& , points], PlotMarkers -> None]//First//Last),
		{} (* else no tooltips *)
	];

style = If[First[big], 
	{PlotMarkers -> None, PlotStyle -> Darker[Red], ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label},
	{PlotMarkers -> $PlotMarkers, ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label}
	];

If[Last[big],
	plot = ListLogPlot[points,
		FilterRules[{opts},Options[ListLogPlot]], FilterRules[{style},Options[ListLogPlot]], Joined -> True],
	plot = ErrorListLogPlot[epoints, FilterRules[{opts},Options[ErrorListLogPlot]], style]
];
plot[[1]] = {plot[[1]],{tiplist}};
plot
];

LogDataPlot[{
{xData_List, yData_List, xSigma_List, ySigma_List, nPoints_Integer},
Optional[name_,None],___},
	opts:OptionsPattern[{Tips->Automatic, ErrorListLogPlot}]
] := 
Block[{points, epoints,tips = OptionValue[Tips], tiplist, big, style,
	 label = OptionValue[PlotLabel],plot,lpoints},
If[!CheckLength[{xData, yData, xSigma, ySigma, nPoints}], Abort[]];
If[label === None, label = name];
big = Map[nPoints > # &, $DataSizeThreshold];

points = Transpose[{xData,yData}];
epoints = Transpose[{points,Apply[ErrorBar,Transpose[{xSigma,ySigma}],1]}];

tiplist = 
	If[tips === True || tips === All || (tips === Automatic && !Last[big]),
		(ListLogPlot[MapIndexed[ Tooltip[#1,{First[#2],#1}]& , points], PlotMarkers -> None]//First//Last),
		{} (* else no tooltips *)
	];

style = If[First[big], 
	{PlotMarkers -> None, PlotStyle -> Darker[Red], ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label},
	{PlotMarkers -> $PlotMarkers, ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label}
	];

If[Last[big],
	plot = ListLogPlot[points,
		FilterRules[{opts},Options[ListLogPlot]], FilterRules[{style},Options[ListLogPlot]], Joined -> True],
	plot = ErrorListLogPlot[epoints, FilterRules[{opts},Options[ErrorListLogPlot]], style]
];
plot[[1]] = {plot[[1]],{tiplist}};
plot
];


(***********************************************************)
(* LogLogDataPlot *) 

LogLogDataPlot[
	opts:OptionsPattern[{Tips->Automatic, ErrorListLogLogPlot}]
] := 
Block[{points, epoints,tips = OptionValue[Tips], tiplist, big, style,
	 label = OptionValue[PlotLabel],plot,lpoints},
If[!CheckLength[], Abort[]];
If[label === None, label = ExtractFileName[]];
big = Map[n > # &, $DataSizeThreshold];

points = Transpose[{xx,yy}];
epoints = Transpose[{points,Apply[ErrorBar,Transpose[{sx,sy}],1]}];

tiplist = 
	If[tips === True || tips === All || (tips === Automatic && !Last[big]),
		(ListLogLogPlot[MapIndexed[ Tooltip[#1,{First[#2],#1}]& , points], PlotMarkers -> None]//First//Last),
		{} (* else no tooltips *)
	];

style = If[First[big], 
	{PlotMarkers -> None, PlotStyle -> Darker[Red], ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label},
	{PlotMarkers -> $PlotMarkers, ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label}
	];

If[Last[big],
	plot = ListLogLogPlot[points, 
		FilterRules[{opts},Options[ListLogLogPlot]], FilterRules[{style},Options[ListLogLogPlot]], Joined -> True],
	plot = ErrorListLogLogPlot[epoints, FilterRules[{opts},Options[ErrorListLogLogPlot]], style]
];
plot[[1]] = {plot[[1]],{tiplist}};
plot
];

LogLogDataPlot[{
{xData_List, yData_List, xSigma_List, ySigma_List, nPoints_Integer},
Optional[name_,None],___},
	opts:OptionsPattern[{Tips->Automatic, ErrorListLogLogPlot}]
] := 
Block[{points, epoints,tips = OptionValue[Tips], tiplist, big, style,
	 label = OptionValue[PlotLabel],plot,lpoints},
If[!CheckLength[{xData, yData, xSigma, ySigma, nPoints}], Abort[]];
If[label === None, label = name];
big = Map[nPoints > # &, $DataSizeThreshold];

points = Transpose[{xData,yData}];
epoints = Transpose[{points,Apply[ErrorBar,Transpose[{xSigma,ySigma}],1]}];

tiplist = 
	If[tips === True || tips === All || (tips === Automatic && !Last[big]),
		(ListLogLogPlot[MapIndexed[ Tooltip[#1,{First[#2],#1}]& , points], PlotMarkers -> None]//First//Last),
		{} (* else no tooltips *)
	];

style = If[First[big], 
	{PlotMarkers -> None, PlotStyle -> Darker[Red], ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label},
	{PlotMarkers -> $PlotMarkers, ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label}
	];

If[Last[big],
	plot = ListLogLogPlot[points, 
		FilterRules[{opts},Options[ListLogLogPlot]], FilterRules[{style},Options[ListLogLogPlot]], Joined -> True],
	plot = ErrorListLogLogPlot[epoints, FilterRules[{opts},Options[ErrorListLogLogPlot]], style]
];
plot[[1]] = {plot[[1]],{tiplist}};
plot
];


(***********************************************************)
(* LogLinearDataPlot *) 

LogLinearDataPlot[
	opts:OptionsPattern[{Tips->Automatic, ErrorListLogLinearPlot}]
] := 
Block[{points, epoints,tips = OptionValue[Tips], tiplist, big, style,
	 label = OptionValue[PlotLabel],plot,lpoints},
If[!CheckLength[], Abort[]];
If[label === None, label = ExtractFileName[]];
big = Map[n > # &, $DataSizeThreshold];

points = Transpose[{xx,yy}];
epoints=Transpose[{points,Apply[ErrorBar,Transpose[{sx,sy}],1]}];

tiplist = 
	If[tips === True || tips === All || (tips === Automatic && !Last[big]),
		(ListLogLinearPlot[MapIndexed[ Tooltip[#1,{First[#2],#1}]& , points], PlotMarkers -> None]//First//Last),
		{} (* else no tooltips *)
	];

style = If[First[big], 
	{PlotMarkers -> None, PlotStyle -> Darker[Red], ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label},
	{PlotMarkers -> $PlotMarkers, ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label}
	];

If[Last[big],
	plot = ListLogLinearPlot[points, 
		FilterRules[{opts}, Options[ListLogLinearPlot]], FilterRules[{style},Options[ListLogLinearPlot]], Joined -> True],
	plot = ErrorListLogLinearPlot[epoints, FilterRules[{opts},Options[ErrorListLogLinearPlot]], style]
];
plot[[1]] = {plot[[1]],{tiplist}};
plot
];

LogLinearDataPlot[{
{xData_List, yData_List, xSigma_List, ySigma_List, nPoints_Integer},
Optional[name_,None],___},
	opts:OptionsPattern[{Tips->Automatic, ErrorListLogLinearPlot}]
] := 
Block[{points, epoints,tips = OptionValue[Tips], tiplist, big, style,
	 label = OptionValue[PlotLabel],plot,lpoints},
If[!CheckLength[{xData, yData, xSigma, ySigma, nPoints}], Abort[]];
If[label === None, label = name];
big = Map[nPoints > # &, $DataSizeThreshold];

points = Transpose[{xData,yData}];
epoints = Transpose[{points,Apply[ErrorBar,Transpose[{xSigma,ySigma}],1]}];

tiplist = 
	If[tips === True || tips === All || (tips === Automatic && !Last[big]),
		(ListLogLinearPlot[MapIndexed[ Tooltip[#1,{First[#2],#1}]& , points], PlotMarkers -> None]//First//Last),
		{} (* else no tooltips *)
	];

style = If[First[big], 
	{PlotMarkers -> None, PlotStyle -> Darker[Red], ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label},
	{PlotMarkers -> $PlotMarkers, ErrorBarStyle -> $ErrorBarStyle, PlotLabel -> label}
	];

If[Last[big],
	plot = ListLogLinearPlot[points, 
		FilterRules[{opts}, Options[ListLogLinearPlot]], FilterRules[{style},Options[ListLogLinearPlot]], Joined -> True],
	plot = ErrorListLogLinearPlot[epoints, FilterRules[{opts},Options[ErrorListLogLinearPlot]], style]
];
plot[[1]] = {plot[[1]],{tiplist}};
plot
];


(***********************************************************)
(* ScatterDataPlot *)

ScatterDataPlot[
	opts:OptionsPattern[{Tips->Automatic, ListPlot}]
] := 
Block[{points, epoints, tips = OptionValue[Tips], tiplist, big, style,
	 label = OptionValue[PlotLabel],plot},
If[!CheckLength[], Abort[]];
If[label === None, label = ExtractFileName[]];
big = Map[n > # &, $DataSizeThreshold];

points = Transpose[{xx,yy}];

tiplist = If[tips === True || tips === All || (tips === Automatic && !Last[big]),
	MapIndexed[ Tooltip[{Opacity[0.],Point[#1]},{First[#2],#1}]& , points],
	{} (* else no tooltips *)
];

style = {PlotMarkers -> None, PlotStyle -> Darker[Red], PlotLabel -> label, AspectRatio -> Automatic};

plot = ListPlot[points, 
		FilterRules[{opts},Options[ListPlot]], FilterRules[{style},Options[ListPlot]]];
plot[[1]] = {plot[[1]],{tiplist}};
plot
];



(***********************************************************)
(* LinearDifferencePlot[] *) 

LinearDifferencePlot[
	opts:OptionsPattern[{Tips->Automatic, ErrorListPlot}]
]:=
Block[{diffs,errors},
If[OwnValues[fY]=={}, Message[DifferencePlot::uneval];Abort[]];

FitPlot = 
	Show[
		LinearDataPlot[opts],
		Plot[Tooltip[fY[x],funct],{x,First[xx],Last[xx]},
			Evaluate[FilterRules[{opts},Options[Plot]]]]
	];

diffs = yy-fY[xx];
errors = Sqrt[sy^2+(fY'[xx] sx)^2];
DiffPlot = 
	Show[
		LinearDataPlot[{{xx,diffs,0sx,errors,n},"Residuals and Effective Uncertainties"}, opts],
		Plot[Tooltip[0,funct],{x,First[xx],Last[xx]},
			PlotStyle -> {Black,Dashed}, Evaluate[FilterRules[{opts},Options[Plot]]]]
	];

fitlogscales = {False,False};

Column[{
	FitPlot,
	DiffPlot,
	funct, results}]
];


(***********************************************************)
(* LogDifferencePlot[] *) 

LogDifferencePlot[
	opts:OptionsPattern[{Tips->Automatic, ErrorListPlot}]
]:=
Block[{diffs,errors},
If[OwnValues[fY]=={}, Message[DifferencePlot::uneval];Abort[]];

FitPlot = 
	Show[
		LogDataPlot[opts],
		LogPlot[Tooltip[fY[x],funct],{x,First[xx],Last[xx]},
			Evaluate[FilterRules[{opts},Options[LogPlot]]]]
	];

diffs = yy-fY[xx];
errors = Sqrt[sy^2+(fY'[xx] sx)^2];
DiffPlot = 
	Show[
		LinearDataPlot[{{xx,diffs,0sx,errors,n},"Residuals and Effective Uncertainties"}, opts],
		Plot[Tooltip[0,funct],{x,First[xx],Last[xx]},
			PlotStyle -> {Black,Dashed}, Evaluate[FilterRules[{opts},Options[Plot]]]]
	];

fitlogscales = {False,True};

Column[{
	FitPlot,
	DiffPlot,
	funct, results}]
];


(***********************************************************)
(* LogLogDifferencePlot[] *) 

LogLogDifferencePlot[
	opts:OptionsPattern[{Tips->Automatic, ErrorListLogLogPlot}]
]:=
Block[{diffs,errors},
If[OwnValues[fY]=={}, Message[DifferencePlot::uneval];Abort[]];

FitPlot = 
	Show[
		LogLogDataPlot[opts],
		LogLogPlot[Tooltip[fY[x],funct],{x,First[xx],Last[xx]},
			Evaluate[FilterRules[{opts},Options[LogLogPlot]]]]
	];

diffs = yy-fY[xx];
errors = Sqrt[sy^2+(fY'[xx] sx)^2];
DiffPlot = 
	Show[
		LogLinearDataPlot[{{xx,diffs,0sx,errors,n},"Residuals and Effective Uncertainties"}, opts],
		LogLinearPlot[Tooltip[0,funct],{x,First[xx],Last[xx]},
			PlotStyle -> {Black,Dashed}, Evaluate[FilterRules[{opts},Options[LogLinearPlot]]]]
	];

fitlogscales = {True,True};

Column[{
	FitPlot,
	DiffPlot,
	funct, results}]
];


(***********************************************************)
(* LogLinearDifferencePlot[] *) 

LogLinearDifferencePlot[
	opts:OptionsPattern[{Tips->Automatic, ErrorListLogLinearPlot}]
]:=
Block[{diffs,errors},
If[OwnValues[fY]=={}, Message[DifferencePlot::uneval];Abort[]];

FitPlot = 
	Show[
		LogLinearDataPlot[opts],
		LogLinearPlot[Tooltip[fY[x],funct],{x,First[xx],Last[xx]},
			Evaluate[FilterRules[{opts},Options[LogLinearPlot]]]]
	];

diffs = yy-fY[xx];
errors = Sqrt[sy^2+(fY'[xx] sx)^2];
DiffPlot = 
	Show[
		LogLinearDataPlot[{{xx,diffs,0sx,errors,n},"Residuals and Effective Uncertainties"}, opts],
		LogLinearPlot[Tooltip[0,funct],{x,First[xx],Last[xx]},
			PlotStyle -> {Black,Dashed}, Evaluate[FilterRules[{opts},Options[LogLinearPlot]]]]
	];

fitlogscales = {True,False};

Column[{
	FitPlot,
	DiffPlot,
	funct, results}]
];


(***********************************************************)
(*  *) 



(***********************************************************)
End[]; (* `Private` *)

