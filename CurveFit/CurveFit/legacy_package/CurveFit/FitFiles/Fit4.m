(* ::Package:: *)

(* Copyright 1997-2007 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Fit4.m - Fitting routine definitions *)

(*
This file includes resonance curve and filter fits.
*)


(***********************************************************)
(* Fitting function usages *) 

ResonanceCurveLPFit::usage="ResonanceCurveLPFit[ ] "<>
"Fits data with: \n"<>
"y(omega) = "<>
"\!\(\(ymax\\ gamma\\ omega0\)\/\@\(\(\(gamma\^2\\ omega\^2\)\) + "<>
"\((omega\^2 - omega0\^2)\)\^2\)\) \n"<>
"(e.g. R-L-C low pass filter (output across C), driven mechanical "<>
"oscillator with Q > 9 (i.e. "<>
"gamma << omega0), or any other 2nd order low pass filter.)";
ResonanceCurveLPFit::tip=
"\!\(TraditionalForm\`y\_max\/\@\(\[Omega]\^2\/\[Omega]\_0\%2 + \[Omega]\_0\%2\/\[Gamma]\^2\((1 - \[Omega]\^2\/\[Omega]\_0\%2)\)\^2\)\)";
fResonanceCurveLP::usage="fResonanceCurveLP[omega0,gamma,ymax] [x] = \n"<>
"\!\(\(ymax\\ gamma\\ omega0\)\/\@\(\(\(gamma\^2\\ x\^2\)\) + "<>
"\((x\^2 - omega0\^2)\)\^2\)\) \n"<>
"(e.g. R-L-C low pass filter (output across C), driven mechanical "<>
"oscillator with Q > 9 (i.e. "<>
"gamma << omega0), or any other 2nd order low pass filter.)\n"<>
"fResonanceCurveLP[ ] [x] uses results from the latest fit";

ResonanceCurveLPCFit::usage="ResonanceCurveLPCFit[ ] "<>
"Fits data with: \n"<>
"y(omega) = "<>
"\!\(\(ymax\\ gamma\\ omega0\)\/\@\(\(\(gamma\^2\\ omega\^2\)\) + "<>
"\((omega\^2-omega0\^2)\)\^2\) + c\) \n"<>
"(e.g. R-L-C low pass filter (output across C), driven mechanical "<>
"oscillator with Q > 9 (i.e. "<>
"gamma << omega0), or any other 2nd order low pass filter, with an "<>
"added constant offset.)";
ResonanceCurveLPCFit::tip=
"\!\(TraditionalForm\`y\_max\/\@\(\[Omega]\^2\/\[Omega]\_0\%2 + \[Omega]\_0\%2\/\[Gamma]\^2\((1 - \[Omega]\^2\/\[Omega]\_0\%2)\)\^2\) + c\)";
fResonanceCurveLPC::usage="fResonanceCurveLPC[omega0,gamma,ymax,c] [x] "<>
"= \n"<>
"\!\(\(ymax\\ gamma\\ omega0\)\/\@\(\(\(gamma\^2\\ x\^2\)\) + "<>
"\((x\^2 - omega0\^2)\)\^2\) + c\) \n"<>
"(e.g. R-L-C low pass filter (output across C), driven mechanical "<>
"oscillator with Q > 9 (i.e. "<>
"gamma << omega0), or any other 2nd order low pass filter, with an "<>
"added constant offset.) \n"<>
"fResonanceCurveLPC[ ] [x] uses results from the latest fit";

ResonanceCurveLPLFit::usage="ResonanceCurveLPLFit[ ] "<>
"Fits data with: \n"<>
"y(omega) = \!\(\(\(ymax\\ "<>
"gamma\\ omega0\)\/\@\(\(\(omega\^2\\ gamma\^2\)\) + \((omega\^2 "<>
"- omega0\^2)\)\^2"<>
"\) + c + \(\(d\\ \(\((omega - omega0)\)\)\)\)\)\) \n"<>
"(e.g. R-L-C low pass filter (output across C), driven mechanical "<>
"oscillator with Q > 9 (i.e. "<>
"gamma << omega0), or any other 2nd order low pass filter, with an "<>
"added linear background.)";
ResonanceCurveLPLFit::tip=
"\!\(TraditionalForm\`y\_max\/\@\(\[Omega]\^2\/\[Omega]\_0\%2 + \[Omega]\_0\%2\/\[Gamma]\^2\((1 - \[Omega]\^2\/\[Omega]\_0\%2)\)\^2\) + c + \(d\\ \(\((\[Omega] - \[Omega]\_0)\)\)\)\)";
fResonanceCurveLPL::usage="fResonanceCurveL[omega0,gamma,ymax,c,d] [x] ="<>
" \n\!\(\(\(ymax\\ "<>
"gamma\\ omega0\)\/\@\(\(\(x\^2\\ gamma\^2\)\) + \((x\^2 "<>
"- omega0\^2)\)\^2"<>
"\) + c + \(\(d\\ \(\((x - omega0)\)\)\)\)\)\) \n"<>
"(e.g. R-L-C low pass filter (output across C), driven mechanical "<>
"oscillator with Q > 9 (i.e. "<>
"gamma << omega0), or any other 2nd order low pass filter, with an "<>
"added linear background.) \n"<>
"fResonanceCurveL[ ] [x] uses results from the latest fit";

ResonanceCurveSFit::usage="ResonanceCurveSFit[ ] "<>
"fits data with: \n"<>
"y(omega) = \!\(\("<>
"\(ymax\\ gamma\\ omega\)\/\@\(\(\(omega\^2\\ gamma\^2\)\) + "<>
"\((omega\^2 - omega0\^2)\)\^2"<>
"\)\)\) \n"<>
"(e.g. Resonance curve for R-L-C in parallel, or with "<>
"any other symmetric resonance curve.)";
ResonanceCurveSFit::tip=
"\!\(TraditionalForm\`y\_max\/\@\(1 + \[Omega]\_0\%2\/\[Gamma]\^2\((\[Omega] \_ 0 \/ \[Omega] - \[Omega] \/ \[Omega] \_ 0)\) \^ 2\)\)";
fResonanceCurveS::usage="fResonanceCurveS[omega0,gamma,ymax] "<>
"[x] = \n"<>
"\!\(\("<>
"\(ymax\\ gamma\\ x\)\/\@\(\(\(x\^2\\ gamma\^2\)\) + "<>
"\((x\^2 - omega0\^2)\)\^2"<>
"\)\)\) \n"<>
"(e.g. Resonance curve for R-L-C in parallel, or with "<>
"any other symmetric resonance curve.) \n"<>
"fResonanceCurveS[ ] [x] uses results from the latest fit";

ResonanceCurveSCFit::usage="ResonanceCurveSCFit[ ] "<>
"fits data with: \n"<>
"y(omega) = \!\(\("<>
"\(ymax\\ gamma\\ omega\)\/\@\(\(\(omega\^2\\ gamma\^2\)\) + "<>
"\((omega\^2 - omega0\^2)\)\^2"<>
"\) + c\)\) \n"<>
"(e.g. Resonance curve for R-L-C in parallel, or with "<>
"any other symmetric resonance curve, with an added "<>
"constant offset.)";
ResonanceCurveSCFit::tip=
"\!\(TraditionalForm\`y\_max\/\@\(1 + \[Omega]\_0\%2\/\[Gamma]\^2\((\[Omega] \_ 0 \/ \[Omega] - \[Omega] \/ \[Omega] \_ 0)\) \^ 2\) + c \)";
fResonanceCurveSC::usage="fResonanceCurveSC[omega0,gamma,ymax,c] "<>
"[x] = \n"<>
"\!\(\("<>
"\(ymax\\ gamma\\ x\)\/\@\(\(\(x\^2\\ gamma\^2\)\) + "<>
"\((x\^2 - omega0\^2)\)\^2"<>
"\) + c\)\) \n"<>
"(e.g. Resonance curve for R-L-C in parallel, or with "<>
"any other symmetric resonance curve, with an added "<>
"constant offset.) \n"<>
"fResonanceCurveSC[ ] [x] uses results from the latest fit";

ResonanceCurveSLFit::usage="ResonanceCurveSLFit[ ] "<>
"fits data with: \n"<>
"y(omega) = \!\(\("<>
"\(ymax\\ gamma\\ omega\)\/\@\(\(\(omega\^2\\ gamma\^2\)\) + "<>
"\((omega\^2 - omega0\^2)\)\^2"<>
"\) + c + \(\(d\\ \(\((omega - omega0)\)\)\)\)\)\) \n"<>
"(e.g. Resonance curve for R-L-C in parallel, or with "<>
"any other symmetric resonance curve, with "<>
"an added linear background offset.)";
ResonanceCurveSLFit::tip=
"\!\(TraditionalForm\`y\_max\/\@\(1 + \[Omega]\_0\%2\/\[Gamma]\^2\((\[Omega] \_ 0 \/ \[Omega] - \[Omega] \/ \[Omega] \_ 0)\) \^ 2\) + c + \(d\\ \(\((\[Omega] - \[Omega]\_0)\)\)\)\)";
fResonanceCurveSL::usage="fResonanceCurveSL[omega0,gamma,ymax,c,d] "<>
"[x] = \n"<>
"\!\(\("<>
"\(ymax\\ gamma\\ x\)\/\@\(\(\(x\^2\\ gamma\^2\)\) + "<>
"\((x\^2 - omega0\^2)\)\^2"<>
"\) + c + \(\(d\\ \(\((x - omega0)\)\)\)\)\)\) \n"<>
"(e.g. Resonance curve for R-L-C in parallel, or with "<>
"any other symmetric resonance curve, with "<>
"an added linear background offset.)\n"<>
"fResonanceCurveSL[ ] [x] uses results from the latest fit";

SecondOrderLPFilterFit::usage="SecondOrderLPFilterFit[ ] "<>
"Fits data with: \n"<>
"y(omega) = "<>
"\!\(\(\(a\\ omega0\^2\)\/\@\(\(omega\^2\\ omega0\^2\)"<>
"\/Q\^2 + \((omega\^2 - omega0\^2)\)\^2\) + b\)\) \n"<>
"(e.g. 2nd order R-L-C low pass filter, with an added "<>
"constant offset. Uses Q instead of gamma as a fit parameter.)";
SecondOrderLPFilterFit::tip=
"\!\(TraditionalForm\`\(c + y\_max\/\@\(\[Omega]\^2\/\[Omega]\_0\%2 + \(\(Q\^2\\ \((1 - \[Omega]\^2\/\[Omega]\_0\%2)\)\^2\)\)\)\)\)";
fSecondOrderLPFilter::usage="fSecondOrderLPFilter"<>
"[a,omega0,Q,b] [x] = \n"<>
"\!\(\(\(a\\ omega0\^2\)\/\@\(\(x\^2\\ omega0\^2\)"<>
"\/Q\^2 + \((x\^2 - omega0\^2)\)\^2\) + b\)\) \n"<>
"(e.g. 2nd order R-L-C low pass filter, with an added "<>
"constant offset. Uses Q instead of gamma as a parameter.)\n"<>
"fSecondOrderLPFilter[ ] [x] uses results from the latest fit";

ResonancePhaseDegreesCFit::usage="ResonancePhaseDegreesCFit[ ] "<>
"fits data with: \n"<>
"\!\(TraditionalForm\`\(\(\(y(x)\)\) = \(\(\(\(\[PlusMinus] \(\(\(\(tan\^\(-1\)\)\)(\(\(Q\\ \(\((x\/\[Omega]\_0 - \[Omega]\_0\/x)\)\)\)\))\)\)\)\) + \[Theta]\_0\)\)\)\) \n"<>
"(where the phase angles are in degrees). \nThis represents the "<>
"phase of the steady-state response of a 2nd order resonant "<>
"system. The sign of the arctangent is chosen by the routine "<>
"during the fitting process.";
ResonancePhaseDegreesCFit::tip = "\!\(TraditionalForm\`\(\(\(\[PlusMinus] \(\(\(\(tan\^\(-1\)\)\)(\(\(Q\\ \(\((\[Omega]\/\[Omega]\_0 - \[Omega]\_0\/\[Omega])\)\)\)\))\)\)\)\) + \[Theta]\_0\)\)" 
fResonancePhaseDegreesC;


Begin["`Private`"];



(***********************************************************)
(* List of the fitting functions *)
 
AppendTo[FitList,
{ "Resonance Fits",
{ResonanceCurveLPFit,ResonanceCurveLPCFit,ResonanceCurveLPLFit,
SecondOrderLPFilterFit,
ResonanceCurveSFit,ResonanceCurveSCFit,ResonanceCurveSLFit,
ResonancePhaseDegreesCFit},
{"Series RLC (\[Gamma]): C","Series RLC (\[Gamma]): C + const","Series RLC (\[Gamma]): C + linear",
"Series RLC (Q): C + const",
"Series RLC (\[Gamma]): R","Series RLC (\[Gamma]): R + const","Series RLC (\[Gamma]): R + linear",
"Fit phase: 2nd-order resonance(Q)"}
}
];



(***********************************************************)
(* Error messages *)



(***********************************************************)
(* f<function>[] definitions *) 

fResonanceCurveLP[] := 
Function[{x}, ymax gamma omega0/Sqrt[(x^2 - omega0^2)^2 + (gamma x)^2]]
fResonanceCurveLP[omega0_,gamma_,ymax_] := 
Function[{x}, ymax gamma omega0/Sqrt[(x^2 - omega0^2)^2 + (gamma x)^2]]

fResonanceCurveLPC[] :=
Function[{x},ymax gamma omega0/Sqrt[(x^2 - omega0^2)^2 + (gamma x)^2] + c]
fResonanceCurveLPC[omega0_,gamma_,ymax_,c_] :=
Function[{x},ymax gamma omega0/Sqrt[(x^2 - omega0^2)^2 + (gamma x)^2] + c]

fResonanceCurveLPL[] :=
Function[{x},ymax gamma omega0/Sqrt[(x^2 - omega0^2)^2 + (gamma x)^2] + 
c + d (x - omega0)]
fResonanceCurveLPL[omega0_,gamma_,ymax_,c_,d_] :=
Function[{x},ymax gamma omega0/Sqrt[(x^2 - omega0^2)^2 + (gamma x)^2] + 
c + d (x - omega0)]

fResonanceCurveS[] :=
Function[{x},ymax gamma x/Sqrt[(x^2 - omega0^2)^2 + (gamma x)^2]]
fResonanceCurveS[omega0_,gamma_,ymax_] :=
Function[{x},ymax gamma x/Sqrt[(x^2 - omega0^2)^2 + (gamma x)^2]]

fResonanceCurveSC[] :=
Function[{x},ymax gamma x/Sqrt[(x^2 - omega0^2)^2 + (gamma x)^2] + c]
fResonanceCurveSC[omega0_,gamma_,ymax_,c_] :=
Function[{x},ymax gamma x/Sqrt[(x^2 - omega0^2)^2 + (gamma x)^2] + c]

fResonanceCurveSL[] :=
Function[{x},ymax gamma x/Sqrt[(x^2 - omega0^2)^2 + (gamma x)^2] + c + 
d (x - omega0)]
fResonanceCurveSL[omega0_,gamma_,ymax_,c_,d_] :=
Function[{x},ymax gamma x/Sqrt[(x^2 - omega0^2)^2 + (gamma x)^2] + c + 
d (x - omega0)]

fSecondOrderLPFilter[] :=
Function[{x},a omega0^2/Sqrt[(x^2 - omega0^2)^2 + (omega0 x / Q)^2] + b]
fSecondOrderLPFilter[a_,omega0_,Q_,b_] :=
Function[{x},a omega0^2/Sqrt[(x^2 - omega0^2)^2 + (omega0 x / Q)^2] + b]

fResonancePhaseDegreesC[1][omega0_,theta0_,Q_] := 
Function[{x}, ArcTan[Q (x/omega0-omega0/x)]180./Pi+theta0]

fResonancePhaseDegreesC[-1][omega0_,theta0_,Q_] :=
Function[{x},-ArcTan[Q (x/omega0-omega0/x)]180./Pi+theta0]

fResonancePhaseDegreesC[type_/;type!=0][omega0_,theta0_,Q_] := 
fResonancePhaseDegreesC[Sign[type]][omega0,theta0,Q]

fResonancePhaseDegreesC[type_][] :=
fResonancePhaseDegreesC[Sign[type]][omega0,theta0,Q]


(***********************************************************
				RESONANCE CURVE FIT 
(FOR MECHANICAL OSCILLATOR OR ANY 2ND ORDER LOW PASS FILTER)
 y[omega]=
 ymax gamma omega0/Sqrt[(omega^2-omega0^2)^2+(gamma omega)^2]
 ***********************************************************)

ResonanceCurveLPFit[]:=Block[{x,q,stdv,chi,chicode,chi2},

chi[yymax_Real,ggamma_Real,oomega0_Real]:=chicode[yymax,ggamma,oomega0];

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(\[Omega]) = \!\(\(y\_max \[Gamma]
\[Omega]\_0\)\/\@\(\((\[Omega]\^2 - \[Omega]\_0\%2)\)\^2 +
\((\[Gamma] \[Omega])\)\^2\)\)"];
Print["Fit of (x,y)  (unweighted)"];

ClearAll[yymax,ggamma,oomega0];
yf[omega_]:=yymax*ggamma*oomega0/Sqrt[(omega^2-oomega0^2)^2+(ggamma*omega)^2];\


(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

ymaxinit=Max[yyy];
iofymaxinit=Flatten[Position[yyy,ymaxinit]][[1]];
omega0init=xxx[[iofymaxinit]];
Block[{q1,q2},
q2=(ymaxinit-ymaxinit/Sqrt[2.])^2;
Do[If[yyy[[i]] >= yyy[[i-1]], q2=(yyy[[i]]-ymaxinit/2.)^2,
 If[(q1=(yyy[[i]]-ymaxinit/Sqrt[2.])^2) <=q2, 
  q2=q1;, n1=i-1;Break[]]],
 {i,iofymaxinit+1,n}]];
gammainit=2.*(xxx[[n1]]-omega0init);
];

chi2=(yy-yf[xx])^2;
chicode=Compile[{yymax,ggamma,oomega0},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0],
	{oomega0,omega0init,omega0init*1.1+10.^-15},
	{yymax,ymaxinit,ymaxinit*1.1+10.^-15},
	{ggamma,gammainit,gammainit*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-3)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
ymax1=ymax;
gamma1=gamma;
omega01=omega0;
chiplus=Sqrt[q[[1]]^2+stdv^2];
fy[x_]:=FindMinimum[chi[x,ggamma,oomega0],{oomega0,omega0,omega0*1.01+10.^-15}\
,
	{ggamma,gamma,gamma*1.01+10.^-15}, MaxIterations -> 100][[1]];
fg[x_]:=FindMinimum[chi[yymax,x,oomega0],{oomega0,omega0,omega0*1.01+10.^-15},\

	{yymax,ymax,ymax*1.01+10.^-15}, MaxIterations -> 100][[1]];
fo[x_]:=FindMinimum[chi[yymax,ggamma,x],{yymax,ymax,ymax*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15}, MaxIterations -> 100][[1]];


rsy:=Abs[x-ymax] /. FindMinimum[(chi[x,gamma,omega0]-chiplus)^2,
	{x,ymax,ymax*1.01+10.^-15},MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];
rsg:=Abs[x-gamma] /. FindMinimum[(chi[ymax,x,omega0]-chiplus)^2,
	{x,gamma,gamma*1.01+10.^-15}, MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];
rso:=Abs[x-omega0] /. FindMinimum[(chi[ymax,gamma,x]-chiplus)^2,
	{x,omega0,omega0*1.01+10.^-15}, MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];

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

Print[results=TableForm[{{{"\!\(y\_max\)= ",ymax},{"\[Gamma]= ",gamma},
	{"\!\(\[Omega]\_0\)= ",omega0}},{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},
	{"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
	{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
	{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{yymax,ggamma,oomega0}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0],
	{oomega0,omega01,omega01*1.01+10.^-15},
        {yymax,ymax1,ymax1*1.01+10.^-15},
	{ggamma,gamma1,gamma1*1.01+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
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

Print[results=TableForm[{{{"\!\(y\_max\)= ",ymax},{"\[Gamma]= ",gamma},
	{"\!\(\[Omega]\_0\)= ",omega0}},{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},
	{"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
	{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
	{"\!\(\[Chi]\^2\)/(n-3) = ",1.*q[[1]]^2/(n-3)}}}]];
	
ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+((((yymax*ggamma*oomega0*xx*
	(ggamma^2 - 2*oomega0^2 + 2*xx^2))/(ggamma^2*xx^2 + 
	(oomega0^2 - xx^2)^2)^(3/2)))*sx)^2);
chicode=Compile[{yymax,ggamma,oomega0}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0],{oomega0,omega01,omega01*1.01+10.^-15}\
,
	{yymax,ymax1,ymax1*1.01+10.^-15},{ggamma,gamma1,gamma1*1.01+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
ssy=Sqrt[sy^2+((((ymax*gamma*omega0*xx*(gamma^2 - 2*omega0^2 + 2*xx^2))/
	(gamma^2*xx^2 + (omega0^2 - xx^2)^2)^(3/2)))*sx)^2];
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

Print[results=TableForm[{{{"\!\(y\_max\)= ",ymax},{"\[Gamma]= ",gamma},
	{"\!\(\[Omega]\_0\)= ",omega0}},{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},
	{"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
	{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
	{"\!\(\[Chi]\^2\)/(n-3) = ",1.*q[[1]]^2/(n-3)}}}]];
	
];

yff[x_] := Evaluate[yf[x] /. {yymax -> ymax, oomega0 -> omega0, 
	ggamma -> gamma}];
fY=fResonanceCurveLP[];
];



(***********************************************************
		     RESONANCE CURVE FIT WITH CONSTANT 
(FOR MECHANICAL OSCILLATOR, OR ANY 2ND ORDER LOW PASS FILTER)
                    (Option (N) in FFIT)
 y[omega]=
 ymax gamma omega0/Sqrt[(omega^2-omega0^2)^2+(gamma omega)^2] + c
 ***********************************************************)

ResonanceCurveLPCFit[]:=Block[{x,q,stdv,chi,chicode,chi2,n1,c1},

chi[yymax_Real,ggamma_Real,oomega0_Real,cc_Real]:=chicode[yymax,ggamma,\
oomega0,cc];

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(\[Omega]) = \!\(\(y\_max \[Gamma]
\[Omega]\_0\)\/\@\(\((\[Omega]\^2 - \[Omega]\_0\%2)\)\^2 +
\((\[Gamma] \[Omega])\)\^2\)\) + c"];

ClearAll[yymax,ggamma,oomega0,cc];
yf[omega_]:=yymax*ggamma*oomega0/Sqrt[(omega^2-oomega0^2)^2+(ggamma*omega)^2]+\

	cc;

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data,ymin,ymax},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

ymin=Min[yyy];
ymax=Max[yyy];
cinit=Max[ymin/10., ymin-.25*(ymax-ymin)];
ymaxinit=ymax-cinit;
iofymaxinit=Flatten[Position[yyy,ymax]][[1]];
omega0init=xxx[[iofymaxinit]];
yyy=yyy-cinit;
Block[{q1,q2},
q2=(ymaxinit-ymaxinit/Sqrt[2.])^2;
Do[If[yyy[[i]] >= yyy[[i-1]], q2=(yyy[[i]]-ymaxinit/2.)^2,
 If[(q1=(yyy[[i]]-ymaxinit/Sqrt[2.])^2) <=q2, 
  q2=q1;, n1=i-1;Break[]]],
 {i,iofymaxinit+1,n}]];
gammainit=2.*(xxx[[n1]]-omega0init);
];

chi2=(yy-yf[xx])^2;
chicode=Compile[{yymax,ggamma,oomega0,cc}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc],
	{oomega0,omega0init,omega0init*1.1+10.^-15},
	{yymax,ymaxinit,ymaxinit*1.1+10.^-15},
	{ggamma,gammainit,gammainit*1.1+10.^-15},{cc,cinit,cinit*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-4)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 =1.*oomega0 /. q[[2,1]];
c=1.*cc /. q[[2,4]];
ymax1=ymax;
gamma1=gamma;
omega01=omega0;
chiplus=Sqrt[q[[1]]^2+stdv^2];
c1=c;

fy[x_]:=FindMinimum[chi[x,ggamma,oomega0,cc],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];
fg[x_]:=FindMinimum[chi[yymax,x,oomega0,cc],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{yymax,ymax,ymax*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];
fo[x_]:=FindMinimum[chi[yymax,ggamma,x,cc],{yymax,ymax,ymax*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[yymax,ggamma,oomega0,x],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{yymax,ymax,ymax*1.01+10.^-15},{ggamma,gamma,gamma*1.01+10.^-15}, 
	MaxIterations -> 100][[1]];

rsy:=Abs[x-ymax] /. FindMinimum[(chi[x,gamma,omega0,c]-chiplus)^2,
	{x,ymax,ymax*1.01+10.^-15},MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];
rsg:=Abs[x-gamma] /. FindMinimum[(chi[ymax,x,omega0,c]-chiplus)^2,
	{x,gamma,gamma*1.01+10.^-15}, MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];
rso:=Abs[x-omega0] /. FindMinimum[(chi[ymax,gamma,x,c]-chiplus)^2,
	{x,omega0,omega0*1.01+10.^-15}, MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[ymax,gamma,omega0,x]-chiplus)^2,
	{x,c,c*1.01+10.^-15}, MaxIterations -> 100
	(*, WorkingPrecision -> 20*)][[2]];

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
chicode=Compile[{yymax,ggamma,oomega0,cc}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc],
        {oomega0,omega01,omega01*1.01+10.^-15},
	{yymax,ymax1,ymax1*1.01+10.^-15},{ggamma,gamma1,gamma1*1.01+10.^-15},
	{cc,c1,c1*1.1+10.^-15},MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
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
	{"\!\(\[Chi]\^2\)/(n-4) = ",1.*q[[1]]^2/(n-4)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+((((yymax*ggamma*oomega0*xx*
	(ggamma^2 - 2*oomega0^2 + 2*xx^2))/(ggamma^2*xx^2 + 
	(oomega0^2 - xx^2)^2)^(3/2)))*sx)^2);
chicode=Compile[{yymax,ggamma,oomega0,cc},
	Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc],
	{oomega0,omega01,omega01*1.01+10.^-15},
        {yymax,ymax1,ymax1*1.01+10.^-15},{ggamma,gamma1,gamma1*1.01+10.^-15},
        {cc,c1,c1*1.1+10.^-15},MaxIterations -> 100(*, WorkingPrecision -> 20 \
*)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
c=1.*cc /. q[[2,4]];
ssy=Sqrt[sy^2+((((ymax*gamma*omega0*xx*(gamma^2 - 2*omega0^2 + 2*xx^2))/
	(gamma^2*xx^2 + (omega0^2 - xx^2)^2)^(3/2)))*sx)^2];

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
	{"\!\(\[Chi]\^2\)/(n-4) = ",1.*q[[1]]^2/(n-4)}}}]];
];

yff[x_] := Evaluate[yf[x] /. {yymax -> ymax, oomega0 -> omega0, 
	ggamma -> gamma, cc -> c}];
fY=fResonanceCurveLPC[];
];



(***********************************************************
		              RESONANCE CURVE FIT 
		(FOR L-C IN PARALLEL, AND THAT IN SERIES WITH R,
		    OR WITH ANY OTHER SYMMETRIC RESONANCE)
 y[omega]=
 ymax gamma omega/Sqrt[(omega^2-omega0^2)^2+(gamma omega)^2]
 ***********************************************************)

ResonanceCurveSFit[]:=Block[{x,q,stdv,chi,chicode,chi2},

chi[yymax_Real,ggamma_Real,oomega0_Real]:=chicode[yymax,ggamma,oomega0];

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(\[Omega]) = \!\(\(y\_max \[Gamma] \[Omega]\)
 \/\@\(\((\[Omega]\^2 - \[Omega]\_0\%2)\)\^2 +\((\[Gamma] \
\[Omega])\)\^2\)\)"];
Print["Fit of (x,y)  (unweighted)"];

ClearAll[yymax,ggamma,oomega0];
yf[omega_]:=yymax*ggamma*omega/Sqrt[(omega^2-oomega0^2)^2+(ggamma*omega)^2];

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

ymaxinit=Max[yyy];
iofymaxinit=Flatten[Position[yyy,ymaxinit]][[1]];
omega0init=xxx[[iofymaxinit]];
Block[{q1,q2},
q2=(ymaxinit-ymaxinit/Sqrt[2.])^2;
Do[If[yyy[[i]] >= yyy[[i-1]], q2=(yyy[[i]]-ymaxinit/2.)^2,
 If[(q1=(yyy[[i]]-ymaxinit/Sqrt[2.])^2) <=q2, 
  q2=q1;, n1=i-1;Break[]]],
 {i,iofymaxinit+1,n}]];
gammainit=2.*(xxx[[n1]]-omega0init);
];

chi2=(yy-yf[xx])^2;
chicode=Compile[{yymax,ggamma,oomega0},Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0],
	{oomega0,omega0init,omega0init*1.1+10.^-15},
	{yymax,ymaxinit,ymaxinit*1.1+10.^-15},
	{ggamma,gammainit,gammainit*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-3)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
ymax1=ymax;
gamma1=gamma;
omega01=omega0;
chiplus=Sqrt[q[[1]]^2+stdv^2];
fy[x_]:=FindMinimum[chi[x,ggamma,oomega0],{oomega0,omega0,omega0*1.01+10.^-15}\
,
	{ggamma,gamma,gamma*1.01+10.^-15}, MaxIterations -> 100][[1]];
fg[x_]:=FindMinimum[chi[yymax,x,oomega0],{oomega0,omega0,omega0*1.01+10.^-15},\

	{yymax,ymax,ymax*1.01+10.^-15}, MaxIterations -> 100][[1]];
fo[x_]:=FindMinimum[chi[yymax,ggamma,x],{yymax,ymax,ymax*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15}, MaxIterations -> 100][[1]];


rsy:=Abs[x-ymax] /. FindMinimum[(chi[x,gamma,omega0]-chiplus)^2,
	{x,ymax,ymax*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsg:=Abs[x-gamma] /. FindMinimum[(chi[ymax,x,omega0]-chiplus)^2,
	{x,gamma,gamma*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rso:=Abs[x-omega0] /. FindMinimum[(chi[ymax,gamma,x]-chiplus)^2,
	{x,omega0,omega0*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];

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

Print[results=TableForm[{{{"\!\(y\_max\)= ",ymax},{"\[Gamma]= ",gamma},
 {"\!\(\[Omega]\_0\)= ",omega0}},{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},
 {"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
 {"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{yymax,ggamma,oomega0}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0],
	{oomega0,omega01,omega01*1.01+10.^-15},
        {yymax,ymax1,ymax1*1.01+10.^-15},{ggamma,gamma1,gamma1*1.01+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
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

Print[results=TableForm[{{{"\!\(y\_max\)= ",ymax},{"\[Gamma]= ",gamma},
 {"\!\(\[Omega]\_0\)= ",omega0}},{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},
 {"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
 {"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
 {"\!\(\[Chi]\^2\)/(n-3) = ",1.*q[[1]]^2/(n-3)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(((ggamma*(oomega0^4 - xx^4)*yymax)/
	(oomega0^4 + ggamma^2*xx^2 - 2*oomega0^2*xx^2 + xx^4)^(3/2))*sx)^2);
chicode=Compile[{yymax,ggamma,oomega0}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0],{oomega0,omega01,omega01*1.01+10.^-15}\
,
	{yymax,ymax1,ymax1*1.01+10.^-15},{ggamma,gamma1,gamma1*1.01+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
ssy=Sqrt[sy^2+(((gamma*(omega0^4 - xx^4)*ymax)/
	(omega0^4 + gamma^2*xx^2 - 2*omega0^2*xx^2 + xx^4)^(3/2))*sx)^2];
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

Print[results=TableForm[{{{"\!\(y\_max\)= ",ymax},{"\[Gamma]= ",gamma},
 {"\!\(\[Omega]\_0\)= ",omega0}},{{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},
 {"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
 {"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
 {"\!\(\[Chi]\^2\)/(n-3) = ",1.*q[[1]]^2/(n-3)}}}]];
];

yff[x_] := Evaluate[yf[x] 
 /. {yymax -> ymax, oomega0 -> omega0, ggamma -> gamma}];
fY=fResonanceCurveS[];
];



(***********************************************************
			RESONANCE CURVE FIT WITH CONSTANT 
		(FOR L-C IN PARALLEL, AND THAT IN SERIES WITH R,
			OR ANY OTHER SYMMETRIC RESONANCE)
 y[omega]=
 ymax gamma omega/Sqrt[(omega^2-omega0^2)^2+(gamma omega)^2] + c
 ***********************************************************)

ResonanceCurveSCFit[]:=Block[{x,q,stdv,chi,chicode,chi2,n1,c1},

chi[yymax_Real,ggamma_Real,oomega0_Real,cc_Real]:=chicode[yymax,ggamma,\
oomega0,cc];

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(\[Omega]) = \!\(\(y\_max \[Gamma] \[Omega]\)\/\@\(
 \((\[Omega]\^2 - \[Omega]\_0\%2)\)\^2 + \((\[Gamma] \[Omega])\)\^2\)\) + \
c"];
Print["Fit of (x,y)  (unweighted)"];

ClearAll[yymax,ggamma,oomega0,cc];
yf[omega_]:=yymax*ggamma*omega/Sqrt[(omega^2-oomega0^2)^2+(ggamma*omega)^2]+
	cc;

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data,ymin,ymax},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

ymin=Min[yyy];
ymax=Max[yyy];
cinit=Max[ymin/10., ymin-.25*(ymax-ymin)];
ymaxinit=ymax-cinit;
iofymaxinit=Flatten[Position[yyy,ymax]][[1]];
omega0init=xxx[[iofymaxinit]];
yyy=yyy-cinit;
Block[{q1,q2},
q2=(ymaxinit-ymaxinit/Sqrt[2.])^2;
Do[If[yyy[[i]] >= yyy[[i-1]], q2=(yyy[[i]]-ymaxinit/2.)^2,
 If[(q1=(yyy[[i]]-ymaxinit/Sqrt[2.])^2) <=q2, 
  q2=q1;, n1=i-1;Break[]]],
 {i,iofymaxinit+1,n}]];
gammainit=2.*(xxx[[n1]]-omega0init);
];

chi2=(yy-yf[xx])^2;
chicode=Compile[{yymax,ggamma,oomega0,cc}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc],
	{oomega0,omega0init,omega0init*1.1+10.^-15},
	{yymax,ymaxinit,ymaxinit*1.1+10.^-15},
	{ggamma,gammainit,gammainit*1.1+10.^-15},{cc,cinit,cinit*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-4)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 =1.*oomega0 /. q[[2,1]];
c=1.*cc /. q[[2,4]];
ymax1=ymax;
gamma1=gamma;
omega01=omega0;
chiplus=Sqrt[q[[1]]^2+stdv^2];
c1=c;

fy[x_]:=FindMinimum[chi[x,ggamma,oomega0,cc],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];
fg[x_]:=FindMinimum[chi[yymax,x,oomega0,cc],
        {oomega0,omega0,omega0*1.01+10.^-15},{yymax,ymax,ymax*1.01+10.^-15},
        {cc,c,c*1.1+10.^-15}, MaxIterations -> 100][[1]];
fo[x_]:=FindMinimum[chi[yymax,ggamma,x,cc],{yymax,ymax,ymax*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[yymax,ggamma,oomega0,x],
        {oomega0,omega0,omega0*1.01+10.^-15},{yymax,ymax,ymax*1.01+10.^-15},
        {ggamma,gamma,gamma*1.01+10.^-15},MaxIterations -> 100][[1]];

rsy:=Abs[x-ymax] /. FindMinimum[(chi[x,gamma,omega0,c]-chiplus)^2,
	{x,ymax,ymax*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsg:=Abs[x-gamma] /. FindMinimum[(chi[ymax,x,omega0,c]-chiplus)^2,
	{x,gamma,gamma*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rso:=Abs[x-omega0] /. FindMinimum[(chi[ymax,gamma,x,c]-chiplus)^2,
	{x,omega0,omega0*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[ymax,gamma,omega0,x]-chiplus)^2,
	{x,c,c*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];

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
chicode=Compile[{yymax,ggamma,oomega0,cc}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc],
        {oomega0,omega01,omega01*1.01+10.^-15},
	{yymax,ymax1,ymax1*1.01+10.^-15},{ggamma,gamma1,gamma1*1.01+10.^-15},
	{cc,c1,c1*1.1+10.^-15},MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
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
	{"\!\(\[Chi]\^2\)/(n-4) = ",1.*q[[1]]^2/(n-4)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(((ggamma*(oomega0^4 - xx^4)*yymax)/
	(oomega0^4 + ggamma^2*xx^2 - 2*oomega0^2*xx^2 + xx^4)^(3/2))*sx)^2);
chicode=Compile[{yymax,ggamma,oomega0,cc},
	Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc],
	{oomega0,omega01,omega01*1.01+10.^-15},
        {yymax,ymax1,ymax1*1.01+10.^-15},
	{ggamma,gamma1,gamma1*1.01+10.^-15},{cc,c1,c1*1.1+10.^-15}, 
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
c=1.*cc /. q[[2,4]];
ssy=Sqrt[sy^2+(((gamma*(omega0^4 - xx^4)*ymax)/
	(omega0^4 + gamma^2*xx^2 - 2*omega0^2*xx^2 + xx^4)^(3/2))*sx)^2];

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
	{"\!\(\[Chi]\^2\)/(n-4) = ",1.*q[[1]]^2/(n-4)}}}]];
];
yff[x_] := Evaluate[yf[x] /. {yymax -> ymax, oomega0 -> omega0, 
	ggamma -> gamma, cc -> c}];
fY=fResonanceCurveSC[];
];



(***********************************************************
		 RESONANCE CURVE FIT WITH LINEAR BACKGROUND 
	  (FOR MECHANICAL OSCILLATOR, OR ANY LOW PASS FILTER)
 y[omega]=
 ymax gamma omega0/Sqrt[(omega^2-omega0^2)^2+(gamma omega)^2] 
 + c + d (omega -omega0)
 ***********************************************************)

ResonanceCurveLPLFit[]:=Block[{x,q,stdv,chi,chicode,chi2,n1,c1,d1},

chi[yymax_Real,ggamma_Real,oomega0_Real,cc_Real,dd_Real]:=
chicode[yymax,ggamma,oomega0,cc,dd];

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(\[Omega]) = \!\(\(y\_max \[Gamma] \[Omega]\_0\)\/\@\(\(
 (\[Omega]\^2 - \\[Omega]\_0\%2)\)\^2 + \((\[Gamma] \[Omega])\)\^2\)\) + "<>
 "c + d (\[Omega] - \!\(\[Omega]\_0\))"];

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data,ymin,ymax},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

ymin=Min[yyy];
ymax=Max[yyy];
cinit=Max[ymin/10., ymin-.25*(ymax-ymin)];
ymaxinit=ymax-cinit;
iofymaxinit=Flatten[Position[yyy,ymax]][[1]];
omega0init=xxx[[iofymaxinit]];
yyy=yyy-cinit;
Block[{q1,q2},
q2=(ymaxinit-ymaxinit/Sqrt[2.])^2;
Do[If[yyy[[i]] >= yyy[[i-1]], q2=(yyy[[i]]-ymaxinit/2.)^2,
 If[(q1=(yyy[[i]]-ymaxinit/Sqrt[2.])^2) <=q2, 
  q2=q1;, n1=i-1;Break[]]],
 {i,iofymaxinit+1,n}]];
gammainit=2.*(xxx[[n1]]-omega0init);
dinit=(yyy[[n]]-yyy[[1]])/(xxx[[n]]-xxx[[1]]);
If[dinit == 0, dinit=(yyy[[n]]*.9-yyy[[1]]*1.1)/(xxx[[n]]-xxx[[1]]);,""];
];

ClearAll[yymax,ggamma,oomega0,cc,dd];
yf[omega_]:=yymax*ggamma*oomega0/Sqrt[(omega^2-oomega0^2)^2+(ggamma*omega)^2]+\

	cc + dd*(omega-omega0init);

chi2=(yy-yf[xx])^2;
chicode=Compile[{yymax,ggamma,oomega0,cc,dd}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc,dd],
	{oomega0,omega0init,omega0init*1.1+10.^-15},
	{yymax,ymaxinit,ymaxinit*1.1+10.^-15},
	{ggamma,gammainit,gammainit*1.1+10.^-15},{cc,cinit,cinit*1.1+10.^-15},
	{dd,dinit,dinit*1.1},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-5)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 =1.*oomega0 /. q[[2,1]];
c=1.*cc /. q[[2,4]];
d=1.*dd /. q[[2,5]];
ymax1=ymax;
gamma1=gamma;
omega01=omega0;
chiplus=Sqrt[q[[1]]^2+stdv^2];
c1=c;
d1=d;

fy[x_]:=FindMinimum[chi[x,ggamma,oomega0,cc,dd],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.1+10.^-15},
        {dd,d,d*1.1+10.^-15},MaxIterations -> 100][[1]];
fg[x_]:=FindMinimum[chi[yymax,x,oomega0,cc,dd],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{yymax,ymax,ymax*1.01+10.^-15},{cc,c,c*1.1+10.^-15},
        {dd,d,d*1.1+10.^-15},MaxIterations -> 100][[1]];
fo[x_]:=FindMinimum[chi[yymax,ggamma,x,cc,dd],{yymax,ymax,ymax*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.1+10.^-15},
        {dd,d,d*1.1+10.^-15},MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[yymax,ggamma,oomega0,x,dd],
	{oomega0,omega0,omega0*1.01+10.^-15},{yymax,ymax,ymax*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{dd,d,d*1.01+10.^-15}, 
	MaxIterations -> 100][[1]];
fd[x_]:=FindMinimum[chi[yymax,ggamma,oomega0,cc,x],
	{oomega0,omega0,omega0*1.01+10.^-15},{yymax,ymax,ymax*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.01+10.^-15}, 
	MaxIterations -> 100][[1]];

rsy:=Abs[x-ymax] /. FindMinimum[(chi[x,gamma,omega0,c,d]-chiplus)^2,
	{x,ymax,ymax*1.01+10.^-15},MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsg:=Abs[x-gamma] /. FindMinimum[(chi[ymax,x,omega0,c,d]-chiplus)^2,
	{x,gamma,gamma*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rso:=Abs[x-omega0] /. FindMinimum[(chi[ymax,gamma,x,c,d]-chiplus)^2,
	{x,omega0,omega0*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[ymax,gamma,omega0,x,d]-chiplus)^2,
	{x,c,c*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsd:=Abs[x-d] /. FindMinimum[(chi[ymax,gamma,omega0,c,x]-chiplus)^2,
	{x,d,d*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];

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

Print[results=TableForm[{{{"c= ",c+d*(omega0-omega0init)},{"d= ",d}},
 {{"\!\(\[Sigma]\_c\)= \
",Sqrt[sigc^2+(omega0-omega0init)^2*sigd^2+d^2*sigo^2]},
 {"\!\(\[Sigma]\_d\)= ",sigd}},{{"\!\(y\_max\)= ",ymax},
 {"\!\(\[Omega]\_0\)= ",omega0},{"\[Gamma]= ",gamma}},
 {{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",
 sigo},{"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{yymax,ggamma,oomega0,cc,dd}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc,dd],
        {oomega0,omega01,omega01*1.01+10.^-15},
	{yymax,ymax1,ymax1*1.01+10.^-15},{ggamma,gamma1,gamma1*1.01+10.^-15},
	{cc,c1,c1*1.1+10.^-15},{dd,d1,d1*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];	
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
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

Print[results=TableForm[{{{"c= ",c+d*(omega0-omega0init)},{"d= ",d}},
 {{"\!\(\[Sigma]\_c\)= \
",Sqrt[sigc^2+(omega0-omega0init)^2*sigd^2+d^2*sigo^2]},
 {"\!\(\[Sigma]\_d\)= ",sigd}},{{"\!\(y\_max\)= ",ymax},
 {"\!\(\[Omega]\_0\)= ",omega0},{"\[Gamma]= ",gamma}},
 {{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",
 sigo},{"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
 {"\!\(\[Chi]\^2\)/(n-5) = ",1.*q[[1]]^2/(n-5)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(dd - (ggamma*oomega0*xx*(ggamma^2 - 2*oomega0^2 + 
	2*xx^2)*yymax)/(ggamma^2*xx^2 + (oomega0^2 - xx^2)^2)^(3/2))^2*sx^2);
chicode=Compile[{yymax,ggamma,oomega0,cc,dd},
	Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc,dd],
	{oomega0,omega01,omega01*1.01+10.^-15},
        {yymax,ymax1,ymax1*1.01+10.^-15},
	{ggamma,gamma1,gamma1*1.01+10.^-15},{cc,c1,c1*1.1+10.^-15},
        {dd,d1,d1*1.1+10.^-15},MaxIterations -> 100(*, WorkingPrecision -> 20 \
*)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
c=1.*cc /. q[[2,4]];
ssy=Sqrt[sy^2+(d - (gamma*omega0*xx*(gamma^2-2*omega0^2+2*xx^2)*ymax)/
	(gamma^2*xx^2 + (omega0^2 - xx^2)^2)^(3/2))^2*sx^2];

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

Print[results=TableForm[{{{"c= ",c+d*(omega0-omega0init)},{"d= ",d}},
 {{"\!\(\[Sigma]\_c\)= \
",Sqrt[sigc^2+(omega0-omega0init)^2*sigd^2+d^2*sigo^2]},
 {"\!\(\[Sigma]\_d\)= ",sigd}},{{"\!\(y\_max\)= ",ymax},
 {"\!\(\[Omega]\_0\)= ",omega0},{"\[Gamma]= ",gamma}},
 {{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",
 sigo},{"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
 {"\!\(\[Chi]\^2\)/(n-5) = ",1.*q[[1]]^2/(n-5)}}}]];

];

yff[x_] := Evaluate[yf[x] /. {yymax -> ymax, oomega0 -> omega0, 
	ggamma -> gamma, cc -> c, dd->d}];

c=c+d*(omega0-omega0init);
sigc=Sqrt[sigc^2+(omega0-omega0init)^2*sigd^2+d^2*sigo^2];
fY=fResonanceCurveLPL[];
];



(***********************************************************
		 RESONANCE CURVE FIT WITH LINEAR BACKGROUND 
	  (FOR L-C IN PARALLEL, AND THAT IN SERIES WITH R,
		   OR WITH ANY OTHER SYMMETRIC RESONANCE)
 y[omega]=
 ymax gamma omega/Sqrt[(omega^2-omega0^2)^2+(gamma omega)^2] 
 + c + d (omega -omega0)
 ***********************************************************)

ResonanceCurveSLFit[]:=Block[{x,q,stdv,chi,chicode,chi2,n1,c1,d1},

chi[yymax_Real,ggamma_Real,oomega0_Real,cc_Real,dd_Real]:=
chicode[yymax,ggamma,oomega0,cc,dd];

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(\[Omega]) = \!\(\(y\_max \[Gamma] \[Omega]\)\/\@\(\(
 (\[Omega]\^2 - \\[Omega]\_0\%2)\)\^2 + \((\[Gamma] \[Omega])\)\^2\)\) + "<>
 "c + d (\[Omega] - \!\(\[Omega]\_0\))"];

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data,ymin,ymax},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

ymin=Min[yyy];
ymax=Max[yyy];
cinit=Max[ymin/10., ymin-.25*(ymax-ymin)];
ymaxinit=ymax-cinit;
iofymaxinit=Flatten[Position[yyy,ymax]][[1]];
omega0init=xxx[[iofymaxinit]];
yyy=yyy-cinit;
Block[{q1,q2},
q2=(ymaxinit-ymaxinit/Sqrt[2.])^2;
Do[If[yyy[[i]] >= yyy[[i-1]], q2=(yyy[[i]]-ymaxinit/2.)^2,
 If[(q1=(yyy[[i]]-ymaxinit/Sqrt[2.])^2) <=q2, 
  q2=q1;, n1=i-1;Break[]]],
 {i,iofymaxinit+1,n}]];
gammainit=2.*(xxx[[n1]]-omega0init);
dinit=(yyy[[n]]-yyy[[1]])/(xxx[[n]]-xxx[[1]]);
If[dinit == 0, dinit=(yyy[[n]]*.9-yyy[[1]]*1.1)/(xxx[[n]]-xxx[[1]]);,""];
];

ClearAll[yymax,ggamma,oomega0,cc,dd];
yf[omega_]:=yymax*ggamma*omega/Sqrt[(omega^2-oomega0^2)^2+(ggamma*omega)^2]+
	cc + dd*(omega-omega0init);

chi2=(yy-yf[xx])^2;
chicode=Compile[{yymax,ggamma,oomega0,cc,dd}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc,dd],
	{oomega0,omega0init,omega0init*1.1+10.^-15},
	{yymax,ymaxinit,ymaxinit*1.1+10.^-15},
	{ggamma,gammainit,gammainit*1.1+10.^-15},{cc,cinit,cinit*1.1+10.^-15},
	{dd,dinit,dinit*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-5)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 =1.*oomega0 /. q[[2,1]];
c=1.*cc /. q[[2,4]];
d=1.*dd /. q[[2,5]];
ymax1=ymax;
gamma1=gamma;
omega01=omega0;
chiplus=Sqrt[q[[1]]^2+stdv^2];
c1=c;
d1=d;

fy[x_]:=FindMinimum[chi[x,ggamma,oomega0,cc,dd],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.1+10.^-15},
        {dd,d,d*1.1+10.^-15},MaxIterations -> 100][[1]];
fg[x_]:=FindMinimum[chi[yymax,x,oomega0,cc,dd],
        {oomega0,omega0,omega0*1.01+10.^-15},{yymax,ymax,ymax*1.01+10.^-15},
        {cc,c,c*1.1+10.^-15},{dd,d,d*1.1+10.^-15},MaxIterations -> 100][[1]];
fo[x_]:=FindMinimum[chi[yymax,ggamma,x,cc,dd],{yymax,ymax,ymax*1.01+10.^-15},
	{ggamma,gamma,gamma*1.01+10.^-15},{cc,c,c*1.1+10.^-15},
        {dd,d,d*1.1+10.^-15},MaxIterations -> 100][[1]];
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
	{x,gamma,gamma*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rso:=Abs[x-omega0] /. FindMinimum[(chi[ymax,gamma,x,c,d]-chiplus)^2,
	{x,omega0,omega0*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[ymax,gamma,omega0,x,d]-chiplus)^2,
	{x,c,c*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsd:=Abs[x-d] /. FindMinimum[(chi[ymax,gamma,omega0,c,x]-chiplus)^2,
	{x,d,d*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];

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

Print[results=TableForm[{{{"c= ",c+d*(omega0-omega0init)},{"d= ",d}},
 {{"\!\(\[Sigma]\_c\)= \
",Sqrt[sigc^2+(omega0-omega0init)^2*sigd^2+d^2*sigo^2]},
 {"\!\(\[Sigma]\_d\)= ",sigd}},{{"\!\(y\_max\)= ",ymax},
 {"\!\(\[Omega]\_0\)= ",omega0},{"\[Gamma]= ",gamma}},
 {{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",
 sigo},{"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{yymax,ggamma,oomega0,cc,dd}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc,dd],
        {oomega0,omega01,omega01*1.01+10.^-15},
	{yymax,ymax1,ymax1*1.01+10.^-15},{ggamma,gamma1,gamma1*1.01+10.^-15},
	{cc,c1,c1*1.1+10.^-15},{dd,d1,d1*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];	
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
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

Print[results=TableForm[{{{"c= ",c+d*(omega0-omega0init)},{"d= ",d}},
 {{"\!\(\[Sigma]\_c\)= \
",Sqrt[sigc^2+(omega0-omega0init)^2*sigd^2+d^2*sigo^2]},
 {"\!\(\[Sigma]\_d\)= ",sigd}},{{"\!\(y\_max\)= ",ymax},
 {"\!\(\[Omega]\_0\)= ",omega0},{"\[Gamma]= ",gamma}},
 {{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",
 sigo},{"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
 {"\!\(\[Chi]\^2\)/(n-5) = ",1.*q[[1]]^2/(n-5)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+(dd + (ggamma*(oomega0^4 - xx^4)*yymax)/
	(oomega0^4 + ggamma^2*xx^2 - 2*oomega0^2*xx^2 + xx^4)^(3/2))^2*sx^2);
chicode=Compile[{yymax,ggamma,oomega0,cc,dd},
	Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[yymax,ggamma,oomega0,cc,dd],
	{oomega0,omega01,omega01*1.01+10.^-15},
        {yymax,ymax1,ymax1*1.01+10.^-15},
	{ggamma,gamma1,gamma1*1.01+10.^-15},{cc,c1,c1*1.1+10.^-15},
        {dd,d1,d1*1.1+10.^-15},MaxIterations -> 100(*, WorkingPrecision -> 20 \
*)];
ymax=1.*yymax /. q[[2,2]];
gamma=1.*ggamma /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
c=1.*cc /. q[[2,4]];
ssy=Sqrt[sy^2 + (d+(gamma*(omega0^4 - xx^4)*ymax)/
	(omega0^4+gamma^2*xx^2-2*omega0^2*xx^2+xx^4)^(3/2))^2*sx^2];

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

Print[results=TableForm[{{{"c= ",c+d*(omega0-omega0init)},{"d= ",d}},
 {{"\!\(\[Sigma]\_c\)= \
",Sqrt[sigc^2+(omega0-omega0init)^2*sigd^2+d^2*sigo^2]},
 {"\!\(\[Sigma]\_d\)= ",sigd}},{{"\!\(y\_max\)= ",ymax},
 {"\!\(\[Omega]\_0\)= ",omega0},{"\[Gamma]= ",gamma}},
 {{"\!\(\[Sigma]\_\(y\_max\)\)= ",sigy},{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",
 sigo},{"\!\(\[Sigma]\_\[Gamma]\)= ",sigg},
 {"\!\(\[Chi]\^2\)/(n-5) = ",1.*q[[1]]^2/(n-5)}}}]];

];

yff[x_] := Evaluate[yf[x] /. {yymax -> ymax, oomega0 -> omega0, 
	ggamma -> gamma, cc -> c, dd->d}];

c=c+d*(omega0-omega0init);
sigc=Sqrt[sigc^2+(omega0-omega0init)^2*sigd^2+d^2*sigo^2];
fY=fResonanceCurveSL[];
];



(***********************************************************
                   2ND ORDER LOW PASS FILTER
  (Same as option (N) in FFIT, but different parameter 
   definitions)
 y[omega]=
 a omega0^2/Sqrt[(omega^2-omega0^2)^2+(omega0 omega / Q)^2] + c
 ***********************************************************)

SecondOrderLPFilterFit[]:= Block[{x,q,stdv,chi,chicode,chi2,n1,c1},

chi[aa_Real,QQ_Real,oomega0_Real,cc_Real]:=chicode[aa,QQ,oomega0,cc];

If[!CheckLength[], Abort[]];
ClearFit;

Print["n = ",n];
Print[funct="y(\[Omega]) = \!\(\(a \[Omega]\_0\%2\)\/\@\(\(\((\[Omega]\^ 2 - \
\[Omega]\_0\%2)\)\)\^2 + \(\((\(\[Omega]\_0 \[Omega]\)\/Q)\)\)\^2\)\) + b"];

ClearAll[aa,QQ,oomega0,cc];
yf[omega_]:=aa*oomega0^2/Sqrt[(omega^2-oomega0^2)^2+(oomega0*omega/QQ)^2] + \
cc;

(* Sorts temporarily xx and yy in increasing xx, in order to set initial
 * values.
 *)
Block[{xxx,yyy,data,ymin,ymax},
data=Transpose[Sort[Transpose[{xx,yy}]]];
xxx=data[[1]];
yyy=data[[2]];

ymin=Min[yyy];
ymax=Max[yyy];
cinit=Max[ymin/10., ymin-.25*(ymax-ymin)];
ymaxinit=ymax-cinit;
iofymaxinit=Flatten[Position[yyy,ymax]][[1]];
omega0init=xxx[[iofymaxinit]];
yyy=yyy-cinit;
Block[{q1,q2},
q2=(ymaxinit-ymaxinit/Sqrt[2.])^2;
Do[If[yyy[[i]] >= yyy[[i-1]], q2=(yyy[[i]]-ymaxinit/2.)^2,
 If[(q1=(yyy[[i]]-ymaxinit/Sqrt[2.])^2) <=q2, 
  q2=q1;, n1=i-1;Break[]]],
 {i,iofymaxinit+1,n}]];
gammainit=2.*(xxx[[n1]]-omega0init);

ainit = ymaxinit*gammainit/omega0init;
Qinit = omega0init/gammainit;
];

chi2=(yy-yf[xx])^2;
chicode=Compile[{aa,QQ,oomega0,cc}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,QQ,oomega0,cc],
	{oomega0,omega0init,omega0init*1.1+10.^-15},
	{aa,ainit,ainit*1.1+10.^-15},
	{QQ,Qinit,Qinit*1.1+10.^-15},{cc,cinit,cinit*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
stdv=1.*q[[1]]/Sqrt[(n-4)];
a=1.*aa /. q[[2,2]];
Q=1.*QQ /. q[[2,3]];
omega0 =1.*oomega0 /. q[[2,1]];
c=1.*cc /. q[[2,4]];
a1=a;
Q1=Q;
omega01=omega0;
chiplus=Sqrt[q[[1]]^2+stdv^2];
c1=c;

fa[x_]:=FindMinimum[chi[x,QQ,oomega0,cc],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{QQ,Q,Q*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];
fQ[x_]:=FindMinimum[chi[aa,x,oomega0,cc],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{aa,a,a*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];
fo[x_]:=FindMinimum[chi[aa,QQ,x,cc],{aa,a,a*1.01+10.^-15},
	{QQ,Q,Q*1.01+10.^-15},{cc,c,c*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];
fc[x_]:=FindMinimum[chi[aa,QQ,oomega0,x],
        {oomega0,omega0,omega0*1.01+10.^-15},
	{aa,a,a*1.01+10.^-15},{QQ,Q,Q*1.01+10.^-15}, 
	MaxIterations -> 100][[1]];

rsa:=Abs[x-a] /. FindMinimum[(chi[x,Q,omega0,c]-chiplus)^2,
	{x,a,a*1.01+10.^-15},MaxIterations -> 100
        (*, WorkingPrecision -> 20*)][[2]];
rsQ:=Abs[x-Q] /. FindMinimum[(chi[a,x,omega0,c]-chiplus)^2,
	{x,Q,Q*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rso:=Abs[x-omega0] /. FindMinimum[(chi[a,Q,x,c]-chiplus)^2,
	{x,omega0,omega0*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];
rsc:=Abs[x-c] /. FindMinimum[(chi[a,Q,omega0,x]-chiplus)^2,
	{x,c,c*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];

DeleteNotification;
PrintNotification["Calculating siga"];
siga = findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigQ"];
sigQ = findsig[Q,rsQ,fQ];
DeleteNotification;
PrintNotification["Calculating sigo"];
sigo = findsig[omega0,rso,fo];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc = findsig[c,rsc,fc];
DeleteNotification;
b=c;
sigb=sigc;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},
	{{"\!\(\[Sigma]\_\(a\)\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb}},
	{{"\!\(\[Omega]\_0\)= ",omega0},{"Q= ",Q}},
	{{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
	{"\!\(\[Sigma]\_Q\)= ",sigQ},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2=(yy-yf[xx])^2/sy^2;
chicode=Compile[{aa,QQ,oomega0,cc}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,QQ,oomega0,cc],
        {oomega0,omega01,omega01*1.01+10.^-15},
	{aa,a1,a1*1.01+10.^-15},{QQ,Q1,Q1*1.01+10.^-15},
	{cc,c1,c1*1.1+10.^-15},MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,2]];
Q=1.*QQ /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
c=1.*cc /. q[[2,4]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga = findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigQ"];
sigQ = findsig[Q,rsQ,fQ];
DeleteNotification;
PrintNotification["Calculating sigo"];
sigo = findsig[omega0,rso,fo];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc = findsig[c,rsc,fc];
DeleteNotification;
b=c;
sigb=sigc;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},
	{{"\!\(\[Sigma]\_\(a\)\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb}},
	{{"\!\(\[Omega]\_0\)= ",omega0},{"Q= ",Q}},
	{{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
	 {"\!\(\[Sigma]\_Q\)= ",sigQ},
	 {"\!\(\[Chi]\^2\)/(n-4)= ",1.*q[[1]]^2/(n-4)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2+((aa*oomega0^2*(2*oomega0^2*(-2+QQ^(-2))*xx+4*xx^3))/\

     (2*(oomega0^4 + oomega0^2*(-2 + QQ^(-2))*xx^2 + xx^4)^(3/2))*sx)^2);
chicode=Compile[{aa,QQ,oomega0,cc}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[aa,QQ,oomega0,cc],
        {oomega0,omega01,omega01*1.01+10.^-15},
	{aa,a1,a1*1.01+10.^-15},{QQ,Q1,Q1*1.01+10.^-15},
	{cc,c1,c1*1.1+10.^-15},MaxIterations -> 100(*, WorkingPrecision -> 20 *)];
a=1.*aa /. q[[2,2]];
Q=1.*QQ /. q[[2,3]];
omega0 = 1.*oomega0 /. q[[2,1]];
c=1.*cc /. q[[2,4]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating siga"];
siga = findsig[a,rsa,fa];
DeleteNotification;
PrintNotification["Calculating sigQ"];
sigQ = findsig[Q,rsQ,fQ];
DeleteNotification;
PrintNotification["Calculating sigo"];
sigo = findsig[omega0,rso,fo];
DeleteNotification;
PrintNotification["Calculating sigc"];
sigc = findsig[c,rsc,fc];
DeleteNotification;
b=c;
sigb=sigc;

Print[results=TableForm[{{{"a= ",a},{"b= ",b}},
	{{"\!\(\[Sigma]\_\(a\)\)= ",siga},{"\!\(\[Sigma]\_b\)= ",sigb}},
	{{"\!\(\[Omega]\_0\)= ",omega0},{"Q= ",Q}},
	{{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},
	 {"\!\(\[Sigma]\_Q\)= ",sigQ},
	 {"\!\(\[Chi]\^2\)/(n-4)= ",1.*q[[1]]^2/(n-4)}}}]];

ssy=Sqrt[sy^2+((a*omega0^2*(2*omega0^2*(-2+Q^(-2))*xx+4*xx^3))/
         (2*(omega0^4 + omega0^2*(-2 + Q^(-2))*xx^2 + xx^4)^(3/2))*sx)^2];
];

yff[x_] := Evaluate[yf[x] 
 /. {aa -> a, oomega0 -> omega0, QQ -> Q, cc -> c}];
fY=fSecondOrderLPFilter[];
];



(***********************************************************
				2nd-ORDER RESONANCE PHASE FIT 
 ***********************************************************)

ResonancePhaseDegreesCFit[] := 
Block[
{dataXY,wts,g,Dy,pars,init,type,f,d,result,chis,fit,x,q,stdv,chi,chicode,chi2, w0, t0, q0},

chi[oomega0_Real,ttheta0_Real,QQ_Real]:=chicode[oomega0,ttheta0,QQ];

If[!CheckLength[], Abort[]];
ClearFit;

(* Does phase increase or decrease at resonance? *)
type=Sign[Last[yy]-First[yy]];
g=fResonancePhaseDegreesC[type];


Print["n = ",n];
If[type > 0,
	Print[funct = "y (\[Omega]) = "<>
		"\!\(TraditionalForm\`\(\(\(\(\(tan\^\(-1\)\)\)(\(\(Q\\ \(\((\[Omega]\/\[Omega]\_0 - \[Omega]\_0\/\[Omega])\)\)\)\))\)\) + \[Theta]\_0\)\)"
	],
	Print[funct = "y(\[Omega]) = "<>
		"\!\(TraditionalForm\`\(\[Theta]\_0 - \(\(\(\(tan\^\(-1\)\)\)(\(\(Q\\ \(\((\[Omega]\/\[Omega]\_0 - \[Omega]\_0\/\[Omega])\)\)\)\))\)\)\)\)"
	]
];

Print["Fit of (x,y)  (unweighted)"];
ClearAll[oomega0,ttheta0,QQ];
yf[omega_] := g[oomega0,ttheta0,QQ][omega];
Dy[omega_]:=yf'[omega];

(* Initial estimates of parameter values *)
(* estimate of theta0, rounded to nearest 90 deg *)
theta0init = Round[Mean[{First[yy],Last[yy]}],90];
(* pick {y,x} points near t0 *)
d = Reverse/@Cases[dataXY, {_,y_}/;Abs[y-theta0init]<30];
If[Length[d] > 1,
	(* at least 2 points in the resonance region, so a line can be fit to them *)
	f = Function[{y},Evaluate[Fit[d,{1,y},y]]] (* a linear fit of freq v. phase *);
	(* estimate of omega0 (at phase = theta0init) *)
	omega0init = f[theta0init];
	(* estimate of Q *)
	Qinit = omega0init/Abs[f[theta0init+45]-f[theta0init-45]] ,

	(* handle the case where there aren't many points in the resonance region *)
	omega0init = Median[xx] (* estimate of omega0 *);
	Qinit = 100 (* estimate of Q *);
];

chi2=(yy-yf[xx])^2;
chicode=Compile[{oomega0,ttheta0,QQ}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[oomega0,ttheta0,QQ],
	{oomega0,omega0init,omega0init*1.1+10.^-15},
	{ttheta0,theta0init,theta0init*1.1+10.^-15},
	{QQ,Qinit,Qinit*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)
];
stdv = 1.*q[[1]]/Sqrt[(n-3)];
omega01 = omega0 = 1.*oomega0 /. q[[2,1]];
theta01 = theta0 = 1.*ttheta0 /. q[[2,2]];
Q1 = Q = 1.*QQ /. q[[2,3]];
chiplus=Sqrt[q[[1]]^2+stdv^2];

fo[x_]:=FindMinimum[chi[x,ttheta0,QQ],
		{ttheta0,theta0,theta0*1.1+10.^-15},{QQ,Q,Q*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];

ft[x_]:=FindMinimum[chi[oomega0,x,QQ],
		{oomega0,omega0,omega0*1.01+10.^-15},{QQ,Q,Q*1.01+10.^-15}, 
        MaxIterations -> 100][[1]];

fQ[x_]:=FindMinimum[chi[oomega0,ttheta0,x],
		{oomega0,omega0,omega0*1.01+10.^-15},{ttheta0,theta0,theta0*1.1+10.^-15}, 
        MaxIterations -> 100][[1]];

rso:=Abs[x-omega0] /. FindMinimum[(chi[x,theta0,Q]-chiplus)^2,
		{x,omega0,omega0*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];

rst:=Abs[x-theta0] /. FindMinimum[(chi[omega0,x,Q]-chiplus)^2,
		{x,theta0,theta0*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];

rsQ:=Abs[x-Q] /. FindMinimum[(chi[omega0,theta0,x]-chiplus)^2,
		{x,Q,Q*1.01+10.^-15}, MaxIterations -> 100 (*,
        WorkingPrecision -> 20 *)][[2]];

DeleteNotification;
PrintNotification["Calculating sigo"];
sigo = findsig[omega0,rso,fo];
DeleteNotification;
PrintNotification["Calculating sigQ"];
sigQ = findsig[Q,rsQ,fQ];
DeleteNotification;
PrintNotification["Calculating sigt"];
sigt = findsig[theta0,rst,ft];

Print[results=TableForm[{
	{{"\!\(\[Omega]\_0\)= ",omega0},{"\!\(\[Theta]\_0\)= ",theta0},{"Q= ",Q}},
	{{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},{"\!\(\[Sigma]\_\(\[Theta]\_0\)\)= ",sigt},
	{"\!\(\[Sigma]\_Q\)= ",sigQ},{"Std. deviation= ",stdv}}}]];

ssy=yy*0.+stdv;

If[Min[sy] > 0,  
Print["Fit of (x,y\[PlusMinus]\!\(\[Sigma]\_y\))  "];

chi2 = (yy-yf[xx])^2/sy^2;
chicode = Compile[{oomega0,ttheta0,QQ}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[oomega0,ttheta0,QQ],
	{oomega0,omega01,omega01*1.1+10.^-15},
	{ttheta0,theta01,theta01*1.1+10.^-15},
	{QQ,Q1,Q1*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)
];
omega0 = 1.*oomega0 /. q[[2,1]];
theta0 = 1.*ttheta0 /. q[[2,2]];
Q = 1.*QQ /. q[[2,3]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating sigo"];
sigo = findsig[omega0,rso,fo];
DeleteNotification;
PrintNotification["Calculating sigQ"];
sigQ = findsig[Q,rsQ,fQ];
DeleteNotification;
PrintNotification["Calculating sigt"];
sigt = findsig[theta0,rst,ft];

Print[results=TableForm[{
	{{"\!\(\[Omega]\_0\)= ",omega0},{"\!\(\[Theta]\_0\)= ",theta0},{"Q= ",Q}},
	{{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},{"\!\(\[Sigma]\_\(\[Theta]\_0\)\)= ",sigt},
	{"\!\(\[Sigma]\_Q\)= ",sigQ},{"\!\(\[Chi]\^2\)/(n-3)= ",1.*q[[1]]^2/(n-3)}}}]];

ssy=sy;
];

If[Min[sx] > 0,
Print["Fit of (x\[PlusMinus]\!\(\[Sigma]\_x\),y\[PlusMinus]\!\(\[Sigma]\_y\)) \
"];

chi2=(yy-yf[xx])^2/(sy^2 + (Dy[xx] sx)^2);
chicode = Compile[{oomega0,ttheta0,QQ}, Evaluate[Sqrt[Plus @@ chi2]]];

PrintNotification["Minimizing Chi^2"];
q=FindMinimum[chi[oomega0,ttheta0,QQ],
	{oomega0,omega01,omega01*1.1+10.^-15},
	{ttheta0,theta01,theta01*1.1+10.^-15},
	{QQ,Q1,Q1*1.1+10.^-15},
	MaxIterations -> 100(*, WorkingPrecision -> 20 *)
];
omega0 = 1.*oomega0 /. q[[2,1]];
theta0 = 1.*ttheta0 /. q[[2,2]];
Q = 1.*QQ /. q[[2,3]];
chiplus=Sqrt[q[[1]]^2+1];

DeleteNotification;
PrintNotification["Calculating sigo"];
sigo = findsig[omega0,rso,fo];
DeleteNotification;
PrintNotification["Calculating sigQ"];
sigQ = findsig[Q,rsQ,fQ];
DeleteNotification;
PrintNotification["Calculating sigt"];
sigt = findsig[theta0,rst,ft];

Print[results=TableForm[{
	{{"\!\(\[Omega]\_0\)= ",omega0},{"\!\(\[Theta]\_0\)= ",theta0},{"Q= ",Q}},
	{{"\!\(\[Sigma]\_\(\[Omega]\_0\)\)= ",sigo},{"\!\(\[Sigma]\_\(\[Theta]\_0\)\)= ",sigt},
	{"\!\(\[Sigma]\_Q\)= ",sigQ},{"\!\(\[Chi]\^2\)/(n-3)= ",1.*q[[1]]^2/(n-3)}}}]];

ssy = Sqrt[sy^2 + (Dy[xx] sx)^2];
];

yff[x_] := Evaluate[yf[x] 
 /. {oomega0 -> omega0, QQ -> Q, ttheta0 -> theta0}];
fY=g[];


];



(***********************************************************)
End[]; (* `Private` *)

