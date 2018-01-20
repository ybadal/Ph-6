(* ::Package:: *)

(* Copyright 1997-2014 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Palette.m - Main control of the CurveFit user environment *)



(***********************************************************)
(* If necessary, load the main CurveFit package first *)

If[!MemberQ[$Packages,"CurveFit`"], Get["CurveFit`CurveFit`"]];



BeginPackage["CurveFit`Palette`",{"CurveFit`"}];

(* clear everything first, so the package may be read twice *)
Unprotect["`*"]; 
ClearAll["`*"];



Begin["`Private`"];
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
(* Usage messages *)

CurveFit::usage = 
"Begins or resumes a CurveFit session by: \n"<>
"  (1) Opening the main CurveFit function palette. \n"<>
"  (2) Clearing any fit parameter values.";

curvefit::usage = Curvefit::usage = CurveFit::usage;

QuitCurveFit::usage = 
"Quits the CurveFit session. The CurveFit palette will close. "<>
"The CurveFit package will remain loaded, however. "<>
"Restart CurveFit with the CurveFit command. \n"<>
"See also: CurveFit, ClearFitParameters";

xnew::usage = "xnew[x,y] is a function you must define before "<>
"using DataTransform[ ] to transform the x-values in the data set. \n"<>
"See also: DataTransform, ynew";

ynew::usage = "ynew[x,y] is a function you must define before "<>
"using DataTransform[ ] to transform the y-values in the data set. \n"<>
"See also: DataTransform, xnew";



Begin["`Private`"];

(*
   We worry that CurveFit may already be loaded and the palettes 
   may be active when this package is being read (reread),
   so we take measures to close the active palettes.
*)

If[Names["`CurveFitPalette"]!={}, 
	NotebookClose[CurveFitPalette];
];
If[Names["`DataViewerPalette"]!={}, 
	NotebookClose[DataViewerPalette];
];

(* now clear everything  *)
Unprotect["`*"]; 
ClearAll["`*"];



(***********************************************************)
(* Public variable initializations *) 

SetDirectory[$UserDocumentsDirectory];



(***********************************************************)
(* The palettes *)

CurveFitPalette = PaletteNotebook[{}];
DataViewerPalette = PaletteNotebook[{}]; (* code is in Palette`Viewer.m *)



(***********************************************************)
(* Private declarations *) 

mainpalette::usage = "creates the top-level palette";
dataviewer::usage = "creates the data viewer palette";

(* Variables and their initial values -------------------- *)

curvefitlaunched::usage = 
"True if a CurveFit session is active, otherwise False.";
curvefitlaunched = False;



(* Functions called by a button press -------------------- *)

insert::usage =
"insert[commandstring] inserts its argument string in a "<>
"new cell at the end of the current input notebook. It does "<>
"not evaluate the cell.";

eval::usage =
"eval[commandstring] inserts its argument string in "<>
"a new cell at the end of the current input notebook and then "<>
"evaluates the cell.";

TextHint::usage =
"TextHint[textstring] inserts its argument string in a "<>
"new text cell at the end of the current input notebook";



(***********************************************************)
(* Error messages *)



(***********************************************************)
(* CurveFit *) 

CurveFit := (
If[!curvefitlaunched,
	EraseData[];
	EmptyUndo[];
	CurveFit`Private`databackup = {{},{},{},{},0};
	SetDirectory[$UserDocumentsDirectory];
];
Block[{nb=InputNotebook[]},
ClearFit;
curvefitlaunched = True;
mainpalette;
dataviewer;
SetSelectedNotebook[nb];
]
)

Curvefit := CurveFit
curvefit := CurveFit



(***********************************************************)
(* QuitCurveFit *) 

QuitCurveFit := (
If[curvefitlaunched,
	If[
	ChoiceDialog[Beep[];"Are you sure? All CurveFit data will be lost!"],
		EraseData[];
		EmptyUndo[];
		CurveFit`Private`databackup = {{},{},{},{},0};
		ClearFit;
		NotebookClose[CurveFitPalette];
		NotebookClose[DataViewerPalette];
		curvefitlaunched = False;
		SetSelectedNotebook[InputNotebook[]];
	],
	ChoiceDialog["A CurveFit session is not running!",
		{"OK"->True}];
];
)



(***********************************************************)
(* insert ,eval, TextHint *) 

insert[command_String, nb_NotebookObject]:=(
SelectionMove[nb,After,Notebook];
NotebookWrite[nb,command,None];
SelectionMove[nb, All, Cell];
SetOptions[NotebookSelection[nb], 
	GeneratedCell -> False];
)
insert[command_String]:= insert[command, InputNotebook[]]

eval[command_String, nb_NotebookObject]:=(
SelectionMove[nb,After,Notebook];
NotebookWrite[nb,command,None];
SelectionMove[nb, All, Cell];
SetOptions[NotebookSelection[nb], 
	GeneratedCell -> False];
SelectionEvaluateCreateCell[nb];
)
eval[command_String]:= eval[command, InputNotebook[]]

TextHint[s_String, nb_NotebookObject]:=(
SelectionMove[nb,After,Notebook];
NotebookWrite[nb,Cell[s,"Text"],None];
SelectionMove[nb, All, Cell];
SetOptions[NotebookSelection[nb], 
	GeneratedCell -> False];
)
TextHint[s_String]:=TextHint[s,InputNotebook[]]



(***********************************************************)
(* Button to redisplay the main palette *) 

backtomain := Tooltip[
	Button["Back", mainpalette],
	"Return to main CurveFit palette"
]



(***********************************************************)
(* Data Viewer Window *)

Get[ToFileName[{"CurveFit","PaletteFiles"}, "Viewer.m"]];


(***********************************************************)
(* Palette file I/O selections *)

Get[ToFileName[{"CurveFit","PaletteFiles"}, "File.m"]];


(***********************************************************)
(* Palette fits and fit plots selections *)

Get[ToFileName[{"CurveFit","PaletteFiles"}, "Fits.m"]];


(***********************************************************)
(* Palette data modification selections *)

Get[ToFileName[{"CurveFit","PaletteFiles"}, "ModData.m"]];


(***********************************************************)
(* Data plotting palette selections *) 

dataplotmenu := 
Tooltip[
ActionMenu["Data plots",
{
	"Data Viewer Window"     :> dataviewer,
	Delimiter,
	"Linear Plot"            :> eval["LinearDataPlot[]"],
	"Log y - Linear x Plot"  :> eval["LogDataPlot[]"],
	"Log-Log Plot"           :> eval["LogLogDataPlot[]"],
	"Log x - Linear y Plot"  :> eval["LogLinearDataPlot[]"],
	"Scatter Plot of (x,y)"  :> eval["ScatterDataPlot[]"]
}
],
"Executes a function like LinearDataPlot[ ] "<>
"in the input notebook, or opens a separate data viewer window."
]

dataplothelp := 
Tooltip[
Button["Help", 
	eval["?CurveFit`*DataPlot"]
],
"Puts a menu of help for the data plotting routines "<>
"in the input notebook"]

dataplotitem := {dataplothelp, dataplotmenu}



(***********************************************************)
(* Main Palette Display *) 

mainpalette := (
	NotebookClose[CurveFitPalette];
	CurveFitPalette =
	CreatePalette[
		Grid[{
			fileioitem, (* in Palette`File.m *)
			dataplotitem, 
			fitmainitem, (* in Palette`Fits.m *)
			fitplotitem, (* in Palette`Fits.m *)
			moddataitem, (* in Palette`ModData.m *)
			backupitem (* in Palette`ModData.m *)
			},
			Alignment -> Left,
			Dividers -> {None,{False,False,True,False,True,False,False}}
		],
		WindowTitle->"CurveFit Main",
		Saveable->False
	];
)


(***********************************************************)

(* get rid of any Global symbols which shadow CurveFit symbols *)
Remove/@((StringJoin["Global`",#])&)/@
	Names["CurveFit`Palette`*"]//Quiet;

(* Restore the original status of spelling messages *)
If[spellFlag, On[General::"spell"]]
If[spell1Flag, On[General::"spell1"]]
If[commaFlag, On[Syntax::"com"]]
If[shdwFlag, On[General::"shdw"]]
ClearAll[spellFlag, spell1Flag, commaFlag, shdwFlag]
Remove[spellFlag, spell1Flag, commaFlag, shdwFlag]
End[]; (* `Private` *)

EndPackage[];  (* CurveFit`Palette` *)

