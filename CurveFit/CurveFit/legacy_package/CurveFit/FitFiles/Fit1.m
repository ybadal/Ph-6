(* ::Package:: *)

(* Copyright 1997-2007 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFitFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Fit1.m - Fitting routine definitions *)

(*
This file includes polynomial fits.
*)


(***********************************************************)
(* Fitting function usages *) 

ConstantFit::usage="ConstantFit[ ] Fits data with y = \!\(a\)";
ConstantFit::tip=
"\!\(TraditionalForm\`\(a\)\)";
fConstant::usage="fConstant[a] [x] = \!\(a\)\n"<>
"fConstant[ ] [x] uses a from "<>
"the latest fit";

SlopeFit::usage="SlopeFit[ ] Fits data with y = \!\(b\\ x\)";
SlopeFit::tip=
"\!\(TraditionalForm\`\(b\\ x\)\)";
fSlope::usage="fSlope[b] [x] = \!\(b\\ x\)\n"<>
"fSlope[ ] [x] uses b from "<>
"the latest fit";

LinearFit::usage="LinearFit[ ] Fits data with: "<>
"y = \!\(a + \(\(b\\ x\)\)\)";
LinearFit::tip=
"\!\(TraditionalForm\`\(a + \(\(b\\ x\)\)\)\)";
fLinear::usage="fLinear[a,b] [x] = \!\(a + \(\(b\\ x\)\)\)\n"<>
"fLinear[ ] [x] uses "<>
"results from the latest fit";

QuadraticFit::usage="QuadraticFit[ ] "<>
"Fits data with: y = \!\(a + \(\(b\\ x\)\) + \(\(c\\ x\^2\)\)\)";
QuadraticFit::tip=
"\!\(TraditionalForm\`\(\(\(c\\ x\^2\)\) + \(\(b\\ x\)\) + a\)\)";
fQuadratic::usage="fQuadratic[a,b,c] [x] "<>
"= \!\(a + \(\(b\\ x\)\) + \(\(c\\ x\^2\)\)\)\n"<>
"fQuadratic[ ] [x] uses results from the latest fit";

CubicFit::usage="CubicFit[ ] "<>
"Fits data with: y = \!\(a + \(\(b\\ x\)\) + "<>
"\(\(c\\ x\^2\)\) + \(\(d\\ x\^3\)\)\)";
CubicFit::tip=
"\!\(TraditionalForm\`\(\(\(d\\ x\^3\)\) + \(\(c\\ x\^2\)\) "<>
"+ \(\(b\\ x\)\) + a\)\)";
fCubic::usage="fCubic[a,b,c,d] [x] = "<>
"\!\(a + \(\(b\\ x\)\) + "<>
"\(\(c\\ x\^2\)\) + \(\(d\\ x\^3\)\)\)\n"<>
"fCubic[ ] [x] uses results from the latest fit";



Begin["`Private`"];



(***********************************************************)
(* List of the fitting functions *)
 
AppendTo[FitList,
{ "Polynomial Fits",
{ConstantFit,SlopeFit,LinearFit,QuadraticFit,CubicFit},
{"Constant","Proportional","Linear","Quadratic","Cubic"}
}
];


(***********************************************************)
(* f<function>[] definitions *) 

fConstant[] := Function[{x}, a]
fConstant[a_] := Function[{x}, a]

fSlope[] := Function[{x}, b x]
fSlope[b_] := Function[{x}, b x]

fLinear[] := Function[{x}, a + b x]
fLinear[a_,b_] := Function[{x}, a + b x]

fQuadratic[] := Function[{x}, a + b x + c x^2]
fQuadratic[a_,b_,c_] := Function[{x}, a + b x + c x^2]

fCubic[] := Function[{x}, a + b x + c x^2 + d x^3]
fCubic[a_,b_,c_,d_] := Function[{x}, a + b x + c x^2 + d x^3]



(***********************************************************)
(* Error messages *)



(***********************************************************
			LINEAR FIT ON DATA
			   y = a + b x
***********************************************************)

LinearFit[]:=Block[{x,q,stdv,chi,chicode,chi2},

chi[aa_Real,bb_Real]:=chicode[aa,bb];

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];

(* "funct" is the fit function. (To be printed with the difference plot.) *)
Print[funct="y(x) = a + b x"];

Print["Fit of (x,y)  (unweighted)"];

(* Define the function yf[x] that you want to fit with *)

ClearAll[aa,bb];
yf[x_]:=aa+bb*x;

(* Make initial guesses for the values of the constants of the fit *)

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

binit=(yyy[[n]]-yyy[[1]])/(xxx[[n]]-xxx[[1]]);
If[binit==0.,binit=10.^-15;];
ainit=yyy[[1]]-binit*xxx[[1]];
If[ainit==0.,ainit=10.^-15;];
];

(* Instead of minimizing Chi^2, it's actually a bit more efficient
 * to minimize Chi = Sqrt[Chi^2]. 
 * This is because Chi^2 sometimes has a too sharp slope with some 
 * parameter, and in cases with difficult data this can mislead the 
 * Mathematica routines.
 *
 * We define Chi for the unweighted case. 
 * Compile makes chi[aa,bb] execute faster.
 *)
 
chi2=(yy-yf[xx])^2;
chicode=Compile[{aa,bb},Evaluate[Sqrt[Plus @@ chi2]]];

(* WE now minimize Chi to find the best fit parameters. It would be enough 
 * to give FindMinimum one starting value for each parameter, 
 * e.g. for aa: {aa,ainit}, but test revealed that this algorithm is much
 * slower and in some cases wouldnt converge or gave wrong results.
 * Turns out that the algorithm where you specify 2 initial values: 
 * e.g. {aa,ainit,ainit*1.1}, is much faster and accurate. 
 * (Mathematica uses different algorithms for the two cases. In the latter
 * case, it computes the slope of Chi with respect to the parameters
 * numerically, which turns out to be the best approach.)
 * 	The difficulty is to give the best possible initial values.
 * They must be a good guess of the final answer, and indicate a decent 
 * initial step size for the search. How to choose what step size?
 * This will depend on how sensitive Chi is with the appropriate parameter.
 * The best initial guess value and a 10% deviation from it, i.e.
 * {aa,ainit,ainit*1.1} works fine for most unweighted fits.
 * For weighted fits, reasonable initial values are the unweighted fit 
 * results with a 1% deviation. i.e. {aa,a,a*1.01}. 
 * 	Choose your initial values carefully. They matter a lot.
 * Tip: You can use a broader range in the unweighted case. But in cases
 * where Chi is highly correlated & steep, one should reduce the search
 * range when doing the weighted fit, using the unweighted fit results
 * as initial conditions. 
 *  	One thing that is VERY IMPORTANT is the order in which you 
 * minimize the parameters. You should alway put the most uncorrelated
 * parameter first.  Usually, it's the one who Chi^2 is the most sensitive \
to.
 * (i.e. the one that gives the largest change in Chi 
 * for say a 10% change in the parameter value). Then follow with the 
 * second sensitive parameter and so on. This doesn't matter in the linear
 * and quadratic fit cases cause the sensitivity is of the same order, 
 * but it matters a lot in resonance curve fits or with other functions. 
 * For example in the case of the resonance curve, in order of decreasing 
 * sensitivity, the parameters are: omega0, ymax, gamma, c  
 *)

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb],{aa,ainit,ainit*1.1},{bb,binit,binit*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*If[n==2, 0., q[[1]]/Sqrt[(n-2)]];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
a1=a;
b1=b;
If[a==0.,a1=10.^-15];
If[b==0.,b1=10.^-15];

DeleteNotification;

(* We now want to find the sigmas for the parameters.
 * We define functions f, that depend on one of the variables, and minimize
 * the others in order to get the value of Chi^2 = Chi^2_ (min)+variance.
 * (or Chi = Sqrt[Chi^2_ (min)+variance] as we use Chi instead of Chi^2)  
 *)

chiplus=Sqrt[q[[1]]^2+stdv^2];

(* A 1% deviation in the rest of the parameters of the fs is a good initial \
step
 *)

fa[x_]:=FindMinimum[chi[x,bb],{bb,b,b*1.01+10.^-15},
	MaxIterations -> 100][[1]];
fb[x_]:=FindMinimum[chi[aa,x],{aa,a,a*1.01+10.^-15},
	MaxIterations -> 100][[1]];

rsa:=Abs[x-a] /. FindMinimum[(chi[x,b]-chiplus)^2,
	{x,a,a*1.01+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)][[2]];
rsb:=Abs[x-b] /. FindMinimum[(chi[a,x]-chiplus)^2,
	{x,b,b*1.01+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)][[2]];

Block[{a2,b2},
 a2=Round[10.^10*Chop[a]]/10^10;
 b2=Round[10.^10*Chop[b]]/10^10;
 If[((Plus @@ (yy-yf[xx])^2) /. {aa->a2,bb->b2}) ==0.,a=a2+0.;b=b2+0.;
 stdv=0.;];
];

If[stdv==0.,
siga=0.;
sigb=0.;
,
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
];

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},{{"\!\(\[Sigma]\_a\)= ",siga},
	{"\!\(\[Sigma]\_b\)= ",sigb},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "]; 

(* We define Chi for the weighted case where we only use sy. *)

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{aa,bb},Evaluate[Sqrt[Plus @@ chi2]]];

If[stdv!=0.,
PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb],{aa,a1,a1*1.1},{bb,b1,b1*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
chiplus=Sqrt[q[[1]]^2+1];
DeleteNotification;
,
chiplus=1.;q[[1]]=0.;
];

PrintNotification["Calculating siga"];
siga=findsig[a+If[a==0.,10^-15,0.],rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b+If[b==0.,10^-15,0.],rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},{{"\!\(\[Sigma]\_a\)= ",siga},
	{"\!\(\[Sigma]\_b\)= ",sigb},{"\!\(\[Chi]\^2\)/(n-2)= ",
	If[n==2,0.,1.*q[[1]]^2/(n-2)]}}}]];

ssy=sy;
];

If[Min[sx] > 0,  
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
 "];

(* We last define Chi with the weighted sy_effective and do again
 * the same as above 
 *)

chi2=(yy-yf[xx])^2/(sy^2+bb^2*sx^2);
chicode=Compile[{aa,bb},Evaluate[Sqrt[Plus @@ chi2]]];

If[stdv!=0.,
PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb],{aa,a1,a1*1.1},{bb,b1,b1*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
b=1.*bb /. q[[2,2]];
a=1.*aa /. q[[2,1]];
chiplus=Sqrt[q[[1]]^2+1];
DeleteNotification;
,
chiplus=1.;q[[1]]=0.;
];

ssy=Sqrt[sy^2+(b*sx)^2];

PrintNotification["Calculating siga"];
siga=findsig[a+If[a==0.,10^-15,0.],rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b+If[b==0.,10^-15,0.],rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},{{"\!\(\[Sigma]\_a\)= ",siga},
	{"\!\(\[Sigma]\_b\)= ",sigb},{"\!\(\[Chi]\^2\)/(n-2)= ",
	If[n==2, 0. ,1.*q[[1]]^2/(n-2)]}}}]]];

(* We now define the function yff[x] with the fit constants, so we can use
   it for the plot & difference plot codes. ssy is the effective sy, also
 to be used in the difference plot codes. *)

yff[x_] := Evaluate[yf[x] /. {aa -> a, bb -> b}];
fY=fLinear[];
];



(***********************************************************
	                  CONSTANT FIT
		      	       y = a
 ***********************************************************)

ConstantFit[]:=Block[{std, wts},

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];

(* "funct" is the fit function. (To be printed with the difference plot.) *)
Print[funct="y(x) = a"];

Print["Fit of (x,y)  (unweighted)"];
a = Mean[N[yy]];
std = If[n > 1,StandardDeviation[N[yy]], "Undefined (n < 2)"];
siga = If[NumberQ[std],N[std/Sqrt[n]],0];

Print[results=TableForm[{{{"a= ",a}},{{"\!\(\[Sigma]\_a\)= ",siga},
        {"Std. deviation= ",std}}}]];

yff[x_] := a;
fY = fConstant[];
If[n < 2 || Min[sy] <= 0,  Return[]];

Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];
wts = 1. sy^(-2);
siga = 1/Total[wts];
a = N[siga Total[yy wts]];
siga = N[Sqrt[siga]];
std = N[Total[(yy - a)^2 wts]/(n - 1)];

Print[results=TableForm[{{{"a= ",a}},{{"\!\(\[Sigma]\_a\)= ",siga},
        {"\!\(\[Chi]\^2\)/(n-1)= ",
	std}}}]];

yff[x_] := a;
fY = fConstant[];
];



(***********************************************************
	             LINEAR FIT THROUGH THE ORIGIN
		      	       y = b x
 ***********************************************************)

SlopeFit[]:=Block[{x,q,stdv,chi,chicode,chi2},

chi[bb_Real]:=chicode[bb];

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];

Print[funct="y(x) = b x"];

Print["Fit of (x,y)  (unweighted)"];

ClearAll[bb];
yf[x_]:=bb*x;

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

binit=(yyy[[n]]-yyy[[1]])/(xxx[[n]]-xxx[[1]]);
If[binit==0.,binit=10.^-15;];
];

chi2=(yy-yf[xx])^2;
chicode=Compile[{bb},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[bb],{bb,binit,binit*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*If[n==1, 0., q[[1]]/Sqrt[(n-1)]];
b=1.*bb /. q[[2,1]];
b1=b;
If[b==0.,b1=10.^-15];

DeleteNotification;

chiplus=Sqrt[q[[1]]^2+stdv^2];


fb[x_]:=chi[x];

rsb:=Abs[x-b] /. FindMinimum[(chi[x]-chiplus)^2,
	{x,b,b*1.01+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)][[2]];

Block[{b2},
 b2=Round[10.^10*Chop[b]]/10^10;
 If[((Plus @@ (yy-yf[xx])^2) /. {bb->b2}) ==0.,b=b2+0.;
 stdv=0.;];
];

If[stdv==0.,
sigb=0.;
,
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
];

Print[results=TableForm[{{{"b= ",b}},{{"\!\(\[Sigma]\_b\)= ",sigb},
        {"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "]; 


chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{bb},Evaluate[Sqrt[Plus @@ chi2]]];

If[stdv!=0.,
PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[bb],{bb,b1,b1*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
b=1.*bb /. q[[2,1]];
chiplus=Sqrt[q[[1]]^2+1];
DeleteNotification;
,
chiplus=1.;q[[1]]=0.;
];

PrintNotification["Calculating sigb"];
sigb=findsig[b+If[b==0.,10^-15,0.],rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"b= ",b}},{{"\!\(\[Sigma]\_b\)= ",sigb},
        {"\!\(\[Chi]\^2\)/(n-1)= ",
	If[n==1,0.,1.*q[[1]]^2/(n-1)]}}}]];

ssy=sy;
];

If[Min[sx] > 0,  
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
 "];


chi2=(yy-yf[xx])^2/(sy^2+bb^2*sx^2);
chicode=Compile[{bb},Evaluate[Sqrt[Plus @@ chi2]]];

If[stdv!=0.,
PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[bb],{bb,b1,b1*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
b=1.*bb /. q[[2,1]];
chiplus=Sqrt[q[[1]]^2+1];
DeleteNotification;
,
chiplus=1.;q[[1]]=0.;
];

ssy=Sqrt[sy^2+(b*sx)^2];

PrintNotification["Calculating sigb"];
sigb=findsig[b+If[b==0.,10^-15,0.],rsb,fb];
DeleteNotification;

Print[results=TableForm[{{{"b= ",b}},{{"\!\(\[Sigma]\_b\)= ",sigb},
        {"\!\(\[Chi]\^2\)/(n-1)= ",
	If[n==1, 0. ,1.*q[[1]]^2/(n-1)]}}}]]];

yff[x_] := Evaluate[yf[x] /. {bb -> b}];
fY = fSlope[];
];




(***********************************************************
			QUADRATIC FIT ON DATA
			 y = a + b x + c x^2
 ***********************************************************)

QuadraticFit[]:=Block[{x,q,stdv,chi,chicode,chi2},

chi[aa_Real,bb_Real,cc_Real]:=chicode[aa,bb,cc];

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(x) = a + b x + c \!\(x\^2\)"];
Print["Fit of (x,y)  (unweighted)"];

ClearAll[aa,bb,cc];
yf[x_]:=aa+bb*x+cc*x^2;

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data,x1,x2,x3,y1,y2,y3},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];
x1=xxx[[1]];
x2=xxx[[Round[n/2]]];
x3=xxx[[n]];
y1=yyy[[1]];
y2=yyy[[Round[n/2]]];
y3=yyy[[n]];
ainit=(x1*x3*(-x1+x3)*y2+x2^2*(x3*y1-x1*y3)+x2*(-(x3^2*y1)+x1^2*y3))/
	((x1-x2)*(x1-x3)*(x2-x3));
binit=(x3^2*(y1-y2)+x1^2*(y2-y3)+x2^2*(-y1+y3))/((x1-x2)*(x1-x3)*(x2-x3));
cinit=(x3*(-y1+y2)+x2*(y1-y3)+x1*(-y2+y3))/((x1-x2)*(x1-x3)*(x2-x3));
If[ainit==0.,ainit=10.^-15];
If[binit==0.,binit=10.^-15];
If[cinit==0.,cinit=10.^-15];
];

chi2=(yy-yf[xx])^2;
chicode=Compile[{aa,bb,cc},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb,cc],{aa,ainit,ainit*1.1},{bb,binit,binit*1.1},
	{cc,cinit,cinit*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*If[n==3, 0., q[[1]]/Sqrt[(n-3)]];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
c=1.*cc /. q[[2,3]];
a1=a;
b1=b;
c1=c;
If[a==0.,a1=10.^-15];
If[b==0.,b1=10.^-15];
If[c==0.,c1=10.^-15];

DeleteNotification;

chiplus=Sqrt[q[[1]]^2+stdv^2];
fa[x_]:=FindMinimum[chi[x,bb,cc],{bb,b,b*1.01+10.^-15},
	{cc,c,c*1.01+10.^-15},MaxIterations -> 100][[1]];
fb[x_]:=FindMinimum[chi[aa,x,cc],{aa,a,a*1.01+10.^-15},
	{cc,c,c*1.01+10.^-15},MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[aa,bb,x],{aa,a,a*1.01+10.^-15},
	{bb,b,b*1.01+10.^-15},MaxIterations -> 100][[1]];

rsa:=Abs[x-a] /. FindMinimum[(chi[x,b,c]-chiplus)^2,
	{x,a,a*1.01+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)][[2]];
rsb:=Abs[x-b] /. FindMinimum[(chi[a,x,c]-chiplus)^2,
	{x,b,b*1.01+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[a,b,x]-chiplus)^2,
	{x,c,c*1.01+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)][[2]];

Block[{a2,b2,c2},
 a2=Round[10.^10*Chop[a]]/10^10;
 b2=Round[10.^10*Chop[b]]/10^10;
 c2=Round[10.^10*Chop[c]]/10^10;
 If[((Plus @@ (yy-yf[xx])^2) /. {aa->a2,bb->b2,cc->c2}) ==0.,a=a2+0.;b=b2+0.;
  c=c2+0.;stdv=0.;];
];

If[stdv==0.,
siga=0.;
sigb=0.;
sigc=0.;
,
PrintNotification["Calculating siga"];
siga=findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b,rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
];

Print[results=TableForm[{{{"a= ",a},{"b= ",b},{"c= ",c}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_c\)= ",sigc},{"Std. deviation= ",stdv}}}]];


ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{aa,bb,cc},Evaluate[Sqrt[Plus @@ chi2]]];

If[stdv!=0.,
PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb,cc],{aa,a1,a1*1.1},{bb,b1,b1*1.1},
	{cc,c1,c1*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
c=1.*cc /. q[[2,3]];
chiplus=Sqrt[q[[1]]^2+1];
DeleteNotification;
,
chiplus=1.;q[[1]]=0.;
];

PrintNotification["Calculating siga"];
siga=findsig[a+If[a==0.,10^-15,0.],rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b+If[b==0.,10^-15,0.],rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c+If[c==0.,10^-15,0.],rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b},{"c= ",c}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_c\)= ",sigc},
	{"\!\(\[Chi]\^2\)/(n-3)= ",If[n==3, 0., 1.*q[[1]]^2/(n-3)]}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(bb+2*cc*xx)^2*sx^2);
chicode=Compile[{aa,bb,cc},Evaluate[Sqrt[Plus @@ chi2]]];

If[stdv!=0.,
PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb,cc],{aa,a1,a1*1.1},{bb,b1,b1*1.1},
	{cc,c1,c1*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
c=1.*cc /. q[[2,3]];
chiplus=Sqrt[q[[1]]^2+1];
DeleteNotification;
,
chiplus=1.;q[[1]]=0.;
];

ssy=Sqrt[sy^2+((b+2*c*xx)*sx)^2];

PrintNotification["Calculating siga"];
siga=findsig[a+If[a==0.,10^-15,0.],rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b+If[b==0.,10^-15,0.],rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c+If[c==0.,10^-15,0.],rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b},{"c= ",c}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb},
	{"\!\(\[Sigma]\_c\)= ",sigc},
	{"\!\(\[Chi]\^2\)/(n-3)= ",If[n==3,0. ,1.*q[[1]]^2/(n-3)]}}}]]];

yff[x_] := Evaluate[yf[x] /. {aa -> a, bb -> b, cc -> c}];
fY = fQuadratic[];
];



(***********************************************************
			     CUBIC FIT ON DATA
	 		y = a + b x + c x^2 + d x^3
 ***********************************************************)

CubicFit[]:=Block[{x,q,stdv,chi,chicode,chi2},

chi[aa_Real,bb_Real,cc_Real,dd_Real]:=chicode[aa,bb,cc,dd];

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(x) = a + b x + c \!\(x\^2\) + d \!\(x\^3\)"];
Print["Fit of (x,y)  (unweighted)"];

ClearAll[aa,bb,cc,dd];
yf[x_]:=aa+bb*x+cc*x^2+dd*x^3;

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data,x1,x2,x3,x4,y1,y2,y3,y4},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];
x1=xxx[[1]];
x2=xxx[[Round[(n+1)/3]]];
x3=xxx[[Round[(2*n+1)/3]]];
x4=xxx[[n]];
y1=yyy[[1]];
y2=yyy[[Round[(n+1)/3]]];
y3=yyy[[Round[(2*n+1)/3]]];
y4=yyy[[n]];
ainit=(x1*(x1-x3)*x3*(x1-x4)*(x3-x4)*x4*y2+x2^3*(x1*(x1-x4)*x4*y3+
 x3^2*(-x4*y1+x1*y4)+x3*(x4^2*y1-x1^2*y4))+x2*(x1^2*(x1-x4)*x4^2*y3+
 x3^3*(-x4^2*y1+x1^2*y4)+x3^2*(x4^3*y1-x1^3*y4))+x2^2*(x1*x4*(-x1^2+x4^2)*y3+
 x3^3*(x4*y1-x1*y4)+x3*(-x4^3*y1+x1^3*y4)))/
 ((x1-x2)*(x1-x3)*(x2-x3)*(x1-x4)*(x2-x4)*(x3-x4));
binit=(x1^2*(x1-x4)*x4^2*(y2-y3)+x3^3*(x4^2*y1+x1^2*y2-x4^2*y2-x1^2*y4)+ 
 x2^3*(-x4^2*y1-x1^2*y3+x4^2*y3+x3^2*(y1-y4)+x1^2*y4)+x3^2*(-x4^3*y1-x1^3*y2+
 x4^3*y2+x1^3*y4)+x2^2*(x4^3*y1+x1^3*y3-x4^3*y3-x1^3*y4+x3^3*(-y1+y4)))/
 ((x1-x2)*(x1-x3)*(x2-x3)*(x1-x4)*(x2-x4)*(x3-x4));
cinit=-((x1*x4*(x1^2-x4^2)*(y2-y3)+x3^3*(x4*y1+x1*y2-x4*y2-x1*y4)+
 x2^3*(-x4*y1-x1*y3+x4*y3+x3*(y1-y4)+x1*y4)+x3*(-x4^3*y1-x1^3*y2+x4^3*y2+
 x1^3*y4)+x2*(x4^3*y1+x1^3*y3-x4^3*y3-x1^3*y4+x3^3*(-y1+y4)))/
 ((x1-x2)*(x1-x3)*(x2-x3)*(x1-x4)*(x2-x4)*(x3-x4)));
dinit=(x1*(x1-x4)*x4*(y2-y3)+x3^2*(x4*y1+x1*y2-x4*y2-x1*y4)+x2^2*(-x4*y1-
 x1*y3+x4*y3+x3*(y1-y4)+x1*y4)+x3*(-x4^2*y1-x1^2*y2+x4^2*y2+x1^2*y4)+
 x2*(x4^2*y1+x1^2*y3-x4^2*y3-x1^2*y4+x3^2*(-y1+y4)))/
 ((x1-x2)*(x1-x3)*(x2-x3)*(x1-x4)*(x2-x4)*(x3-x4));
If[ainit==0.,ainit=10.^-15];
If[binit==0.,binit=10.^-15];
If[cinit==0.,cinit=10.^-15];
If[dinit==0.,dinit=10.^-15];
];

chi2=(yy-yf[xx])^2;
chicode=Compile[{aa,bb,cc,dd},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,bb,cc,dd],{aa,ainit,ainit*1.1},{bb,binit,binit*1.1},
	{cc,cinit,cinit*1.1},{dd,dinit,dinit*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*If[n==4, 0., q[[1]]/Sqrt[(n-4)]];
a=1.*aa /. q[[2,1]];
b=1.*bb /. q[[2,2]];
c=1.*cc /. q[[2,3]];
d=1.*dd /. q[[2,4]];
a1=a;
b1=b;
c1=c;
d1=d;
If[a==0.,a1=10.^-15];
If[b==0.,b1=10.^-15];
If[c==0.,c1=10.^-15];
If[d==0.,d1=10.^-15];

DeleteNotification;

chiplus=Sqrt[q[[1]]^2+stdv^2];
fa[x_]:=FindMinimum[chi[x,bb,cc,dd],{bb,b,b*1.01+10.^-15},
        {cc,c,c*1.01+10.^-15},{dd,d,d*1.01+10.^-15},MaxIterations -> \
100][[1]];
fb[x_]:=FindMinimum[chi[aa,x,cc,dd],{aa,a,a*1.01+10.^-15},
	{cc,c,c*1.01+10.^-15},{dd,d,d*1.01+10.^-15},MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[aa,bb,x,dd],{aa,a,a*1.01+10.^-15},
	{bb,b,b*1.01+10.^-15},{dd,d,d*1.01+10.^-15},MaxIterations -> 100][[1]];
fd[x_]:=FindMinimum[chi[aa,bb,cc,x],{aa,a,a*1.01+10.^-15},
	{bb,b,b*1.01+10.^-15},{cc,c,c*1.01+10.^-15},MaxIterations -> 100][[1]];

rsa:=Abs[x-a] /. FindMinimum[(chi[x,b,c,d]-chiplus)^2,{x,a,a*1.01+10.^-15},
        MaxIterations -> 100(*,WorkingPrecision -> 20*)][[2]];
rsb:=Abs[x-b] /. FindMinimum[(chi[a,x,c,d]-chiplus)^2,{x,b,b*1.01+10.^-15},
        MaxIterations -> 100(*,WorkingPrecision -> 20*)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[a,b,x,d]-chiplus)^2,{x,c,c*1.01+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)][[2]];
rsd:=Abs[x-d] /. FindMinimum[(chi[a,b,c,x]-chiplus)^2,{x,d,d*1.01+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)][[2]];

Block[{a2,b2,c2,d2},
a2=Round[10.^10*Chop[a]]/10^10;
b2=Round[10.^10*Chop[b]]/10^10;
c2=Round[10.^10*Chop[c]]/10^10;
d2=Round[10.^10*Chop[d]]/10^10;
If[((Plus @@ (yy-yf[xx])^2) /. {aa->a2,bb->b2,cc->c2,dd->d2})==0.,
	a=a2+0.;b=b2+0.;c=c2+0.;d=d2+0.;stdv=0.;];
];

If[stdv==0.,
siga=0.;
sigb=0.;
sigc=0.;
sigd=0.;
,
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
];

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb}},
	{{"c= ",c},{"d= ",d}},
	{{"\!\(\[Sigma]\_c\)= ",sigc},{"\!\(\[Sigma]\_d\)= ",sigd},
	{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{aa,bb,cc,dd},Evaluate[Sqrt[Plus @@ chi2]]];

If[stdv!=0.,
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
,
chiplus=1.;q[[1]]=0.;
];

PrintNotification["Calculating siga"];
siga=findsig[a+If[a==0.,10^-15,0.],rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b+If[b==0.,10^-15,0.],rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c+If[c==0.,10^-15,0.],rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d+If[d==0.,10^-15,0.],rsd,fd];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb}},
	{{"c= ",c},{"d= ",d}},
	{{"\!\(\[Sigma]\_c\)= ",sigc},{"\!\(\[Sigma]\_d\)= ",sigd},
	{"\!\(\[Chi]\^2\)/(n-4)= ",If[n==4, 0., 1.*q[[1]]^2/(n-4)]}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(bb+2*cc*xx+3*dd*xx^2)^2*sx^2);
chicode=Compile[{aa,bb,cc,dd},Evaluate[Sqrt[Plus @@ chi2]]];

If[stdv!=0.,
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
,
chiplus=1.;q[[1]]=0.;
];

ssy=Sqrt[sy^2+((b+2*c*xx+3*d*xx^2)*sx)^2];

PrintNotification["Calculating siga"];
siga=findsig[a+If[a==0.,10^-15,0.],rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigb"];
sigb=findsig[b+If[b==0.,10^-15,0.],rsb,fb];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c+If[c==0.,10^-15,0.],rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d+If[d==0.,10^-15,0.],rsd,fd];
DeleteNotification;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},
	{{"\!\(\[Sigma]\_a\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb}},
	{{"c= ",c},{"d= ",d}},
	{{"\!\(\[Sigma]\_c\)= ",sigc},{"\!\(\[Sigma]\_d\)= ",sigd},
	{"\!\(\[Chi]\^2\)/(n-4)= ",If[n==4, 0., 1.*q[[1]]^2/(n-4)]}}}]];
];

yff[x_] := Evaluate[yf[x] /. {aa -> a, bb -> b, cc -> c, dd -> d}];
fY=fCubic[];
];



(***********************************************************)
End[]; (* `Private` *)

