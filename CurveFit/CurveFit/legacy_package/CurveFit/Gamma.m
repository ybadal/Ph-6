(* ::Package:: *)

(* Copyright 1997-2011 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* Gamma.m - gamma spectrum and other histogram data manipulations *)



(***********************************************************)
(* Function usage messages *)

MakePoisson::usage = "MakePoisson[] sets \[Sigma]y uncertainties by "<>
 "assuming that Y values are counts obeying Poisson statistics. "<>
 "It sets the sy array values to \!\(\*SqrtBox[\"Y\"]\), except that if Y is zero or "<>
 "less, it sets the corresponding sy = 1.\n\n"<>
 "If option Xerrors \[RightArrow] True (the default), estimate sx as \n"<>
 "  sx = \[CapitalDelta]X / (sy \!\(\*SqrtBox[\"12\"]\)) \n\n"<>
 "Options: see help for Xerrors (default True)";

RemoveEmptyBins::usage = "RemoveEmptyBins[] removes those data "<>
 "points which have Y \[LessEqual] 0.";

RestoreEmptyBins::usage = "RestoreEmptyBins[] assumes that X values "<>
 "represent integer channels which originally started at 0 and "<>
 "included a total number of channels which was a power of 2. It "<>
 "inserts empty channels with integer X among the existing ones "<>
 "to restore this channel count. The \[Sigma]y and \[Sigma]x of each added channel "<>
 "are set to 0.";

Rebin::usage = "ReBin[k] (with k a positive integer) sorts then partitions the "<>
 "data into disjoint sets of k channels. If the number of data points "<>
 "is not divisible by k, the last few points in the set will be dropped. \n\n"<>
 "The Y values for each of the sets are summed: \nY = \!\(\*SubscriptBox[\"\[CapitalSigma]Y\", \"i\"]\) (using error "<>
 "propagation to get \[Sigma]y).\n\n"<>
 "A weighted mean of the X "<>
 "values of each set is calculated using the Y values as weights: \n"<>
 "X = \[Sum](\!\(\*SubscriptBox[\"Y\", \"i\"]\)\!\(\*SubscriptBox[\"X\", \"i\"]\))/\!\(\*SubscriptBox[\"\[CapitalSigma]Y\", \"i\"]\) \n\n"<>
 "An estimate of \[Sigma]x is determined by error propagation of the formula for X. \n\n"<>
 "The data set is replaced with these new X,Y values and their uncertainties. The "<>
 "resulting data set will have k times fewer channels, with roughly k times "<>
 "as many values per channel summed to give better statistics in each channel. \n\n"<>
 "Options: see help for Averaging (default False), Xerrors (default True)";

Averaging::usage = "An option for Rebin which has the following effect: \n\n"<>
 "Averaging \[RightArrow] True: divide the resulting Y and \[Sigma]Y by the number of bins per "<>
 "set to preserve rates or intensities. \n"<>
 "Averaging \[RightArrow] False: just sum the Y values without dividing by the number of "<>
 "bins per set.";

Xerrors::usage = "An option for functions such as Rebin and MakePoisson which "<>
 "determines whether \[Sigma]x values should be calculated, or just set to 0: \n\n"<>
 "Xerrors \[RightArrow] True: estimate \[Sigma]x values \n"<>
 "Xerrors \[RightArrow] False: set \[Sigma]x to 0 (Rebin) or leave alone (MakePoisson)";



Begin["`Private`"];



(***********************************************************)
(* Error messages *)

Rebin::unknown = "Incorrect choice of arguments `1`.";



Options[MakePoisson] = {
	Xerrors -> True
};

MakePoisson[OptionsPattern[]]:= 
Block[{sxFlag},
	If[!CheckLength[], Return[] ];
	sxFlag = OptionValue[Xerrors];
	(* SaveForUndo[]; Don't need this... SortData[] calls SaveForUndo[] *)
	SortData[];
	sy = Sqrt[Map[Max[#,1.0]&,yy]];
	Print[n, " Y count values have had sigma values assigned."];
	If[sxFlag,
		sx = Differences[xx];
		sx = (Prepend[sx,First[sx]]/Sqrt[12.])/sy;
		Print[n, " X channel values have had sigma values assigned."]
	];
]


RemoveEmptyBins[]:=(
	If[!CheckLength[], Return[] ];
	SaveForUndo[];
	{yy,xx,sx,sy} = Transpose[
		Select[Transpose[{yy,xx,sx,sy}], First[#] > 0 &]
	];
	Print[n - Length[xx], " channels removed."];
	n = Length[xx];
)


RestoreEmptyBins[]:=
Block[{x,y,xs,ys,m,f},
	If[!CheckLength[], Return[] ];
	SaveForUndo[];
	xx = Floor[xx];
	x = Range[0, 2^Ceiling[Log[2,Max[xx]]]-1];
	m = Length[x];
	y = ConstantArray[0.0,m];
	xs = ys = ConstantArray[0,m];
	f[{xv_,yv_,sxv_,syv_}]:= If[xv >= 0,
		y[[xv+1]] = yv;
		xs[[xv+1]] = sxv;
		ys[[xv+1]] = syv
	];
	Scan[f,Transpose[{xx,yy,sx,sy}]];
	Print[m - n, " channels added."];
	{xx, yy, sx, sy, n} = {1.0 x, y, xs, ys, m};
]


Options[Rebin] = {
	Averaging -> False,
	Xerrors -> True
};

Rebin[k_Integer/;k > 1, OptionsPattern[]]:=
Block[{listX, listY, listVX, listVY, f, avg, sxFlag},
	If[!CheckLength[], Return[] ];
	SaveForUndo[];

	avg = OptionValue[Averaging];
	sxFlag = OptionValue[Xerrors];

	{xx,yy,sx,sy} = Transpose[Sort[Transpose[{xx,yy,sx,sy}]]];
	listX = Partition[xx,k];
	listY = Partition[yy,k];
	listVX = Partition[sx^2,k];
	listVY = Partition[sy^2,k];

	yy = Total/@listY;
	sy = 1.0 Sqrt/@Total/@listVY;
	If[avg, yy /= k; sy /= k];

	f[x_List, y_List, vx_List, vy_List]:= Block[{X, SX, Y = Total[y]},
		X = If[Y != 0,
				Dot[x,y]/Y,
				(First[x]+Last[x])/2.
			];
		SX = If[Y != 0, 
				Sqrt[Dot[y^2,vx]+Dot[(x-X)^2,vy]]/Y,
				(k/(k-1))(Last[x]-First[x])/Sqrt[12.]
			];
		{X,SX}
	];
	{xx,sx} = Transpose[MapThread[f, {listX, listY, listVX, listVY}]];
	n = Length[xx];
	Print["Rebinned data by a factor of ",k," to get ",n," data points."]
]

Rebin[badargs___]:=(
	Message[Rebin::unknown, {badargs}];
	Message[Rebin::usage];
)



(***********************************************************)
End[]; (* `Private` *)

