(* ::Package:: *)

(* Copyright 1997-2007 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit`Palette.m *)

(* The code assumes that we are already in the 
	CurveFit`Palette`Private 
	context. *)

(* Fits.m - Palette fits and fit plots selections *)



(***********************************************************)
(* Fitting functions main palette menu *) 

fitmainmenu := 
Tooltip[
	ActionMenu["Fitting functions",
		Evaluate[ 
			Table[
				With[{i=i},FitList[[i,1]] :> fitpalette[i]],
			 {i,Length[FitList]}] 
		]
	],
	"Displays a palette of various fitting functions"
]

fitmainhelp := 
Tooltip[
Button["Help", 
	(eval["?CurveFit`*Fit"]; eval["?CurveFit`f*"])
],
"Puts a menu of help for the fitting routines "<>
"and related functions in the input notebook"]

fitmainitem := {fitmainhelp, fitmainmenu}



(***********************************************************)
(* Fit sub-palettes *) 

fitpalette[n_Integer] := (
	NotebookClose[CurveFitPalette];
	CurveFitPalette =
	CreatePalette[
		Grid[
		Prepend[
		Table[
			With[
				{sym=FitList[[n,2,i]],nam=SymbolName[FitList[[n,2,i]]],str=FitList[[n,3,i]]},
				{Tooltip[Button[str, eval[nam<>"[]"];mainpalette],sym::tip]}
			],
			{i,Length[FitList[[n,2]] ]}
		]
		, {backtomain} ]
		,Alignment-> {Left,Center}
		],
		WindowTitle->"Fits",
		Saveable->False
	];
)


(***********************************************************)
(* Special Fit sub-palette for exponential fits *) 

fitpalette[2] := (
	NotebookClose[CurveFitPalette];
	CurveFitPalette =
	CreatePalette[
		Grid[
		Join[
		{{backtomain}},
		(* functions with no special processing *)
		Table[
			With[
				{sym=FitList[[2,2,i]],nam=SymbolName[FitList[[2,2,i]]],str=FitList[[2,3,i]]},
				{Tooltip[Button[str, eval[nam<>"[]"];mainpalette],sym::tip]}
			],
			{i,5}
		],
		(* functions which need to set region1 *)
		Table[
			With[
				{sym=FitList[[2,2,i]],nam=SymbolName[FitList[[2,2,i]]],str=FitList[[2,3,i]]},
				{Tooltip[
					Button[str, 
						eval[nam<>"::usage"];
						Xeval[nam,"LogDataPlot","False",
							"\"Set the X value for region1.\""];
						mainpalette],
					sym::tip
				]}
			],
			{i,6,7}
		],
		(* functions which need to set region1 and region2 *)
		Table[
			With[
				{sym=FitList[[2,2,i]],nam=SymbolName[FitList[[2,2,i]]],str=FitList[[2,3,i]]},
				{Tooltip[
					Button[str, 
						eval[nam<>"::usage"];
						XReval[nam,"LogDataPlot","False",
							"\"Set the X values for region1 and region2.\""];
						mainpalette],
					sym::tip
				]}
			],
			{i,8,8}
		]
		] (* Join *)
		,Alignment-> {Left,Center}
		],
		WindowTitle->"Fits",
		Saveable->False
	];
)


(***********************************************************)
(* Fit result plots palette selections *) 

fitplotmenu := 
Tooltip[
ActionMenu["Plot fit results",
{
	"Linear Plot"            :>  eval["LinearDifferencePlot[]"],
	"Log y - Linear x Plot"  :>  eval["LogDifferencePlot[]"],
	"Log-Log Plot"           :>  eval["LogLogDifferencePlot[]"],
	"Log x - Linear y Plot"  :>  eval["LogLinearDifferencePlot[]"]
}
],
"Executes a function like LinearDifferencePlot[ ] "<>
"in the input notebook"
]

fitplothelp := 
Tooltip[
Button["Help", 
	eval["?CurveFit`*DifferencePlot"]
],
"Puts a menu of help for the data plotting routines "<>
"in the input notebook"]

fitplotitem := {fitplothelp, fitplotmenu}

