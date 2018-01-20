(* ::Package:: *)

(* Copyright 1997-2014 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit`Palette.m *)

(* The code assumes that we are already in the 
	CurveFit`Palette`Private 
	context. *)

(* Viewer.m - Data Viewer window *)



(***********************************************************)
(* Data Viewer Mode for Modify data dialogs, etc. *)

plotfcn = LinearDataPlot;

CurveFit`ViewerPlot::usage = "ViewerPlot[] returns the plotting "<>
 "function name last used by the CurveFit Data Viewer window to "<>
 "display the data set. See also: plotLogs.";

CurveFit`ViewerPlot[] := plotfcn


(***********************************************************)
(* Data Viewer Window *)

dataviewer := (
	NotebookClose[DataViewerPalette];
	DataViewerPalette =
	CreatePalette[
		Block[{view},
		Manipulate[
			Column[{
			view = If[Quiet[CheckLength[]],
				If[!StringQ[display],
					CheckAbort[plotfcn = display;
						display[ImageSize->400],
						"Unable to use this plot type!\n"<>
						"0 or negative values with a Log axis."],
					If[Head[Symbol[display]] =!= Symbol,
						Symbol[display],
						Which[
							Head[CurveFit`FitResults] === Symbol 
							&& MemberQ[{"CurveFit`FitResults","CurveFit`FitPlot","CurveFit`DiffPlot"},display],
								"No fitting function has been used.",
							display == "CurveFit`FitPlot",
								Switch[plotfcn,
									LinearDataPlot, LinearDifferencePlot[ImageSize->400];,
									LogDataPlot, LogDifferencePlot[ImageSize->400];,
									LogLogDataPlot, LogLogDifferencePlot[ImageSize->400];,
									LogLinearDataPlot, LogLinearDifferencePlot[ImageSize->400];
								];
								CurveFit`FitPlot,
							display == "CurveFit`DiffPlot",
								Switch[plotfcn,
									LinearDataPlot, LinearDifferencePlot[ImageSize->400];,
									LogDataPlot, LogDifferencePlot[ImageSize->400];,
									LogLogDataPlot, LogLogDifferencePlot[ImageSize->400];,
									LogLinearDataPlot, LogLinearDifferencePlot[ImageSize->400];
								];
								CurveFit`DiffPlot,
							display == "CurveFit`ListData",
								CurveFit`ListData[],
							True,
								"Unable to display - value not defined."
						]
					]
				],
				"No valid data!"
			],
			Row[{
			Tooltip[Button["Copy display to notebook",
				Switch[Head[view],
				String,	
					SelectionMove[InputNotebook[],After,Cell];
					NotebookWrite[InputNotebook[],display,All];
					SelectionMove[InputNotebook[],All,Cell];
					SelectionEvaluate[InputNotebook[]],
				Graphics,
					SelectionMove[InputNotebook[],After,Cell];
					NotebookWrite[InputNotebook[],ToBoxes[view]];
					SelectionMove[InputNotebook[],After,Cell],
				Panel,
					SelectionMove[InputNotebook[],After,Cell];
					NotebookWrite[InputNotebook[],display<>"[]",All];
					SelectionMove[InputNotebook[],All,Cell];
					SelectionEvaluate[InputNotebook[]],
				_,
					SelectionMove[InputNotebook[],After,Cell];
					NotebookWrite[InputNotebook[],display,All];
					SelectionMove[InputNotebook[],All,Cell];
					SelectionEvaluate[InputNotebook[]]
				],
				ImageSize -> Automatic
			],"Inserts the displayed graphic or text at the end of the selected notebook" ],

			If[Length[CurveFit`Private`UndoStack] > 0,
				Tooltip[
					Button[" Undo ", eval["Undo[]"], ImageSize -> Automatic],
				"Undo the last data manipulation or file load"],
				"",""],

			If[Length[CurveFit`Private`RedoStack] > 0,
				Tooltip[
					Button[" Redo ", eval["Redo[]"], ImageSize -> Automatic],
				"Redo the Undo"],
				"",""]
			}, Spacer[20] ] (*Row*)
			
			},Spacings->1],


			{{display,LinearDataPlot,"Data Display"},
				{
					LinearDataPlot->"Data Plot: Linear", 
					LogDataPlot->"Data Plot: Log Y", 
					LogLogDataPlot->"Data Plot: Log-Log",
					LogLinearDataPlot->"Data Plot: Log X", 
					Delimiter, 
					ScatterDataPlot->"Scatter Plot: (X,Y) Points", 
					Delimiter, 
					"CurveFit`ListData"->"Data Table", 
					"DataFileHeader"->"File Comments", 
					"DataFileName"->"File Path", 
					Delimiter,
					"CurveFit`FitResults"->"Fit Results",
					"CurveFit`FitPlot"->"Fit Plot",
					"CurveFit`DiffPlot"->"Residual Plot"
				},
				ControlType->PopupMenu
			},

			AppearanceElements->None,
			Alignment->Right,
			ControlPlacement->Top,
			TrackedSymbols:> 
				{display,xx,yy,sx,sy,n, 
				CurveFit`DataFileName, CurveFit`DataFileHeader,
				CurveFit`Private`results, CurveFit`FitPlot,
				CurveFit`DiffPlot, CurveFit`Private`UndoStack}
		]],
		WindowMargins->{{Automatic,10},{10,Automatic}},
		Saveable->False,
		WindowTitle-> "CurveFit Data Viewer"
	];
)

