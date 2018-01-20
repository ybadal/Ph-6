(* ::Package:: *)

(* Copyright 1997-2007 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFitFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Fit2.m - Fitting routine definitions *)

(*
This file includes exponential and log fits.
*)


(***********************************************************)
(* Fitting function usages *) 

LogLogFit::usage="LogLogFit[ ] \n"<>
"Fits data with: y = \!\(a\\ x\^b\)";
LogLogFit::tip=
"\!\(TraditionalForm\`\(a\\ x\^b\)\)";
fLogLog::usage="fLogLog[a,b] [x] = \!\(a\\ x\^b\)\n"<>
"fLogLog[ ] [x] uses results "<>
"from the latest fit";

LogLogCFit::usage="LogLogCFit[ ] \n"<>
"Fits data with: y = \!\(\(\(a\\ x\^b\)\) + c\)";
LogLogCFit::tip=
"\!\(TraditionalForm\`\(\(\(a\\ x\^b\)\) + c\)\)";
fLogLogC::usage="fLogLogC[a,b,c] [x] = \!\(\(\(a\\ x\^b\)\) + c\)\n"<>
"fLogLogC[ ] [x] "<>
"uses results from the latest fit";

SemilogFit::usage="SemilogFit[ ] \n"<>
"Fits data with: y = \!\(a\\ \[ExponentialE]\^\(b\\ x\)\)";
SemilogFit::tip=
"\!\(TraditionalForm\`\(a\\ \[ExponentialE]\^\(b\\ x\)\)\)";
fSemilog::usage="fSemilog[a,b] [x] = \!\(a\\ \[ExponentialE]\^\(b\\ x\)\)\n"<>
"fSemilog[ ] [x] uses results from the latest fit";

SemilogCFit::usage="SemilogCFit[ ] \n"<>
"Fits data with: y = \!\(\(a\\ \[ExponentialE]\^\(b\\ x\)\) + c\)";
SemilogCFit::tip=
"\!\(TraditionalForm\`\(\(\(a\\ \[ExponentialE]\^\(b\\ x\)\)\) + c\)\)";
fSemilogC::usage="fSemilogC[a,b,c] [x] = "<>
"\!\(\(a\\ \[ExponentialE]\^\(b\\ x\)\) + c\)\n"<>
"fSemilogC[ ] [x] uses results from the latest fit";

DiodeFit::usage="DiodeFit[ ] "<>
"fits data with the diode equation: \n"<>
"y = \!\(a\\ \(\((\(\[ExponentialE]\^\(b\\ x\)\) - 1)\)\)\)\n"<>
"Current -> y, Voltage -> x.";
DiodeFit::tip=
"\!\(TraditionalForm\`\(a\\ \(\((\[ExponentialE]\^\(b\\ x\) - 1)\)\)\)\)";
fDiode::usage="fDiode[a,b] [x] = "<>
"\!\(a\\ \(\((\(\[ExponentialE]\^\(b\\ x\)\) - 1)\)\)\)\n"<>
"fDiode[ ] [x] uses results from the latest fit";

DecayingExponentialLFit::usage="DecayingExponentialLFit[ ] "<>
"fits data with: \n"<>
"y = \!\(\(\(a\\ \[ExponentialE]\^\(b\\ x\)\) + c\) + \(\(d\\ \(\((x - xmin)"<>
"\)\)\)\)\) \n"<>
"Important: b must be negative (i.e. decaying exponential).  \n\n"<>
"Set the value of the variable:  region1 \n"<>
"to the x-location where the linear "<>
"background becomes dominant before calling this function.  "<>
"It must be true that: xmin < region1 < xmax.  \n\n"<>
"DecayingExponentialLFit[r1] sets region1 = r1 and then does the fit.";
DecayingExponentialLFit::tip=
"\!\(TraditionalForm\`\(\(\(a\\ \[ExponentialE]\^\(b\\ x\)\)\) + c + \(\(d\\ "<>
"\(\((x - x\_min)\)\)\)\)\)\)";
fDecayingExponentialL::usage="fDecayingExponentialL[a,b,c,d,xmin] [x] "<>
"= \!\(\(\(a\\ \[ExponentialE]\^\(b\\ x\)\) + c\) + \(\(d\\ \(\((x - xmin)"<>
"\)\)\)\)\) \n"<>
"fDecayingExponentialL[ ] [x] uses "<>
"results from the latest fit";

TwoDecayingExponentialsFit::usage="TwoDecayingExponentialsFit[ ] "<>
"fits data with: \n"<>
"y = \!\(\(\(\(a\\ \[ExponentialE]\^\(b\\ x\)\)\) + "<>
"\(\(c\\ \[ExponentialE]\^\(d\\ x\)\)\)\)\) \n"<>
"Important: b and d must be negative (decaying exponentials).\n\n"<>
"Set the value of the variable:  region1 \n"<>
"to the x-location where the second exponential becomes dominant "<>
"before calling this function.  It must "<>
"be true that: xmin < region1 < xmax. \n\n"<>
"TwoDecayingExponentialsFit[r1] sets region1 = r1 and then "<>
"does the fit.";
TwoDecayingExponentialsFit::tip=
"\!\(TraditionalForm\`\(\(\(a\\ \[ExponentialE]\^\(b\\ x\)\)\) + "<>
"\(\(c\\ \[ExponentialE]\^\(d\\ x\)\)\)\)\)";
fTwoDecayingExponentials::usage="fTwoDecayingExponentials[a,b,c,d] [x] "<>
"= \!\(\(\(\(a\\ \[ExponentialE]\^\(b\\ x\)\)\) + "<>
"\(\(c\\ \[ExponentialE]\^\(d\\ x\)\)\)\)\) \n"<>
"fTwoDecayingExponentials[ ] [x] uses "<>
"results from the latest fit";

TwoDecayingExponentialsCFit::usage=
"TwoDecayingExponentialsCFit[ ] "<>
"fits data with: \n"<>
"y = \!\(\(\(\(a\\ \[ExponentialE]\^\(b\\ x\)\)\) + "<>
"\(\(c\\ \[ExponentialE]\^\(d\\ x\)\)\) + e\)\) \n"<>
"Important: b and d must be negative (decaying exponentials).\n\n"<>
"Set the value of the variable:  region1 \n"<>
"to the x-location where the second exponential becomes dominant.\n\n"<>
"Set the value of the variable:  region2 \n"<>
"to the x-location where the constant background becomes dominant. "<>
"If the background itself is not "<>
"visible in the data set, then give region2 a value close to xmax. "<>
"Keep in mind that in that case, the minimization output for e "<>
"might not be the actual background level. \n\n"<>
"It must be true that: "<>
"xmin < region1 < region2 < xmax. \nOnce setting these values "<>
"you can call this function to perform the fit. \n\n"<>
"TwoDecayingExponentialsCFit[r1, r2] sets region1 = r1 and region2 = "<>
"r2 before performing the fit.";
TwoDecayingExponentialsCFit::tip=
"\!\(TraditionalForm\`\(\(\(a\\ \[ExponentialE]\^\(b\\ x\)\)\) + "<>
"\(\(c\\ \[ExponentialE]\^\(d\\ x\)\)\) + e\)\)";
fTwoDecayingExponentialsC::usage=
"fTwoDecayingExponentialsC[a,b,c,d,e] "<>
"[x] = \!\(\(\(\(a\\ \[ExponentialE]\^\(b\\ x\)\)\) + "<>
"\(\(c\\ \[ExponentialE]\^\(d\\ x\)\)\) + e\)\) \n"<>
"fTwoDecayingExponentialsC[ ] [x] uses results from the latest fit";



Begin["`Private`"];



(***********************************************************)
(* List of the fitting functions *)
 
AppendTo[FitList,
{ "Exponential and Log Fits",
{LogLogFit,LogLogCFit,SemilogFit,SemilogCFit,
DiodeFit,
DecayingExponentialLFit,TwoDecayingExponentialsFit,
TwoDecayingExponentialsCFit},
{"Power Law","Power Law + c","Exponential","Exponential + c",
"Diode equation",
"Exp Decay + Linear","2 Exp Decays",
"2 Exp Decays + c"}
}
];


(***********************************************************)
(* Error messages *)

LogLogFit::negx="Encountered zero or negative values in x.";
LogLogFit::negy="Encountered zero or negative values in y.";

LogLogCFit::negx="Encountered zero or negative values in x.";
LogLogCFit::negy="Encountered zero or negative values in y.";

SemilogFit::neg="Encountered zero or negative values in y.";

DiodeFit::neg="Encountered zero or negative values in y.";

SemilogCFit::neg="Encountered zero or negative values in y.";

DecayingExponentialLFit::neg="Encountered zero or negative "<>
"values in y.";
DecayingExponentialLFit::range="It must be: `1` < region1 < `2`";

TwoDecayingExponentialsCFit::neg="Encountered negative values in y.";
TwoDecayingExponentialsCFit::range="It must be: `1` < region1 "<>
"< region2 < `2`";

TwoDecayingExponentialsFit::neg="Encountered negative values in y.";
TwoDecayingExponentialsFit::range="It must be: `1` < region1 < `2`";



(***********************************************************)
(* f<function>[] definitions *) 

fLogLog[] := Function[{x}, a x^b];
fLogLog[a_,b_] := Function[{x}, a x^b];

fLogLogC[] := Function[{x}, a x^b + c]
fLogLogC[a_,b_,c_] := Function[{x}, a x^b + c]

fSemilog[] := Function[{x}, a Exp[b x]]
fSemilog[a_,b_] := Function[{x}, a Exp[b x]]

fSemilogC[] := Function[{x}, a Exp[b x] + c]
fSemilogC[a_,b_,c_] := Function[{x}, a Exp[b x] + c]

fDiode[] := Function[{x}, a (Exp[b x] - 1 )]
fDiode[a_,b_] := Function[{x}, a (Exp[b x] - 1 )]

fDecayingExponentialL[] := 
Function[{x}, a Exp[b x] + c + d (x - xMinimum)]
fDecayingExponentialL[a_,b_,c_,d_,xmin_] := 
Function[{x}, a Exp[b x] + c + d (x - xmin)]

fTwoDecayingExponentials[] := Function[{x}, a Exp[b x] + c Exp[d x]]
fTwoDecayingExponentials[a_,b_,c_,d_] := 
Function[{x}, a Exp[b x] + c Exp[d x]]

fTwoDecayingExponentialsC[] := Function[{x}, a Exp[b x] + c Exp[d x] + e]
fTwoDecayingExponentialsC[a_,b_,c_,d_,e_] := Function[{x}, a Exp[b x] + 
c Exp[d x] + e]



(***********************************************************
				LOGLOG FIT ON DATA 
 			    	    y = a x^b
 ***********************************************************)

LogLogFit[]:=Block[{x,q,stdv,chi,chicode,chi2},

chi[aa_Real,bb_Real]:=chicode[aa,bb];

(* It seems that the order of minimization should be: bb, aa, cc for most 
 * cases. There were some pathological cases though 
 * (i.e. not really log-log) which performed great under the inverse
 * order for a and b. We therefore made the code to switch if it sees the
 * characteristic message given due to bad ordering. 
 *)

If[!CheckLength[], Abort[]];
If[Min[yy] <= 0, Message[LogLogFit::negy];Abort[]];
If[Min[xx] <= 0, Message[LogLogFit::negx];Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(x) = a \!\(x\^b\)"];
Print["Fit of (x,y)  (unweighted)"];

ClearAll[aa,bb];
yf[x_]:=aa*x^bb;

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

binit=(Log[Abs[yyy[[n]]/yyy[[1]]]])/(Log[Abs[xxx[[n]]/xxx[[1]]]]);
ainit=yyy[[1]]*xxx[[1]]^(-binit);
];
If[ainit==0.,ainit=10.^-15];
If[binit==0.,binit=10.^-15];

chi2=(yy-yf[xx])^2;
chicode=Compile[{aa,bb},Evaluate[Sqrt[Sum[chi2[[i]], {i,n}]]]];

PrintNotification["Minimizing Chi^2"];
$Messages=$Input;
Check[
q=FindMinimum[chi[aa,bb],{bb,binit,binit*1.1},{aa,ainit,ainit*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,2]];
b=1.*bb /. q[[2,1]];
,
$Messages=$Output;
q=FindMinimum[chi[aa,bb],{aa,ainit,ainit*1.1},{bb,binit,binit*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
,
CompiledFunction::cfn];
$Messages=$Output;

stdv=1.*q[[1]]/Sqrt[(n-2)];
a1=a;
b1=b;
chiplus=Sqrt[q[[1]]^2+stdv^2];

fa[x_]:=FindMinimum[chi[x,bb],{bb,b,b*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];
fb[x_]:=FindMinimum[chi[aa,x],{aa,a,a*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];

rsa:=Abs[x-a] /. FindMinimum[(chi[x,b]-chiplus)^2,
	{x,a,a*1.01+10.^-15},MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];
rsb:=Abs[x-b] /. FindMinimum[(chi[a,x]-chiplus)^2,
	{x,b,b*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},
{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"Std. deviation= ",stdv}}}]];


ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{aa,bb}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
$Messages=$Input;
Check[
q=FindMinimum[chi[aa,bb],{bb,b1,b1*1.01},{aa,a1,a1*1.01},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,2]];
b=1.*bb /. q[[2,1]];
,
$Messages=$Output;
q=FindMinimum[chi[aa,bb],{aa,a1,a1*1.01},{bb,b1,b1*1.01},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
,
CompiledFunction::cfn];
$Messages=$Output;

chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Chi]\^2\)/(n-2)= ",1.*q[[1]]^2/(n-2)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(aa*bb*xx^(bb-1)*sx)^2);
chicode=Compile[{aa,bb},Evaluate[Sqrt[Sum[chi2[[i]], {i,n}]]]];

PrintNotification["Minimizing Chi^2"];
$Messages=$Input;
Check[
q=FindMinimum[chi[aa,bb],{bb,b1,b1*1.01},{aa,a1,a1*1.01},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,2]];
b=1.*bb /. q[[2,1]];
,
$Messages=$Output;
q=FindMinimum[chi[aa,bb],{aa,a1,a1*1.01},{bb,b1,b1*1.01},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
,
CompiledFunction::cfn];
$Messages=$Output;

ssy=Sqrt[sy^2+(a*b*xx^(b-1)*sx)^2];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},{{"\!\(\[Sigma]\_a\)= ",siga},
	{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Chi]\^2\)/(n-2)= ",1.*q[[1]]^2/(n-2)}}}]]];

yff[x_] := Evaluate[yf[x] /. {aa -> a, bb -> b}];
fY=fLogLog[];
];



(***********************************************************
			LOGLOG FIT ON DATA (WITH CONSTANT)
 				y = a x^b + c
 ***********************************************************)

LogLogCFit[]:=Block[{x,q,stdv,chi,chicode,chi2},

chi[aa_Real,bb_Real,cc_Real]:=chicode[aa,bb,cc];

If[!CheckLength[], Abort[]];
If[Min[yy] <= 0, Message[LogLogCFit::negy];Abort[]];
If[Min[xx] <= 0, Message[LogLogCFit::negx];Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(x) = a \!\(x\^b\) + c"];
Print["Fit of (x,y)  (unweighted)"];

ClearAll[aa,bb,cc];
yf[x_]:=aa*x^bb+cc;

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

cinit=Min[yyy]*.7;
binit=(Log[Abs[(yyy[[n]]-cinit)/(yyy[[1]]-cinit)]])/
 (Log[Abs[xxx[[n]]/xxx[[1]]]]);
ainit=(yyy[[1]]-cinit)*xxx[[1]]^(-binit);
];
If[ainit==0.,ainit=10.^-15];
If[binit==0.,binit=10.^-15];
If[cinit==0.,cinit=10.^-15];

chi2=(yy-yf[xx])^2;
chicode=Compile[{aa,bb,cc},Evaluate[Sqrt[Sum[chi2[[i]], {i,n}]]]];

PrintNotification["Minimizing Chi^2"];
$Messages=$Input;
Check[
q=FindMinimum[chi[aa,bb,cc],{bb,binit,binit*1.1},{aa,ainit,ainit*1.1},
	{cc,0.,cinit}, MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=aa*1. /. q[[2,2]];
b=bb*1. /. q[[2,1]];
,
$Messages=$Output;
q=FindMinimum[chi[aa,bb,cc],{aa,ainit,ainit*1.1},{bb,binit,binit*1.1},
	{cc,0.,cinit}, MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=aa*1. /. q[[2,1]];
b=bb*1. /. q[[2,2]];
,
CompiledFunction::cfn];
$Messages=$Output;

stdv=1.*q[[1]]/Sqrt[(n-3)];
c=cc*1. /. q[[2,3]];
a1=a;
b1=b;
chiplus=Sqrt[q[[1]]^2+stdv^2];

fa[x_]:=FindMinimum[chi[x,bb,cc],{bb,b,b*1.01+10.^-15},{cc,c,c*1.1+10.^-15},
	MaxIterations -> 200][[1]];
fb[x_]:=FindMinimum[chi[aa,x,cc],{aa,a,a*1.01+10.^-15},{cc,c,c*1.1+10.^-15},
	MaxIterations -> 200][[1]];
fc[x_]:=FindMinimum[chi[aa,bb,x],{aa,a,a*1.01+10.^-15},{bb,b,b*1.1+10.^-15},
	MaxIterations -> 200][[1]];

rsa:=Abs[x-a] /. FindMinimum[(chi[x,b,c]-chiplus)^2,
	{x,a,a*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsb:=Abs[x-b] /. FindMinimum[(chi[a,x,c]-chiplus)^2,
	{x,b,b*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[a,b,x]-chiplus)^2,
	{x,c,c*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b},{"c= ",c}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_c\)= ",sigc},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{aa,bb,cc},Evaluate[Sqrt[Sum[chi2[[i]], {i,n}]]]];

PrintNotification["Minimizing Chi^2"];
$Messages=$Input;
Check[
q=FindMinimum[chi[aa,bb,cc],{bb,b1,b1*1.01},{aa,a1,a1*1.01},
	{cc,0.,cinit}, MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=aa*1. /. q[[2,2]];
b=bb*1. /. q[[2,1]];
,
$Messages=$Output;
q=FindMinimum[chi[aa,bb,cc],{aa,a1,a1*1.01},{bb,b1,b1*1.01},
	{cc,0.,cinit}, MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=aa*1. /. q[[2,1]];
b=bb*1. /. q[[2,2]];
,
CompiledFunction::cfn];
$Messages=$Output;

c=cc*1. /. q[[2,3]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b},{"c= ",c}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_c\)= ",sigc},
	{"\!\(\[Chi]\^2\)/(n-3)= ",1.*q[[1]]^2/(n-3)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(aa*bb*xx^(bb-1)*sx)^2);
chicode=Compile[{aa,bb,cc},Evaluate[Sqrt[Sum[chi2[[i]], {i,n}]]]];

PrintNotification["Minimizing Chi^2"];
$Messages=$Input;
Check[
q=FindMinimum[chi[aa,bb,cc],{bb,b1,b1*1.01},{aa,a1,a1*1.01},
	{cc,0.,cinit}, MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=aa*1. /. q[[2,2]];
b=bb*1. /. q[[2,1]];
,
$Messages=$Output;
q=FindMinimum[chi[aa,bb,cc],{aa,a1,a1*1.01},{bb,b1,b1*1.01},
	{cc,0.,cinit}, MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=aa*1. /. q[[2,1]];
b=bb*1. /. q[[2,2]];
,
CompiledFunction::cfn];
$Messages=$Output;

c=cc*1. /. q[[2,3]];
ssy=Sqrt[sy^2+(a*b*xx^(b-1)*sx)^2];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b},{"c= ",c}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_c\)= ",sigc},
	{"\!\(\[Chi]\^2\)/(n-3)= ",1.*q[[1]]^2/(n-3)}}}]]];

yff[x_] := Evaluate[yf[x] /. {aa -> a, bb -> b, cc -> c}];
fY=fLogLogC[];
];



(***********************************************************
			SEMILOG FIT ON DATA
 			  y = a Exp[b x]
 ***********************************************************)

SemilogFit[]:=Block[{x,q,stdv,chi,chicode,chi2},

(* In the Semilog cases: most sensitive in order: aa, bb, cc *)

chi[aa_Real,bb_Real]:=chicode[aa,bb];

If[!CheckLength[], Abort[]];
(* If[Min[yy] <= 0, Message[SemilogFit::neg];Abort[]]; *)
ClearFit;

Print["n = ",n];
Print[funct="y(x) = a Exp[b x]"];
Print["Fit of (x,y)  (unweighted)"];

ClearAll[aa,bb];
yf[x_]:=aa*Exp[bb*x];

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Select[Sort[Transpose[{xx,yy}]], #[[2]] > 0&]];
xxx=data[[1]];
yyy=data[[2]];

binit=(Log[Abs[Last[yyy]/First[yyy]]])/(Last[xxx]-First[xxx]);
ainit=First[yyy]*Exp[-binit*First[xxx]];
];
If[ainit==0.,ainit=10.^-15];
If[binit==0.,binit=10.^-15];

chi2=(yy-yf[xx])^2;
chicode=Compile[{aa,bb},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb],{aa,ainit,ainit*1.1},{bb,binit,binit*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-2)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
a1=a;
b1=b;
chiplus=Sqrt[q[[1]]^2+stdv^2];

fa[x_]:=FindMinimum[chi[x,bb],{bb,b,b*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];
fb[x_]:=FindMinimum[chi[aa,x],{aa,a,a*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];

rsa:=Abs[x-a] /. FindMinimum[(chi[x,b]-chiplus)^2,
	{x,a,a*1.01+10.^-15},MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];
rsb:=Abs[x-b] /. FindMinimum[(chi[a,x]-chiplus)^2,
	{x,b,b*1.01+10.^-15},MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},{{"\!\(\[Sigma]\_a\)= ",siga},
{"\!\(\[Sigma]\_b\)= ",sigb},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{aa,bb},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb],{aa,a1,a1*1.01},{bb,b1,b1*1.01},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Chi]\^2\)/(n-2)= ",1.*q[[1]]^2/(n-2)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(aa*bb*Exp[bb*xx]*sx)^2);
chicode=Compile[{aa,bb},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb],{aa,a1,a1*1.01},{bb,b1,b1*1.01},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
ssy=Sqrt[sy^2+(a*b*Exp[b*xx]*sx)^2];
chiplus=Sqrt[q[[1]]^2+1];

fa[x_]:=FindMinimum[chi[x,bb],{bb,b,b*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];
fb[x_]:=FindMinimum[chi[aa,x],{aa,a,a*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},{{"\!\(\[Sigma]\_a\)= ",siga},
	{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Chi]\^2\)/(n-2)= ",1.*q[[1]]^2/(n-2)}}}]]];

yff[x_] := Evaluate[yf[x] /. {aa -> a, bb -> b}];
fY=fSemilog[];
];



(***********************************************************
			SEMILOG FIT ON DATA (WITH CONSTANT)
 				y = a Exp[b x] + c
 ***********************************************************)

SemilogCFit[]:=Block[{x,q,stdv,chi,chicode,chi2}, 

chi[aa_Real,bb_Real,cc_Real]:=chicode[aa,bb,cc];

If[!CheckLength[], Abort[]];
(* If[Min[yy] <= 0, Message[SemilogFit::neg];Abort[]]; *)
ClearFit;

Print["n = ",n];
Print[funct="y(x) = a Exp[b x] + c"];
Print["Fit of (x,y)  (unweighted)"];

ClearAll[aa,bb,cc];
yf[x_]:=aa*Exp[bb*x]+cc;

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Select[Sort[Transpose[{xx,yy}]],#[[2]]>0&]];
xxx=data[[1]];
yyy=data[[2]];

cinit=Min[yyy]*.7;
binit=(Log[Abs[(Last[yyy]-cinit)/(First[yyy]-cinit)]])/(Last[xxx]-First[xxx]);
ainit=(First[yyy]-cinit)*Exp[-binit*First[xxx]];
];
If[ainit==0.,ainit=10.^-15];
If[binit==0.,binit=10.^-15];
If[cinit==0.,cinit=10.^-15];

chi2=(yy-yf[xx])^2;
chicode=Compile[{aa,bb,cc},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
$Messages=$Input;
Check[
q=FindMinimum[chi[aa,bb,cc],{aa,ainit,ainit*1.1},{bb,binit,binit*1.1},
	{cc,0.,cinit}, MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
,
$Messages=$Output;
q=FindMinimum[chi[aa,bb,cc],{bb,binit,binit*1.1},{aa,ainit,ainit*1.1},
	{cc,0.,cinit}, MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,2]];
b=1.*bb /. q[[2,1]];
,
CompiledFunction::cfn];
$Messages=$Output;

c=1.*cc /. q[[2,3]];
stdv=1.*q[[1]]/Sqrt[(n-3)];
a1=a;
b1=b;
chiplus=Sqrt[q[[1]]^2+stdv^2];

fa[x_]:=FindMinimum[chi[x,bb,cc],{bb,b,b*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
	MaxIterations -> 100][[1]];
fb[x_]:=FindMinimum[chi[aa,x,cc],{aa,a,a*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
	MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[aa,bb,x],{aa,a,a*1.01+10.^-15},{bb,b,b*1.1+10.^-15}, 
	MaxIterations -> 100][[1]];

rsa:=Abs[x-a] /. FindMinimum[(chi[x,b,c]-chiplus)^2,
	{x,a,a*1.01+10.^-15},MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];
rsb:=Abs[x-b] /. FindMinimum[(chi[a,x,c]-chiplus)^2,
	{x,b,b*1.01+10.^-15},MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[a,b,x]-chiplus)^2,
	{x,c,c*1.01+10.^-15},MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b},{"c= ",c}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_c\)= ",sigc},{"Std. deviation= ",stdv}}}]];


ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{aa,bb,cc},Evaluate[Sqrt[Sum[chi2[[i]], {i,n}]]]];

PrintNotification["Minimizing Chi^2"];
$Messages=$Input;
Check[
q=FindMinimum[chi[aa,bb,cc],{aa,a1,a1*1.01},{bb,b1,b1*1.01},{cc,0.,cinit},
	MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
,
$Messages=$Output;
q=FindMinimum[chi[aa,bb,cc],{bb,b1,b1*1.01},{aa,a1,a1*1.01},{cc,0.,cinit},
	MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,2]];
b=1.*bb /. q[[2,1]];
,
CompiledFunction::cfn];
$Messages=$Output;

c=1.*cc /. q[[2,3]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b},{"c= ",c}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_c\)= ",sigc},
	{"\!\(\[Chi]\^2\)/(n-3)= ",1.*q[[1]]^2/(n-3)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(aa*bb*Exp[bb*xx]*sx)^2);
chicode=Compile[{aa,bb,cc},Evaluate[Sqrt[Sum[chi2[[i]], {i,n}]]]];

PrintNotification["Minimizing Chi^2"];
$Messages=$Input;
Check[
q=FindMinimum[chi[aa,bb,cc],{aa,a1,a1*1.01},{bb,b1,b1*1.01},{cc,0.,cinit},
	MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
,
$Messages=$Output;
q=FindMinimum[chi[aa,bb,cc],{bb,b1,b1*1.01},{aa,a1,a1*1.01},{cc,0.,cinit},
	MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,2]];
b=1.*bb /. q[[2,1]];
,
CompiledFunction::cfn];
$Messages=$Output;

c=1.*cc /. q[[2,3]];
ssy=Sqrt[sy^2+(a*b*Exp[b*xx]*sx)^2];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b},{"c= ",c}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_c\)= ",sigc},
	{"\!\(\[Chi]\^2\)/(n-3)= ",1.*q[[1]]^2/(n-3)}}}]]];

yff[x_] := Evaluate[yf[x] /. {aa -> a, bb -> b, cc -> c}];
fY=fSemilogC[];
];



(***********************************************************
   FIT OF DIODE DATA WITH THE -1 TERM BEING SIGNIFICANT 
                   (e.g. Germanium diode)
 	      y = a ( Exp[b x] - 1 )    (y:I, x:V)
 ***********************************************************)

DiodeFit[]:=Block[{x,q,stdv,chi,chicode,chi2},

chi[aa_Real,bb_Real]:=chicode[aa,bb];

If[!CheckLength[], Abort[]];
If[Min[yy] <= 0, Message[DiodeFit::neg];Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(x) = a ( Exp[b x] - 1 )"];
Print["Fit of (x,y)  (unweighted)"];

ClearAll[aa,bb];
yf[x_]:=aa*(Exp[bb*x]-1.);

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

binit=(Log[Abs[yyy[[n]]/yyy[[Round[n/3]]]]])/(xxx[[n]]-xxx[[Round[n/3]]]);
ainit=yyy[[n]]*Exp[-binit*xxx[[n]]];
];
If[ainit==0.,ainit=10.^-15];
If[binit==0.,binit=10.^-15];

chi2=(yy-yf[xx])^2;
chicode=Compile[{aa,bb},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb],{aa,ainit,ainit*1.1+10.^-15},
        {bb,binit,binit*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-2)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
a1=a;
b1=b;
chiplus=Sqrt[q[[1]]^2+stdv^2];

fa[x_]:=FindMinimum[chi[x,bb],{bb,b,b*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];
fb[x_]:=FindMinimum[chi[aa,x],{aa,a,a*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];

rsa:=Abs[x-a] /. FindMinimum[(chi[x,b]-chiplus)^2,
	{x,a,a*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsb:=Abs[x-b] /. FindMinimum[(chi[a,x]-chiplus)^2,
	{x,b,b*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},{{"\!\(\[Sigma]\_a\)= ",siga},
{"\!\(\[Sigma]\_b\)= ",sigb},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{aa,bb},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb],{aa,a1,a1*1.01},{bb,b1,b1*1.01},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Chi]\^2\)/(n-2)= ",1.*q[[1]]^2/(n-2)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(aa*bb*Exp[bb*xx]*sx)^2);
chicode=Compile[{aa,bb},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb],{aa,a1,a1*1.01},{bb,b1,b1*1.01},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
ssy=Sqrt[sy^2+(a*b*Exp[b*xx]*sx)^2];
chiplus=Sqrt[q[[1]]^2+1];

fa[x_]:=FindMinimum[chi[x,bb],{bb,b,b*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];
fb[x_]:=FindMinimum[chi[aa,x],{aa,a,a*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},{{"\!\(\[Sigma]\_a\)= ",siga},
	{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Chi]\^2\)/(n-2)= ",1.*q[[1]]^2/(n-2)}}}]]];

yff[x_]:= If[Length[x]==0,
 If[x<=0., 10.^-15, Evaluate[yf[x] /. {aa -> a, bb -> b}]],
 Table[If[x[[i]]<=0., 10.^-15, Evaluate[yf[x[[i]]] /. {aa -> a, bb -> b}]],
  {i,Length[x]}]];
fY=fDiode[];

];



(***********************************************************
        DECAYING EXPONENTIAL WITH LINEAR BACKGROUND
 ***********************************************************)

DecayingExponentialLFit[]:=Block[{x,q,stdv,xmin,n1,chi,chicode,chi2}, 

chi[aa_Real,bb_Real,cc_Real,dd_Real]:=chicode[aa,bb,cc,dd];

If[!CheckLength[], Abort[]];
If[Min[yy] <= 0, Message[DecayingExponentialLFit::neg];Abort[]];
If[(Min[xx] < region1 < Max[xx]) == False,
	Message[DecayingExponentialLFit::range,ToString[Min[xx]],ToString[Max[xx]]];
	Abort[]
];
ClearFit;

Print["n = ",n];
Print[funct="y(x) = a Exp[b x] + c + d (x - \!\(x\_min\))"];
Print["Fit of (x,y)  (unweighted)"];

ClearAll[aa,bb,cc,dd];
xmin=Min[xx];
yf[x_]:=aa*Exp[bb*x]+cc + dd*(x-xmin);

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

(* Finding the xxx array location of region1 *)
Block[{q1,q2},
q2=(xxx[[1]]-region1)^2;
Do[If[(q1=(xxx[[i]]-region1)^2) <q2,q2=q1;,n1=i-1;Break[];],
	{i,2,n}]];
							
dinit=(yyy[[n]]-yyy[[n1]])/(xxx[[n]]-xxx[[n1]]);
cinit=yyy[[n]]-dinit*(xxx[[n]]-xmin);
binit=Log[Abs[(yyy[[n1]]-.9*(cinit+dinit*(xxx[[n1]]-xmin)))/
	(yyy[[1]]-.9*(cinit+dinit*(xxx[[1]]-xmin)))]]/(xxx[[n1]]-xxx[[1]]);
ainit=(yyy[[1]]-.9*(cinit+dinit*(xxx[[1]]-xmin)))*Exp[-binit*xxx[[1]]];
];
If[ainit==0.,ainit=10.^-15];
If[binit==0.,binit=10.^-15];
If[cinit==0.,cinit=10.^-15];
If[dinit==0.,dinit=10.^-15];


chi2=(yy-yf[xx])^2;
chicode=Compile[{aa,bb,cc,dd},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
$Messages=$Input;
Check[
q=FindMinimum[chi[aa,bb,cc,dd],{aa,ainit,ainit*1.1},{bb,binit,binit*1.1},
	{cc,cinit,cinit*1.1}, {dd,dinit,dinit*1.1}, MaxIterations -> 500 (*,
        WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
,
$Messages=$Output;
q=FindMinimum[chi[aa,bb,cc,dd],{bb,binit,binit*1.1},{aa,ainit,ainit*1.1},
	{cc,cinit,cinit*1.1}, {dd,dinit,dinit*1.1}, MaxIterations -> 500 (*,
        WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,2]];
b=1.*bb /. q[[2,1]];
,
CompiledFunction::cfn];
$Messages=$Output;

c=1.*cc /. q[[2,3]];
d=1.*dd /. q[[2,4]];
stdv=1.*q[[1]]/Sqrt[(n-4)];
a1=a;
b1=b;
c1=c;
d1=d;
chiplus=Sqrt[q[[1]]^2+stdv^2];

fa[x_]:=FindMinimum[chi[x,bb,cc,dd],{bb,b,b*1.01+10.^-15},
        {cc,c,c*1.1+10.^-15}, {dd,d,d*1.1+10.^-15},MaxIterations -> \
100][[1]];
fb[x_]:=FindMinimum[chi[aa,x,cc,dd],{aa,a,a*1.01+10.^-15},
        {cc,c,c*1.1+10.^-15},{dd,d,d*1.1+10.^-15},MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[aa,bb,x,dd],{aa,a,a*1.01+10.^-15},
        {bb,b,b*1.1+10.^-15},{dd,d,d*1.1+10.^-15},MaxIterations -> 100][[1]];
fd[x_]:=FindMinimum[chi[aa,bb,cc,x],{aa,a,a*1.01+10.^-15},
        {bb,b,b*1.1+10.^-15},{cc,c,c*1.1+10.^-15},MaxIterations -> 100][[1]];

rsa:=Abs[x-a] /. FindMinimum[(chi[x,b,c,d]-chiplus)^2,
	{x,a,a*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsb:=Abs[x-b] /. FindMinimum[(chi[a,x,c,d]-chiplus)^2,
	{x,b,b*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[a,b,x,d]-chiplus)^2,
	{x,c,c*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsd:=Abs[x-d] /. FindMinimum[(chi[a,b,c,x]-chiplus)^2,
	{x,d,d*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;

Print[results=TableForm[
   {{{"a= ",a},{"b= ",b},{"c= ",c},{"d= ",d},{"\!\(x\_min\)= ",xmin}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_c\)= ",sigc},{"\!\(\[Sigma]\_d\)= ",sigd}},
	{{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{aa,bb,cc,dd},Evaluate[Sqrt[Sum[chi2[[i]], {i,n}]]]];

PrintNotification["Minimizing Chi^2"];
$Messages=$Input;
Check[
q=FindMinimum[chi[aa,bb,cc,dd],{aa,a1,a1*1.01},{bb,b1,b1*1.01},
	{cc,c1,c1*1.1},{dd,d1,d1*1.1}, MaxIterations -> 500
(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
,
$Messages=$Output;
q=FindMinimum[chi[aa,bb,cc,dd],{bb,b1,b1*1.01},{aa,a1,a1*1.01},
	{cc,c1,c1*1.1},{dd,d1,d1*1.1}, MaxIterations -> 500
(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,2]];
b=1.*bb /. q[[2,1]];
,
CompiledFunction::cfn];
$Messages=$Output;

c=1.*cc /. q[[2,3]];
d=1.*dd /. q[[2,4]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;

Print[results=TableForm[
   {{{"a= ",a},{"b= ",b},{"c= ",c},{"d= ",d},{"\!\(x\_min\) ",xmin}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_c\)= ",sigc},{"\!\(\[Sigma]\_d\)= ",sigd}},
	{{"\!\(\[Chi]\^2\)/(n-4)= ",1.*q[[1]]^2/(n-4)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) "];

chi2=(yy-yf[xx])^2/(sy^2+((aa*bb*Exp[bb*xx]+dd*xx)*sx)^2);
chicode=Compile[{aa,bb,cc,dd},Evaluate[Sqrt[Sum[chi2[[i]], {i,n}]]]];

PrintNotification["Minimizing Chi^2"];
$Messages=$Input;
Check[

q=FindMinimum[chi[aa,bb,cc,dd],{aa,a1,a1*1.01},{bb,b1,b1*1.01},{cc,c1,c1*1.1},\

	{dd,d1,d1*1.1}, MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
,
$Messages=$Output;

q=FindMinimum[chi[aa,bb,cc,dd],{bb,b1,b1*1.01},{aa,a1,a1*1.01},{cc,c1,c1*1.1},\

	{dd,d1,d1*1.1}, MaxIterations -> 500(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,2]];
b=1.*bb /. q[[2,1]];
,
CompiledFunction::cfn];
$Messages=$Output;

c=1.*cc /. q[[2,3]];
d=1.*dd /. q[[2,4]];
ssy=Sqrt[sy^2+((a*b*Exp[b*xx]+d*xx)*sx)^2];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;

Print[results=TableForm[
   {{{"a= ",a},{"b= ",b},{"c= ",c},{"d= ",d},{"\!\(x\_min\) ",xmin}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_c\)= ",sigc},{"\!\(\[Sigma]\_d\)= ",sigd}},
	{{"\!\(\[Chi]\^2\)/(n-4)= ",1.*q[[1]]^2/(n-4)}}}]];

];

yff[x_] := Evaluate[yf[x] /. {aa -> a, bb -> b, cc -> c, dd -> d}];
xMinimum=xmin;
fY=fDecayingExponentialL[];
];

DecayingExponentialLFit[r1_?NumericQ]:= (
region1 = N[r1];
DecayingExponentialLFit[]
)



(***********************************************************
			 TWO DECAYING EXPONENTIALS
			y = a Exp[b x] + c Exp[d x]
 ***********************************************************)

TwoDecayingExponentialsFit[]:=Block[{x,q,stdv,chi,chicode,chi2,n1,n2,xxmin,xxmax},\


chi[aa_Real,bb_Real,cc_Real,dd_Real]:=chicode[aa,bb,cc,dd];

If[!CheckLength[], Abort[]];
If[Min[yy] <= 0, Message[TwoDecayingExponentialsFit::neg];Abort[]];
xxmin=Min[xx];
xxmax=Max[xx];
If[(xxmin < region1 < xxmax) == False,
	Message[TwoDecayingExponentialsFit::range,ToString[xxmin],ToString[xxmax]];
	Abort[]
];
ClearFit;

Print["n = ",n];
Print[funct="y(x) = a Exp[b x] + c Exp[d x]"];

Print["Fit of (x,y)  (unweighted)"];

ClearAll[aa,bb,cc,dd];
yf[x_]:=aa*Exp[bb*x]+cc*Exp[dd*x];

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

(* Finding the xxx array location of the two regions *)
Block[{q1,q2},
q2=(xxx[[1]]-region1)^2;
Do[If[(q1=(xxx[[i]]-region1)^2) <q2,q2=q1;,n1=i-1;Break[];],
	{i,2,n}];
];

dinit=Log[Abs[yyy[[n]]/yyy[[n1]]]]/(xxx[[n]]-xxx[[n1]]);
cinit=yyy[[n1]]*Exp[-dinit*xxx[[n1]]];
binit=Log[Abs[(yyy[[n1]]-.9*cinit*Exp[dinit*xxx[[n1]]])/
 (yyy[[1]]-.9*cinit*Exp[dinit*xxx[[1]]])]]/(xxx[[n1]]-xxx[[1]]);
ainit=(yyy[[1]]-.9*cinit*Exp[dinit*xxx[[1]]])*Exp[-binit*xxx[[1]]];
];
If[ainit==0.,ainit=10.^-15];
If[binit==0.,binit=10.^-15];
If[cinit==0.,cinit=10.^-15];
If[dinit==0.,dinit=10.^-15];

chi2=(yy-yf[xx])^2;
chicode=Compile[{aa,bb,cc,dd},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb,cc,dd],{aa,ainit,ainit*1.1},{bb,binit,binit*1.1},
	{cc,cinit,cinit*1.1},{dd,dinit,dinit*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];

stdv=1.*q[[1]]/Sqrt[(n-4)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
c=1.*cc /. q[[2,3]];
d=1.*dd /. q[[2,4]];
a1=a;
b1=b;
c1=c;
d1=d;
chiplus=Sqrt[q[[1]]^2+stdv^2];
fa[x_]:=FindMinimum[chi[x,bb,cc,dd],{bb,b,b*1.01+10.^-15},
        {cc,c,c*1.01+10.^-15},{dd,d,d*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];
fb[x_]:=FindMinimum[chi[aa,x,cc,dd],{aa,a,a*1.01+10.^-15},
        {cc,c,c*1.01+10.^-15},{dd,d,d*1.01+10.^-15},
        MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[aa,bb,x,dd],{aa,a,a*1.01+10.^-15},
        {bb,b,b*1.01+10.^-15},{dd,d,d*1.01+10.^-15},
        MaxIterations -> 100][[1]];
fd[x_]:=FindMinimum[chi[aa,bb,cc,x],{aa,a,a*1.01+10.^-15},
        {bb,b,b*1.01+10.^-15},{cc,c,c*1.01+10.^-15},
        MaxIterations -> 100][[1]];

rsa:=Abs[x-a] /. FindMinimum[(chi[x,b,c,d]-chiplus)^2,
	{x,a,a*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsb:=Abs[x-b] /. FindMinimum[(chi[a,x,c,d]-chiplus)^2,
	{x,b,b*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[a,b,x,d]-chiplus)^2,
	{x,c,c*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsd:=Abs[x-d] /. FindMinimum[(chi[a,b,c,x]-chiplus)^2,
	{x,d,d*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"c= ",c}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_c\)= ",sigc}},
	{{"b= ",b},{"d= ",d}},{{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_d\)= ",sigd},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{aa,bb,cc,dd},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb,cc,dd],{aa,a1,a1*1.1},{bb,b1,b1*1.1},
	{cc,c1,c1*1.1},{dd,d1,d1*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
c=1.*cc /. q[[2,3]];
d=1.*dd /. q[[2,4]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"c= ",c}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_c\)= ",sigc}},
	{{"b= ",b},{"d= ",d}},{{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_d\)= ",sigd},
	{"\!\(\[Chi]\^2\)/(n-4)= ",1.*q[[1]]^2/(n-4)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(aa*bb*Exp[bb*xx]+cc*dd*Exp[dd*xx])^2*sx^2);
chicode=Compile[{aa,bb,cc,dd},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb,cc,dd],{aa,a1,a1*1.1},{bb,b1,b1*1.1},
	{cc,c1,c1*1.1},{dd,d1,d1*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
c=1.*cc /. q[[2,3]];
d=1.*dd /. q[[2,4]];
ssy=Sqrt[sy^2+((a*b*Exp[b*xx]+c*d*Exp[d*xx])*sx)^2];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"c= ",c}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_c\)= ",sigc}},
	{{"b= ",b},{"d= ",d}},{{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_d\)= ",sigd},
	{"\!\(\[Chi]\^2\)/(n-4)= ",1.*q[[1]]^2/(n-4)}}}]];

];

yff[x_] := Evaluate[yf[x] /. {aa -> a, bb -> b, cc -> c, dd -> d}];
fY=fTwoDecayingExponentials[];
];

TwoDecayingExponentialsFit[r1_?NumericQ]:= (
region1 = N[r1];
TwoDecayingExponentialsFit[]
)



(***********************************************************
		   TWO DECAYING EXPONENTIALS (WITH CONSTANT)
			y = a Exp[b x] + c Exp[d x] + e
 ***********************************************************)

TwoDecayingExponentialsCFit[]:=
Block[{x,q,stdv,chi,chicode,chi2,n1,n2,xxmin,xxmax},

chi[aa_Real,bb_Real,cc_Real,dd_Real,ee_Real]:=chicode[aa,bb,cc,dd,ee];

If[!CheckLength[], Abort[]];
If[Min[yy] <= 0, Message[TwoDecayingExponentialsCFit::neg];Abort[]];
xxmin=Min[xx];
xxmax=Max[xx];
If[(xxmin < region1 < region2 < xxmax) == False,
	Message[TwoDecayingExponentialsCFit::range,ToString[xxmin],ToString[xxmax]];
	Abort[]
];
ClearFit;


Print["n = ",n];
Print[funct="y(x) = a Exp[b x] + c Exp[d x] + e"];

Print["Fit of (x,y)  (unweighted)"];

ClearAll[aa,bb,cc,dd,ee];
yf[x_]:=aa*Exp[bb*x]+cc*Exp[dd*x]+ee;

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

(* Finding the xxx array location of the two regions *)
Block[{q1,q2},
q2=(xxx[[1]]-region1)^2;
Do[If[(q1=(xxx[[i]]-region1)^2) <q2,q2=q1;,n1=i-1;Break[];],
	{i,2,n}];
q2=(xxx[[1]]-region2)^2;
Do[If[(q1=(xxx[[i]]-region2)^2) <q2,q2=q1;,n2=i-1;Break[];],
	{i,2,n}];];

einit=Min[yy]*.9;
dinit=Log[Abs[(yyy[[n2]]-einit)/(yyy[[n1]]-einit)]]/(xxx[[n2]]-xxx[[n1]]);
cinit=(yyy[[n1]]-einit)*Exp[-dinit*xxx[[n1]]];
binit=Log[Abs[(yyy[[n1]]-.9*(einit+cinit*Exp[dinit*xxx[[n1]]]))/
 (yyy[[1]]-.9*(einit+cinit*Exp[dinit*xxx[[1]]]))]]/(xxx[[n1]]-xxx[[1]]);
ainit=(yyy[[1]]-.9*(einit+cinit*Exp[dinit*xxx[[1]]]))*Exp[-binit*xxx[[1]]];
];
If[ainit==0.,ainit=10.^-15];
If[binit==0.,binit=10.^-15];
If[cinit==0.,cinit=10.^-15];
If[dinit==0.,dinit=10.^-15];
If[einit==0.,einit=10.^-15];

chi2=(yy-yf[xx])^2;
chicode=Compile[{aa,bb,cc,dd,ee},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb,cc,dd,ee],{aa,ainit,ainit*1.1},{bb,binit,binit*1.1},
	{cc,cinit,cinit*1.1},{dd,dinit,dinit*1.1},{ee,einit,einit*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];

stdv=1.*q[[1]]/Sqrt[(n-5)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
c=1.*cc /. q[[2,3]];
d=1.*dd /. q[[2,4]];
e=1.*ee /. q[[2,5]];
a1=a;
b1=b;
c1=c;
d1=d;
e1=e;
chiplus=Sqrt[q[[1]]^2+stdv^2];
fa[x_]:=FindMinimum[chi[x,bb,cc,dd,ee],{bb,b,b*1.01+10.^-15},
        {cc,c,c*1.01+10.^-15},{dd,d,d*1.01+10.^-15},{ee,e,e*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];
fb[x_]:=FindMinimum[chi[aa,x,cc,dd,ee],{aa,a,a*1.01+10.^-15},
        {cc,c,c*1.01+10.^-15},{dd,d,d*1.01+10.^-15},{ee,e,e*1.01+10.^-15},
        MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[aa,bb,x,dd,ee],{aa,a,a*1.01+10.^-15},
        {bb,b,b*1.01+10.^-15},{dd,d,d*1.01+10.^-15},{ee,e,e*1.01+10.^-15},
        MaxIterations -> 100][[1]];
fd[x_]:=FindMinimum[chi[aa,bb,cc,x,ee],{aa,a,a*1.01+10.^-15},
        {bb,b,b*1.01+10.^-15},{cc,c,c*1.01+10.^-15},{ee,e,e*1.01+10.^-15},
        MaxIterations -> 100][[1]];
fe[x_]:=FindMinimum[chi[aa,bb,cc,dd,x],{aa,a,a*1.01+10.^-15},
        {bb,b,b*1.01+10.^-15},{cc,c,c*1.01+10.^-15},{dd,d,d*1.01+10.^-15},
        MaxIterations -> 100][[1]];

rsa:=Abs[x-a] /. FindMinimum[(chi[x,b,c,d,e]-chiplus)^2,
	{x,a,a*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsb:=Abs[x-b] /. FindMinimum[(chi[a,x,c,d,e]-chiplus)^2,
	{x,b,b*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[a,b,x,d,e]-chiplus)^2,
	{x,c,c*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsd:=Abs[x-d] /. FindMinimum[(chi[a,b,c,x,e]-chiplus)^2,
	{x,d,d*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rse:=Abs[x-e] /. FindMinimum[(chi[a,b,c,d,x]-chiplus)^2,
	{x,e,e*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;
PrintNotification["Calculating sige"];
sige=findsig[e,rse,fe];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"c= ",c},{"e= ",e}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_c\)= ",sigc},
	{"\!\(\[Sigma]\_e\)= ",sige}},{{"b= ",b},{"d= ",d}},
	{{"\!\(\[Sigma]\_b\)= ",sigb},{"\!\(\[Sigma]\_d\)= ",sigd},
	{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{aa,bb,cc,dd,ee},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb,cc,dd,ee],{aa,a1,a1*1.1},{bb,b1,b1*1.1},
	{cc,c1,c1*1.1},{dd,d1,d1*1.1},{ee,e1,e1*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
c=1.*cc /. q[[2,3]];
d=1.*dd /. q[[2,4]];
e=1.*ee /. q[[2,5]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;
PrintNotification["Calculating sige"];
sige=findsig[e,rse,fe];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"c= ",c},{"e= ",e}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_c\)= ",sigc},
	{"\!\(\[Sigma]\_e\)= ",sige}},{{"b= ",b},{"d= ",d}},
	{{"\!\(\[Sigma]\_b\)= ",sigb},{"\!\(\[Sigma]\_d\)= ",sigd},
	{"\!\(\[Chi]\^2\)/(n-5)= ",1.*q[[1]]^2/(n-5)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(aa*bb*Exp[bb*xx]+cc*dd*Exp[dd*xx])^2*sx^2);
chicode=Compile[{aa,bb,cc,dd,ee},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb,cc,dd,ee],{aa,a1,a1*1.1},{bb,b1,b1*1.1},
	{cc,c1,c1*1.1},{dd,d1,d1*1.1},{ee,e1,e1*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
c=1.*cc /. q[[2,3]];
d=1.*dd /. q[[2,4]];
e=1.*ee /. q[[2,5]];
ssy=Sqrt[sy^2+((a*b*Exp[b*xx]+c*d*Exp[d*xx])*sx)^2];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;
PrintNotification["Calculating sige"];
sige=findsig[e,rse,fe];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"c= ",c},{"e= ",e}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_c\)= ",sigc},
	{"\!\(\[Sigma]\_e\)= ",sige}},
	{{"b= ",b},{"d= ",d}},
	{{"\!\(\[Sigma]\_b\)= ",sigb},{"\!\(\[Sigma]\_d\)= ",sigd},
	{"\!\(\[Chi]\^2\)/(n-5)= ",1.*q[[1]]^2/(n-5)}}}]];

];

yff[x_] := 
Evaluate[yf[x] /. {aa -> a, bb -> b, cc -> c, dd -> d, ee -> e}];
fY=fTwoDecayingExponentialsC[];
];

TwoDecayingExponentialsCFit[r1_?NumericQ, r2_?NumericQ]:= (
region1 = N[r1];
region2 = N[r2];
TwoDecayingExponentialsCFit[]
)



(***********************************************************)
End[]; (* `Private` *)

