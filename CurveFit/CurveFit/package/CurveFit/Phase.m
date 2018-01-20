(* ::Package:: *)

(* Copyright 1997-2009 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Phase.m - phase and frequency data manipulations *)



(***********************************************************)
(* Function usage messages *)

UnwrapPhaseDeg::usage = "UnwrapPhaseDeg[] converts Y phase "<>
 "data (in degrees) (stored in the yy array) so that it doesn't wrap "<>
 "in value between +180 and -180 degrees, so that small phase data "<>
 "errors don't result in large (360 degree) discontinuities in the data.";

UnwrapPhaseRad::usage = "UnwrapPhaseRad[] converts Y phase "<>
 "data (in radians) (stored in the yy array) so that it doesn't wrap "<>
 "in value between +\[Pi] and -\[Pi], so that small phase data "<>
 "errors don't result in large (2\[Pi]) discontinuities in the data.";

DegToRad::usage = "DegToRad[] converts Y phase "<>
 "data (in degrees) (stored in the yy array) to radians by multiplying "<>
 "each value by \[Pi]/180. Also scales sy uncertainties.";

RadToDeg::usage = "RadToDeg[] converts Y phase "<>
 "data (in radians) (stored in the yy array) to degrees by multiplying "<>
 "each value by 180/\[Pi]. Also scales sy uncertainties.";

HzToRadPerSec::usage = "HzToRadPerSec[] converts X frequency "<>
 "data (in Hertz) (stored in the xx array) to radians/sec by "<>
 "multiplying each value by 2\[Pi]. Also scales sx uncertainties.";

RadPerSecToHz::usage = "RadPerSecToHz[] converts X frequency "<>
 "data (in radians/sec) (stored in the xx array) to Hertz by "<>
 "dividing each value by 2\[Pi]. Also scales sx uncertainties.";



Begin["`Private`"];



UnwrapPhaseDeg[]:=(
SaveForUndo[];
 (* yy[[1]], and then phase increments: *)
yy = Prepend[ListConvolve[{1,-1},yy], First[yy]];
(* Unwrap a phase increment if it is more than +/-300 degrees *)
yy = Function[{y},
		If[y > 300, Mod[y,360]-360, If[y < -300, Mod[y,-360]+360,y]]
	] /@ yy;
(* convert increments back into accumulated phases *)
yy = Accumulate[yy];
Print[n, " Y phase values converted."];
)


UnwrapPhaseRad[]:=(
SaveForUndo[];
 (* yy[[1]], and then phase increments: *)
yy = Prepend[ListConvolve[{1,-1},yy], First[yy]];
(* Unwrap a phase increment if it is more than +/-5 radians *)
yy = Function[{y},
		If[y > 5, Mod[y,2 Pi]-2 Pi, If[y < -5, Mod[y,-2 Pi]+2 Pi,y]]
	] /@ yy;
(* convert increments back into accumulated phases *)
yy = Accumulate[yy];
Print[n, " Y phase values converted."];
)


RadToDeg[]:=(
SaveForUndo[];
yy /= (1.0 Degree);
sy /= (1.0 Degree);
Print[n, " Y phase values converted."];
)


DegToRad[]:=(
SaveForUndo[];
yy *= (1.0 Degree);
sy *= (1.0 Degree);
Print[n, " Y phase values converted."];
)


RadPerSecToHz[]:=(
SaveForUndo[];
xx /= (2.0 Pi);
sx /= (2.0 Pi);
Print[n, " X frequency values converted."];
)


HzToRadPerSec[]:=(
SaveForUndo[];
xx *= (2.0 Pi);
sx *= (2.0 Pi);
Print[n, " X frequency values converted."];
)


(***********************************************************)
End[]; (* `Private` *)

