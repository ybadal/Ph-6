(* ::Package:: *)

(* Copyright 1997-2007 by California Inst. of Technology, Pasadena, CA. *)
(* Copyright 1997-2007 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFitFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Fit3.m - Fitting routine definitions *)

(*
This file includes Lorentzian and Gaussian fits.
*)


(***********************************************************)
(* Fitting function usages *) 

LorentzianCFit::usage="LorentzianCFit[ ] "<>
"fits data with a Lorentzian profile: \n"<>
"y(omega) = "<>
"\!\(ymax\\ \((gamma / 2)\)\^2\/\(\(\(\((gamma / 2)\)\^2 + "<>
"\((omega - omega0)\)\^2\)\)\) + c\)\n"<>
"If "<>
"ymax < 0, it is an absorption spectrum.  If ymax > 0, it is an "<>
"emission spectrum.  The code recognizes both cases.";
LorentzianCFit::tip=
"\!\(TraditionalForm\`\(Y\_max\\ \((\[Gamma] / 2)\)\^2\/\(\(\(\((\[Gamma] / 2)\)\^2 + "<>
"\((x - \[Omega]\_0)\)\^2\)\)\) + c\)\)";
fLorentzianC::usage="fLorentzianC[omega0,gamma,ymax,c] [x] = \n"<>
"\!\(ymax\\ \((gamma / 2)\)\^2\/\(\(\(\((gamma / 2)\)\^2 + "<>
"\((omega - omega0)\)\^2\)\)\) + c\)\n"<>
"fLorentzianC[ ] [x] uses results from the latest fit";

LorentzianLFit::usage="LorentzianLFit[ ] "<>
"fits data with a Lorentzian profile with a "<>
"linear background: \n"<>
"y(omega) = \!\(\(ymax\\ \((gamma / 2)\)\^2\/\(\(\(\((gamma / 2)\)\^2 + "<>
"\((omega - omega0)\)\^2\)\)\) + c + "<>
"\(\(d\\ \(\((omega - omega0)\)\)\)\)\)\) \n"<>
"If ymax < 0, it is an "<>
"absorption spectrum.  If ymax > 0, it is an emission spectrum. "<>
"The code recognizes both cases.";
LorentzianLFit::tip=
"\!\(TraditionalForm\`\(Y\_max\\ \((\[Gamma] / 2)\)\^2\/\(\(\(\((\[Gamma] / 2)\)\^2 + "<>
"\((x - \[Omega]\_0)\)\^2\)\)\) + c + \(\(d\\ \(\((x - \[Omega]\_0)\)\)\)\)\)\)";
fLorentzianL::usage="fLorentzianL[omega0,gamma,ymax,c,d] [x] = \n"<>
"\!\(\(ymax\\ \((gamma / 2)\)\^2\/\(\(\(\((gamma / 2)\)\^2 + "<>
"\((omega - omega0)\)\^2\)\)\) + c + "<>
"\(\(d\\ \(\((omega - omega0)\)\)\)\)\)\) \n"<>
"fLorentzianL[ ] [x] uses results from the latest fit";

GaussianCFit::usage="GaussianCFit[ ] "<>
"fits data with a Gaussian profile: \n"<>
"y = \!\(\(\(ymax\\ \(\(Exp[\(\(-\(\(\((x - mean)"<>
"\)\^2\/\(2\\ sigma\^2\)\)\)\)\)]\)\)\)\) + c\)";
GaussianCFit::tip=
"\!\(TraditionalForm\`\(\(\(Y\_max\\ \(\(Exp[\(\(-\(\(\((x - \[Mu])"<>
"\)\^2\/\(2\\ \[Sigma]\^2\)\)\)\)\)]\)\)\)\) + c\)\)";
fGaussianC::usage="fGaussianC[mean,sigma,ymax,c] [x] = \n"<>
"\!\(\(\(ymax\\ \(\(Exp[\(\(-\(\(\((x - mean)"<>
"\)\^2\/\(2\\ sigma\^2\)\)\)\)\)]\)\)\)\) + c\)\n"<>
"fGaussianC[ ] [x] uses results from the latest fit";

GaussianLFit::usage="GaussianLFit[ ] "<>
"fits data with a Gaussian profile on a linear "<>
"background: \n"<>
"y = \!\(\(\(ymax\\ \(\(Exp[\(\(-\(\(\((x - mean)"<>
"\)\^2\/\(2\\ sigma\^2\)\)\)\)\)]\)\)\)\) + c + "<>
"\(\(d\\ \(\((x - mean)\)\)\)\)\)";
GaussianLFit::tip=
"\!\(TraditionalForm\`\(\(\(Y\_max\\ \(\(Exp[\(\(-\(\(\((x - \[Mu])"<>
"\)\^2\/\(2\\ \[Sigma]\^2\)\)\)\)\)]\)\)\)\) + c + \(\(d\\ \(\((x - \[Mu])"<>
"\)\)\)\)\)\)";
fGaussianL::usage="fGaussianL[mean,sigma,ymax,c,d] [x] = \n"<>
"\!\(\(\(ymax\\ \(\(Exp[\(\(-\(\(\((x - mean)"<>
"\)\^2\/\(2\\ sigma\^2\)\)\)\)\)]\)\)\)\) + c + "<>
"\(\(d\\ \(\((x - mean)\)\)\)\)\) \n"<>
"fGaussianL[ ] [x] uses results from the latest fit";



Begin["`Private`"];



(***********************************************************)
(* List of the fitting functions *)
 
AppendTo[FitList,
{ "Lorentzian and Gaussian Fits",
{LorentzianCFit,LorentzianLFit,GaussianCFit,GaussianLFit},
{"Lorentzian + c","Lorentzian + Linear","Gaussian + c","Gaussian + Linear"}
}
];



(***********************************************************)
(* Error messages *)

LorentzianCFit::neg="Encountered zero or negative values in y.";
LorentzianLFit::neg="Encountered zero or negative values in y.";



(***********************************************************)
(* f<function>[] definitions *) 

fLorentzianC[] :=
Function[{x},ymax (gamma/2)^2/((x - omega0)^2 + (gamma/2)^2) + c]
fLorentzianC[omega0_,gamma_,ymax_,c_] :=
Function[{x},ymax (gamma/2)^2/((x - omega0)^2 + (gamma/2)^2) + c]

fLorentzianL[] :=
Function[{x},ymax (gamma/2)^2/((x - omega0)^2 + (gamma/2)^2) + c + 
d (x - omega0)]
fLorentzianL[omega0_,gamma_,ymax_,c_,d_] :=
Function[{x},ymax (gamma/2)^2/((x - omega0)^2 + (gamma/2)^2) + c + 
d (x - omega0)]

fGaussianC[] :=
Function[{x},ymax Exp[-(x - mean)^2/(2 sigma^2)] + c]
fGaussianC[mean_,sigma_,ymax_,c_] :=
Function[{x},ymax Exp[-(x - mean)^2/(2 sigma^2)] + c]

fGaussianL[] :=
Function[{x},ymax Exp[-(x - mean)^2/(2 sigma^2)] + c + d (x - mean)]
fGaussianL[mean_,sigma_,ymax_,c_,d_] :=
Function[{x},ymax Exp[-(x - mean)^2/(2 sigma^2)] + c + d (x - mean)]



(***********************************************************
		LORENTZIAN PROFILE WITH CONSTANT BACKGROUND
 ***********************************************************)

LorentzianCFit[]:=Block[{x,q,stdv,chi,chicode,chi2},

chi[yymax_Real,ggamma_Real,oomega0_Real,cc_Real]:=chicode[yymax,ggamma,\
oomega0,cc];

If[!CheckLength[], Abort[]];
If[Min[yy-sy] <= 0, Message[LorentzianCFit::neg];Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(\[Omega]) = c \[PlusMinus] \!\(y\_max\)
\!\(\((\[Gamma]\/2)\)\^2\/\(\((\[Omega] - \[Omega]\_0)\)\^2 +
\((\[Gamma]\/2)\)\^2\)\)"];
Print["Fit of (x,y)  (unweighted)"];

ClearAll[yymax,ggamma,oomega0,cc];
yf[x_]:=yymax*(ggamma/2)^2/((x-oomega0)^2+(ggamma/2)^2)+cc;

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data,yyymin,yyymax},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];
yyymin=Min[yyy];
yyymax=Max[yyy];
If[(yyy[[1]]-yyymin)^2+(yyy[[n]]-yyymin)^2 < 
   (yyy[[1]]-yyymax)^2+(yyy[[n]]-yyymax)^2,
""
,
yyymin=yyymax;
yyymax=Min[yyy];
];
iofymaxinit=Flatten[Position[yyy,yyymax]][[1]];
omega0init=xxx[[iofymaxinit]];
ymaxinit=yyymax-yyymin;
cinit=yyymin-.1*ymaxinit;
Block[{q1,q2},
q2=(ymaxinit-ymaxinit/2.)^2;
Do[If[Sign[ymaxinit]*yyy[[i]] >= Sign[ymaxinit]*yyy[[i-1]], 
 q2=(yyy[[i]]-yyymin-ymaxinit/2.)^2,
  If[(q1=(yyy[[i]]-yyymin-ymaxinit/2.)^2) <=q2, 
   q2=q1;, n1=i-1;Break[]]],
{i,iofymaxinit+1,n}]];
gammainit=2.*(xxx[[n1]]-omega0init);
];
If[ymaxinit==0.,ymaxinit=10.^-15];
If[omega0init==0.,omega0init=10.^-15];
If[gammainit==0.,gammainit=10.^-15];
If[cinit==0.,cinit=10.^-15];

chi2=(yy-yf[xx])^2;
chicode=Compile[{yymax,ggamma,oomega0,cc},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc],
	{oomega0,omega0init,omega0init*1.1},{yymax,ymaxinit,ymaxinit*1.1},
	{ggamma,gammainit,gammainit*1.1},{cc,cinit,cinit*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-4)];
omega0=1.*oomega0 /. q[[2,1]];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
c=1.*cc /. q[[2,4]];
omega01=omega0;
gamma1=gamma;
ymax1=ymax;
c1=c;
chiplus=Sqrt[q[[1]]^2+stdv^2];
fy[x_]:=FindMinimum[chi[x,ggamma,oomega0,cc],
        {oomega0,omega0,omega0*1.01+10.^-15},
        {ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];
fg[x_]:=FindMinimum[chi[yymax,x,oomega0,cc],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{yymax,ymax,ymax*1.01+10.^-15},{cc,c,c*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];
fo[x_]:=FindMinimum[chi[yymax,ggamma,x,cc],{yymax,ymax,ymax*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[yymax,ggamma,oomega0,x],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{yymax,ymax,ymax*1.01+10.^-15},{ggamma,gamma,gamma*1.01+10.^-15}, 
	MaxIterations -> 100][[1]];

rsy:=Abs[x-ymax] /. FindMinimum[(chi[x,gamma,omega0,c]-chiplus)^2,
	{x,ymax,ymax*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsg:=Abs[x-gamma] /. FindMinimum[(chi[ymax,x,omega0,c]-chiplus)^2,
	{x,gamma,gamma*1.01+10.^-15},MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rso:=Abs[x-omega0] /. FindMinimum[(chi[ymax,gamma,x,c]-chiplus)^2,
	{x,omega0,omega0*1.01+10.^-15},MaxIterations ->100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[ymax,gamma,omega0,x]-chiplus)^2,
	{x,c,c*1.01+10.^-15},MaxIterations ->100(*, WorkingPrecision -> 20 *)][[2]];

DeleteNotification;
PrintNotification["Calculating sigy"];
sigy=findsig[ymax,rsy,fy];
DeleteNotification;
PrintNotification["Calculating sigg"];
sigg=findsig[gamma,rsg,fg];
DeleteNotification;
PrintNotification["Calculating sigo"];
sigo=findsig[omega0,rso,fo];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"\!\(y\_max\)= ",ymax},{"c= ",c}},
	{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_c\)= ",sigc}},
	{{"\!\(\[Omega]\_0\)= ",omega0},{"\[Gamma]= ",gamma}},
	{{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
	{"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{yymax,ggamma,oomega0,cc},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc],
	{oomega0,omega01,omega01*1.1+10.^-15},{yymax,ymax1,ymax1*1.1+10.^-15},
	{ggamma,gamma1,gamma1*1.1+10.^-15},{cc,c1,c1*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
omega0=1.*oomega0 /. q[[2,1]];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
c=1.*cc /. q[[2,4]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating sigy"];
sigy=findsig[ymax,rsy,fy];
DeleteNotification;
PrintNotification["Calculating sigg"];
sigg=findsig[gamma,rsg,fg];
DeleteNotification;
PrintNotification["Calculating sigo"];
sigo=findsig[omega0,rso,fo];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"\!\(y\_max\)= ",ymax},{"c= ",c}},
	{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_c\)= ",sigc}},
	{{"\!\(\[Omega]\_0\)= ",omega0},{"\[Gamma]= ",gamma}},
	{{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
	{"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
	{"\!\(\[Chi]\^2\)/(n-4)= ",1.*q[[1]]^2/(n-4)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+((-8*ggamma^2*(xx-oomega0)*yymax)/(ggamma^2+4*
	(xx-oomega0)^2)^2)^2*sx^2);
chicode=Compile[{yymax,ggamma,oomega0,cc},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc],
	{oomega0,omega01,omega01*1.1+10.^-15},{yymax,ymax1,ymax1*1.1+10.^-15},
	{ggamma,gamma1,gamma1*1.1+10.^-15},{cc,c1,c1*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
omega0=1.*oomega0 /. q[[2,1]];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
c=1.*cc /. q[[2,4]];
ssy=Sqrt[sy^2+(((-8*gamma^2*(xx-omega0)*ymax)/(gamma^2+4*
	(xx-omega0)^2)^2)*sx)^2];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating sigy"];
sigy=findsig[ymax,rsy,fy];
DeleteNotification;
PrintNotification["Calculating sigg"];
sigg=findsig[gamma,rsg,fg];
DeleteNotification;
PrintNotification["Calculating sigo"];
sigo=findsig[omega0,rso,fo];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"\!\(y\_max\)= ",ymax},{"c= ",c}},
	{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_c\)= ",sigc}},
	{{"\!\(\[Omega]\_0\)= ",omega0},{"\[Gamma]= ",gamma}},
	{{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
	{"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
	{"\!\(\[Chi]\^2\)/(n-4)= ",1.*q[[1]]^2/(n-4)}}}]];

];

yff[x_] := 
Evaluate[yf[x] 
 /. {yymax -> ymax, ggamma -> gamma, oomega0 -> omega0,cc -> c}];
fY=fLorentzianC[];
];



(***********************************************************
 		LORENTZIAN PROFILE WITH LINEAR BACKGROUND
***********************************************************)

LorentzianLFit[]:=Block[{x,q,stdv,chi,chicode,chi2},

chi[yymax_Real,ggamma_Real,oomega0_Real,cc_Real,dd_Real]:=
chicode[yymax,ggamma,oomega0,cc,dd];

If[!CheckLength[], Abort[]];
If[Min[yy-sy] <= 0, Message[LorentzianLFit::neg];Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(\[Omega]) = c \[PlusMinus] \!\(y\_max\)
\!\(\((\[Gamma]\/2)\)\^2\/\(\((\[Omega] - \[Omega]\_0)\)\^2 +
\((\[Gamma]\/2)\)\^2\)\) + d (\[Omega] - \!\(\[Omega]\_0\))"];

Print["Fit of (x,y)  (unweighted)"];

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data,yyymin,yyymax},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];
yyymin=Min[yyy];
yyymax=Max[yyy];
If[(yyy[[1]]-yyymin)^2+(yyy[[n]]-yyymin)^2 < 
   (yyy[[1]]-yyymax)^2+(yyy[[n]]-yyymax)^2,
""
,
yyymin=yyymax;
yyymax=Min[yyy];
];
iofymaxinit=Flatten[Position[yyy,yyymax]][[1]];
omega0init=xxx[[iofymaxinit]];
ymaxinit=yyymax-yyymin;
cinit=yyymin-.1*ymaxinit;
Block[{q1,q2},
q2=(ymaxinit-ymaxinit/2.)^2;
Do[If[Sign[ymaxinit]*yyy[[i]] >= Sign[ymaxinit]*yyy[[i-1]], 
 q2=(yyy[[i]]-yyymin-ymaxinit/2.)^2,
  If[(q1=(yyy[[i]]-yyymin-ymaxinit/2.)^2) <=q2, 
   q2=q1;, n1=i-1;Break[]]],
{i,iofymaxinit+1,n}]];
gammainit=2.*(xxx[[n1]]-omega0init);
dinit=(yyy[[n]]-yyy[[1]])/(xxx[[n]]-xxx[[1]]);
If[dinit == 0, dinit=(yyy[[n]]*.9-yyy[[1]]*1.1)/(xxx[[n]]-xxx[[1]]);,""];
];
If[ymaxinit==0.,ymaxinit=10.^-15];
If[omega0init==0.,omega0init=10.^-15];
If[gammainit==0.,gammainit=10.^-15];
If[cinit==0.,cinit=10.^-15];


ClearAll[yymax,ggamma,oomega0,cc,dd];
yf[x_]:=yymax*(ggamma/2)^2/((x-oomega0)^2+(ggamma/2)^2)+cc+dd*(x-omega0init);

chi2=(yy-yf[xx])^2;
chicode=Compile[{yymax,ggamma,oomega0,cc,dd},
	Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc,dd],
	{oomega0,omega0init,omega0init*1.1+10.^-15},
        {yymax,ymaxinit,ymaxinit*1.1+10.^-15},
	{ggamma,gammainit,gammainit*1.1+10.^-15},{cc,cinit,cinit*1.1+10.^-15},
	{dd,dinit,dinit*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-5)];
omega0=1.*oomega0 /. q[[2,1]];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
c=1.*cc /. q[[2,4]];
d=1.*dd /. q[[2,5]];
omega01=omega0;
gamma1=gamma;
ymax1=ymax;
c1=c;
d1=d;
chiplus=Sqrt[q[[1]]^2+stdv^2];
fy[x_]:=FindMinimum[chi[x,ggamma,oomega0,cc,dd],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.1+10.^-15},
        {dd,d,d*1.01+10.^-15},MaxIterations -> 100][[1]];
fg[x_]:=FindMinimum[chi[yymax,x,oomega0,cc,dd],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{yymax,ymax,ymax*1.01+10.^-15},{cc,c,c*1.01+10.^-15},
        {dd,d,d*1.01+10.^-15},MaxIterations -> 100][[1]];
fo[x_]:=FindMinimum[chi[yymax,ggamma,x,cc,dd],{yymax,ymax,ymax*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.01+10.^-15},
        {dd,d,d*1.01+10.^-15},MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[yymax,ggamma,oomega0,x,dd],
	{oomega0,omega0,omega0*1.01+10.^-15},{yymax,ymax,ymax*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{dd,d,d*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];
fd[x_]:=FindMinimum[chi[yymax,ggamma,oomega0,cc,x],
	{oomega0,omega0,omega0*1.01+10.^-15},{yymax,ymax,ymax*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];

rsy:=Abs[x-ymax] /. FindMinimum[(chi[x,gamma,omega0,c,d]-chiplus)^2,
	{x,ymax,ymax*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsg:=Abs[x-gamma] /. FindMinimum[(chi[ymax,x,omega0,c,d]-chiplus)^2,
	{x,gamma,gamma*1.01+10.^-15},MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rso:=Abs[x-omega0] /. FindMinimum[(chi[ymax,gamma,x,c,d]-chiplus)^2,
	{x,omega0,omega0*1.01+10.^-15},MaxIterations ->100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[ymax,gamma,omega0,x,d]-chiplus)^2,
	{x,c,c*1.01+10.^-15},MaxIterations -> 100(*,WorkingPrecision -> 20*)][[2]];
rsd:=Abs[x-d] /. FindMinimum[(chi[ymax,gamma,omega0,c,x]-chiplus)^2,
	{x,d,d*1.01+10.^-15},MaxIterations -> 100(*,WorkingPrecision -> 20*)][[2]];

DeleteNotification;
PrintNotification["Calculating sigy"];
sigy=findsig[ymax,rsy,fy];
DeleteNotification;
PrintNotification["Calculating sigg"];
sigg=findsig[gamma,rsg,fg];
DeleteNotification;
PrintNotification["Calculating sigo"];
sigo=findsig[omega0,rso,fo];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;

Print[results=TableForm[{{{"c= ", c+d*(omega0-omega0init)},{"d= ", d}},
 {{"\!\(\[Sigma]\_c\)= \
",Sqrt[sigc^2+(omega0-omega0init)^2*sigd^2+d^2*sigo^2]},
 {"\!\(\[Sigma]\_d\)= ",sigd}},{{"\!\(y\_max\)= ",ymax},
 {"\!\(\[Omega]\_0\)= ",omega0},{"\[Gamma]= ",gamma}},
 {{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},
 {"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
 {"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{yymax,ggamma,oomega0,cc,dd},
	Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc,dd],
	{oomega0,omega01,omega01*1.1+10.^-15},{yymax,ymax1,ymax1*1.1+10.^-15},
	{ggamma,gamma1,gamma1*1.1+10.^-15},{cc,c1,c1*1.1+10.^-15},
        {dd,d1,d1*1.1+10.^-15},MaxIterations -> 100(*, WorkingPrecision -> 20 \
*)];
omega0=1.*oomega0 /. q[[2,1]];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
c=1.*cc /. q[[2,4]];
d=1.*dd /. q[[2,5]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating sigy"];
sigy=findsig[ymax,rsy,fy];
DeleteNotification;
PrintNotification["Calculating sigg"];
sigg=findsig[gamma,rsg,fg];
DeleteNotification;
PrintNotification["Calculating sigo"];
sigo=findsig[omega0,rso,fo];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;

Print[results=TableForm[{{{"c= ", c+d*(omega0-omega0init)},{"d= ", d}},
 {{"\!\(\[Sigma]\_c\)= \
",Sqrt[sigc^2+(omega0-omega0init)^2*sigd^2+d^2*sigo^2]},
 {"\!\(\[Sigma]\_d\)= ",sigd}},{{"\!\(y\_max\)= ",ymax},
 {"\!\(\[Omega]\_0\)= ",omega0},{"\[Gamma]= ",gamma}},
 {{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},
 {"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
 {"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
 {"\!\(\[Chi]\^2\)/(n-5)= ",1.*q[[1]]^2/(n-5)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(dd + (8*ggamma^2*(oomega0 - xx)*yymax)/
	(ggamma^2 + 4*(oomega0 - xx)^2)^2)^2*sx^2);
chicode=Compile[{yymax,ggamma,oomega0,cc,dd},
	Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc,dd],
	{oomega0,omega01,omega01*1.1+10.^-15},{yymax,ymax1,ymax1*1.1+10.^-15},
	{ggamma,gamma1,gamma1*1.1+10.^-15},{cc,c1,c1*1.1+10.^-15},
        {dd,d1,d1*1.1+10.^-15},MaxIterations -> 100(*, WorkingPrecision -> 20 \
*)];
omega0=1.*oomega0 /. q[[2,1]];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
c=1.*cc /. q[[2,4]];
d=1.*dd /. q[[2,5]];
ssy=Sqrt[sy^2+(d + (8*gamma^2*(omega0 - xx)*ymax)/
	(gamma^2 + 4*(omega0 - xx)^2)^2)^2*sx^2];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating sigy"];
sigy=findsig[ymax,rsy,fy];
DeleteNotification;
PrintNotification["Calculating sigg"];
sigg=findsig[gamma,rsg,fg];
DeleteNotification;
PrintNotification["Calculating sigo"];
sigo=findsig[omega0,rso,fo];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;

Print[results=TableForm[{{{"c= ", c+d*(omega0-omega0init)},{"d= ", d}},
 {{"\!\(\[Sigma]\_c\)= \
",Sqrt[sigc^2+(omega0-omega0init)^2*sigd^2+d^2*sigo^2]},
 {"\!\(\[Sigma]\_d\)= ",sigd}},{{"\!\(y\_max\)= ",ymax},
 {"\!\(\[Omega]\_0\)= ",omega0},{"\[Gamma]= ",gamma}},
 {{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},
 {"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
 {"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
 {"\!\(\[Chi]\^2\)/(n-5)= ",1.*q[[1]]^2/(n-5)}}}]];

];

yff[x_] := 
Evaluate[yf[x] 
/. {yymax -> ymax, ggamma -> gamma, oomega0 -> omega0,cc -> c,
	dd -> d}];

c=c+d*(omega0-omega0init);
sigc=Sqrt[sigc^2+(omega0-omega0init)^2*sigd^2+d^2*sigo^2];
fY=fLorentzianL[];
];



(***********************************************************
		GAUSSIAN PROFILE WITH CONSTANT BACKGROUND
 ***********************************************************)

GaussianCFit[]:=Block[{x,q,stdv,chi,chicode,chi2,n1},

chi[yymax_Real,ssigma_Real,mmean_Real,cc_Real]:=chicode[yymax,ssigma,mmean,cc]\
;

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(x) =
\!\(y\_max\) exp\!\( (-\((x - \[Mu])\)\^2\/\(2 sigma\^2\)) \) + c"];

Print["Fit of (x,y)  (unweighted)"];

ClearAll[yymax,ssigma,mmean,cc];
yf[x_]:=yymax*Exp[-(x-mmean)^2/(2.*ssigma^2)] + cc;

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

yyymax=Max[yyy];
yyymin=Min[yyy];
iofymaxinit=Flatten[Position[yyy,yyymax]][[1]];
meaninit=xxx[[iofymaxinit]];
ymaxinit=yyymax-yyymin;
cinit=yyymin*.9;
Block[{q1,q2},
q2=(ymaxinit-ymaxinit/Exp[.5])^2;
Do[If[yyy[[i]] >= yyy[[i-1]], q2=(yyy[[i]]-yyymin-ymaxinit/Exp[.5])^2,
 If[(q1=(yyy[[i]]-yyymin-ymaxinit/Exp[.5])^2) <= q2, 
  q2=q1;, n1=i-1;Break[]]],
 {i,iofymaxinit+1,n}]];
sigmainit=xxx[[n1]]-meaninit;
];
If[ymaxinit==0.,ymaxinit=10.^-15];
If[sigmainit==0.,sigmainit=10.^-15];
If[meaninit==0.,meaninit=10.^-15];
If[cinit==0.,cinit=10.^-15];


chi2=(yy-yf[xx])^2;
chicode=Compile[{yymax,ssigma,mmean,cc}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ssigma,mmean,cc],
	{mmean,meaninit,meaninit*1.1+10.^-15},
        {yymax,ymaxinit,ymaxinit*1.1+10.^-15},
	{ssigma,sigmainit,sigmainit*1.1+10.^-15},{cc,cinit,cinit*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-4)];
ymax=1.*yymax /. q[[2,2]];
sigma=1.*ssigma /. q[[2,3]];
mean=1.*mmean /. q[[2,1]];
c=1.*cc /. q[[2,4]];
ymax1=ymax;
sigma1=sigma;
mean1=mean;
c1=c;
chiplus=Sqrt[q[[1]]^2+stdv^2];

fy[x_]:=FindMinimum[chi[x,ssigma,mmean,cc],{mmean,mean,mean*1.01+10.^-15},
	{ssigma,sigma,sigma*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];
fs[x_]:=FindMinimum[chi[yymax,x,mmean,cc],{mmean,mean,mean*1.01+10.^-15},
	{yymax,ymax,ymax*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];
fm[x_]:=FindMinimum[chi[yymax,ssigma,x,cc],{yymax,ymax,ymax*1.01+10.^-15},
	{ssigma,sigma,sigma*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[yymax,ssigma,mmean,x],{mmean,mean,mean*1.01+10.^-15},
	{yymax,ymax,ymax*1.01+10.^-15},{ssigma,sigma,sigma*1.01+10.^-15},
	MaxIterations -> 100][[1]];

rsy:=Abs[x-ymax] /. FindMinimum[(chi[x,sigma,mean,c]-chiplus)^2,
	{x,ymax,ymax*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rss:=Abs[x-sigma] /. FindMinimum[(chi[ymax,x,mean,c]-chiplus)^2,
	{x,sigma,sigma*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsm:=Abs[x-mean] /. FindMinimum[(chi[ymax,sigma,x,c]-chiplus)^2,
	{x,mean,mean*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[ymax,sigma,mean,x]-chiplus)^2,
	{x,c,c*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];

DeleteNotification;
PrintNotification["Calculating sigy"];
sigy=findsig[ymax,rsy,fy];
DeleteNotification;
PrintNotification["Calculating sigs"];
sigs=findsig[sigma,rss,fs];
DeleteNotification;
PrintNotification["Calculating sigm"];
sigm=findsig[mean,rsm,fm];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"\!\(y\_max\)= ",ymax},{"c= ",c}},
	{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_c\)= ",sigc}},
	{{"\[Mu]= ",mean},{"sigma= ",sigma}},
	{{"\!\(\[Sigma]\_\[Mu]\)= ",sigm},{"\!\(\[Sigma]\_sigma\)= ",sigs},
	{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{yymax,ssigma,mmean,cc}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ssigma,mmean,cc],
	{mmean,mean1,mean1*1.1+10.^-15},
	{yymax,ymax1,ymax1*1.1+10.^-15},
	{ssigma,sigma1,sigma1*1.1+10.^-15},{cc,c1,c1*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
ymax=1.*yymax /. q[[2,2]];
sigma=1.*ssigma /. q[[2,3]];
mean=1.*mmean /. q[[2,1]];
c=1.*cc /. q[[2,4]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating sigy"];
sigy=findsig[ymax,rsy,fy];
DeleteNotification;
PrintNotification["Calculating sigs"];
sigs=findsig[sigma,rss,fs];
DeleteNotification;
PrintNotification["Calculating sigm"];
sigm=findsig[mean,rsm,fm];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"\!\(y\_max\)= ",ymax},{"c= ",c}},
	{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_c\)= ",sigc}},
	{{"\[Mu]= ",mean},{"sigma= ",sigma}},
	{{"\!\(\[Sigma]\_\[Mu]\)= ",sigm},{"\!\(\[Sigma]\_sigma\)= ",sigs},
	{"\!\(\[Chi]\^2\)/(n-4)= ",1.*q[[1]]^2/(n-4)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(((mmean - xx)*yymax)/
	(Exp[(mmean - xx)^2/(2*ssigma^2)]*ssigma^2)*sx)^2);
chicode=Compile[{yymax,ssigma,mmean,cc}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ssigma,mmean,cc],
	{mmean,mean1,mean1*1.1+10.^-15},
	{yymax,ymax1,ymax1*1.1+10.^-15},
	{ssigma,sigma1,sigma1*1.1+10.^-15},{cc,c1,c1*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
ymax=1.*yymax /. q[[2,2]];
sigma=1.*ssigma /. q[[2,3]];
mean=1.*mmean /. q[[2,1]];
c=1.*cc /. q[[2,4]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating sigy"];
sigy=findsig[ymax,rsy,fy];
DeleteNotification;
PrintNotification["Calculating sigs"];
sigs=findsig[sigma,rss,fs];
DeleteNotification;
PrintNotification["Calculating sigm"];
sigm=findsig[mean,rsm,fm];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;

Print[results=TableForm[{{{"\!\(y\_max\)= ",ymax},{"c= ",c}},
	{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_c\)= ",sigc}},
	{{"\[Mu]= ",mean},{"sigma= ",sigma}},
	{{"\!\(\[Sigma]\_\[Mu]\)= ",sigm},{"\!\(\[Sigma]\_sigma\)= ",sigs},
	{"\!\(\[Chi]\^2\)/(n-4)= ",1.*q[[1]]^2/(n-4)}}}]];

ssy=Sqrt[sy^2+(((mean - xx)*ymax)/
	(Exp[(mean - xx)^2/(2*sigma^2)]*sigma^2)*sx)^2];
];

yff[x_] := Evaluate[yf[x] 
/. {yymax -> ymax, mmean -> mean, ssigma -> sigma, cc -> c}];
sigmean=sigm;
sigsigma=sigs;
fY=fGaussianC[];
];



(***********************************************************
		GAUSSIAN PROFILE WITH LINEAR BACKGROUND
 ***********************************************************)

GaussianLFit[]:=Block[{x,q,stdv,chi,chicode,chi2,n1},

chi[yymax_Real,ssigma_Real,mmean_Real,cc_Real,dd_Real]:=
chicode[yymax,ssigma,mmean,cc,dd];

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(x) =
\!\(y\_max\) exp\!\( (-\((x - \[Mu])\)\^2\/\(2 sigma\^2\)) \) +
c + d (x - \[Mu])"];
Print["Fit of (x,y)  (unweighted)"];

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

yyymax=Max[yyy];
yyymin=Min[yyy];
iofymaxinit=Flatten[Position[yyy,yyymax]][[1]];
meaninit=xxx[[iofymaxinit]];
ymaxinit=yyymax-yyymin;
cinit=yyymin*.9;
Block[{q1,q2},
q2=(ymaxinit-ymaxinit/Exp[.5])^2;
Do[If[yyy[[i]] >= yyy[[i-1]], q2=(yyy[[i]]-yyymin-ymaxinit/Exp[.5])^2,
 If[(q1=(yyy[[i]]-yyymin-ymaxinit/Exp[.5])^2) <= q2, 
  q2=q1;, n1=i-1;Break[]]],
 {i,iofymaxinit+1,n}]];
sigmainit=xxx[[n1]]-meaninit;
dinit=(yyy[[n]]-yyy[[1]])/(xxx[[n]]-xxx[[1]]);
If[dinit == 0, dinit=(yyy[[n]]*.9-yyy[[1]]*1.1)/(xxx[[n]]-xxx[[1]]);,""];
];
If[ymaxinit==0.,ymaxinit=10.^-15];
If[meaninit==0.,meaninit=10.^-15];
If[sigmainit==0.,sigmainit=10.^-15];
If[cinit==0.,cinit=10.^-15];


ClearAll[yymax,ssigma,mmean,cc,dd];
yf[x_]:=yymax*Exp[-(x-mmean)^2/(2.*ssigma^2)] + cc + dd*(x-meaninit);

chi2=(yy-yf[xx])^2;
chicode=Compile[{yymax,ssigma,mmean,cc,dd}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ssigma,mmean,cc,dd],
	{mmean,meaninit,meaninit*1.1+10.^-15},
	{yymax,ymaxinit,ymaxinit*1.1+10.^-15},
	{ssigma,sigmainit,sigmainit*1.1+10.^-15},{cc,cinit,cinit*1.1+10.^-15},
	{dd,dinit,dinit*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-5)];
ymax=1.*yymax /. q[[2,2]];
sigma=1.*ssigma /. q[[2,3]];
mean=1.*mmean /. q[[2,1]];
c=1.*cc /. q[[2,4]];
d=1.*dd /. q[[2,5]];
ymax1=ymax;
sigma1=sigma;
mean1=mean;
c1=c;
d1=d;
chiplus=Sqrt[q[[1]]^2+stdv^2];

fy[x_]:=FindMinimum[chi[x,ssigma,mmean,cc,dd],{mmean,mean,mean*1.01+10.^-15},
	{ssigma,sigma,sigma*1.01+10.^-15},{cc,c,c*1.1+10.^-15},
        {dd,d,d*1.1+10.^-15},MaxIterations -> 100][[1]];
fs[x_]:=FindMinimum[chi[yymax,x,mmean,cc,dd],{mmean,mean,mean*1.01+10.^-15},
	{yymax,ymax,ymax*1.01+10.^-15},{cc,c,c*1.1+10.^-15},
        {dd,d,d*1.1+10.^-15},MaxIterations -> 100][[1]];
fm[x_]:=FindMinimum[chi[yymax,ssigma,x,cc,dd],{yymax,ymax,ymax*1.01+10.^-15},
	{ssigma,sigma,sigma*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        {dd,d,d*1.1+10.^-15},MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[yymax,ssigma,mmean,x,dd],
        {mmean,mean,mean*1.01+10.^-15},{yymax,ymax,ymax*1.01+10.^-15},
        {ssigma,sigma,sigma*1.01+10.^-15},{dd,d,d*1.1+10.^-15},
	MaxIterations -> 100][[1]];
fd[x_]:=FindMinimum[chi[yymax,ssigma,mmean,cc,x],
        {mmean,mean,mean*1.01+10.^-15},{yymax,ymax,ymax*1.01+10.^-15},
        {ssigma,sigma,sigma*1.01+10.^-15},{cc,c,c*1.1+10.^-15},
	MaxIterations -> 100][[1]];

rsy:=Abs[x-ymax] /. FindMinimum[(chi[x,sigma,mean,c,d]-chiplus)^2,
	{x,ymax,ymax*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rss:=Abs[x-sigma] /. FindMinimum[(chi[ymax,x,mean,c,d]-chiplus)^2,
	{x,sigma,sigma*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsm:=Abs[x-mean] /. FindMinimum[(chi[ymax,sigma,x,c,d]-chiplus)^2,
	{x,mean,mean*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[ymax,sigma,mean,x,d]-chiplus)^2,
	{x,c,c*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsd:=Abs[x-d] /. FindMinimum[(chi[ymax,sigma,mean,c,x]-chiplus)^2,
	{x,d,d*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];

DeleteNotification;
PrintNotification["Calculating sigy"];
sigy=findsig[ymax,rsy,fy];
DeleteNotification;
PrintNotification["Calculating sigs"];
sigs=findsig[sigma,rss,fs];
DeleteNotification;
PrintNotification["Calculating sigm"];
sigm=findsig[mean,rsm,fm];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;

Print[results=TableForm[{{{"c= ",c+d*(mean-meaninit)},{"d= ",d}},
 {{"\!\(\[Sigma]\_c\)= ",Sqrt[sigc^2+(mean-meaninit)^2*sigd^2+d^2*sigm^2]},
 {"\!\(\[Sigma]\_d\)= ",sigd}},{{"\!\(y\_max\)= ",ymax},
 {"\[Mu]= ",mean},{"sigma= ",sigma}},
 {{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_\[Mu]\)= ",sigm},
 {"\!\(\[Sigma]\_sigma\)= ",sigs},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{yymax,ssigma,mmean,cc,dd}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ssigma,mmean,cc,dd],
	{mmean,mean1,mean1*1.1+10.^-15},
	{yymax,ymax1,ymax1*1.1+10.^-15},
	{ssigma,sigma1,sigma1*1.1+10.^-15},{cc,c1,c1*1.1+10.^-15},
        {dd,d1,d1*1.1+10.^-15},MaxIterations -> 100(*, WorkingPrecision -> 20 \
*)];
ymax=1.*yymax /. q[[2,2]];
sigma=1.*ssigma /. q[[2,3]];
mean=1.*mmean /. q[[2,1]];
c=1.*cc /. q[[2,4]];
d=1.*dd /. q[[2,5]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating sigy"];
sigy=findsig[ymax,rsy,fy];
DeleteNotification;
PrintNotification["Calculating sigs"];
sigs=findsig[sigma,rss,fs];
DeleteNotification;
PrintNotification["Calculating sigm"];
sigm=findsig[mean,rsm,fm];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;

Print[results=TableForm[{{{"c= ",c+d*(mean-meaninit)},{"d= ",d}},
 {{"\!\(\[Sigma]\_c\)= ",Sqrt[sigc^2+(mean-meaninit)^2*sigd^2+d^2*sigm^2]},
 {"\!\(\[Sigma]\_d\)= ",sigd}},{{"\!\(y\_max\)= ",ymax},{"\[Mu]= ",mean},
 {"sigma= ",sigma}},{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},
 {"\!\(\[Sigma]\_\[Mu]\)= ",sigm},{"\!\(\[Sigma]\_sigma\)= ",sigs},
 {"\!\(\[Chi]\^2\)/(n-5)= ",1.*q[[1]]^2/(n-5)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(dd + ((mmean - xx)*yymax)/
	(Exp[(mmean - xx)^2/(2*ssigma^2)]*ssigma^2))^2*sx^2);
chicode=Compile[{yymax,ssigma,mmean,cc,dd}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ssigma,mmean,cc,dd],
	{mmean,mean1,mean1*1.1+10.^-15},
	{yymax,ymax1,ymax1*1.1+10.^-15},
	{ssigma,sigma1,sigma1*1.1+10.^-15},{cc,c1,c1*1.1+10.^-15},
        {dd,d1,d1*1.1+10.^-15},MaxIterations -> 100(*, WorkingPrecision -> 20 \
*)];
ymax=1.*yymax /. q[[2,2]];
sigma=1.*ssigma /. q[[2,3]];
mean=1.*mmean /. q[[2,1]];
c=1.*cc /. q[[2,4]];
d=1.*dd /. q[[2,5]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating sigy"];
sigy=findsig[ymax,rsy,fy];
DeleteNotification;
PrintNotification["Calculating sigs"];
sigs=findsig[sigma,rss,fs];
DeleteNotification;
PrintNotification["Calculating sigm"];
sigm=findsig[mean,rsm,fm];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc=findsig[c,rsc,fc];
DeleteNotification;
PrintNotification["Calculating sigd"];
sigd=findsig[d,rsd,fd];
DeleteNotification;

Print[results=TableForm[{{{"c= ",c+d*(mean-meaninit)},{"d= ",d}},
 {{"\!\(\[Sigma]\_c\)= ",Sqrt[sigc^2+(mean-meaninit)^2*sigd^2+d^2*sigm^2]},
 {"\!\(\[Sigma]\_d\)= ",sigd}},{{"\!\(y\_max\)= ",ymax},{"\[Mu]= ",mean},
 {"sigma= ",sigma}},{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},
 {"\!\(\[Sigma]\_\[Mu]\)= ",sigm},{"\!\(\[Sigma]\_sigma\)= ",sigs},
	{"\!\(\[Chi]\^2\)/(n-5)= ",1.*q[[1]]^2/(n-5)}}}]];

ssy=Sqrt[sy^2+(d + ((mean - xx)*ymax)/
   (Exp[(mean - xx)^2/(2*sigma^2)]*sigma^2))^2*sx^2];
];

yff[x_] := Evaluate[yf[x] 
/. {yymax -> ymax, mmean -> mean, ssigma -> sigma, cc -> c,
	dd -> d}];

c=c+d*(mean-meaninit);
sigc=Sqrt[sigc^2+(mean-meaninit)^2*sigd^2+d^2*sigm^2];
sigmean=sigm;
sigsigma=sigs;
fY=fGaussianL[];
];



(***********************************************************)
End[]; (* `Private` *)

