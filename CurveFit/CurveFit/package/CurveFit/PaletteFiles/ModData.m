(* ::Package:: *)

(* Copyright 1997-2011 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit`Palette.m *)

(* The code assumes that we are already in the 
	CurveFit`Palette`Private 
	context. *)

(* ModData.m - Palette data modification selections *)



(***********************************************************)
(* Xeval - used to select a single X argument for a function eval  *) 

Xeval[f_String,plotname_String,log_String,prompt_String]:= 
eval[
"With[{x = SetX[ "<>plotname<>
	"[], "<>
	"Log -> "<>log<>", Label -> "<>prompt<>
	" ]}, \n"<>
"  Print[x]; \n\n"<>
"  "<>f<>"[x] \n"<>
"]\n"
]



(***********************************************************)
(* XReval - used to select a pair of X arguments for a function eval  *) 

XReval[f_String,plotname_String,log_String,prompt_String]:= 
eval[
"With[{x = SetXRange[ "<>plotname<>
	"[], "<>
	"Log -> "<>log<>", Label -> "<>prompt<>
	" ]}, \n"<>
"  Print[x]; \n\n"<>
"  "<>f<>"[Sequence@@x] \n"<>
"]\n"
]



(***********************************************************)
(* YReval - used to select a pair of Y arguments for a function eval  *) 

YReval[f_String,plotname_String,log_String,prompt_String]:= 
eval[
"With[{x = SetYRange[ "<>plotname<>
	"[], "<>
	"Log -> "<>log<>", Label -> "<>prompt<>
	" ]}, \n"<>
"  Print[x]; \n\n"<>
"  "<>f<>"[Sequence@@x] \n"<>
"]\n"
]



(***********************************************************)
(* Modify the data set main palette selections *) 

moddatamenu::usage = "Each subpalette of the \"Modify data points\" "<>
 "menu selection provides help for its items.";

moddatamenu := 
Tooltip[
ActionMenu["Modify data points",
{
	"Select a subrange of points" :>  removepalette[],
	Delimiter,
	"Basic data manipulations" :>  manippalette[],
	Delimiter,
	"Transform Frequency, Phase" :>  phasepalette[],
	"Transform Gamma Spectrum" :>  gammapalette[],
	Delimiter,
	"Algebraic Transforms"       :>  transformpalette[]
}
],
"Displays a palette of various routines to modify the data set."
]

moddatahelp := 
Tooltip[
Button["Help", 
	eval["?CurveFit`Palette`Private`moddatamenu"];
],
"Each subpalette provides its own help button"]

moddataitem := {moddatahelp, moddatamenu}



(***********************************************************)
(* plotLogs - lookup table for logscales  *) 

CurveFit`plotLogs::usage = "plotLogs[] returns a list of two "<>
 "booleans which tell whether the x and y axes of the CurveFit Data "<>
 "Viewer window use log scales. See ViewerPlot.";

CurveFit`plotLogs[LinearDataPlot] := {False,False};
CurveFit`plotLogs[LogDataPlot] := {False,True};
CurveFit`plotLogs[LogLinearDataPlot] := {True,False};
CurveFit`plotLogs[LogLogDataPlot] := {True,True};
CurveFit`plotLogs[] := CurveFit`plotLogs[CurveFit`ViewerPlot[]];



(***********************************************************)
(* Remove Data sub-palette *) 

XPlotPrompt = "Change the plot from LinearDataPlot[ ] "<>
"to something else like LogDataPlot[ ] if you wish. If the plot "<>
"has a log X-axis (like LogLogDataPlot[ ]), then the Log option to "<>
"SetXRange[ ] must be changed to Log \[RightArrow] True";

YPlotPrompt = "Change the plot from LinearDataPlot[ ] "<>
"to something else like LogDataPlot[ ] if you wish. If the plot "<>
"has a log Y-axis (like LogDataPlot[ ]), then the Log option to "<>
"SetYRange[ ] must be changed to Log \[RightArrow] True";

NKeepPrompt = "Edit the arguments to be the range of indexes Nmin and "<>
"Nmax you wish to keep. All points with indexes from Nmin to Nmax will "<>
"be retained. Points outside the range will be removed.";

NRemovePrompt = "Edit the arguments to be the range of indexes Nmin and "<>
"Nmax you wish to remove. All points with indexes from Nmin to Nmax will "<>
"be removed. Points outside the range will be kept.";

removepalette[] := (
	NotebookClose[CurveFitPalette];
	CurveFitPalette =
	CreatePalette[
		Column[{
			backtomain,
			Tooltip[
				Button["Help", 
					eval["?CurveFit`*Keep"];
					eval["?CurveFit`*Remove"];
					eval["?CurveFit`Set*Range"];
				],
				"Puts a menu of help for the data subrange routines "<>
				"in the input notebook"
			],
			Tooltip[
				Button["Keep an X-range", 
					TextHint[XPlotPrompt];
					XReval["XRangeKeep",SymbolName[plotfcn],SymbolName[plotLogs[plotfcn][[1]]],
						"\"Set the X values for the range you wish to keep.\""];
					mainpalette],
				"Keep an X-range of points, removing all others."
			],
			Tooltip[
				Button["Remove an X-range", 
					TextHint[XPlotPrompt];
					XReval["XRangeRemove",SymbolName[plotfcn],SymbolName[plotLogs[plotfcn][[1]]],
						"\"Set the X values for the range you wish to remove.\""];
					mainpalette],
				"Remove an X-range of points, keeping all others."
			],
			Tooltip[
				Button["Keep a Y-range", 
					TextHint[YPlotPrompt];
					YReval["YRangeKeep",SymbolName[plotfcn],SymbolName[plotLogs[plotfcn][[2]]],
						"\"Set the Y values for the range you wish to keep.\""];
					mainpalette],
				"Keep a Y-range of points, removing all others."
			],
			Tooltip[
				Button["Remove a Y-range", 
					TextHint[YPlotPrompt];
					YReval["YRangeRemove",SymbolName[plotfcn],SymbolName[plotLogs[plotfcn][[2]]],
						"\"Set the Y values for the range you wish to remove.\""];
					mainpalette],
				"Remove a Y-range of points, keeping all others."
			],
			Tooltip[
				Button["Keep an N-range", 
					TextHint[NKeepPrompt];
					insert["NRangeKeep[ (*min*) 1, (*max*) "<>ToString[n]<>" ]"];
					mainpalette],
				"Keep a range of points specified by their index, removing all others."
			],
			Tooltip[
				Button["Remove an N-range", 
					TextHint[NRemovePrompt];
					insert["NRangeRemove[ (*min*) 1, (*max*) 1 ]"];
					mainpalette],
				"Remove a range of points specified by their index, keeping all others."
			],
			Tooltip[
				Button["Remove a single point", 
					insert["NRangeRemove[ (*point number*) 1 ]"];
					mainpalette],
				"Remove a single point specified by its index, keeping all others."
			]
			},
			Alignment -> Left
		],
		WindowTitle->"Subrange",
		Saveable->False
	];
)


(***********************************************************)
(* Basic Data Manipulations sub-palette *) 

manippalette[] := (
	NotebookClose[CurveFitPalette];
	CurveFitPalette =
	CreatePalette[
		Column[{
			backtomain,
			Tooltip[
				Button["Help", 
					eval[
						"?\"CurveFit`Switch*\"|\"CurveFit`SortData\""<>
						"|\"CurveFit`AssignYsigmas\"|\"CurveFit`CalculateYsigmas\""
					];
				],
				"Puts a menu of help for the data manipulation routines "<>
				"in the input notebook"
			],
			Tooltip[
				Button["Sort by X values", 
					eval["SortData[]"];
					mainpalette],
				"Sorts the data points in order of increasing X value"
			],
			Tooltip[
				Button["Set X to the range 1 - N", 
					SaveForUndo[]; 
					eval["xx = Range[n]; sx = ConstantArray[0,n];"];
					mainpalette],
				"Sets each X value to the index 1..n of the point, \[Sigma]x = 0."
			],
			Tooltip[
				Button["Switch X and Y (and \[Sigma]x, \[Sigma]y)", 
					eval["SwitchXXandYY[]"];
					mainpalette],
				"Swaps the values of the x,\[Sigma]x and y,\[Sigma]y data. The new data is not sorted."
			],
			Tooltip[
				Button["Switch \[Sigma]x and \[Sigma]y only", 
					eval["SwitchSXandSY[]"];
					mainpalette],
				"Swaps the values of the \[Sigma]x and \[Sigma]y (x and y unchanged)"
			],
			Tooltip[
				Button["Set all \[Sigma]x values to 0",
					SaveForUndo[]; 
					eval["sx = ConstantArray[0,n];"];
					mainpalette],
				"Set sx to a vector of all 0's."
			],
			Tooltip[
				Button["Replace all \[Sigma]y = 0 values", 
					eval["?CurveFit`AssignYsigmas"];
					insert["AssignYsigmas[ ](* insert value between brackets *)"];
					mainpalette],
				"Replace \[Sigma]y = 0 with \[Sigma]y = (value you specify)"
			],
			Tooltip[
				Button["Analyze Y data and assign \[Sigma]y's",
					eval["CalculateYsigmas[]"];
					mainpalette],
				"Group Y's by X value and assign \[Sigma]y's from std. deviations."
			]
			},
			Alignment -> Left
		],
		WindowTitle->"Manipulate Data",
		Saveable->False
	];
)


(***********************************************************)
(* Phase, frequency Manipulations sub-palette *) 
phasepalette[] := (
	NotebookClose[CurveFitPalette];
	CurveFitPalette =
	CreatePalette[
		Column[{
			backtomain,
			Tooltip[
				Button["Help", 
					eval["?CurveFit`Unwrap*"];
					eval["?CurveFit`*To*"];
				],
				"Puts a menu of help for the phase, frequency manipulation routines "<>
				"in the input notebook"
			],
			Tooltip[
				Button["Unwrap Y Phase (degrees)", 
					eval["UnwrapPhaseDeg[]"];
					mainpalette],
				"Unwraps Y phase discontinuities at \[PlusMinus]180 degrees."
			],
			Tooltip[
				Button["Unwrap Y Phase (radians)", 
					eval["UnwrapPhaseRad[]"];
					mainpalette],
				"Unwraps Y phase discontinuities at \[PlusMinus]\[Pi] radians."
			],
			Tooltip[
				Button["Y degrees \[RightArrow] radians", 
					eval["DegToRad[]"];
					mainpalette],
				"Convert Y phase data from degrees to radians."
			],
			Tooltip[
				Button["Y radians \[RightArrow] degrees", 
					eval["RadToDeg[]"];
					mainpalette],
				"Convert Y phase data from radians to degrees."
			],
			Tooltip[
				Button["X Hz \[RightArrow] rad/sec", 
					eval["HzToRadPerSec[]"];
					mainpalette],
				"Convert X frequency data from Hertz to radians/sec."
			],
			Tooltip[
				Button["X rad/sec \[RightArrow] Hz", 
					eval["RadPerSecToHz[]"];
					mainpalette],
				"Convert X frequency data from radians/sec to Hertz."
			]
			},
			Alignment -> Left
		],
		WindowTitle->"Phase, Freq Data",
		Saveable->False
	];
)


(***********************************************************)
(* Gamma Spectrum Manipulations sub-palette *) 
RebinPrompt = 
"(* change the arguments of the following function \n"<>
"   to perform the data rebinning you want, \n"<>
"   then evaluate this cell.      *)\n\n"<>
"Rebin[ \n"<>
"  3,   (* change to the number of channels you want to combine *)\n"<>
"  Averaging -> True,   (* change to False to make Y values the total of the binned channel Y's *)\n"<>
"  Xerrors -> True   (* change to False to set sx = 0 for the data *)\n"<>
"]\n\n"<>
"(* Use Undo[] if you don't like the results. *)";

gammapalette[] := (
	NotebookClose[CurveFitPalette];
	CurveFitPalette =
	CreatePalette[
		Grid[{
			{backtomain, SpanFromLeft},
			{Tooltip[
				Button["Help",
					eval["?CurveFit`MakePoisson"];
					eval["?Xerrors"];
					],
				"Set \[Sigma]y = \!\(\*SqrtBox[\"Y\"]\)"
			],
			Tooltip[
				Button["Set to Poisson count data",
					eval["MakePoisson[Xerrors -> True]"];
					mainpalette],
				"Set \[Sigma]y = \!\(\*SqrtBox[\"Y\"]\)"
			]},
			{Tooltip[
				Button["Help",
					eval["?CurveFit`RemoveEmptyBins"];
					],
				"Remove channels with 0 counts"
			],
			Tooltip[
				Button["Remove empty bins",
					eval["RemoveEmptyBins[]"];
					mainpalette],
				"Remove channels with 0 counts"
			]},
			{Tooltip[
				Button["Help",
					eval["?CurveFit`RestoreEmptyBins"];
					],
				"Restore channels with 0 counts"
			],
			Tooltip[
				Button["Restore empty bins",
					eval["RestoreEmptyBins[]"];
					mainpalette],
				"Restore channels with 0 counts"
			]},
			{Tooltip[
				Button["Help",
					eval["?CurveFit`Rebin"];
					eval["?CurveFit`Averaging"];
					eval["?CurveFit`Xerrors"];
					],
				"Rebin data set to combine adjacent channel data"
			],
			Tooltip[
				Button["Rebin data",
					insert[RebinPrompt];
					mainpalette],
				"Rebin data set to combine adjacent channel data"
			]}
			},
			Alignment -> Left
		],
		WindowTitle->"Gamma Data",
		Saveable->False
	];
)


(***********************************************************)
(* Transform Data sub-palette *) 
DataTransformPrompt = 
"(* change the right-hand sides of the following function \n"<>
"   definitions of xnew[] and ynew[] to perform the data \n"<>
"   transformation you need, then evaluate this cell.      *)\n\n"<>
"xnew[ x_, y_ ] := x \n"<>
"ynew[ x_, y_ ] := y \n\n"<>
"DataTransform[]\n\n"<>
"(* Use Undo[] if you don't like the results. *)";

transformpalette[] := (
	NotebookClose[CurveFitPalette];
	CurveFitPalette =
	CreatePalette[
		Column[{
			backtomain,
			Tooltip[
				Button["Help", 
					eval["?CurveFit`*Transform"];
				],
				"Puts a menu of help for the data transform routines "<>
				"in the input notebook"
			],
			Tooltip[
				Button["Y \[RightArrow] \!\(\*SuperscriptBox[\"Y\", \"2\"]\)", 
					eval[
						"xnew[ x_, y_ ] := x \n"<>
						"ynew[ x_, y_ ] := y^2 \n"<>
						"DataTransform[]\n"<>
						"(* Use Undo[] if you don't like the results. *)"
						];
					mainpalette],
				"Replace each y value with \!\(\*SuperscriptBox[\"y\", \"2\"]\)"
			],
			Tooltip[
				Button["Y \[RightArrow] \!\(\*SqrtBox[\"Y\"]\)", 
					eval[
						"xnew[ x_, y_ ] := x \n"<>
						"ynew[ x_, y_ ] := Sqrt[y] \n"<>
						"DataTransform[]\n"<>
						"(* Use Undo[] if you don't like the results. *)"
						];
					mainpalette],
				"Replace each y value with \!\(\*SqrtBox[\"y\"]\)"
			],
			Tooltip[
				Button["Y \[RightArrow] 1/Y", 
					eval[
						"xnew[ x_, y_ ] := x \n"<>
						"ynew[ x_, y_ ] := 1.0/y \n"<>
						"DataTransform[]\n"<>
						"(* Use Undo[] if you don't like the results. *)"
						];
					mainpalette],
				"Replace each y value with 1/y"
			],
			Tooltip[
				Button["Y \[RightArrow] -Y", 
					eval[
						"xnew[ x_, y_ ] := x \n"<>
						"ynew[ x_, y_ ] := -y \n"<>
						"DataTransform[]\n"<>
						"(* Use Undo[] if you don't like the results. *)"
						];
					mainpalette],
				"Replace each y value with -y"
			],
			Tooltip[
				Button["Y \[RightArrow] |Y|", 
					eval[
						"SaveForUndo[]\n"<>
						"yy = Abs[yy]; \n"<>
						"(* Use Undo[] if you don't like the results. *)"
						];
					mainpalette],
				"Replace each y value with its absolute value"
			],
			Tooltip[
				Button["Y \[RightArrow] \!\(\*SuperscriptBox[\"e\", \"Y\"]\)", 
					eval[
						"xnew[ x_, y_ ] := x \n"<>
						"ynew[ x_, y_ ] := Exp[y] \n"<>
						"DataTransform[]\n"<>
						"(* Use Undo[] if you don't like the results. *)"
						];
					mainpalette],
				"Replace each y value with Exp[y]"
			],
			Tooltip[
				Button["Y \[RightArrow] \!\(\*SubscriptBox[\"Log\", \"e\"]\)[Y]", 
					eval[
						"xnew[ x_, y_ ] := x \n"<>
						"ynew[ x_, y_ ] := Log[y] \n"<>
						"DataTransform[]\n"<>
						"(* Use Undo[] if you don't like the results. *)"
						];
					mainpalette],
				"Replace each y value with \!\(\*SubscriptBox[\"Log\", \"e\"]\)[y]"
			],
			Tooltip[
				Button["Y \[RightArrow] Y/X", 
					eval[
						"xnew[ x_, y_ ] := x \n"<>
						"ynew[ x_, y_ ] := y/x \n"<>
						"DataTransform[]\n"<>
						"(* Use Undo[] if you don't like the results. *)"
						];
					mainpalette],
				"Replace each y value with y/x"
			],
			Tooltip[
				Button["Y \[RightArrow] Y\[CenterDot]X", 
					eval[
						"xnew[ x_, y_ ] := x \n"<>
						"ynew[ x_, y_ ] := y x \n"<>
						"DataTransform[]\n"<>
						"(* Use Undo[] if you don't like the results. *)"
						];
					mainpalette],
				"Replace each y value with y\[CenterDot]x"
			],
			Tooltip[
				Button["User-defined", 
					eval["?CurveFit`DataTransform"];
					insert[DataTransformPrompt];
					mainpalette],
				"Use functions you define to transform x and y data and errors."
			]
			},
			Alignment -> Left
		],
		WindowTitle->"Transform",
		Saveable->False
	];
)


(***********************************************************)
(* Undo, Backup palette selections *) 

backupmenu := 
Tooltip[
ActionMenu["Undo and Backup",
{
	"List the data set"           :>  eval["ListData[]"],
	Delimiter,
	"Undo data operation"         :>  eval["Undo[]"],
	"Redo data operation"         :>  eval["Redo[]"],
	"Push data for Undo" :>  eval["SaveForUndo[]"],
	Delimiter,
	"Retrieve previous data"         :>  eval["SelectPrevData[]"],
	Delimiter,
	"Backup data"                 :>  eval["BackupData[]"],
	"Merge Backup with data"      :>  eval["MergeData[]"],
	"Restore backed-up data"      :>  eval["RestoreData[]"],
	Delimiter,
	"Erase data set"  :>  eval["EraseData[] (* Use Undo[] to recover *)"],
	Delimiter,
	"Repair data set" :>  eval["RepairData[]"]
}
],
"Most data set modifications can be undone"
]

backuphelp := 
Tooltip[
Button["Help", 
	eval["?CurveFit`*do"];eval["?CurveFit`*Data"]
],
"Puts a menu of help for the undo and backup routines "<>
"in the input notebook"]

backupitem := {backuphelp, backupmenu}

