(* ::Package:: *)

(* Copyright 1997-2011 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Common.m - Miscellaneous shared definitions *)



(***********************************************************)
(* Common CurveFit Shared Variables, Functions and Option Names*) 

DataFileName::usage = "the file name or path of the last-read or saved data file.";

DataFileHeader::usage = 
"the comment header of the last-read or saved data file.";

ExtractFileName::usage = "ExtractFileName[pathname] extracts the "<>
"file-name portion of the file path name in the String pathname, "<>
"that is, it removes any directory path information from pathname.\n"<>
"ExtractFileName[ ] uses DataFileName as the pathname argument.\n\n"<>
"See also: DataFileName, DirectoryName";

DisplayResults::usage = "An option for several CurveFit functions "<>
"which manipulate the data set. DisplayResults->True will result "<>
"in display of the entire data set after the function completes; "<>
"DisplayResults->False will result in a minimal data value display.\n"<>
"The default behavior is DisplayResults->$DisplayResults.";

$DisplayResults::usage = "The default display behavior for functions "<>
"which manipulate the data set. If False, then a minimal number of "<>
"data values will be displayed; if True, then the entire data set "<>
"will be displayed.\n\n"<>
"See also: DisplayResults";

Sorting::usage = "An option for several CurveFit data manipulation "<>
"functions: \n"<>
"If Sorting -> True, then the function will sort the resulting data by X value; if False "<>
"then the data will be not be sorted. The default for most functions is True.";



Begin["`Private`"];



(***********************************************************)
(* Error messages *)

DisplayResults::unknown =
"DisplayResults must be True or False, not `1`. Using `2`";

Sorting::unknown = "Sorting must be True or False, not `1`. Using `2`";



(***********************************************************)
(* Default variable settings *)

DataFileName = "";
DataFileHeader = "";
$DisplayResults = False;
SetAttributes[DisplayResults,Protected];



(***********************************************************)
(* ExtractFileName[] *) 

ExtractFileName[path_String]:=
	StringDrop[path,StringLength[DirectoryName[path]]]

ExtractFileName[]:= ExtractFileName[DataFileName]
SetAttributes[ExtractFileName,{Protected}];



(***********************************************************)
(* Stack Operations *) 

(* PushStack *) 
PushStack::usage = "PushStack[s] = data pushes the value of "<>
"data onto the stack variable s. If s is not a list, then "<>
"PushStack clears s and then sets s = {data}.";

PushStack/:Set[PushStack[s_Symbol],d_] := Check[
	If[Head[s]===List,
	PrependTo[s,d],
	Clear[s];s={d},
	Clear[s];s={d}
	];
	d
	,$Failed]
SetAttributes[PushStack,{HoldFirst,Protected}];

(* PopStack *) 
PopStack::usage = "PopStack[s] pops and returns the top value "<>
"stored in the stack variable s. If s is not a list or is "<>
"empty, then PopStack[s] attempts to set s={} and returns $Failed.";

PopStack[s_Symbol] := 
	Check[{First[s],s=Rest[s]}[[1]],{s={},$Failed}[[2]] ]
SetAttributes[PopStack,{HoldFirst,Protected}];

(* EmptyStack *) 
EmptyStack::usage = "EmptyStack[s] attempts to set s={}. It "<>
"returns $Failed if unsuccessful";

EmptyStack[s_Symbol]:=Check[s=.;s={},$Failed]
SetAttributes[EmptyStack,{HoldFirst,Protected}];


(* SwapStack *) 
SwapStack::usage = "SwapStack[s,d] swaps the values of d and the "<>
"top element of the stack s, and returns the new value of d. If s "<>
"is not a list or is empty, then SwapStack[s,d] returns $Failed. \n"<>
"MAKE SURE YOU PUT THE STACK AS THE FIRST ARGUMENT TO SwapStack!";

SwapStack[s_Symbol,d_Symbol]:= 
	With[{t=d},
		Check[
			s=Check[d=Check[First[s],d];Prepend[Rest[s],t],s];
			d,
		$Failed]
	]
SetAttributes[SwapStack,{HoldAll,Protected}];



(***********************************************************)
(* PrintNotification and DeleteNotification *)

(* 
PrintNotification prints a cell of text with a special tag. 
The cell is removed with a call to DeleteNotification, usually 
once there has been a successful step in a complicated 
evaluation.  Text is typically of the form: 
"Minimizing function" or "Calculating siga".
*)
PrintNotification[text_] := (
NotebookWrite[EvaluationNotebook[],
	Cell[text,"Print",CellTags->{"notification"}]];
);
SetAttributes[PrintNotification,{Protected}];

(* 
DeleteNotification deletes the last cell if it has tag 
"notification" (as set by PrintNotification). 
*)
DeleteNotification := (
SelectionMove[EvaluationNotebook[],Previous,Cell];
If[Options[NotebookSelection[EvaluationNotebook[]],CellTags] =={},
 SelectionMove[EvaluationNotebook[],After,Cell];,
 NotebookDelete[EvaluationNotebook[]];]
);
SetAttributes[DeleteNotification,{Protected}];



(***********************************************************)
End[]; (* `Private` *)

