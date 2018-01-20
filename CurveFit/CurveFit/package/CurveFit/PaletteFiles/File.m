(* ::Package:: *)

(* Copyright 1997-2007 by California Inst. of Technology, Pasadena, CA. *)

(* Only call this package file from CurveFit`Palette.m *)

(* The code assumes that we are already in the 
	CurveFit`Palette`Private 
	context. *)

(* File.m - Palette File I/O selections *)



(***********************************************************)
(* File I/O palette selections *) 

fileiomenu := 
Tooltip[
ActionMenu["Data I/O",
{
	"Load standard file"       :>  
		eval[
		"With["<>
		"  {name = SystemDialogInput[\"FileOpen\","<>
			"{DataFileName,{\"data files\"->"<>
			"{\"*.dat\", \"*.mca\"},\"all files\"->{\"*\"}}}]"<>
			"},\n"<>
		"  If[ name =!= $Canceled, \n"<>
		"    LoadFile[name]]\n"<>
		"]"
		],

	"Load Frequency Response file"  :>   
		eval[
		"With["<>
		"  {name = SystemDialogInput[\"FileOpen\","<>
			"{DataFileName,{\"data files\"->"<>
			"{\"*.dat\", \"*.mca\"},\"all files\"->{\"*\"}}}]"<>
			"},\n"<>
		"  If[ name =!= $Canceled, \n"<>
		"    LoadFile[name, "<>
			"Nonstandard -> True, DataFunction -> FreqResp]]\n"<>
		"]"
		],

	"Load and select columns"  :>   
		eval[
		"With["<>
		"  {name = SystemDialogInput[\"FileOpen\","<>
			"{DataFileName,{\"data files\"->"<>
			"{\"*.dat\", \"*.mca\"},\"all files\"->{\"*\"}}}]"<>
			"},\n"<>
		"  If[ name =!= $Canceled, \n"<>
		"    LoadFile[name, Nonstandard -> True]]\n"<>
		"]"
		],

	"Load Gamma spectrum (.tsv) file"       :>  
		eval[
		"With["<>
		"  {name = SystemDialogInput[\"FileOpen\","<>
			"{DataFileName,{\"spectrum files\"->"<>
			"{\"*.tsv\"},\"all files\"->{\"*\"}}}]"<>
			"},\n"<>
		"  If[ name =!= $Canceled, \n"<>
		"    LoadFile[name, SkipLines\[Rule]{\"Data:\",\"Counts\"}]]\n"<>
		"]"
		],

	"Load Tek O'scope waveform file (1 channel)"       :>  
		eval[
		"With["<>
		"  {name = SystemDialogInput[\"FileOpen\","<>
			"{DataFileName,{\"Tek waveform files\"->"<>
			"{\"*.csv\",\"*.tsv\"},\"all files\"->{\"*\"}}}]"<>
			"},\n"<>
		"  If[ name =!= $Canceled, \n"<>
		"    LoadTekFile[name]]\n"<>
		"]"
		],

	Delimiter,

	"Merge standard file with current data"       :>  
		eval[
		"With["<>
		"  {name = SystemDialogInput[\"FileOpen\","<>
			"{DataFileName,{\"data files\"->"<>
			"{\"*.dat\", \"*.mca\"},\"all files\"->{\"*\"}}}]"<>
			"},\n"<>
		"  If[ name =!= $Canceled, \n"<>
		"    LoadFile[name, MergeFile -> True]]\n"<>
		"]"
		],

	"Merge and select columns"  :>   
		eval[
		"With["<>
		"  {name = SystemDialogInput[\"FileOpen\","<>
			"{DataFileName,{\"data files\"->"<>
			"{\"*.dat\", \"*.mca\"},\"all files\"->{\"*\"}}}]"<>
			"},\n"<>
		"  If[ name =!= $Canceled, \n"<>
		"    LoadFile[name, Nonstandard -> True, MergeFile -> True]]\n"<>
		"]"
		],

	"Merge Gamma spectrum (.tsv) file"       :>  
		eval[
		"With["<>
		"  {name = SystemDialogInput[\"FileOpen\","<>
			"{DataFileName,{\"spectrum files\"->"<>
			"{\"*.tsv\"},\"all files\"->{\"*\"}}}]"<>
			"},\n"<>
		"  If[ name =!= $Canceled, \n"<>
		"    LoadFile[name, SkipLines\[Rule]{\"Data:\",\"Counts\"}, MergeFile -> True]]\n"<>
		"]"
		],

	Delimiter,
	"Retrieve previous data"         :>  
		eval["SelectPrevData[]"],

	Delimiter,

	"Save file"                :>  
		eval[
		"With["<>
		"  {name = SystemDialogInput[\"FileSave\", DataFileName]},\n"<>
		"  If[ name =!= $Canceled, SaveFile[name]]\n"<>
		"]"
		],

	"Save file with header"    :>  
		eval[
		"With["<>
		"  {name = SystemDialogInput[\"FileSave\", DataFileName]},\n"<>
		"  If[ name =!= $Canceled, SaveFile[name, DataFileHeader]]\n"<>
		"]"
		],

	Delimiter,

	"Show file header information"    :>  
		eval["DataFileHeader"],

	"Show file path"    :>  
		eval["DataFileName"],

	"Edit file header information"    :>  
		eval["EditHeader[]"]
}
],
"Load or save file data; show file header or path"
]

fileiohelp := 
Tooltip[
Button["Help", 
	eval["?\"CurveFit`*File*\"|\"CurveFit`CommentDelimiters\""<>
		"|\"CurveFit`SkipLines\"|\"CurveFit`Nonstandard\""<>
		"|\"CurveFit`Sorting\"|\"CurveFit`DataFunction\""<>
		"|\"CurveFit`EditHeader\"|\"CurveFit`SelectPrevData\""<>
		"|\"CurveFit`FreqResp\""]
],
"Puts a menu of help for the data I/O routines "<>
"in the input notebook"]

fileioitem := {fileiohelp, fileiomenu}

