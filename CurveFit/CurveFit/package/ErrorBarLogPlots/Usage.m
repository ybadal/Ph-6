(* Mathematica package *)
(* Usage statements. Included by ErrorBarLogPlots.m *)
(* ErrorBarLogPlots ver 3.0 12/2015 *)

ErrorListLogPlot::usage = "ErrorListLogPlot[{{{\!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], 
StyleBox[\"1\", \"TR\"]]\),\!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], 
StyleBox[\"1\", \"TR\"]]\)},ErrorBar[\!\(\*SubscriptBox[
StyleBox[\"err\", \"TI\"], \"1\"]\)]},{{\!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\),\!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\)},ErrorBar[\!\(\*SubscriptBox[
StyleBox[\"err\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\)]},\!\(\*
StyleBox[\"\[Ellipsis]\", \"TR\"]\)}] makes a log plot of points with \
specified \!\(\*
StyleBox[\"x\", \"TI\"]\) and \!\(\*
StyleBox[\"y\", \"TI\"]\) coordinates and error magnitudes. To use \
this function you must load the ErrorBarLogPlots package.";
	
ErrorListLogLinearPlot::usage = "ErrorListLogLinearPlot[{{{\!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], 
StyleBox[\"1\", \"TR\"]]\),\!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], 
StyleBox[\"1\", \"TR\"]]\)},ErrorBar[\!\(\*SubscriptBox[
StyleBox[\"err\", \"TI\"], \"1\"]\)]},{{\!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\),\!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\)},ErrorBar[\!\(\*SubscriptBox[
StyleBox[\"err\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\)]},\!\(\*
StyleBox[\"\[Ellipsis]\", \"TR\"]\)}] makes a log(\!\(\*
StyleBox[\"x\", \"TI\"]\))-linear(\!\(\*
StyleBox[\"y\", \"TI\"]\)) plot of points with specified \!\(\*
StyleBox[\"x\", \"TI\"]\) and \!\(\*
StyleBox[\"y\", \"TI\"]\) coordinates and error magnitudes. To use \
this function you must load the ErrorBarLogPlots package.";

ErrorListLogLogPlot::usage = "ErrorListLogLogPlot[{{{\!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], 
StyleBox[\"1\", \"TR\"]]\),\!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], 
StyleBox[\"1\", \"TR\"]]\)},ErrorBar[\!\(\*SubscriptBox[
StyleBox[\"err\", \"TI\"], \"1\"]\)]},{{\!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\),\!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\)},ErrorBar[\!\(\*SubscriptBox[
StyleBox[\"err\", \"TI\"], 
StyleBox[\"2\", \"TR\"]]\)]},\!\(\*
StyleBox[\"\[Ellipsis]\", \"TR\"]\)}] makes a log-log plot of points \
with specified \!\(\*
StyleBox[\"x\", \"TI\"]\) and \!\(\*
StyleBox[\"y\", \"TI\"]\) coordinates and error magnitudes. To use \
this function you must load the ErrorBarLogPlots package.";

ErrorBarScale::usage = "ErrorBarScale[\!\(\*
StyleBox[\"xscale\", \"TI\"]\), \!\(\*
StyleBox[\"yscale\", \"TI\"]\)] may be supplied as a value for the \
ErrorBarFunction option of the ErrorListPlot family. It scales \!\(\*
StyleBox[\"x\", \"TI\"]\) and \!\(\*
StyleBox[\"y\", \"TI\"]\) error bar sizes by the supplied factors to \
make them more visible in a plot. To use this function you must load \
the ErrorBarLogPlots package.";

ErrorBarMapping::usage = "ErrorBarMapping is an option of the ErrorListLogPlot family which controls how error bar lengths "<>
	"are mapped onto Log-scale axes. The default value is Automatic. Other option values include the strings "<>
	"\"Simple\" and \"Exact\". To use this function you must load "<>
	"the ErrorBarLogPlots package.";
	
ErrorBarStyle::usage = "ErrorBarStyle is an option of the ErrorListLogPlot family which may be used to control the style of "<>
	"default error bars independently of the option PlotStyle. The default is Automatic, which makes the error bar style "<>
	"match that set by the option PlotStyle, unless you change the value of the variable $ErrorBarStyle. To use this  "<>
	"function you must load the ErrorBarLogPlots package.";
	
$ErrorBarStyle::usage = "$ErrorBarStyle is a variable which provides the default style for error bars drawn by any of the  "<>
	"ErrorListLogPlot family if the option ErrorBarStyle is not specified or is set to ErrorBarStyle \[Rule] Automatic. The  "<>
	"default value for this variable is {}, which will force error bars to be drawn using the style specified by option  "<>
	"PlotStyle; set this variable to some other value to override this behavior. This variable is created when you load the  "<>
	"ErrorBarLogPlots package. Also see ErrorBarStyle.";
