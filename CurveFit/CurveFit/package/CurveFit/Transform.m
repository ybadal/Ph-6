(* ::Package:: *)

(* Copyright 1997-2007 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Transform.m - Data transformations with error propagation *)



(***********************************************************)
(* Usage messages *) 

xnew::usage =
 "Used in the DataTransform routine.  xnew[x,y] is the new x.";
ynew::usage =
 "Used in the DataTransform routine.  ynew[x,y] is the new y.";

DataTransform::usage = "DataTransform[options] Transforms the "<>
 "data AND the errors, "<>
 "according to the functions: x -> xnew(x,y) and y -> ynew(x,y). "<>
 "If no change is wanted in one of the variables (e.g. x), "<>
 "then enter: \"xnew[x_,y_]:=x;\"  \n"<>
 "options is an optional sequence of options in the form "<>
 "\"opt->value\"; DisplayResults is an available option. \n"<>
 "See also: DisplayResults \n\n"<>
 "If you wish to change the data or errors in some other way, you "<>
 "can directly modify the arrays xx, yy, sy or sx.  \n\n"<>
 "Note:  This function transforms the errors automatically, based "<>
 "on error propagation.  If you wish to transform only the errors, "<>
 "you must manipulate the arrays sx and sy directly.  Another "<>
 "important note is that when you define the transformation functions "<>
 "xnew[x_,y_] and ynew[x_,y_], you must NOT use the data arrays "<>
 "xx and yy, and should only use the undefined variables x, y." ;



Begin["`Private`"];



(***********************************************************)
(* Error messages *) 

DataTransform::error="Data unchanged.";
DataTransform::D="Transformation function has undefined derivative.  "<>
        "Data unchanged.";



(***********************************************************)
(* default definitions of xnew[] and ynew[] do nothing *)

xnew[x_,y_] := x
ynew[x_,y_] := y



(***********************************************************)
(* DataTransform[] *) 

(* DATA TRANSFORMATION 
 * First define the functions xnew[] and ynew[] so that
 * xnew[x,y] -> x, ynew[x,y] -> y. 
 * It calculates the new sx and sy by itself.
 * If no change in a variable (i.e. x) is wanted, use:  
 * xnew(x,y)=x.     
 * Example:
 * xnew[x_,y_]:=x;
 * ynew[x_,y_]:=2.*Pi/y;
 *)

Options[DataTransform] = {DisplayResults :> $DisplayResults};

DataTransform[OptionsPattern[]]:= 
Block[{x,y,fpxx,fpxy,fpyx,fpyy,
	xxnew,sxnew,yynew,synew,display},

display=OptionValue[DisplayResults];
If[display,,,
	Message[DisplayResults::unknown,display,True]; 
	display=True;
];

If[!CheckLength[], Abort[],

fpxx[x_,y_]=D[xnew[x,y],x];
fpxy[x_,y_]=D[xnew[x,y],y];
fpyx[x_,y_]=D[ynew[x,y],x];
fpyy[x_,y_]=D[ynew[x,y],y];

xxnew=xx*0+1.*xnew[xx,yy];
sxnew=Sqrt[(fpxx[xx,yy]*1.*sx)^2+(fpxy[xx,yy]*1.*sy)^2];
yynew=yy*0+1.*ynew[xx,yy];
synew=Sqrt[(fpyx[xx,yy]*1.*sx)^2+(fpyy[xx,yy]*1.*sy)^2];

If[$MessageList != {},Message[DataTransform::error];Abort[];,

If[NumberQ[xxnew[[1]]] != True || 
   NumberQ[sxnew[[1]]] != True ||
   NumberQ[yynew[[1]]] != True ||
   NumberQ[synew[[1]]] != True,
Message[DataTransform::D];Abort[],

SaveForUndo[];
xx=xxnew;
sx=sxnew;
yy=yynew;
sy=synew; 

If[display
	,
	(* display data *)
	Print[TableForm[Join[
		{{"point","x","y","\!\(\[Sigma]\_y\)","\!\(\[Sigma]\_x\)"}},
        Transpose[{Range[n],xx,yy,sy,sx}]]]];
	,
	(* don't display data *)
	Print["All ",n," points transformed."];
	,
	(* display not a boolean value *)
	Message[DisplayResults::unknown]
];
]]];
];



(***********************************************************)
End[]; (* `Private` *)

