(* ::Package:: *)

(* Copyright 1997-2007 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* 1D.m - Analysis of a single variable sample set *)



(***********************************************************)
(* Function usage messages *)

LoadFile1D::usage = "LoadFile["<>
 "\!\(\*
StyleBox[\"filename\",\nFontSlant->\"Italic\"]\)"<>
 ", "<>
 "\!\(\*
StyleBox[\"delimiters\",\nFontSlant->\"Italic\"]\)"<>
 "]"<>
 "Loads the file named by the String "<>
 "\!\(\*
StyleBox[\"filename\",\nFontSlant->\"Italic\"]\)"<>
 " containing the data. The file must consist of one or more "<>
 "columns of numbers. The argument "<>
 "\!\(\*
StyleBox[\"delimiters\",\nFontSlant->\"Italic\"]\)"<>
 "is a list of Srings. Any line beginning with one of these"<>
 "Strings will be ignored. The columns of data in the file"<>
 "will be stored as Lists in variables "<>
 "\!\(\*
StyleBox[\"c1\",\nFontWeight->\"Bold\"]\)"<>
 ", "<>
 "\!\(\*
StyleBox[\"c2\",\nFontWeight->\"Bold\"]\)"<>
 ", "<>
 "\!\(\*
StyleBox[\"c3\",\nFontWeight->\"Bold\"]\)"<>
 ", etc, whereas the CurveFit data will be set to all zeros. "<>
 "The appropriate columns must therefore be copied into the "<>
 "\!\(\*
StyleBox[\"yy\",\nFontWeight->\"Bold\"]\)"<>
 " and "<>
 "\!\(\*
StyleBox[\"sy\",\nFontWeight->\"Bold\"]\)"<>
 " arrays for processing. An input line giving an example will"<>
 "be added to the notebook by LoadFile1D.";
 

ColumnSelect1D::usage="LoadFile "<>
 "loads the columns in the variables c1, c2, c3, c4 etc., and prompts "<>
 "the user for what to put in the arrays yy, and sy.";

TransformData1D::usage="Transforms the data and errors according to the "<>
 "function ynew(y).  If display=\"no\", the transformed data aren't "<>
 "displayed.  If you wish to change the data or errors in some other "<>
 "way, you can directly modify the arrays yy or sy.";

ListData1D::usage="Displays the data in column form.";

AnalyzeData1D::usage="Makes the plots of unweighted and weighted \
averaging."<>
 "\n(The latter only if sy is non-zero)";



Begin["`Private`"]



(***********************************************************)
(* Error messages *)

LoadFile1D::missing="File \"`1`\" does not exist in `2`.";
LoadFile1D::empty="File is empty.";
LoadFile1D::column="File does not have the same number of points in each "<>
	"row. i.e. is not in column form.";



(***********************************************************)
(* LoadFile1D *) 

(* GETTING THE DATA FROM FILE. 
 * Data must be in the form: Y SY Z
 * Meaning of Z: if 1, include point, if 0, ignore it
 * Z must be INTEGER 
 * If you don't have SY, put SY=0
 * Points with Z=0 are removed  
 * Components of the data will be saved in the Lists: yy, sy
 * Put the name of the file inside the quotes in the LoadFile1D command:
 * LoadFile1D["file",display="yes"]
 * If you want to prevent the data from being displayed, set display="no".
 * i.e. LoadFile1D["file",display="no"]  
 * Usage of delim is the same as in LoadFile (ie comment lines)
 *)

LoadFile1D[file_, delim_] := Block[{point,data,pdata,trdata,nn,zz,jj,jj2,
	sortdata,string,filestream,nmin},
Catch[
If[FileNames[file] == \
{},Message[LoadFile1D::missing,file,Directory[]];Abort[],

filestream=OpenRead[file];
string=Read[filestream,Character];

If[string === EndOfFile, Message[LoadFile1D::empty];Abort[],


(* the following Block reads the data file, 
   and stores the commented lines (starting with any of the delim characters)
   to the variable: headers, 
   and the other lines, to the 2x2 real number matrix: data.  
*)

Block[{f = Import[file, "Table"], datastrings, headers, hindex}, 
  hindex = Select[Range[1, Length[f]], MemberQ[delim, f[[#]][[1]]] &];
  headers = f[[hindex]];
  headers = Map[StringJoin[#] &, Map[ToString[#] <> " " &, headers, {2}]];
  data = Delete[f, Transpose[{hindex}]];
  If[headers != {}, Print["Comment lines:"]; 
  	Print[TableForm[headers]];];];
(*end of reading the data*)


If[Length[Dimensions[data]] == 1,
Message[LoadFile1D::column];Abort[],

datafilename=file;

jj=Dimensions[data][[2]];
n=Length[data];
trdata=Transpose[data];
Do[
  ClearAll[Evaluate[StringJoin["c",ToString[i]]]];
  Evaluate[ToExpression[StringJoin["c",ToString[i]]]]=1.*trdata[[i]];
,{i,jj}];

Print["Data file \""<>file<>"\" has ",n," rows and ",jj," columns."];

nmin=Min[n,10];
If[n > nmin, Print["List of the first 10 data points:"]];
point=Table[j,{j,0,nmin}];
point[[1]]="point";
pdata=Transpose[Join[{Table["c"<>ToString[i],{i,jj}]},
 Transpose[Map[Take[#,nmin] &, 
 Table[ToExpression["c"<>ToString[i]],{i,jj}]]]]];
pdata=Transpose[Join[{point},pdata]];
Print[TableForm[pdata]];

NotebookWrite[EvaluationNotebook[],
 Cell["(*You have "<>ToString[jj]<>" columns of length "<>ToString[n]<>
 ", which are stored in the arrays: c1, c2, c3, etc.  yy and sy, "<>
 "are the "<>
 "arrays where you need to store the data points and their errors "<>
 "respectively.  "<>
 "Following is an example which you should edit based on what you need to "<>
 "store in each array.  Note that if for example you want "<>
 "sy to have the same value for all points (say 1.5), you must create an "<>
 "ARRAY with all elements being 1.5 (you can't just say: sy=1.5; ), "<>
 "and so the easiest way to do this is to write: sy=yy*0+1.5;"<>
 "  This basically makes an array of 0's of the same length as yy, "<>
 "and adds 1.5 to all the elements.  The semicolon simply prevents the "<>
 "array to be printed on your screen since you can control that option "<>
 "with display=\"yes\"/\"no\".  If you have no errors, (i.e. unweighted "<>
 "fit, you should set sy=yy*0;).  \nFor this file, you cannot go beyond c"<>
 ToString[jj]<>". *)\n \n yy=c1;\n sy=yy*0+1.5;"<>
 "\n \n ColumnSelect1D[display=\" yes \"]","Input"]];

Throw[Null];
];

If[display != "no ",
point=Table[j,{j,0,n}];
point[[1]]="point ";
pdata=Transpose[Join[{{"y ","\!\(\[Sigma]\_y\)"}},
 Transpose[{yy,sy}]]];
pdata=Transpose[Join[{point},pdata]];
Print[TableForm[pdata]];
,
nmin=Min[n,10];
If[n > nmin, Print["List of the first 10 data points:"]];
point=Table[j,{j,0,nmin}];
point[[1]]="point ";
pdata=Transpose[Join[{{"y ","\!\(\[Sigma]\_y\)"}},
 Transpose[Map[Take[#,nmin] &, {yy,sy}]]]];
pdata=Transpose[Join[{point},pdata]];
Print[TableForm[pdata]];
];


Print["n= ",n];

datafilename=file;

(* The following is to make {0.,0.,0. ... 0.} -> {0,0,0 ... 0}. 
 * 0 (Integer) sx draws no error bar; 0. (Real) sx, draws a thickness 
 * 0 error bar, which is not wanted.  
 *)

If[Max[sx]==0, sx=sx*0];
If[Max[sy]==0, sy=sy*0];
]]]];


(***********************************************************)
(* ColumnSelect1D *) 

ColumnSelect1D[display_ ] := Block[{},

If[!CheckLength1D[], Abort[],
yy=yy*1.;
sy=sy*1.;

SelectionMove[EvaluationNotebook[],Previous,CellGroup];
SelectionMove[EvaluationNotebook[],Before,CellGroup];
SelectionMove[EvaluationNotebook[],Next,Cell];
NotebookDelete[EvaluationNotebook[]];

SelectionMove[EvaluationNotebook[],Previous,Cell];
NotebookDelete[EvaluationNotebook[]];

If[display != "no",

If[n > Min[n,10], 
SelectionMove[EvaluationNotebook[],Previous,Cell];
NotebookDelete[EvaluationNotebook[]];
];

point=Table[j,{j,n}];
NotebookWrite[EvaluationNotebook[],Cell[BoxData[TagBox[GridBox[
 Join[{{"point","y","\!\(\[Sigma]\_y\)"}},Transpose[
 ToExpression[Map[ToString[InputForm[#,NumberMarks->True]] &,
 {point,yy,sy},2]]]], RowSpacings->1, ColumnSpacings->3, 
 RowAlignments->Baseline, ColumnAlignments->{Left}], (TableForm[ #]&)]], 
 "Print"]];
,
nmin=Min[n,10];
(* If[n > nmin, Print["List of the first 10 data points:"]]; *)
point=Table[j,{j,nmin}];
NotebookWrite[EvaluationNotebook[],Cell[BoxData[TagBox[GridBox[
 Join[{{"point","y","\!\(\[Sigma]\_y\)"}},Transpose[
 ToExpression[Map[ToString[InputForm[#,NumberMarks->True]] &,
 Map[Take[#,nmin] &, {point,yy,sy}],2]]]], RowSpacings->1, 
 ColumnSpacings->3, RowAlignments->Baseline, ColumnAlignments->{Left}], 
 (TableForm[ #]&)]], "Print"]];
];

NotebookWrite[EvaluationNotebook[],Cell["n= "<>ToString[n],"Output"]];

]];


(***********************************************************)
(* TransformData1D *) 

(* DATA TRANSFORMATION 
 * ynew[y] -> y. It calculates the new sy by itself.     
 * Example:
 * ynew[y_]:=2.*Pi/y; 
 *)

TransformData1D[display_]:= Block[{fpy,yynew,synew,point},

If[!CheckLength1D[], Abort[],
If[display != "no" && display != "yes",Message[disp::unknown];Abort[],

fpy[y_]=Abs[D[ynew[y],y]];
yynew=yy*0+1.*ynew[yy];
synew=fpy[yy]*1.*sy;

If[$MessageList != {},Message[TransformData::error];Abort[];,

If[NumberQ[yynew[[1]]] != True || 
   NumberQ[synew[[1]]] != True,
Message[TransformData::D];Abort[],

yy=yynew;
sy=synew;
If[display !="no",
point=Table[j,{j,n}];
Print[TableForm[Join[{{"point","y","\!\(\[Sigma]\_y\)"}},
	Transpose[{point,yy,sy}]]]];
,Print["All ",n," points transformed."]];
]]]];
];


(***********************************************************)
(* ListData1D *) 

(* SHOWING THE DATA *)

ListData1D:= Block[{point},

If[!CheckLength1D[], Abort[],

point=Table[j,{j,n}];
Print[TableForm[Join[{{"point","y","\!\(\[Sigma]\_y\)"}},
	Transpose[{point,yy,sy}]]]];
]];


(***********************************************************)
(* AnalyzeData1D *) 

(* ANALYZING & PLOTTING THE DATA *)

AnalyzeData1D := Block[{points,ta,ymin,ymax,xmin,xmax,xplotmin,xplotmax,
	yplotmin,yplotmax,sd,ssy,q1,q2},

If[!CheckLength1D[], Abort[],

yy=1.*yy;
sy=1.*sy;
Print["n= ",n];
Print["Unweighted fit"];
mean=(Plus @@ yy)/n;
q1=(yy-mean)^2;
sd=Sqrt[(Plus @@ q1)/(n-1)];
ssy=Table[sd,{i,n}];

Print["\[Mu]= ",mean,"    \!\(\[Sigma]\_\[Mu]\)= ",sd/Sqrt[n]];
Print["Std. dev.= ",sd];

ta=Table[0.,{n},{2}];
xx=Table[i,{i,n}];
points=Transpose[{xx,yy}];
Do[ta[[i,1]]=points[[i]];
        ta[[i,2]]=ErrorBar[ssy[[i]]];
        ,{i,n}];
xmin=1;
xmax=n;
xplotmin=xmin-(xmax-xmin)*.05;
xplotmax=xmax+(xmax-xmin)*.05;

ymin=Min[yy-ssy];
ymax=Max[yy+ssy];
yplotmin=ymin-(ymax-ymin)*.05;
yplotmax=ymax+(ymax-ymin)*.05;

graph1=Show[
ErrorListPlot[ta,
    Frame->False, Axes->True,
	Ticks->{None,Automatic},
	AxesOrigin -> {xplotmin,mean},
	PlotRange -> {{xplotmin,xplotmax},
	{yplotmin,yplotmax}}],

Plot[{mean-sd/Sqrt[n],mean+sd/Sqrt[n]},{x,xplotmin,xplotmax},
    Frame->False, Axes->True,
	AxesOrigin -> {xplotmin,mean},
	PlotRange -> {{xplotmin,xplotmax},{yplotmin,yplotmax}},
	PlotStyle -> Dashing[{.04,.04}]]
];

If[Max[sy]!=0.,
q1=yy/sy^2;
q2=1./sy^2;
q2=Plus @@ q2;
mean=(Plus @@ q1)/q2;
sigmean=1/Sqrt[q2];
q1=((yy-mean)/sy)^2;

ssy=sy;
Print["Weighted fit"];
Print["\[Mu]= ",mean,"    \!\(\[Sigma]\_\[Mu]\)= ",sigmean];
Print["\!\(\[Chi]\^2\)/(n-1)= ",(Plus @@ q1)/(n-1)];

ta=Table[0.,{n},{2}];
xx=Table[i,{i,n}];
points=Transpose[{xx,yy}];
Do[ta[[i,1]]=points[[i]];
        ta[[i,2]]=ErrorBar[ssy[[i]]];
        ,{i,n}];

xmin=1;
xmax=n;
xplotmin=xmin-(xmax-xmin)*.05;
xplotmax=xmax+(xmax-xmin)*.05;

ymin=Min[yy-ssy];
ymax=Max[yy+ssy];
yplotmin=ymin-(ymax-ymin)*.05;
yplotmax=ymax+(ymax-ymin)*.05;

graph2=Show[
ErrorListPlot[ta,
    Frame->False, Axes->True,
	Ticks->{None,Automatic},
	AxesOrigin -> {xplotmin,mean},
	PlotRange -> {{xplotmin,xplotmax},
	{yplotmin,yplotmax}}],
Plot[{mean-sigmamean,mean+sigmamean},{x,xplotmin,xplotmax},
    Frame->False, Axes->True,
	AxesOrigin -> {xplotmin,mean},
	PlotRange -> {{xplotmin,xplotmax},{yplotmin,yplotmax}},
	PlotStyle -> Dashing[{.04,.04}]]
];

]];
];



(****************************************************************************)

End[]; (* `Private` *)

