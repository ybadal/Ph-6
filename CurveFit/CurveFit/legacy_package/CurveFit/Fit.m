(* ::Package:: *)

(* Copyright 1997-2007 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Fit.m - Fitting routine definitions *)

(* 
Each predefined fitting function has two routines:
   <function>Fit and f<function>[], where <function> is the name
	of the fitting function, such as: SlopeFit and fSlope[].

The <function>Fit routine performs chi-squared minimization to
determine the best-fit parameter values, and sets the values
of the several fitting parameters it uses to the values found.

The f<function>[] routine defines a function of one variable to
calculate y[x] based on either the best-fit parameter values or
parameter values supplied by the user. 
*)

(*
This file includes the common definitions for fitting parameters
and then includes the several files which contain the fit code.
*)


(***********************************************************)
(* Private variables used to share data among routines *)

Begin["`Private`"];

chiplus::usage = "Used in parameter sigma calculations.";

(* generated by fitting routines, used by plots of fit results *)
funct::usage = "The function expression for the fit.";
yff::usage = "yff[x] is the fit defined by a fitting function.";
ssy::usage = "A list of the effective uncertainties (including sx).";

End[]; (* `Private` *)



(***********************************************************)
(* usages *)

(* a categorized list of the names of the fitting functions *)
FitList::usage = "A categorized list of the names of the "<>
"fitting functions used to generate the CurveFit palette menu "<>
" of fits.";

(* results from the latest fit *)
FitResults::usage = "Gives a formatted printout of "<>
"the parameter values, sigmas, and \!\(\*SuperscriptBox[\"\[Chi]\", \"2\"]\) from the latest fit to the "<>
" data.";

(* The function which results from the latest fit *)
fY::usage = "The function fY[x] is the result of the latest "<>
"fit to the data.";

(* The parameters used for fitting functions; *)
(* set by the fitting routines *)
a::usage =
b::usage =
c::usage =
d::usage =
e::usage =
gamma::usage =
omega0::usage =
ymax::usage =
tau::usage =
Q::usage =
mean::usage =
sigma::usage =
xMinimum::usage =
theta0::usage =
"A parameter variable set by a fitting routine to "<>
"best fit the data.";

siga::usage =
sigb::usage =
sigc::usage =
sigd::usage =
sige::usage =
sigg::usage =
sigo::usage =
sigy::usage =
sigtau::usage =
sigQ::usage =
sigmean::usage =
sigsigma::usage =
sigt::usage =
"The uncertainty in a parameter value found by a "<>
"fitting routine";

(* These parameters must be set by the user; *)
(* needed for some fitting routines *)
region1;
region2;



(***********************************************************)
(* Function usages *) 

ClearFit::usage="Clears the values of all fit "<>
"parameters, fY, and fit plots.";



Begin["`Private`"];



(***********************************************************)
(* ClearFitParameters *)

ClearFit := 
(Clear[
CurveFit`a,
CurveFit`b,
CurveFit`c,
CurveFit`d,
CurveFit`e,
CurveFit`gamma,
CurveFit`omega0,
CurveFit`ymax,
CurveFit`tau,
CurveFit`Q,
CurveFit`mean,
CurveFit`sigma,
CurveFit`xMinimum,
CurveFit`theta0,
CurveFit`siga,
CurveFit`sigb,
CurveFit`sigc,
CurveFit`sigd,
CurveFit`sige,
CurveFit`sigg,
CurveFit`sigo,
CurveFit`sigy,
CurveFit`sigtau,
CurveFit`sigQ,
CurveFit`sigmean,
CurveFit`sigsigma,
CurveFit`sigt,
CurveFit`fY,
CurveFit`Private`chiplus,
CurveFit`Private`funct,
CurveFit`Private`results,
CurveFit`Private`yff,
CurveFit`Private`ssy
];CurveFit`ClearFitPlots;);

ClearFit;



(***********************************************************)
(* FitResults *)

FitResults := CurveFit`Private`results



(***********************************************************)
(* Error messages *)



(***********************************************************)
(* findsig[]. Used by the fitting routines *)

(* FINDING THE SIGMA GIVEN THE VALUE OF THE VARIBLE AND
 * ITS ROUGH SIGMA
 * In order to find siga, we first find the lower bound by minimizing
 * (chi[a+x,b]-chiplus)^2, (i.e. minimizing chi with the other
 * variables fixed, and not reminimized at each a+x. )
 * From that rsa (rough-sigma-a), we then move in steps of 10, 
 * i.e. rsa*10, rsa*100, etc. till fa[a+rsa*10^i] > chiplus.
 * now we found the order of magnitude of siga. (i.e. rsa is within 
 * a factor of 10 of the actual siga.)
 * Now, we proceed with steps of rsa. i.e. rsa, rsa*2, rsa*3... etc.
 * till we again stop at fa[a+rsa*i] > chiplus.
 * Now we have bracketed siga with a range of width rsa.
 * (e.g. siga is within 4*rsa and 5*rsa.)
 * So now we take the 3 points: 4*rsa, 4.5*rsa, 5*rsa and we fit a
 * parabola through them, we extrapolate where it intercepts chiplus
 * and we have our siga. This procedure gives siga wit accuracy of
 * at least  2 significant digits which is actually all we want. 
 * Test with the code which uses explicitly the routine FindRoot to solve 
 * for x: fa[a+x]=chiplus, gave the same errors for the parameters in all
 * the data sets tried.
 *)

findsig[a_,rsaa_,fa_]:=Block[{rs,x1,x2,x3,f1,f2,f3,e1,e2,e3},
rs=Sign[a]*rsaa/10;
Do[rs=rs*10;If[fa[a+rs*10] >  chiplus,Break[]],{i,20}];
f3=fa[a+rs];
Do[f1=f3;If[ (f3=fa[a+rs*i]) > chiplus,
x1=rs*(i-1);
x2=rs*(i-.5);
x3=rs*i;
f2=fa[a+x2];
e1=(f3*x1*(x1-x2)*x2+x3*(f1*x2*(x2-x3)+f2*x1*(-x1+x3)))/
((x1-x2)*(x1-x3)*(x2-x3));
e2=(f3*(-x1^2+x2^2)+f2*(x1^2-x3^2)+f1*(-x2^2+x3^2))/
((x1-x2)*(x1-x3)*(x2-x3));
e3=(f3*(x1-x2)+f1*(x2-x3)+f2*(-x1+x3))/
((x1-x2)*(x1-x3)*(x2-x3));
Break[];],{i,2,10}];
Abs[(-e2+Sign[a]*Sqrt[e2^2+4*e3*(chiplus-e1)])/2/e3]
];



(***********************************************************)
End[]; (* `Private` *)



(***********************************************************)
(* Load the fit function definitions *)

FitList={};

Get[ToFileName[{"CurveFit","FitFiles"}, "Fit1.m"]];
Get[ToFileName[{"CurveFit","FitFiles"}, "Fit2.m"]];
Get[ToFileName[{"CurveFit","FitFiles"}, "Fit3.m"]];
Get[ToFileName[{"CurveFit","FitFiles"}, "Fit4.m"]];
