(* ::Package:: *)

(* Copyright 1997-2011 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Data.m - Data structure definitions and manipulations *)



(***********************************************************)
(* The data structure variables for the measured data *) 

ClearAll[xx, yy, sy, sx, n];

n::usage = "Number of data points.";
xx::usage = "List containing the X data values.";
yy::usage = "List containing the Y data values.";
sy::usage = "List containing the Y uncertainties.";
sx::usage = "List containing the X uncertainties.";

xx = yy = sy = sx = {}; n = 0;



(***********************************************************)
(* Function usage messages *)

CheckLength::usage = "CheckLength[ ] returns True if CurveFit "<>
 "has data which are all real numbers, "<>
 "and the data array lengths are all consistent. This function is called "<>
 "by many CurveFit routines (including the Data Viewer window). As a "<>
 "side effect, this routine will convert Y values into approximate "<>
 "real numbers (rather than numeric expressions like 3/2 or \[Pi]).";

RepairData::usage = "RepairData[ ] will attempt "<>
 "to repair some CurveFit data inconsistencies. Some examples: "<>
 "a single, scalar uncertainty is replaced by a list; the wrong "<>
 "number of X values cause all X's to be replaced with 1..N; Most numeric "<>
 "values (except, maybe, Integers) are converted to real numbers using N[Re[ ]]. "<>
 "Changes may be reversed using Undo[ ].";

CheckLength1D::usage = "CheckLength1D[ ] returns True if CurveFit "<>
 "has some data, "<>
 "and the yy and sy data array lengths are consistent.";

ListData::usage = "ListData[ ] displays the current data "<>
 "in a table. If there are more than about 21 data points, then a "<>
 "scrollbar is provided to scroll through the data.\n\n"<>
 "ListData[All] displays all points of the current data set regardless "<>
 "of how large the set may be.\n\n"<>
 "Listdata[data] or ListData[data, All] displays the data set provided "<>
 "in the argument. This "<>
 "data should be formatted in the same way as BackupData[var] formats "<>
 "the data set when it saves it to the variable named var.";

BackupData::usage = 
 "BackupData[ ]\n"<>
 "Backs up the current CurveFit data set so that it "<>
 "may be restored later. This is useful if you wish "<>
 "to modify the CurveFit data but may want to revert "<>
 "back to the way it was before in case you change "<>
 "your mind.\n\n"<>
 "BackupData[var]\n"<>
 "Backs up the CurveFit data into the variable you "<>
 "supply as the argument to the function. Use this "<>
 "form of backup if you want to save multiple "<>
 "images of the CurveFit data.\n\n"<>
 "See also: Undo, RestoreData, MergeData";

RestoreData::usage = 
 "RestoreData[ ]\n"<>
 "Restores the CurveFit data set saved by the most "<>
 "recent execution of BackupData[ ].\n\n"<>
 "RestoreData[var]\n"<>
 "Restores the CurveFit data saved by a call of "<>
 "BackupData[var].\n\n"<>
 "See also: BackupData and MergeData";

MergeData::usage = 
 "MergeData[ ]\n"<>
 "Merges backed-up data into current data (and sorts by "<>
 "x-values): {xx, yy, sx, sy, n} = {xx, yy, sx, sy, n} \[Union] "<>
 "{backed-up data}"
 "MergeData[var]\n"<>
 "Merges the CurveFit data saved by a call of "<>
 "BackupData[var].\n\n"<>
 "See also: BackupData and RestoreData";

EraseData::usage =
 "EraseData[ ] empties the data set.";

Undo::usage="Several data manipulation functions and LoadFile[ ] "<>
 "save the data set before performing their operations on an Undo "<>
 "stack. Undo[ ] returns the the data set to its previous state. "<>
 "By using a stack, multiple Undo[ ] operations are supported. \n"<>
 "See also: Redo, SaveForUndo, EmptyUndo";

Redo::usage="After using Undo[ ] to restore a previous data state, "<>
 "use Redo[ ] to reverse the effects of Undo.\n"<>
 "See also: Undo, SaveForUndo, EmptyUndo";

SaveForUndo::usage="SaveForUndo[ ] saves the data state on the Undo "<>
 "stack so that it may be restored using Undo[ ]. It also clears "<>
 "the Redo stack. \n"<>
 "See also: Undo, Redo, EmptyUndo";

EmptyUndo::usage="EmptyUndo[ ] clears the contents of the Undo and "<>
 "Redo stacks, reclaiming the memory they occupy. \n"<>
 "See also: Undo, Redo, SaveForUndo";

XRangeRemove::usage = 
 "XRangeRemove[xmin, xmax, options] or "<>
 "XRangeRemove[{xmin, xmax}, options] Removes data points which "<>
 "are within "<>
 "(xmin, xmax).  \n"<>
 "options is an optional sequence of options in the form "<>
 "\"opt->value\"; DisplayResults is an available option. \n"<>
 "See also: DisplayResults";

XRangeKeep::usage = 
 "XRangeKeep[xmin, xmax, options] or "<>
 "XRangeKeep[{xmin, xmax}, options] Keeps data points which "<>
 "are within "<>
 "(xmin, xmax), removing all the others.  \n"<>
 "options is an optional sequence of options in the form "<>
 "\"opt->value\"; DisplayResults is an available option. \n"<>
 "See also: DisplayResults";

YRangeRemove::usage = 
 "YRangeRemove[ymin, ymax, options] or "<>
 "YRangeRemove[{ymin, ymax}, options] Removes data points which "<>
 "are within "<>
 "(ymin, ymax).  \n"<>
 "options is an optional sequence of options in the form "<>
 "\"opt->value\"; DisplayResults is an available option. \n"<>
 "See also: DisplayResults";

YRangeKeep::usage = 
 "YRangeKeep[ymin, ymax, options] or "<>
 "YRangeKeep[{ymin, ymax}, options] Keeps data points which "<>
 "are within (ymin, ymax), removing all the others.  \n"<>
 "options is an optional sequence of options in the form "<>
 "\"opt->value\"; DisplayResults is an available option. \n"<>
 "See also: DisplayResults";

NRangeRemove::usage = 
 "NRangeRemove[nmin, nmax, options] or "<>
 "NRangeRemove[{nmin, nmax}, options] Removes data points from "<>
 "(including) nmin to nmax.  \n"<>
 "NRangeRemove[n, options] Removes the nth data point. "<>
 "options is an optional sequence of options in the form "<>
 "\"opt->value\"; DisplayResults is an available option. \n"<>
 "See also: DisplayResults";

NRangeKeep::usage = 
 "NRangeKeep[nmin, nmax, options] or "<>
 "NRangeKeep[{nmin, nmax}, options] Keeps data points from "<>
 "(including) nmin to nmax, "<>
 "removing all the others.  \n"<>
 "options is an optional sequence of options in the form "<>
 "\"opt->value\"; DisplayResults is an available option. \n"<>
 "See also: DisplayResults";

SwitchXXandYY::usage = "SwitchXXandYY[ ] switches xx and yy arrays "<>
"and the sx and sy arrays (both data and errors are switched).";

SwitchSXandSY::usage = "SwitchSXandSY[ ] switches sx and sy arrays.";

SortData::usage = "SortData[ ] sorts the data points in order of "<>
"increasing X value.";

CalculateYsigmas::usage = "CalculateYsigmas[ ] examines the group of "<>
"Y values associated with a particular X value. It assigns a Y uncertainty "<>
"to each Y in the group based on the distribution of Y values in the "<>
"group. It does this for each different X value in the set. If the data "<>
"has only a single Y value associated with some X value, then that Y "<>
"uncertainty is set to 0 and a warning message is issued. The resulting "<>
"data set is sorted by X values. The X uncertainties are not affected. "<>
"The function used to calculate the Y uncertainty for each member of a "<>
"group is Mathematica's StandardDeviation[ ].";

AssignYsigmas::usage = "AssignYsigmas[value] replaces all \[Sigma]y = 0 values "<>
"with the argument value you specify. The argument should evaluate to a positive "<>
"numerical value. Use the # symbol to represent the corresponding Y value.\n\n"<>
"Examples:\n\n"<>
"AssignYsigmas[0.02] replaces any \[Sigma]y = 0 value with 0.02\n\n"<>
"AssignYsigmas[0.03 #] replaces any \[Sigma]y = 0 value with 0.03 Y (3% of Y)\n\n"<>
"Any nonzero \[Sigma]y values are left unchanged. Any \[Sigma]y that doesn't evaluate "<>
"to a positive real value is replaced as though it were 0.";

SelectPrevData::usage = "SelectPrevData[ ] displays a dialog window "<>
"to let you select a previous data set pushed onto the Undo stack. "<>
"As you perform data manipulations or load data files, the current data set "<>
"is usually pushed onto the Undo stack before the data is modified. "<>
"Undo[ ] restores the last-pushed data from this stack. SelectPrevData[ ] "<>
"provides access to any of these saved data sets, not just the latest one.";



Begin["`Private`"];



(***********************************************************)
(* Error messages *)

RestoreData::badarg = 
"Can't restore data from the argument supplied.";
RestoreData::nodata = 
"The backup location has no data.  If you wish to "<>
"empty the CurveFit data set, use EraseData[].";

MergeData::badarg = 
"Can't merge data from the argument supplied.";

Undo::empty =
"Can't Undo. There is no previous state data saved.";

Redo::empty =
"Can't Redo. You must Undo[ ] first, then use Redo[ ].";

CheckLength::undef = "At least one of the parameters n, xx, "<>
"yy, sy, sx is undefined.";
CheckLength::improper = "n must be an integer, and xx, yy, sx, sy "<>
"must all be vectors of real numbers.";
CheckLength::unequal = "It must be: n = Length[xx] = Length[yy] "<>
"= Length[sy] = Length[sx]"; 
CheckLength::empty = "The data set is empty. Load data and try again.";
CheckLength::negsxsy = "sx, sy elements must all be nonnegative.";

CheckLength1D::undef = "At least one of the parameters n, "<>
"yy, sy, is undefined.";
CheckLength1D::unequal = "It must be: n = Length[yy] = Length[sy]" ;
CheckLength1D::empty = "The data set is empty. Load data and try again.";
CheckLength1D::negsxsy = "sy must be positive.";

XRange::xminxmax = "It must be: xmin \[LessEqual] xmax";
XRange::count="There must be at least 2 remaining points.";

YRange::yminymax = "It must be: ymin \[LessEqual] ymax";
YRange::count="There must be at least 2 remaining points.";

NRange::nminnmax = "It must be: 1 \[LessEqual] nmin \[LessEqual] nmax "<>
        "\[LessEqual] n.";
NRange::count="There must be at least 2 remaining points.";

CalculateYsigmas::length = 
"Not all X values have multiple Y's. Y Uncertainty = 0 in this case.";

RepairData::noYdata = "No valid numeric Y data could be found.";
RepairData::wrongX = "Wrong number of X values found - replacing X's with 1..N.";
RepairData::wrongSY = "Wrong number of \[Sigma]y values found - replacing all with \[Sigma]y = 0.";
RepairData::wrongSX = "Wrong number of \[Sigma]x values found - replacing all with \[Sigma]x = 0.";
RepairData::scalarSY = "Single (scalar) \[Sigma]y. Converting to a list of values."; 
RepairData::scalarSX = "Single (scalar) \[Sigma]x. Converting to a list of values."; 


(***********************************************************)
(* databackup -- the private variable for data backups *) 

ClearAll[databackup];
databackup = { {{},{},{},{},0} (* Data *), 
	"" (* DataFileName *), "" (* DataFileHeader *)};



(***********************************************************)
(* The Undo and Redo stacks *)

ClearAll[UndoStack, RedoStack, $UndoStackMaxLength];
UndoStack = {};
RedoStack = {};

$UndoStackMaxLength::usage="The maximum depth of the Undo stack.";
$UndoStackMaxLength = 20;



(***********************************************************)
(* CheckLength *)

(* Returns True if n,xx,yy,sy,sx are defined, and if 
n=Length[xx]=Length[yy]=Length[sy]=Length[sx]. Returns False 
otherwise, and displays a message. *)

CheckLength[] := Block[{value},
value = True;

If[OwnValues[n]=={} || OwnValues[xx]=={} || OwnValues[yy]=={} || 
   OwnValues[sy]=={} || OwnValues[sx]=={},
value = False; 
Message[CheckLength::undef],

If[!(IntegerQ[n]&&
	VectorQ[xx,(NumericQ[#]&&Element[#,Reals])&]&&
	VectorQ[yy,(NumericQ[#]&&Element[#,Reals])&]&&
	VectorQ[sx,(NumericQ[#]&&Element[#,Reals])&]&&
	VectorQ[sy,(NumericQ[#]&&Element[#,Reals])&]),
value = False; 
Message[CheckLength::improper],

If[!(MatrixQ[{xx,yy,sx,sy}] && n==Length[yy]),
value = False;
Message[CheckLength::unequal],

If[n == 0,
value = False;
Message[CheckLength::empty],

If[Min[sx] <0 || Min[sy] <0,
value = False;
Message[CheckLength::negsxsy]

]]]]]; (* end of nested If's *)

If[value, yy = N[yy]];
value
];

CheckLength[{xb_List,yb_List,sxb_List,syb_List,nb_Integer}
/;(MatrixQ[{xb,yb,sxb,syb},(NumericQ[#]&&Element[#,Reals])&] && nb==Length[xb] && nb>0)
] := True;

CheckLength[__]:= False;



(***********************************************************)
(* CheckLength1D *)

(* Like CheckLength, but ignores the xx and sx data arrays *)

CheckLength1D[] := Block[{value},
value = True;
If[OwnValues[n]=={} || OwnValues[yy]=={} || OwnValues[sy]=={},
value = False; 
Message[CheckLength1D::undef],
If[n != Length[yy] || n != Length[sy],
value = False;
Message[CheckLength1D::unequal],
If[Min[sy] <0,
value = False;
Message[CheckLength1D::negsxsy]
]]]; (* end of nested If's *)
value
]



(***********************************************************)
(* ListData *) 

ListData[s:Except[_List]:Default] := 
Block[{g, size},
	If[!CheckLength[], Abort];
	size = If[s===All || n<21, All, 370];
	g =
		Grid[
			Prepend[Transpose[{Range[n], xx, yy, sx, sy}],
				Style[#, Plain, Bold]& /@ {"#", "X", "Y", "\[Sigma]X", "\[Sigma]Y"}],
			ItemStyle -> Directive[FontFamily->"Helvetica", Italic],
			ItemSize -> Full,
			Alignment -> {Left, Baseline},
			Spacings -> {Offset[2], Automatic}
		];
	Panel[
		Pane[
			Pane[g, ImageMargins->{{10,10},{0,0}}],
			{All, size},
			Scrollbars -> Automatic, ImageMargins -> 2
		],
		Style[ExtractFileName[], Italic, Larger], Top
	]
];

ListData[{d_List, Optional[name_,None], ___}, s_:Default] := 
Block[{g, size},
	If[!CheckLength[d], Abort];
	size = If[s===All || Last[d]<21, All, 370];
	g =
		Grid[
			Prepend[Transpose[Prepend[Most[d], Range[Last[d]]]],
				Style[#, Plain, Bold]& /@ {"#", "X", "Y", "\[Sigma]X", "\[Sigma]Y"}],
			ItemStyle -> Directive[FontFamily->"Helvetica", Italic],
			ItemSize -> Full,
			Alignment -> {Left, Baseline},
			Spacings -> {Offset[2], Automatic}
		];
	Panel[
		Pane[
			Pane[g, ImageMargins->{{10,10},{0,0}}],
			{All, size},
			Scrollbars -> Automatic, ImageMargins -> 2
		],
		Style[If[name =!= None, ExtractFileName[name], ""], Italic, Larger], Top
	]
];



(***********************************************************)
(* EmptyUndo *) 

EmptyUndo[] := 
(
Clear[RedoStack]; RedoStack = {};
Clear[UndoStack]; UndoStack = {};
);



(***********************************************************)
(* SaveForUndo *) 

SaveForUndo[] := 
(
Clear[RedoStack]; RedoStack = {};
PushStack[UndoStack] = {{xx,yy,sx,sy,n},DataFileName,DataFileHeader};
If[Length[UndoStack] > $UndoStackMaxLength,
	UndoStack = Take[UndoStack,$UndoStackMaxLength];
];
);



(***********************************************************)
(* Undo *) 

Undo[] := 
If[Length[UndoStack] > 0,
	PushStack[RedoStack] = {{xx,yy,sx,sy,n},DataFileName,DataFileHeader};
	{{xx,yy,sx,sy,n},DataFileName,DataFileHeader} = PopStack[UndoStack];
	Print[ExtractFileName[DataFileName]];
	Print["n = "<>ToString[n]];,

	Message[Undo::empty];,

	Clear[UndoStack]; UndoStack = {};
	Message[Undo::empty];
];



(***********************************************************)
(* Redo *) 

Redo[] := 
If[Length[RedoStack] > 0,
	PushStack[UndoStack] = {{xx,yy,sx,sy,n},DataFileName,DataFileHeader};
	{{xx,yy,sx,sy,n},DataFileName,DataFileHeader} = PopStack[RedoStack];
	Print[ExtractFileName[DataFileName]];
	Print["n = "<>ToString[n]];,

	Message[Redo::empty];,

	Clear[RedoStack]; RedoStack = {};
	Message[Redo::empty];
];



(***********************************************************)
(* BackupData[] *) 

SetAttributes[BackupData,{HoldAll}];

BackupData[var_Symbol:databackup] := 
(
Clear[var]; 
var = {{xx,yy,sx,sy,n},DataFileName,DataFileHeader};
Print[ToString[n]<>" data points backed up"<>
	If[StringQ[DataFileName] == False || DataFileName == "", 
		".",
		" from data set "<>ToString[ExtractFileName[DataFileName]]
	]
]; 
)



(***********************************************************)
(* RestoreData[] *) 

RestoreData[
{{xb_List,yb_List,sxb_List,syb_List,nb_Integer},df_String,dh_String}
/;(MatrixQ[{xb,yb,sxb,syb},NumberQ] && nb==Length[xb])
] := (
If[nb > 0,
	SaveForUndo[];
	{xx,yy,sx,sy,n} = {xb,yb,sxb,syb,nb};
	DataFileName = df;
	DataFileHeader = dh;
	Print[ToString[n]<>" data points restored"<>
		If[StringQ[DataFileName] == False || DataFileName == "", 
			".",
			" from data set "<>ToString[ExtractFileName[DataFileName]]
		]
	]; 
	,
	Message[RestoreData::nodata]
]
);

RestoreData[
{xb_List,yb_List,sxb_List,syb_List,nb_Integer}
/;(MatrixQ[{xb,yb,sxb,syb},NumberQ] && nb==Length[xb])
] := RestoreData[{{xb,yb,sxb,syb,nb},"",""}]

RestoreData[] := RestoreData[databackup]
RestoreData[__] := Message[RestoreData::badarg]



(***********************************************************)
(* MergeData[] *) 

MergeData[
{{xb_List,yb_List,sxb_List,syb_List,nb_Integer},df_,___}
/;(MatrixQ[{xb,yb,sxb,syb},NumericQ] && nb==Length[xb] && nb>0)
] := 
Block[
{v1 = Transpose[{xx,yy,sx,sy}], v2 = Transpose[{xb,N[yb],sxb,syb}]},
SaveForUndo[];
{xx,yy,sx,sy} = Transpose[Sort[Join[v1, v2]]];
n += nb;
Print[ToString[nb] <>" data points merged"<>
	If[StringQ[df] == False || df == "", 
		".",
		" from data set "<>ToString[ExtractFileName[df]]
	]
	<>"\ntotal data: "<> ToString[n] <>" points."]
]

MergeData[
{xb_List,yb_List,sxb_List,syb_List,nb_Integer}
/;(MatrixQ[{xb,yb,sxb,syb},NumericQ] && nb==Length[xb] && nb>0)
] := MergeData[{{xb,yb,sxb,syb,nb},"",""}]

MergeData[] := MergeData[databackup]
MergeData[__] := Message[MergeData::badarg]



(***********************************************************)
(* EraseData *) 

EraseData[] := 
(
SaveForUndo[];
Clear[xx, yy, sy, sx, n, DataFileName, DataFileHeader];
{xx,yy,sx,sy,n} = {{},{},{},{},0};
DataFileName = "";
DataFileHeader = "";
)



(***********************************************************)
(* XRangeRemove[] *) 

Options[XRangeRemove] = {DisplayResults:>$DisplayResults};

XRangeRemove[xmin_?NumericQ,xmax_?NumericQ,OptionsPattern[]]:=
Block[{temp,data,k,count,display}, 

display=OptionValue[DisplayResults];
If[display,,,
	Message[DisplayResults::unknown,display,True]; 
	display=True;
];

If[!CheckLength[], Abort[],
If[xmin > xmax, Message[XRange::xminxmax];Abort[];,

k=0;
count=n;
Do[If[xx[[i]] >= xmin && xx[[i]] <= xmax,--count],{i,n}];
If[count < 3, Message[XRange::count];Abort[];,

SaveForUndo[];
data=Transpose[{xx,yy,sy,sx}];
temp=Table[0.,{count}];					
Do[If[xx[[i]] >= xmin && xx[[i]] <= xmax,"",
temp[[++k]]=data[[i]];];,{i,n}];
temp=Transpose[temp];
xx=temp[[1]];
yy=temp[[2]];
sy=temp[[3]];
sx=temp[[4]];

If[display
	,
	(* display data *)
	Print[TableForm[Join[
		{{"point","x","y","\!\(\[Sigma]\_y\)","\!\(\[Sigma]\_x\)"}},
        Transpose[{Range[n],xx,yy,sy,sx}]]]];
];

Print["n= ",k];
Print[n-k, If[n==k+1, " point ", " points "]<>"removed."];
n=k;
]]];
];

XRangeRemove[-Infinity,xmax_,opts:OptionsPattern[]]:=
	XRangeRemove[Min[xx,{xmax}],xmax,opts]
XRangeRemove[xmin_,Infinity,opts:OptionsPattern[]]:=
	XRangeRemove[xmin,Max[xx,{xmin}],opts]
XRangeRemove[{xmin_,xmax_},opts:OptionsPattern[]]:=
	XRangeRemove[xmin,xmax,opts]



(***********************************************************)
(* XRangeKeep[] *) 

Options[XRangeKeep] = {DisplayResults:>$DisplayResults};

XRangeKeep[xmin_?NumericQ,xmax_?NumericQ,OptionsPattern[]]:=
Block[{temp,data,k,count,display}, 

display=OptionValue[DisplayResults];
If[display,,,
	Message[DisplayResults::unknown,display,True]; 
	display=True;
];

If[!CheckLength[], Abort[],
If[xmin > xmax, Message[XRange::xminxmax];Abort[];,

k=0;
count=n;
Do[If[xx[[i]] < xmin || xx[[i]] > xmax,--count],{i,n}];
If[count < 3, Message[XRange::count];Abort[];,

SaveForUndo[];
data=Transpose[{xx,yy,sy,sx}];
temp=Table[0.,{count}];
Do[If[xx[[i]] < xmin || xx[[i]] > xmax,"",
temp[[++k]]=data[[i]];];,{i,n}];
temp=Transpose[temp];
xx=temp[[1]];
yy=temp[[2]];
sy=temp[[3]];
sx=temp[[4]];

If[display
	,
	(* display data *)
	Print[TableForm[Join[
		{{"point","x","y","\!\(\[Sigma]\_y\)","\!\(\[Sigma]\_x\)"}},
        Transpose[{Range[n],xx,yy,sy,sx}]]]];
];

Print["n= ",k];
Print[n-k, If[n==k+1, " point ", " points "]<>"removed."];
n=k;
]]];
];

XRangeKeep[-Infinity,xmax_,opts:OptionsPattern[]]:=
	XRangeKeep[Min[xx,{xmax}],xmax,opts]
XRangeKeep[xmin_,Infinity,opts:OptionsPattern[]]:=
	XRangeKeep[xmin,Max[xx,{xmin}],opts]
XRangeKeep[{xmin_,xmax_},opts:OptionsPattern[]]:=
	XRangeKeep[xmin,xmax,opts]



(***********************************************************)
(* YRangeRemove[] *) 

Options[YRangeRemove] = {DisplayResults:>$DisplayResults};

YRangeRemove[ymin_?NumericQ,ymax_?NumericQ,OptionsPattern[]]:=
Block[{temp,data,k,count,display}, 

display=OptionValue[DisplayResults];
If[display,,,
	Message[DisplayResults::unknown,display,True]; 
	display=True;
];

If[!CheckLength[], Abort[],
If[ymin > ymax, Message[YRange::yminymax];Abort[];,

k=0;
count=n;
Do[If[yy[[i]] >= ymin && yy[[i]] <= ymax,--count],{i,n}];
If[count < 3, Message[YRange::count];Abort[];,

SaveForUndo[];
data=Transpose[{xx,yy,sy,sx}];
temp=Table[0.,{count}];					
Do[If[yy[[i]] >= ymin && yy[[i]] <= ymax,"",
temp[[++k]]=data[[i]];];,{i,n}];
temp=Transpose[temp];
xx=temp[[1]];
yy=temp[[2]];
sy=temp[[3]];
sx=temp[[4]];

If[display
	,
	(* display data *)
	Print[TableForm[Join[
		{{"point","x","y","\!\(\[Sigma]\_y\)","\!\(\[Sigma]\_x\)"}},
        Transpose[{Range[n],xx,yy,sy,sx}]]]];
];

Print["n= ",k];
Print[n-k, If[n==k+1, " point ", " points "]<>"removed."];
n=k;
]]];
];

YRangeRemove[-Infinity,ymax_,opts:OptionsPattern[]]:=
	YRangeRemove[Min[yy,{ymax}],ymax,opts]
YRangeRemove[ymin_,Infinity,opts:OptionsPattern[]]:=
	YRangeRemove[ymin,Max[yy,{ymin}],opts]
YRangeRemove[{ymin_,ymax_},opts:OptionsPattern[]]:=
	YRangeRemove[ymin,ymax,opts]



(***********************************************************)
(* YRangeKeep[] *) 

Options[YRangeKeep] = {DisplayResults:>$DisplayResults};

YRangeKeep[ymin_?NumericQ,ymax_?NumericQ,OptionsPattern[]]:=
Block[{temp,data,k,count,display}, 

display=OptionValue[DisplayResults];
If[display,,,
	Message[DisplayResults::unknown,display,True]; 
	display=True;
];

If[!CheckLength[], Abort[],
If[ymin > ymax, Message[YRange::yminymax];Abort[];,

k=0;
count=n;
Do[If[yy[[i]] < ymin || yy[[i]] > ymax,--count],{i,n}];
If[count < 3, Message[YRange::count];Abort[];,

SaveForUndo[];
data=Transpose[{xx,yy,sy,sx}];
temp=Table[0.,{count}];
Do[If[yy[[i]] < ymin || yy[[i]] > ymax,"",
temp[[++k]]=data[[i]];];,{i,n}];
temp=Transpose[temp];
xx=temp[[1]];
yy=temp[[2]];
sy=temp[[3]];
sx=temp[[4]];

If[display
	,
	(* display data *)
	Print[TableForm[Join[
		{{"point","x","y","\!\(\[Sigma]\_y\)","\!\(\[Sigma]\_x\)"}},
        Transpose[{Range[n],xx,yy,sy,sx}]]]];
];

Print["n= ",k];
Print[n-k, If[n==k+1, " point ", " points "]<>"removed."];
n=k;
]]];
];

YRangeKeep[-Infinity,ymax_,opts:OptionsPattern[]]:=
	YRangeKeep[Min[yy,{ymax}],ymax,opts]
YRangeKeep[ymin_,Infinity,opts:OptionsPattern[]]:=
	YRangeKeep[ymin,Max[yy,{ymin}],opts]
YRangeKeep[{ymin_,ymax_},opts:OptionsPattern[]]:=
	YRangeKeep[ymin,ymax,opts]



(***********************************************************)
(* NRangeRemove[] *) 

Options[NRangeRemove] = {DisplayResults:>$DisplayResults};

NRangeRemove[nmin_?IntegerQ,nmax_?IntegerQ,OptionsPattern[]]:=
Block[{temp,data,k,count,display}, 

display=OptionValue[DisplayResults];
If[display,,,
	Message[DisplayResults::unknown,display,True]; 
	display=True;
];

If[!CheckLength[], Abort[],
If[ nmin < 1 || nmin > nmax || nmax > n, 
	Message[NRange::nminnmax];Abort[];,
count=nmax-nmin+1;
If[ n-count < 2, Message[NRange::count];Abort[];,

SaveForUndo[];
xx=Drop[xx,{nmin,nmax}];
yy=Drop[yy,{nmin,nmax}];
sy=Drop[sy,{nmin,nmax}];
sx=Drop[sx,{nmin,nmax}];
k=n-count;

If[display
	,
	(* display data *)
	Print[TableForm[Join[
		{{"point","x","y","\!\(\[Sigma]\_y\)","\!\(\[Sigma]\_x\)"}},
        Transpose[{Range[n],xx,yy,sy,sx}]]]];
];

Print["n= ",k];
Print[n-k, If[n==k+1, " point ", " points "]<>"removed."];
n=k;
]]];
];

NRangeRemove[{nmin_?NumericQ,nmax_?NumericQ},opts:OptionsPattern[]]:=
	NRangeRemove[nmin,nmax,opts]

NRangeRemove[n_?NumericQ,opts:OptionsPattern[]]:=
	NRangeRemove[n,n,opts]



(***********************************************************)
(* NRangeKeep[] *) 

Options[NRangeKeep] = {DisplayResults:>$DisplayResults};

NRangeKeep[nmin_?IntegerQ,nmax_?IntegerQ,OptionsPattern[]]:=
Block[{temp,data,k,count,display}, 

display=OptionValue[DisplayResults];
If[display,,,
	Message[DisplayResults::unknown,display,True]; 
	display=True;
];

If[!CheckLength[], Abort[],
If[ nmin < 1 || nmin > nmax || nmax > n, 
	Message[NRange::nminnmax];Abort[];,
count=nmax-nmin+1;
If[count < 2, Message[NRange::count];Abort[];,

SaveForUndo[];
xx=Take[xx,{nmin,nmax}];
yy=Take[yy,{nmin,nmax}];
sy=Take[sy,{nmin,nmax}];
sx=Take[sx,{nmin,nmax}];
k=count;

If[display
	,
	(* display data *)
	Print[TableForm[Join[
		{{"point","x","y","\!\(\[Sigma]\_y\)","\!\(\[Sigma]\_x\)"}},
        Transpose[{Range[n],xx,yy,sy,sx}]]]];
];

Print["n= ",k];
Print[n-k, If[n==k+1, " point ", " points "]<>"removed."];
n=k;
]]];
];

NRangeKeep[{nmin_?NumericQ,nmax_?NumericQ},opts:OptionsPattern[]]:=
	NRangeKeep[nmin,nmax,opts]



(***********************************************************)
(* SwitchXXandYY *) 

SwitchXXandYY[]:=Block[{zzz},
If[!CheckLength[], Abort[],
SaveForUndo[];
zzz=xx;xx=yy;yy=zzz;
zzz=sx;sx=sy;sy=zzz;
Print["xx and yy have been switched (so have sx and sy)."]
]];



(***********************************************************)
(* SortData *) 

SortData[]:=(
If[!CheckLength[], Abort[]];
SaveForUndo[];
{xx,yy,sx,sy} = ({xx,yy,sx,sy}//Transpose//Sort//Transpose);
Print["Sorted data in order of increasing X values."];
);



(***********************************************************)
(* SwitchSXandSY *) 

SwitchSXandSY[]:=Block[{zzz},
If[!CheckLength[], Abort[],
SaveForUndo[];
zzz=sx;sx=sy;sy=zzz;
Print["sx and sy have been switched (xx and yy are unchanged)."]
]];



(***********************************************************)
(* CalculateYsigmas *)

CalculateYsigmas[]:= Block[{clusters, yValues, ySigmas, yLengths, warn = False},
If[!CheckLength[], Abort[]];

(* this next step also pushes the data for Undo[] *)
SortData[];

(* partition into clusters with the same X values *)
clusters = Split[Transpose[{xx,yy}], First[#1] == First[#2]&];
(* pick out groups of Y values *)
yValues = clusters[[All,All,2]];
(* calculate the uncertainties from the std deviations *)
ySigmas = Map[If[Length[#]>1, StandardDeviation[#], warn = True; 0]&, yValues, {1}];
If[warn, Message[CalculateYsigmas::length]];
(* and get the number of y values in each cluster *)
yLengths = Map[Length, yValues, {1}];
(* make enough copies of each uncertainty to go with all Y's *)
ySigmas = Apply[ConstantArray, Transpose[{ySigmas,yLengths}], {1}];

(* flatten to a single list and assign the uncertainties *)
sy = Flatten[ySigmas];
Print["Calculated and assigned Y uncertainties."];
If[warn, Print["WARNING: At least one Y has uncertainty = 0."]];
];



(***********************************************************)
(* AssignYsigmas *)

AssignYsigmas[v_]:= Block[{f = (v &), m = 0},
If[!CheckLength[], Abort[]];
SaveForUndo[];
sy = MapIndexed[
		(If[#1 > 0,
			#1,
			 ++m; f[ yy[[ First[#2] ]] ],
			 ++m; f[ yy[[ First[#2] ]] ]
		])&,
	sy];
Print[m," \[Sigma]y value"<>If[m > 1,"s",""]<>" replaced."];
];



(***********************************************************)
(* RepairData *)

RepairData[] := Block[{yLength, undo = False, indexed = False},
If[Quiet[CheckLength[]],
	Print["CurveFit data are consistent."]; 
	If[!VectorQ[yy,NumberQ],
		SaveForUndo[];
		yy = N[yy];
		Print["Y data converted to approximate real numbers. "<>
				"If desired, use Undo[ ] to reverse."];
	];
	Return[]
];

SaveForUndo[];
Catch[
	(* check for a single scalar Y value and make into a list *)
	If[NumberQ[Quiet[yy//N//Re]], yy = {yy//N//Re}];

	(* check that Y data is a list with at least 1 element; Flatten it *)
	If[Head[yy]===List && 
		(yy = Flatten[yy]; (yLength = Length[yy]) >= 1), (* so far so good if True *),
		Message[RepairData::noYdata]; undo = True; Throw[undo],
		Message[RepairData::noYdata]; undo = True; Throw[undo]
	];

	(* Flatten X data. Check for too little or too much X data *)
	If[Head[xx]=!=List || (xx = Flatten[xx]; Length[xx] != yLength),
		Message[RepairData::wrongX]; 
		xx = Range[yLength]; 
		sx = ConstantArray[0,yLength]; 
		indexed = True
	];

	(* check for too little or too much Y uncertainty data *)
	If[Head[sy]===List && (sy = Flatten[sy]; Length[sy] != yLength),
		Message[RepairData::wrongSY]; 
		sy = ConstantArray[0,yLength]
	];

	(* check for too little or too much X uncertainty data *)
	If[Head[sx]===List && (sx = Flatten[sx]; Length[sx] != yLength),
		Message[RepairData::wrongSX]; 
		sx = ConstantArray[0,yLength]
	];

	(* check for a single scalar Y uncertainty value *)
	If[sy == 0,
		Message[RepairData::scalarSY]; 
		sy = ConstantArray[0,yLength]
	];
	If[NumberQ[Quiet[sy//N//Re]],
		Message[RepairData::scalarSY]; 
		sy = ConstantArray[sy//N//Re//Abs,yLength] 
	];

	(* check for a single scalar X uncertainty value *)
	If[sx == 0,
		Message[RepairData::scalarSX]; 
		sx = ConstantArray[0,yLength] 
	];
	If[NumberQ[Quiet[sx//N//Re]],
		Message[RepairData::scalarSX]; 
		sx = ConstantArray[sx//N//Re//Abs,yLength] 
	];

	(* any other sort of unacceptable uncertainty is converted to all 0's *)
	If[Head[sx]=!=List, sx = ConstantArray[0,yLength]];
	If[Head[sy]=!=List, sy = ConstantArray[0,yLength]];

	(* convert all values to real numbers *)
	{xx,yy} = Quiet[{xx,yy}//N//Re];
	sx = Map[If[#==0,0,(#//N//Re//Abs),(#//N//Re//Abs)]&,sx];
	sy = Map[If[#==0,0,(#//N//Re//Abs),(#//N//Re//Abs)]&,sy];

	(* update n (length) and indexes and see if the problem is fixed *)
	n = yLength;
	If[indexed, xx = Range[n]];
	If[Quiet[CheckLength[]], undo = False, undo = True, undo = True];

	Throw[undo]
]; (* Catch *)
If[undo,
	Print["Can't repair the CurveFit data set. Undoing any changes."];
	Undo[],
	Print["Successfully repaired the data. ", n, " data points recovered."];
	Print["Use Undo[] to reverse the changes made to the data."]
];
];


(***********************************************************)
(* SelectPrevData *) 

SelectPrevData[]:=
If[Length[UndoStack]>0 && 
	Length[Position[UndoStack,a_/;Quiet[CheckLength[First[a]]]==True]//Flatten]>0,

	DynamicModule[
		{len=Length[UndoStack], j, a, p, mergeQ, ok},
		ok = ChoiceDialog[
		Panel[
		Column[{
			Style["Data set choice:",Larger],
			If[len <15, RadioButtonBar, SetterBar][
				Dynamic[j],
				Position[UndoStack,a_/;Quiet[CheckLength[First[a]]]==True]//Flatten
			],
			"",
			Style["Action:",Larger],
			RadioButtonBar[Dynamic[mergeQ],{False->"Replace data",True->"Merge data"}],
			"",
			(* display Data Set file path *)
			Dynamic[Pane[Style[UndoStack[[j]]//Rest//First,Italic,Bold],500]],
			"",
			(* select a plot type and display the set *)
			Row[{"Plot type:  ",
				PopupMenu[Dynamic[p],
					{CurveFit`LinearDataPlot->"Linear", CurveFit`LogDataPlot->"Log Y",
					CurveFit`LogLogDataPlot->"Log-Log",CurveFit`LogLinearDataPlot->"Log X"}]
			}],
			Dynamic[p[UndoStack[[j]],
				ImageSize->500, Tips->None, PlotMarkers->None, PlotStyle->Darker[Red], 
				Joined->True, PlotLabel->None]],
			(* display the number of data points *)
			Dynamic[(UndoStack[[j]]//First//Last//ToString)<>" data points"],
			(* display the file comments in a pane with scroll bars as necessary *)
			Panel[
				Pane[Dynamic[Quiet[Check[UndoStack[[j]][[3]],"(no comments)"]]],
					{500,120},Scrollbars->Automatic],
				"Data Set Comments:"]
		}], (* Column *)
		ImageSize->{550,Automatic}, Alignment->{Center,Center}
		], (* Panel *)
		WindowTitle->"Select a data set from the Undo stack",
		WindowSize->{565,Scaled[.9]}, WindowFloating->True,
		WindowElements->{"VerticalScrollBar"} 
		]; (* ChoiceDialog *)
		If[ok,
			If[mergeQ,MergeData,RestoreData][UndoStack[[j]]],
			$Canceled
		]
	], (* DynamicModule *)

	(* else there are no entries on the Undo stack *)
	MessageDialog["There are no previous data sets on the Undo stack."]; $Canceled,

	(* or the Undo stack is not contructed correctly *)
	Clear[UndoStack, RedoStack, $UndoStackMaxLength];
	UndoStack = {};
	RedoStack = {};
	$UndoStackMaxLength = 20;
	MessageDialog["The Undo stack was corrupted. It has been reinitialized."]; $Canceled
]; (* If *)



(***********************************************************)
End[]; (* `Private` *)

