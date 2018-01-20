(* ::Package:: *)

(* Copyright 1997-2012 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit.m *)
(* The code assumes that we are already in the CurveFit` context. *)

(* FileIO.m - Loading and Saving data *)



(***********************************************************)
(* Usage messages *)

CommentDelimiters::usage = "An option for LoadFile and SaveFile which specifies a list of "<>
"strings which are recognized to identify comments in a data file. "<>
"A comment extends from a delimiter string to the end of its line in the file. "<>
"Only characters on a line before a comment delimiter will be interpreted as data. "<>
"LoadFile will search the data file for all strings in the CommentDelimiters list; any "<>
"of the strings will identify a comment. "<>
"A \"comment line\" is any line whose first non-whitespace string is a comment delimiter. "<>
"A group of consecutive comment lines at the beginning of a data file will be interpreted "<>
"as a file header identifying the file contents and will be loaded along with the data. "<>
"The file header is associated with the data set; it is stripped of the beginning delimiters "<>
"and saved to the CurveFit variable DataFileHeader.\n\n"<>
"SaveFile prefixes the first string in CommentDelimiters to each line of DataFileHeader and "<>
"prepends the result to the data file it creates.\n\n"<>
"If not specified, the default list of comment delimiter strings is $CommentDelimiters.\n"<>
"See also: LoadFile, SaveFile, $CommentDelimiters, SkipLines, DataFileHeader";

$CommentDelimiters::usage =
"The default list of comment delimiters in data files.\n"<>
"See also: CommentDelimiters, LoadFile, SaveFile";

SkipLines::usage = "An option for LoadFile which tells it to skip "<>
"one or more lines of the file before reading the data values. Use "<>
"this option if the data file has a comment header, but does not use "<>
"comment delimiters to identify it. \n\n"<>
"SkipLines->n (where n is a positive integer): \n"<>
"The first n lines make up the comment header.  \n\n"<>
"SkipLines->\"string\" (where \"string\" is a character string): \n"<>
"Starting from the beginning of the file, the longest character "<>
"string (which may include many lines) which ends with the line containing \"string\" "<>
"makes up the comment header; lines following that line make up "<>
"the data. The delimiter \"string\" should contain no whitespace "<>
"characters and must be located within a single line of the file. \n\n"<>
"SkipLines->{\"string_1\", \"string_2\", etc.} (a list of character strings): \n"<>
"Starting from the beginning of the file, the longest character "<>
"string (which may include many lines) which ends with the line containing any of the \"string_i\" "<>
"makes up the comment header; lines following that line make up "<>
"the data. The delimiters \"string_i\" should contain no whitespace "<>
"characters and must be located within a single line of the file. \n\n"<>
"SkipLines->0 (the default) or SkipLines->\"\": \n"<>
"Use comment delimiters to identify comment strings.\n\n"<>
"Note that the comment header will end with the LAST OCCURRENCE of the specified string in "<>
"the data file. Any comments in the remainder of the file are identified by the strings in "<>
"CommentDelimiters and will be ignored as usual, but will not be included in the saved "<>
"header information.\n\n"<>
"See also: LoadFile, CommentDelimiters";

Nonstandard::usage = "An option for LoadFile[ ] which tells it that the data in the file to "<>
"load is not organized in the standard way: columns of X, Y, sigma-Y, and sigma-X values.\n\n"<>
"Nonstandard->False (the default): the data in the file has 1 to 4 columns which should be "<>
"interpreted in the standard way (as described in the information for LoadFile). If there "<>
"are more than 4 colulmns, then LoadFile will open a dialog box to allow you to select "<>
"which columns to use when loading the data set.\n\n"<>
"Nonstandard -> True: the data values are arranged in a nonstandard way, and LoadFile must "<>
"call another routine to sort through the data and correctly assign X, Y, sigma-X and sigm-Y. "<>
"the routine to use is identified by the option DataFunction. The default behavior is to "<>
"open a column selector dialog box.\n\n"<>
"Note that LoadFile always expects a basic text (ASCII) file with whitespace-separated, "<>
"C-style data values. It strips comments and identifies the file comment header before "<>
"calling the DataFunction routine.\n\n"<>
"See also: LoadFile, DataFunction";

LoadFile::usage = "LoadFile[filename] or LoadFile[filename, options] loads "<>
"data (in ASCII text form) from the file named in the string filename. The "<>
"file will be loaded from the current working directory (given by the "<>
"function: Directory[ ]) unless filename includes a path specification."<>
"Valid options and their default settings are: \n\n"<>
"  CommentDelimiters -> $CommentDelimiters \n"<>
"  MergeFile -> False \n"<>
"  SkipLines -> 0 \n"<>
"  Sorting -> True \n"<>
"  Nonstandard -> False \n"<>
"  DataFunction -> Identity \n\n"<>
"LoadFile[ ] or LoadFile[options] (no file name given) uses the file name "<>
"of the last file loaded or saved, as defined by the value of "<>
"DataFileName. \n\n"<>
"Files should be basic text (ASCII) format. The data within the file must "<>
"be arranged as columns of numbers separated by whitespace or commas (commas will be "<>
"converted to tabs, so whitespace and commas may be mixed). Lines may end with comments delimited "<>
"by strings specified by the option CommentDelimiters; data must preceed any "<>
"comment delimiter string on a line. Blank lines or lines containing only comments "<>
"within the data lines are ignored.\n\n"<>
"Data in a standard file may be arranged in 1 column to 4 columns, "<>
"but lines of data in a particular file must all have the same number of columns. The interpretation "<>
"of the columns for these various cases is:\n"<>
"\t1 column:\t Y only (X is assigned integer values from 1 to N)\n"<>
"\t2 column:\t X  Y\n"<>
"\t3 column:\t X  Y  Sigma-Y\n"<>
"\t4 column:\t X  Y  Sigma-Y  Sigma-X\n\t(note the order of Sigma-Y and Sigma-X!)\n"<>
"See the information "<>
"about options Nonstandard and DataFunction for advice on how to load data "<>
"from files with a different column arrangement. \n\n"<>
"The first several lines of the "<>
"file may contain header information describing the data; the header comments "<>
"are saved as part of the data set and may be accessed using the CurveFit variable "<>
"DataFileHeader. "<>
"The header lines may be differentiated from the data using a variety of "<>
"methods; see the information for options CommentDelimiters and SkipLines for details.\n\n "<>
"See also: \n"<>
"CommentDelimiters, MergeFile, SkipLines, Nonstandard, DataFunction, Sorting, "<>
"Directory, DataFileName, DataFileHeader" ;

DataFunction::usage="DataFunction is an option for LoadFile[ ] which provides an "<>
"alternate routine for sorting the loaded file's data values into X, Y, sigma-X, and "<>
"sigma-Y lists. The option Nonstandard -> True tells LoadFile to use this alternate "<>
"method. The default is DataFunction -> Identity, which tells LoadFile "<>
"to open a column selection dialog box so the correct column assignments may be made "<>
"interactively.\n\n"<>
"DataFunction -> ColumnSelect[X, Y, SY, SX]\n (where X, Y, SY, and SX are "<>
"all nonnegative integers) tells LoadFile to use the specified column numbers for "<>
"the respective data values, so that, for example, ColumnSelect[1,2,3,4] would assign "<>
"the data columns in the standard way. Using 0 for X would assign integer values from 1 "<>
"to N to X, as with standard 1-column data files. Using 0 for either SX or SY would "<>
"assign all zeros to that uncertainty. Using 0 for Y would assign integers 1 to N, as "<>
"with X.\n\n"<>
"Note that both of the methods described above require that all rows of data in the file "<>
"have the same number of columns.\n\n"<>
"To create a custom assignment method, create a function and pass its name to LoadFile "<>
"using the DataFunction option, such as:\n Nonstandard -> True, DataFunction -> MyFunc\n"<>
"LoadFile will call the function as follows:\n\n"<>
" MyFunc[datavalues, file, header]\n"<>
"datavalues = {{d11, d12, d13, ..},{d21, d22, ..},{d31, ..},..}\n"<>
"(datavalues is a list, each member of which is a list of the data values in one row)\n"<>
"file = string file name argument to LoadFile[ ]\n"<>
"header = string containing the comment header lines in the file\n\n"<>
"If all goes well, your function should return the following data structure:\n"<>
"{num, {Xlist, Ylist, sigmaYlist, sigmaXlist}} (note order of sigma lists!)\n"<>
"num = number of data points (length of each list), or = 0 if conversion failed\n"<>
"Xlist = vector of all X values (each member must be a (real) number)\n"<>
"Ylist = vector of all Y values\n"<>
"sigmaYlist = vector of all Y uncertainties, or all 0's if no uncertainties assigned\n"<>
"(ditto for sigmaXlist)\n\n"<>
"All lists must have the same length, which must equal the value of num. Corresponding "<>
"elements of the various lists define a data point\n"<>
"(so that Transpose[{Xlist,Ylist,sigmaYlist,sigmaXlist}] is a list of data points with "<>
"associated uncertainties). If the user cancels the conversion, the the function should "<>
"return $Canceled.\n\n"<>
"Note that this option is ignored unless the option: Nonstandard -> True is included.\n\n"<>
"See also: LoadFile, Nonstandard";

ColumnSelect::usage = "ColumnSelect[X, Y, SY, SX] is an option value for the LoadFile "<>
"option DataFunction. The arguments X, Y, SY, and SX must all be nonnegative integers. "<>
"Use this by including:\n Nonstandard -> True, DataFunction -> ColumnSelect[X, Y, SY, SX]\n"<>
"as option arguments to LoadFile, which will allow you to override the standard data column "<>
"assignments in the file you wish to load, as described in the information for DataFunction.\n\n"<>
"See also: LoadFile, DataFunction, Nonstandard";

MergeFile::usage = "An option for LoadFile[ ] which determines whether the file contents replace "<>
"the current data or are merged into the current data. If MergeFile -> False, (the default) then "<>
"the current data set is replaced by the contents of the file. If MergeFile -> True is included "<>
"as an option to LoadFile[ ], then the file contents are merged with the current data to form a "<>
"new, larger, combined data set. The resulting data set is sorted by X value.\n\n"<>
"See also: LoadFile, MergeData";

SaveFile::usage = "SaveFile[filename, header] saves the data (xx, yy, sy, sx) in tab-"<>
"separated columns in the standard order (suitable for input by LoadFile[ ]) "<>
"using the String filename to identify the file. If the file already "<>
"exists, you will get a dialog box asking if you wish to overwrite. The second "<>
"argument (header) is optional. If present, it is a string containing lines of "<>
"comment text you wish to put at the beginning of the file. SaveFile will prefix "<>
"each line of the header with a comment delimiter string. The delimiter may be specified "<>
"using the option CommentDelimiters; if not specified the value of $CommentDelimiters will "<>
"be used. If the option gives a list of strings, the first string in the list will be used. "<>
"Use: SaveFile[filename, DataFileHeader] to save the current data with its associated header.\n\n"<>
"Note: saved data is sorted in increasing x order. \n\n"<>
"SaveFile[ ] is the same as SaveFile[DataFileName, DataFileHeader]\n\n"<>
"See also: LoadFile, CommentDelimiters, DataFileName, DataFileHeader";

EditHeader::usage="EditHeader[ ] opens a dialog to edit the data file "<>
 "header (a block of comment lines at the beginning of the data file). "<>
 "It uses the current header string (see DataFileHeader) as the initial "<>
 "string to be edited. \n\n"<>
 "EditHeader[string] uses the argument as the initial string to be edited. \n\n"<>
 "The function returns the new header string, or $Canceled if the dialog is "<>
 "canceled. Any changes to the header string may be reversed after exiting "<>
 "the dialog by using Undo[ ]. \n\n"<>
 "See also: DataFileHeader, $CommentDelimiters";

CFloatRegExp::usage = "CFloatRegExp is a regular expression representing "<>
"a C-style number with optional exponent";

CtoNumber::usage = 
"CtoNumber[string] converts a C-style number string into a Mathematica number value";

FreqResp::usage = "FreqResp is an option value for the LoadFile "<>
"option DataFunction. It is provides the capability for LoadFile to extract various data "<>
"relations from files generated by the Frequency Response application's \"save all\" "<>
"method. These files have 11 data columns storing input and response amplitudes and "<>
"phases v. frequency, along with their uncertainties.\n\n"<>
"The FreqResp method will display a dialog box allowing the user to select from various "<>
"data choices for extraction from the file, such as gain magnitude, phase, real part, or "<>
"imaginary part.\n\n"<>
"To use this method, call LoadFile with options:\n"<>
"Nonstandard -> True, DataFunction -> FreqResp\n\n"<>
"See also: LoadFile, Nonstandard, DataFunction";

LoadTekFile::usage = "LoadTekFile[filename] loads Tektronix Oscilloscope single-channel "<>
"data from the file named in the string filename. The data must be in .csv or .tsv format, "<>
"generated by the Tektronix \"OpenChoice Desktop\" application software. "<>
"The file will be loaded from the current working directory (given by the "<>
"function: Directory[ ]) unless filename includes a path specification.";


Begin["`Private`"];



(***********************************************************)
(* Error messages *)

CommentDelimiters::unknown =
"CommentDelimiters must be a list of strings, not `1`. Using `2`";

SkipLines::unknown =
"SkipLines must be a nonnegative integer, a string, or a list "<>
"of strings, not `1`. Using `2`";
SkipLines::missing =
"Could not find the string or strings `1` in the file \"`2`\". "<>
"Check the file format.";
SkipLines::toolong =
"The value for SkipLines (`1`) exceeds the number of lines in file "<>
"\"`2`\". Check the file format.";

Nonstandard::unknown = "Nonstandard must be True or False, not `1`. Using `2`";

LoadFile::missing = "File \"`1`\" does not exist in `2`.";
LoadFile::column = "File does not have the same number of data values in each "<>
	"row, i.e. is not in matrix form.";
LoadFile::sorted = "Data sorted in increasing x order.";
LoadFile::warnsorted = "Warning:  The data is not sorted in increasing x order.";
LoadFile::empty = "Specified file doesn't contain any data.";
LoadFile::unknown = "Incorrect arrangement of arguments `1`.";
LoadFile::conversion = "Data conversion failed. Check that DataFunction `1` is "<>
"properly defined and the file has the proper data arrangement for it.";

MergeFile::unknown = "Option MergeFile must be either True or False, not `1`. Using `2`.";

ColumnSelect::columns = "At least one line of \"`1`\" has fewer than the required `2` data values";
ColumnSelect::arguments = "ColumnSelect[ ] requires 4 nonnegative integer arguments.";

SaveFile::unknown = "Incorrect arrangement of arguments `1`.";

FreqResp::format = "File should have been generated by the Frequency Response application "<>
"\"save all\" option; each row of data should have 11 values.";

LoadTekFile::conversion = "Data conversion failed. File \"`1`\" is not a properly-formatted "<>
"Tektronix single-channel waveform data file.";


(***********************************************************)
(* Default variable settings *)

$CommentDelimiters = {"# ","#","S ","S"};



(***********************************************************)
(* EditHeader[] *)

EditHeader[s_String]:=
Module[{r},
	r = InputString[
		Style["Use <shift><enter> to insert a line break at the end of "<>
			"any lines you add.\n\n"<>
			"After you exit this dialog, you may use Undo[ ] to restore  "<>
			"the original header.",
			Larger
		],
		s,
		WindowSize->{Automatic,All},
		FieldSize->120,
		WindowTitle->"Edit Data Header",
		WindowFloating->True
	];
	If[r === $Canceled, Return[$Canceled]];
	SaveForUndo[];
	DataFileHeader = r
]

EditHeader[]:= EditHeader[DataFileHeader]



(***********************************************************)
(* CFloatRegExp, CtoNumber[] *)

CFloatRegExp = 
RegularExpression[ "[+-]?([0-9]+[.]?[0-9]*|[.][0-9]+)([eE][+-]?[0-9]+)?"];

CtoNumber[s_String] := ToExpression[StringReplace[s, {"E" -> " 10^", "e" -> " 10^"}]]



(***********************************************************)
(* LoadFile[] *) 

Options[LoadFile] = {
	CommentDelimiters :> $CommentDelimiters,
	MergeFile -> False,
	SkipLines -> 0,
	Sorting -> True,
	Nonstandard -> False,
	DataFunction -> Identity
};

LoadFile[file_String, OptionsPattern[]] := 
Block[
{selectQ, selector, sorting, merging, skip, delims, lines, hdr, data, 
num, cols, values, X, Y, sX, sY, result},

(* set up option values *)
selectQ = OptionValue[Nonstandard];
selector = OptionValue[DataFunction];
sorting = OptionValue[Sorting];
delims = OptionValue[CommentDelimiters];
merging = OptionValue[MergeFile];
skip = OptionValue[SkipLines];

(* test option values for validity *)
If[selectQ,,,
	Message[Nonstandard::unknown, selectQ, False]; selectQ = False
];
If[sorting,,,
	Message[Sorting::unknown,sorting,True]; sorting = True
];
If[merging,,,
	Message[MergeFile::unknown,merging,False]; merging = False
];
If[MatchQ[delims,_String], delims = {delims}];
If[!MatchQ[delims,{___String}],
	Message[CommentDelimiters::unknown, delims, {"#","S","E"}]; delims = {"#","S","E"}
];
If[!(MatchQ[skip, _String]||MatchQ[skip, {__String}]||(MatchQ[skip,_Integer]&& skip>= 0)),
	Message[SkipLines::unknown, skip, 0]; skip = 0
];

(* ensure file exists and has some data. Get the file as lines of text *)
If[FileNames[file] == {}, Message[LoadFile::missing, file, Directory[]]; Abort[]];
lines = Import[file, {"Text", "Lines"}];
If[Length[lines] == 0, Message[LoadFile::empty]; Abort[]];

(* identify the header *)
StripHdr[];
Print[file];
hdr = 
	If[Length[hdr] > 0, 
		Transpose[{hdr, ConstantArray["\n", Length[hdr]]}] //Flatten //StringJoin,
		""
	];
If[hdr =!= "",
	Print["File comment header:"];
	Print[hdr]
];

(* now for the data! *)
values = ParseData[];
If[Length[values] == 0, Message[LoadFile::empty]; Abort[]]; 

If[!selectQ,
	(* handle standard file formats first *)
	If[!MatrixQ[values], Message[LoadFile::column]; Abort[]];
	{num, cols} =  Dimensions[values];
	result =
		If[cols > 4,
			(* too many columns, so call the column selector dialog *)
			LoadColumnDialog[values,file,hdr],
			(* otherwise interpret columns in the standard way *)
			values = Transpose[values];
			Switch[ cols,
				1, X = Range[num]; {Y} = values; sX = sY = ConstantArray[0,num],
				2, {X,Y} = values; sX = sY = ConstantArray[0,num],
				3, {X,Y,sY} = values; sX = ConstantArray[0,num],
				4, {X,Y,sY,sX} = values
			];
			{num, {X,Y,sY,sX}}
		], (* end of standard file processing *)

	(* else selectQ == True, so call the data processor routine *)
	result =
		If[selector === Identity, 
			LoadColumnDialog[values, file, hdr],
			selector[values, file, hdr]
		]
];

(* check for a canceled conversion *)
If[result === $Canceled, Return[$Canceled]];
(* check for a bad conversion *)
If[
	Head[result] =!= List || Length[result] != 2 || !NumberQ[First[result]] ||
	First[result] <= 0 || !MatrixQ[Last[result],NumberQ] ||
	!CheckLength[Append[Last[result],First[result]]],
	 Message[LoadFile::conversion, OptionValue[DataFunction] ];Abort[]
];

(* data conversion looks good *)

(* to merge or not to merge... *)
If[!merging,
	(* not merging, so to sort or not to sort... *)
	SaveForUndo[];
	DataFileName = file;
	DataFileHeader = hdr;
	If[!OrderedQ[First[Last[result]]],
		If[sorting,
			result[[2]] = (Last[result]//Transpose//Sort//Transpose); Message[LoadFile::sorted],
			Message[LoadFile::warnsorted]
		]
	];
	{n,{xx,yy,sy,sx}} = result;
	Print["Read ", n, " data points."],

	(* merging with current data set *)
	MergeData[{Append[Last[result],First[result]],file}];
	DataFileName = file;
	DataFileHeader = hdr;
];
]



(***********************************************************)
(* StripHdr[], ParseData[]: only meant to be called from within LoadFile[ ] *) 

(* StripHdr[] strips the header from the file data and then removes trailing comments  *)
(* from the remaining data lines *)
StripHdr[] :=
Block[{},
hdr = data = {};

(* process skip strings to see if they amount to anything *)
If[Head[skip] === String && skip == "", Clear[skip]; skip = 0];
If[Head[skip] === List,
	skip = Select[skip, !(# === "")&]; If[skip == {}, Clear[skip]; skip = 0]
];

(* here we handle an integer skip *)
If[Head[skip] === Integer && skip > 0,
	If[skip > Length[lines], Message[SkipLines::toolong, skip, file]; Abort[] ];
	hdr = lines[[;;skip]];
	lines = lines[[(skip+1);;]] (* will be {} if skip == Length[lines] *)
];

(* here we handle a string or strings for skip *)
If[ Head[skip] === String || Head[skip] === List,
	Block[{j,v},
		v = StringFreeQ[#, skip]& /@ lines; (* element of v == False if skip found in that line *)
		For[j = Length[lines], j>0 && v[[j]], j--]; (* finds the final line with a skip string *) 
		If[j == 0, Message[SkipLines::missing, skip, file];Abort[] ];
		hdr = lines[[;;j]];
		lines = lines[[(j+1);;]] (* will be {} if j == Length[lines] *)
	]
];
(* now the header has been identified if using skip *)

(* Comments follow a delimiter,data come before *)
If[delims != {},
	data = StringSplit[lines, delims, 2]; (* will be {} if lines == {} *)

	(* Identify the header if not using skip *)
	If[Length[hdr] == 0,
		(* Header is the initial set of lines without any data values before a comment delimiter *)
		(* Move comments into hdr. The first line with data stops this. *)
		data =
			NestWhile[
				(AppendTo[hdr, Last[First[#]]]; Rest[#])& ,data,
				(# != {} && First[First[#]] == "") & 
			];
	];
	
	(* data contains only lines following header. *)
	(*Now just pick out the non-comment stuff for data *)
	data = First /@data,

	(* delims == {} *)
	data = lines
];

(* final header processing: remove trailing whitespace and trailing blank lines *)
While[Length[hdr] > 0 && Last[hdr] == "", hdr = Most[hdr]]; 
If[Length[hdr] > 0, hdr = (StringTrim[#, RegularExpression["\\s+$"]] &) /@ hdr];
]

(***********************************************************)

(* ParseData[] converts the data in each line (comments stripped out) into a list of numbers *)
(* It returns the resulting array of numbers *)
ParseData[] := 
Block[
{nums},
(* convert commas to tabs, so CSV data is properly input *)
(* except ",," is interpreted as "," *)
data = (StringReplace[#,","->"\t"]&) /@ data;

(* parse into C-style number strings, and select only nonempty lines*)
nums = Select[ (StringCases[#, CFloatRegExp] &) /@ data, (# != {} )&  ];

(* convert each string to a Mathematica number *)
Map[ ToExpression[StringReplace[#, {"E" -> " 10^", "e" -> " 10^"}]]& , nums, {2}]
]



(***********************************************************)
(* ColumnSelect[] *) 

ColumnSelect[X_Integer /; X>=0, Y_Integer /; Y>=0, 
	SY_Integer /; SY>=0, SX_Integer /; SX>=0][d:{___List}, f_String, _String] :=
Block[
{cols = Max[X,Y,SY,SX], n = Length[d], x, y, sx, sy},
If[d == {}, Message[LoadFile::empty]; Abort[]];
If[Min[Length/@d] < cols, Message[ColumnSelect::columns, f, cols]; Abort[]];
x = If[X == 0, Range[n], d[[All,X]]];
y = If[Y == 0, Range[n], d[[All,Y]]];
sy = If[SY == 0, ConstantArray[0,n], d[[All,SY]]];
sx = If[SX == 0, ConstantArray[0,n], d[[All,SX]]];
{n,{x,y,sy,sx}}
]

ColumnSelect[a___][___] := Message[ColumnSelect::arguments]



(***********************************************************)
(* LoadColumnDialog[] *) 

(* Called by LoadFile[] to open a dialog box for interactive column selection *)
LoadColumnDialog[data:{___List}, f_String, h_String] :=
Block[{num, cols, range, result, type, caption},

If[data == {}, Message[LoadFile::empty]; Abort[]];
If[!MatrixQ[data,NumberQ], Message[LoadFile::column]; Abort[]];
{num, cols} =  Dimensions[data];

(* define the styles used by various items in the dialog box *)
caption[1,c_]:=Item[Style[c],ItemSize->5,Alignment->Right];
caption[2,c_]:=Style[c,Italic];
caption[3,c_]:=Style[c,Larger];

result = 
	DynamicModule[
	{ok, X = 0, Y = 0, sigmaX = 0, sigmaY = 0, p = LinearDataPlot},
	range = Range[0,cols];
	type = If[cols < 10, RadioButtonBar, SetterBar]; 
	ok = 
		ChoiceDialog[
			Panel[
				Column[{
					caption[3, f],
					Tooltip[
						Panel[Pane[
						Grid[ Prepend[data[[;;5]], Range[cols]],
							ItemStyle -> Directive[FontFamily->"Helvetica", Italic],
							ItemSize -> Full, Alignment -> {Left, Baseline},
							Spacings -> {Offset[2], Automatic}, Dividers->{False,{2->Black}}],
						500, Scrollbars->Automatic, AppearanceElements->None, Alignment->{Center,Automatic}
						],Appearance->"Frameless"
						],"First few data lines with column numbers added."],
					caption[2,"For X and Y: Button 0 means use a range of 1..N"],
					Tooltip[
						Grid[{{caption[1,"X"], type[Dynamic[X],range]},
							{caption[1,"Y"],type[Dynamic[Y],range]}}],
						"Select column. 0 implies 1..N"],
					"",
					caption[2,"For sigma Y and sigma X: Button 0 means set sigmas to all 0's"],
					Tooltip[
						Grid[{{caption[1,"sigma Y"],type[Dynamic[sigmaY],range]},
							{caption[1,"sigmaX"],type[Dynamic[sigmaX],range]}}],
						"Select column. 0 implies all 0's"],
					Dynamic[
						With[{d=ColumnSelect[X,Y,sigmaY,sigmaX][data,f,h]},
							Tooltip[
								p[{Append[Last[d],First[d]],f},ImageSize->500, Tips->None,PlotLabel->None],
							"Plot of selected columns."]
						]
					],
					Row[{
						"Plot type:  ",
						PopupMenu[Dynamic[p],
							{CurveFit`LinearDataPlot->"Linear", CurveFit`LogDataPlot->"Log Y",
							CurveFit`LogLogDataPlot->"Log-Log",CurveFit`LogLinearDataPlot->"Log X"}]
					}]
				}], (* Column *)
				ImageSize->{550,Automatic}, Alignment->{Left,Center}
			] (* Panel *),
			WindowTitle->"Select columns to load", WindowSize->{565,Scaled[.9]}, WindowFloating->True,
		WindowElements->{"VerticalScrollBar"}
		]; (* ChoiceDialog *)

	If[ok, ColumnSelect[X,Y,sigmaY,sigmaX][data,f,h], $Canceled]
	];(* DynamicModule *)

result[[2]] (* strips off DynamicModule[] extra stuff*)
] (* LoadColumnDialog[] *)

LoadColumnDialog[___] := $Canceled



(***********************************************************)
(* Gain, Phase, Real-part, and Imaginary-part calculators for FreqResp[] *) 

(* ga: gain amplitude, without or with uncertainties in input and response *)
ga[ia_, ra_] := ra/ia
ga[ia_, is_, ra_, rs_] := 
Block[{i,r,di,dr},
	di = Evaluate[D[ga[i,r],{i,1}]]/.{i->ia, r->ra}; (* dGain/dInput *)
	dr = Evaluate[D[ga[i,r],{r,1}]]/.{i->ia, r->ra}; (* dGain/dResponse *)

	(* {expected value, uncertainty (simple error propagation)} *)
	Chop[{ga[ia,ra], Sqrt[(is di)^2+(rs dr)^2]}]//N
]

(* gp: gain phase, without or with uncertainties in input and response *)
gp[ip_,rp_] := rp-ip
gp[ip_,is_,rp_,rs_] :=
	(* {expected value, uncertainty (simple error propagation)} *)
	Chop[{gp[ip,rp], Sqrt[is^2+rs^2]}]//N

(* rp: real part from amplitude & phase, without or with uncertainties *)
rp[amp_,ph_] := amp Cos[ph Evaluate[N[Degree]]]
rp[amp_,samp_,ph_,sph_] := 
Block[{a,p,d1a,d1p,d2p},
	(* derivatives required for more sophisticated error prop *)
	d1a=Evaluate[D[rp[a,p],{a,1}]]/.{a->amp,p->ph}; (* dReal/dAmplitude *)
	d1p=Evaluate[D[rp[a,p],{p,1}]]/.{a->amp,p->ph}; (* dReal/dPhase *)
	d2p=Evaluate[D[rp[a,p],{p,2}]]/.{a->amp,p->ph}; (* d2Real/dPhase2 *)

	Chop[{rp[amp,ph]+sph^2 d2p/2, (* expected value corrected for 2nd derivatives *)
	(* uncertainty will be nonzero, even if 1st derivative with phase vanishes *)
	Sqrt[(samp d1a)^2+sph^2(d1p^2+sph^2 d2p^2/2)]}]//N
]

(* ip: imaginary part from amplitude & phase, without or with uncertainties *)
ip[amp_,ph_] := amp Sin[ph Evaluate[N[Degree]]]
ip[amp_,samp_,ph_,sph_] := 
Block[{a,p,d1a,d1p,d2p},
	(* derivatives required for more sophisticated error prop *)
	d1a=Evaluate[D[ip[a,p],{a,1}]]/.{a->amp,p->ph}; (* dImag/dAmplitude *)
	d1p=Evaluate[D[ip[a,p],{p,1}]]/.{a->amp,p->ph}; (* dImag/dPhase *)
	d2p=Evaluate[D[ip[a,p],{p,2}]]/.{a->amp,p->ph}; (* d2Imag/dPhase2 *)

	Chop[{ip[amp,ph]+sph^2 d2p/2, (* expected value corrected for 2nd derivatives *)
	(* uncertainty will be nonzero, even if 1st derivative with phase vanishes *)
	Sqrt[(samp d1a)^2+sph^2(d1p^2+sph^2 d2p^2/2)]}]//N
]



(***********************************************************)
(* FreqResp[] *) 

FreqResp[d_,f_,_]:=
Block[{n, b1Vals, b2Vals, columns, data, gain, phase, choice, y, sigy},

If[!MatrixQ[d,NumberQ] || Length[First[d]]!=11,
	Message[FreqResp::format];Abort[],,
	Message[FreqResp::format];Abort[]
];
n = Length[d];

(* Provide mnemonic access to the 11 columns in the file *)
columns = {"F","GA","GO","IA","IsA","IP","IsP","RA","RsA","RP","RsP"};
columns = MapIndexed[(#1->First[#2])&,columns]; (* e.g.: "IA"->4 *)
data[s_] := d[[All,(s/.columns)]];

(* helpers to derive the gain magnitude or phase from the input and response *)
gain[] := ga[data["IA"],data["IsA"],data["RA"],data["RsA"]];
phase[] := gp[data["IP"],data["IsP"],data["RP"],data["RsP"]];

(* the dialog box radio button choices *)
b1Vals = {"Gain", "Input", "Response"};
b2Vals = {"Magnitude", "Phase", "Real part", "Imaginary part"};

choice =
	DynamicModule[{ok, b1 = b1Vals[[1]], b2 = b2Vals[[1]]},
		ok = 
		ChoiceDialog[
			Pane[Grid[
				{
				 {Item[Style["Select the data to extract from the file:",Larger],Alignment->{Left,Top}],SpanFromLeft},
				 {},
				 {Item[
					Tooltip[RadioButtonBar[Dynamic[b1],Evaluate[b1Vals],Appearance->"Vertical"],"Select the signal"],
					Alignment->{Right,Top},ItemSize->8],
				  Item[
					Tooltip[RadioButtonBar[Dynamic[b2],Evaluate[b2Vals],Appearance->"Vertical"],"select the parameter"],
					Alignment->{Left,Top}]
				 }
				},
				Spacings->3
			]],
			WindowTitle->"Load Frequency Response Data"
		];
		If[ok, {b1,b2},$Canceled]
	][[2]](* strips off DynamicModule[] extra stuff *);
If[choice === $Canceled, Return[$Canceled]];

(* use the radio button choices to fetch (or calculate) Y and sigY data *)
{y, sigy} =
	Switch[choice,
		{"Gain","Magnitude"}, gain[],
		{"Gain","Phase"}, phase[],
		{"Gain","Real part"}, rp @@ Join[gain[],phase[]],
		{"Gain","Imaginary part"}, ip @@ Join[gain[],phase[]],

		{"Input","Magnitude"}, {data["IA"],data["IsA"]},
		{"Input","Phase"}, {data["IP"],data["IsP"]},
		{"Input","Real part"}, rp[data["IA"],data["IsA"],data["IP"],data["IsP"]],
		{"Input","Imaginary part"}, ip[data["IA"],data["IsA"],data["IP"],data["IsP"]],

		{"Response","Magnitude"}, {data["RA"],data["RsA"]},
		{"Response","Phase"}, {data["RP"],data["RsP"]},
		{"Response","Real part"}, rp[data["RA"],data["RsA"],data["RP"],data["RsP"]],
		{"Response","Imaginary part"}, ip[data["RA"],data["RsA"],data["RP"],data["RsP"]]
	];

(* format the results for LoadFile[]. Frequencies have 0 uncertainty (not measured) *)
{n,{data["F"],y,sigy,ConstantArray[0,n]}}
]



(***********************************************************)
(* SaveFile[] *) 

SaveFile[filename_String, Optional[header_String,""], 
	OptionsPattern[{CommentDelimiters :> $CommentDelimiters}]] := 
Block[
{delim, hdr, data},

If[
	!CheckLength[] || 
	(FileNames[filename]!= {} && !ChoiceDialog[filename <> " exists. OK to overwrite?"]),
	Abort[]
];

delim = OptionValue[CommentDelimiters];
If[ListQ[delim], delim = First[delim]];
If[!StringQ[delim], 
	Message[CommentDelimiters::unknown, OptionValue[CommentDelimiters], {"#"}]; delim = "#"
];

(* Process the header into a list of lines with prefixed comment delimiters *)
hdr = StringSplit[header, "\n"];
hdr = StringJoin /@ Transpose[{ConstantArray[delim<>" ", Length[hdr]], hdr}];

(* Process the data *)
data = Map[ToString[CForm[#]]&,({xx, yy, sy, sx}//Transpose//Sort),{2}];
data = StringJoin[Riffle[#,"\t"]]& /@ data; (* now data is a list of lines of tab-separated values *)

(* Write to the file *)
Export[filename, Join[hdr,data],"Lines"];
Print["Sorted data saved in "<>filename];
];

SaveFile[opts:OptionsPattern[{CommentDelimiters :> $CommentDelimiters}]] := 
	SaveFile[DataFileName, DataFileHeader, opts]

SaveFile[badargs__]:= Message[SaveFile::unknown, {badargs}]



(***********************************************************)
(* LoadTekFile *)

LoadTekFile[name_]:= Block[{hdr,data},
	(* ensure file exists and has some data *)
	If[FileNames[name] == {}, Message[LoadFile::missing, name, Directory[]]; Abort[]];
	data = Import[name];
	If[data === $Failed || !MatrixQ[data] || Length[data] == 0, Message[LoadFile::empty]; Abort[]];
	If[Last[Dimensions[data]] != 6, Message[LoadTek::conversion, name]; Abort[]];
	If[!MatrixQ[data[[All,4;;5]],NumberQ], Message[LoadTek::conversion, name]; Abort[]];

	(* process the header *)
	hdr = Select[data[[All,1;;3]], #!={"","",""}&];
	hdr = Map[ToString[If[Head[#] =!= String, CForm[#], #]]&, hdr, {2}];
	hdr = ((Riffle[#," "]//StringJoin)& /@ hdr);
	hdr = (Append[Riffle[hdr,"\n"],"\n"]//StringJoin);

	(* move data into CurveFit structures *)
	SaveForUndo[];
	n = First[Dimensions[data]];
	{xx,yy} = Transpose[data[[All,4;;5]]];
	sx = sy = ConstantArray[0,n];
	DataFileName=name;
	DataFileHeader=hdr;

	Print[name];
	Print["File comment header:"];
	Print[hdr];
	Print["Read ", n, " data points."];
]



(***********************************************************)
End[]; (* `Private` *)

