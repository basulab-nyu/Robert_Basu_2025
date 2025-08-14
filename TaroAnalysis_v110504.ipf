#pragma rtGlobals=1		// Use modern global access method.

//	20/03/2008
//	*Select waves...
//	"Scale waves" was made.
//	*Event Detection...
//	Bug fix. Made the detection algorithm more confined to selected time window. visualizaion of c3w reflect it.
//	Error in "X" button in the "Event cutout" graph fixed. User can open only one CutOut graph. Previous EventCutOut waves will be deleted.
//	Font size in "Help" corrected
//	*Further analysis...
//	Alert on overwrite
//	
//	24/03/2008
//	*Event Detection...
//	Rise time  10-90 and 20-80 both calculated. Wave names changed accordingly.
//	*Further analysis...
//	Risetime histogram
//	Event selection based on amplitude, rise time
//	
//	25/032008
//	bugs in Algorithm caused by wrong FP setting is fixed. Now FP is always 0. 
//	This was a relatively new bug that had been introduced by the "fix" on 20/03/2008
//	A new feature "Conditional Mask" is made.
//
//  after 25/03/08 raster colour problem fixed, ->uploaded as 31/03/08
//
// 	01/04/2008 
//	Time shift button was made in select waves panel. Burst function added in Further analysis.
//
//	01/04/2008 b
//	Time shift can be done at Further analysis too.
//
//	08-15 /04/2008
//	*Decay time constant analysis has been added. Event cut out-> fit, waves will be made. 
// 	In event cut out, masked events are not included. 
//	Original event number ref waves are included in further analysis.
//	in conditional mask, "unmask all" is added.  "inverse mask" is added
//	in selectwaves... Graph, measure values added
// 	remove artifact: mean and interpol is added
//	adjust base line is now not affected by Nan points
//	in further analysis, Stat, result length adjustment: adjustment does not merely use pntnum but does see each lables.
//	Merge tables was added
//	a new function, "Burst transform" is made
//	average trace (blue) is added to event cut out.
//	GetWaveNamesOfTable(), after making tables
//	basepoint is automatically set upon event insertion
//	
//	24/06/2008
//	version 4
//	added decay curve subtraction and check error button 
//	restore params button removed
//	Area measure (Select waves-> Graph -> measure values) now considers the X scaling
//
//	12-19/08/2008 -- 17/09/2008
//	version 5
//	add "make copy" in further analysis stat
//	add "time range" in conditional mask
// 	add MakeAmplitudePlot in further analysis
//	**detection algorithm is reviewed. valley setting, hump detection, enhanced slow rise event detecion.
//	"more settings" panel
//	19/09/2008
//	version 5b
//	autocorrelogram is added
//
//	03/10/2008
//	More analysis is created
//	a bug in Burst transform (cannot find result waves) is fixed
//
//	09/10/2008
//	enhanced burst marking
//	
//	14/10/2008
//	version 5c
//	Area measurement added
//	
//	09/12/2008
//	Bug fix of Further analysis; wrong selection of PSTH options is corrected.
//
//	20/03/2009
//	In Further analysis, onset time can be chosen instead of peak time
//
//	April-May 2009
//	cumulative analysis added
//
//	13/7/2009
//	3xSD option added
//
//   24/9/2009
// 	release in Japan
//
//   1/2/2010
//   Adding Instant. freq. trend
//
//   17/2/2010
//	Event detection; Now the sign of amplitude is not always plus, but depends on the sign of threshold
//  
//  19/2/2010
//  Event detection, event cutout is made faster; "cursor measure" is added
//  custom wave choice is added to conditional mask
//  
//  25/2/2010
//  A bug in Event cut out, which was introduced in 19/2/2010 version, is fixed.
//  
//  8/3/2010
//  Cubic polynomial fitting for "gross" base line is introduced.
//  
//  23/3/2010
//  Added "Normalize at peak" to Event cut out
//  
//  23/3/2010b
//  Event cut out, x-alignment reported by Sara was corrected
//  
//  21/5/2010
//  added a fail-safe zoom out option, after a report from Ian
//  saved as v5i
//
//	31/5/2010
//	saved as v5j
//	Action of "Save resuluts" was changed. The "Save only non-masked events" button was added
//	EventHide is saved and loaded.
//	
//	01/06/2010
//	zoom mag set button was added
//	appearance rearrange
//	
//	23/06/2010
//	zoom mag +  - was added
//
//	24/06/2010
//	function ConvertToC3WaveType was made, a possible bug in c3wh polarity was corrected
//	bug of saveresult affecting eventhide wave was corrected. pointed out by Ingrid
// 
//	14/09/2010
//	Cross correlation analysis is newly added under TaroTools>More tools. 
//
//	25/10/2010
//	cursor interfare is solved. Corsors have been given new names.
//
//	23/11/2010
//	Half-width measurement was made in main panel. RiseTime 10-90 is not displayed. Shape of cursor I (event peak) is now cross.
//
//	24/11/2010
//	RiseTime1090 is displayed again.
//	Half-width histogram was made in FutherAnalysis. 
//	"AnalysisParam"+postfixstr is extended from 60 to 100 pnts
//	
//	29/11/2010
//	smoothing baseline "smooth3" is added in More settings.
//
//	5-7/02/2011
//	internal version 5M
//	in simple graph and cutout window, a trace can be selected by single click on the graph trace
//	event selection of the event cutout window and the main event detection panel is synchronized.
//	event hide, delete, insert are reflected only after "Refresh" of event cut out window
//	
//	14/2/2011
//	cursor hook of cutout window is modified.
//	internal version 5N
//	17/2/2011
//	Started writting CombineResultsPanel and CombineResultsDo, but not finished. Instead, DoLoadResults were modified to allow "merge" of results.
//	FurtherAnalysis range2 default is now Fix, which was Auto.
//
//	7/3/2011
//	bug in cross-correlation is fixed.
	
	 
Function ShowTaroToolsHelp()
	if (WinType("HelpForEventDetection")>0)
		DoWindow/F HelpForEventDetection
		abort
	endif
	//
	String nb = "HelpForEventDetection"
	NewNotebook/N=$nb/F=1/V=1/K=1/W=(191.25,42.5,691.5,472.25) as "TaroTools Help"
	Notebook $nb defaultTab=36, statusWidth=252
	Notebook $nb showRuler=0, rulerUnits=2, updating={1, 0}
	Notebook $nb newRuler=Normal, justification=0, margins={0,0,468}, spacing={0,0,0}, tabs={}, rulerDefaults={"Arial",10,0,(0,0,0)}
	Notebook $nb ruler=Normal, fSize=12, fStyle=1, text="Event detection procedures", fStyle=-1, text=" 24/11/2010 by Taro\r"
	Notebook $nb text="\r"
	Notebook $nb fStyle=5, text="How to use in general\r"
	Notebook $nb fStyle=-1, text="Please ask me or other experienced users.\r"
	Notebook $nb fSize=-1, text="\r"
	Notebook $nb fSize=12, fStyle=5, text="Key combinations\r"
	Notebook $nb fStyle=1, text="Mouse click + Shift", fStyle=-1, text=": Zoom in (or scroll) to the clicked point\r"
	Notebook $nb fStyle=1, text="Mouse click + Command (", fStyle=3, text="Macintosh ", fStyle=1, text=") or Ctrl (", fStyle=3
	Notebook $nb text="Windows ", fStyle=1, text=")", fStyle=-1
	Notebook $nb text=": Zoom in (or scroll) to the event (nearest to the clicked point)\r"
	Notebook $nb fStyle=1, text="Mouse click + Shift + Command (", fStyle=3, text="Macintosh ", fStyle=1, text=") or Ctrl ("
	Notebook $nb fStyle=3, text="Windows ", fStyle=1, text=")", fStyle=-1, text=": Insert an event at the clicked point\r"
	Notebook $nb fStyle=1, text="Mouse click outside of the graph area", fStyle=-1, text=": Zoom out\r"
	Notebook $nb fStyle=1, text="Mouse click (", fStyle=3, text="left", fStyle=1, text=" or ", fStyle=3, text="right", fStyle=1
	Notebook $nb text=" half of window) + Shift + CapsLock", fStyle=-1, text=": A full scroll to the ", fStyle=2, text="left"
	Notebook $nb fStyle=-1, text=" or ", fStyle=2, text="right", fStyle=-1, text=".\r"
	Notebook $nb fStyle=1, text="Command (", fStyle=3, text="Macintosh ", fStyle=1, text=") or Ctrl (", fStyle=3, text="Windows "
	Notebook $nb fStyle=1, text=") + 4", fStyle=-1, text=" : Mask the event\r"
	Notebook $nb fStyle=1, text="Command (", fStyle=3, text="Macintosh ", fStyle=1, text=") or Ctrl (", fStyle=3, text="Windows "
	Notebook $nb fStyle=1, text=") + 5", fStyle=-1, text=" : Move to the previous event\r"
	Notebook $nb fStyle=1, text="Command (", fStyle=3, text="Macintosh ", fStyle=1, text=") or Ctrl (", fStyle=3, text="Windows "
	Notebook $nb fStyle=1, text=") + 6", fStyle=-1, text=" : Move to the following event\r"
	Notebook $nb fStyle=1, text="Command (", fStyle=3, text="Macintosh ", fStyle=1, text=") or Ctrl ("
	Notebook $nb fStyle=3, text="Windows ", fStyle=1, text=") + 7 ", fStyle=-1, text=":", fStyle=1, text=" ", fStyle=-1
	Notebook $nb text=" A full scroll to the left\r"
	Notebook $nb fStyle=1, text="Command (", fStyle=3, text="Macintosh ", fStyle=1, text=") or Ctrl (", fStyle=3, text="Windows "
	Notebook $nb fStyle=1, text=") + 8 ", fStyle=-1, text=":", fStyle=1, text=" ", fStyle=-1
	Notebook $nb text=" A full scroll to the right\r"
	Notebook $nb fStyle=1, text="Command (", fStyle=3, text="Macintosh ", fStyle=1, text=") or Ctrl (", fStyle=3, text="Windows "
	Notebook $nb fStyle=1, text=") +\"Detect events\" button", fStyle=-1, text=": Scan only the present trace\r"
	Notebook $nb fStyle=1, text="Shift + \"Mask event\" button", fStyle=-1
	Notebook $nb text=": Mask all events shown in the present graph window\r"
	Notebook $nb fStyle=1
	Notebook $nb text="Shift or Command (Macintosh ) or Ctrl (Windows ) + \"Delete masked\" button", fStyle=-1
	Notebook $nb text=": Delete the single selected event no matter it is masked or not.\r"
	Notebook $nb fStyle=1, text="Shift + \"Check errors\" button", fStyle=-1
	Notebook $nb text=": Check only important errors, namely 20-80% rise time and area\r"
	Notebook $nb fStyle=1, text="Shift + \"Zoom in\" check on", fStyle=-1, text=": Specify the time to zoom-in.\r"
	Notebook $nb text="\r"
	Notebook $nb fStyle=5, text="Parameter setting tips\r"
	Notebook $nb fStyle=1, text="Threshold", fStyle=-1
	Notebook $nb text=": Set a positive value for positive-going events, a negative value for negative-going events. This will "
	Notebook $nb text="be used in auto detection.\r"
	Notebook $nb fStyle=1, text="smooth1", fStyle=-1
	Notebook $nb text=": Box smoothing for the black (main) trace. This affects not only auto detection but also all value meas"
	Notebook $nb text="urements (amplitude, rise time etc.), for which this parameter can be changed anytime. In auto detection"
	Notebook $nb text=", if event peaks are frequently detected in the rise phase or at other strange places, you may want to t"
	Notebook $nb text="ry a larger smooth1 value.\r"
	Notebook $nb fStyle=1, text="smooth2", fStyle=-1
	Notebook $nb text=": Box smoothing for the orange trace (if shown). This affects only the auto detection process. If slow r"
	Notebook $nb text="ising events are frequently missed and/or base points are set in the rise phase, try a larger value of s"
	Notebook $nb text="mooth 2. But do not make the orange trace too different from the black trace because there may a problem"
	Notebook $nb text=" if the peak amplitude of an orange-trace event becomes smaller than 85% of that of a black-trace event."
	Notebook $nb text=" \r"
	Notebook $nb fStyle=1, text="Base points", fStyle=-1
	Notebook $nb text=": The length of base line in the number of sampling points. The last point of the base line is the onset"
	Notebook $nb text=" time of the event.\r"
	Notebook $nb fStyle=1, text="From, To", fStyle=-1, text=": Events are detected only in this range of traces.\r"
	Notebook $nb fStyle=1, text="Decay Subtraction check", fStyle=-1
	Notebook $nb text=": When this is on, the amplitude measurement is decay corrected and the event area is measured.\r"
	Notebook $nb fStyle=1, text="Tau (ms)", fStyle=-1, text=": This value is required only when ", fStyle=1
	Notebook $nb text="Decay subtraction", fStyle=-1
	Notebook $nb text=" is checked on. Enter a rough estimation of the mean decay time constant of events.\r"
	Notebook $nb text="\r"
	Notebook $nb fStyle=1, text="More settings", fStyle=-1, text=":\r"
	Notebook $nb fStyle=1, text="Gross base line", fStyle=-1
	Notebook $nb text=": There are three ways to set the gross base line (yellow line). This selection affects only auto detect"
	Notebook $nb text="ion. \"Linear fit\" is default. \r"
	Notebook $nb fStyle=1, text="Valley (%)", fStyle=-1
	Notebook $nb text=": Default is 80%. For smooth traces (for example, EPSPs), a higher value (for example 95%) may result in"
	Notebook $nb text=" better detection. In general, an event is recognized as an individual event when the trace decays down "
	Notebook $nb text="to this % of the peak of the event.\r"
	Notebook $nb fStyle=1, text="Detect humps", fStyle=-1
	Notebook $nb text=": Turn this on if you would like to detect multiple events on a rising phase. Then the auto detection wi"
	Notebook $nb text="ll take events that do not have any decay phase. This is supposed to be used with a very high (>95%) \"Va"
	Notebook $nb text="lley (%)\" value.\r"
	Notebook $nb fStyle=1, text="Detect slow rising events", fStyle=-1
	Notebook $nb text=": Enhanced detection of slow rising events. This minimizes occasions that events are missed because of a"
	Notebook $nb text=" noisy rise phase. Fast rising events are detected normally.\r"
	Notebook $nb fStyle=1, text="Peak (%)", fStyle=-1
	Notebook $nb text=": This is an auxiliary setting for Decay subtraction, which should be set at 100% unless you have a spec"
	Notebook $nb text="ial requirement. Affects decay subtraction (green curves) only.\r"
	Notebook $nb text="\r"
	Notebook $nb fStyle=5, text="Other tips\r"
	Notebook $nb fStyle=-1, text="The ", fStyle=1, text="magnification of \"Zoom in\"", fStyle=-1
	Notebook $nb text=" can be set at the slider or at the value box (number). The number (N) in the box indicate that 10^N sam"
	Notebook $nb text="pling points are shown in the graph window in the zoom in mode.\r"
	Notebook $nb text="In \"", fStyle=1, text="Event cut out", fStyle=-1
	Notebook $nb text="\", traces will be cut out with the time range set by the above magnification. The smooth1 filter will be"
	Notebook $nb text=" applied. You can ", fStyle=1, text="fit decay curves", fStyle=-1, text=" and  ", fStyle=1
	Notebook $nb text="measure values", fStyle=-1, text=" between two cursors.\r"
	Notebook $nb text="When you do \"", fStyle=1, text="Save results", fStyle=-1
	Notebook $nb text="\", the waves in the following section will be generated. Masked events will be unmasked in the saved res"
	Notebook $nb text="ults. Note that this is not a \"save\" to the hard drive but just making of waves within Igor experiment.\r"
	Notebook $nb text="When you do \"", fStyle=1, text="Load results", fStyle=-1
	Notebook $nb text="\", the program first read ParamWaveXXXX, which has names of original data traces and the parameters you "
	Notebook $nb text="used. And then the program reads EpisodeXXXX, EventTimeXXXX and BaseTimeXXXX to find the places of all t"
	Notebook $nb text="he events. Finally, amplitudes, rise times and areas will be automatically measured.\r"
	Notebook $nb text="The main event detection window can be ", fStyle=1, text="closed", fStyle=-1
	Notebook $nb text=" by a usual way. (Click the window closure button at the top right (Window) or the top left (Mac).) As a"
	Notebook $nb text=" routine, Igor will ask you if you want to save a window recreation macro but you don’t need to save it."
	Notebook $nb text=" If you would like to keep the detection results, all you have to do is do \"Save results\" before closing"
	Notebook $nb text=" the event detection window.\r"
	Notebook $nb fStyle=1, text="“Check errors” button:\r"
	Notebook $nb fStyle=-1
	Notebook $nb text="When this button is clicked, the program will check each event, starting from the currently selected eve"
	Notebook $nb text="nt, and stops at an event that have a potential error. If you press this button again, the program searc"
	Notebook $nb text="hes a next error event. The potential errors include: (1) Rise time (20-80% and/or 10-90%) cannot be mea"
	Notebook $nb text="sured. This is often due to a wrong placing of base or peak point. (2) Two events overlap because the on"
	Notebook $nb text="set time of the event is set on the left to the peak time of the preceding event. (3) The decay time for"
	Notebook $nb text=" the event is on the limit, 1/5 or 5x of the user set “Tau”. (4) Event area cannot be measured. Points ("
	Notebook $nb text="3) and (4) are checked only when “Decay subtraction” is on. (5) ", textRGB=(0,15872,65280)
	Notebook $nb text="Half-width", textRGB=(0,1,2), text=" cannot be measured.\r"
	Notebook $nb text="Note that not all the potential errors are real errors. So you don’t have to correct them if you think t"
	Notebook $nb text="hey are OK.\r"
	Notebook $nb fStyle=1, text="Shift key + this button", fStyle=-1
	Notebook $nb text=" checks only 20-80% rise of point (1), point (2) and point (4).\r"
	Notebook $nb text="\r"
	Notebook $nb fStyle=5, text="Waves you get\r"
	Notebook $nb fStyle=-1, text="After doing \"", fStyle=4, text="Save results", fStyle=-1
	Notebook $nb text="\" of detection, the following waves will be created. The postfix XXXX is the name of the data set.\r"
	Notebook $nb text="Trace number: ", fStyle=1, text="EpisodeXXXX\r"
	Notebook $nb fStyle=-1, text="Event peak time: ", fStyle=1, text="EventTimeXXXX\r"
	Notebook $nb fStyle=-1, text="Event onset time: ", fStyle=1, text="BaseTimeXXXX\r"
	Notebook $nb fStyle=-1, text="Peak amplitude: ", fStyle=1, text="EventAmplitudeXXXX\r"
	Notebook $nb fStyle=-1, text="Y value at the event peak: ", fStyle=1, text="EventYValueXXXX\r"
	Notebook $nb fStyle=-1, text="Y value at the baseline: ", fStyle=1, text="BaseYValueXXXX\r"
	Notebook $nb fStyle=-1, text="Rise time (20 - 80%): ", fStyle=1, text="RiseTime2080XXXX\r"
	Notebook $nb fStyle=-1, text="Rise time (10 - 90%): ", fStyle=1, text="RiseTime1090XXXX\r"
	Notebook $nb fStyle=-1, textRGB=(0,15872,65280), text="Half-width", textRGB=(0,1,2), text=": ", fStyle=1
	Notebook $nb text="HalfWidthXXXX\r"
	Notebook $nb fStyle=-1, text="Detection parameters and the name of original traces (text wave): ", fStyle=1
	Notebook $nb text="ParamWaveXXXX\r"
	Notebook $nb fStyle=-1, text="Event area: ", fStyle=1, text="AreaAbsXXXX", fStyle=-1
	Notebook $nb text=" (Empty when “Decay subtraction” is off)\r"
	Notebook $nb text="Event masking info: ", fStyle=1, text="EventHideXXXX", fStyle=-1, text=" (0: non-masked, 1: masked)\r"
	Notebook $nb text="\r"
	Notebook $nb text="If you do \"", fStyle=4, text="curve fit", fStyle=-1
	Notebook $nb text="\" from \"Event cut out\" window, the following waves will be generated. You can enter any postfix but the "
	Notebook $nb text="same postfix as the above waves (XXXX) is recommended. Note that these waves are made ", fStyle=1
	Notebook $nb text="independently", fStyle=-1, text=" from the above \"Save results\". \r"
	Notebook $nb fStyle=2, text="- for a single exponential fit\r"
	Notebook $nb fStyle=-1, text="Offset: ", fStyle=1, text="DecayY0XXXX\r"
	Notebook $nb fStyle=-1, text="Amplitude: ", fStyle=1, text="DecayAXXXX\r"
	Notebook $nb fStyle=-1, text="Exponential time constant: ", fStyle=1, text="DecayTauXXXX\r"
	Notebook $nb fStyle=2, text="- for a double exponential fit\r"
	Notebook $nb fStyle=-1, text="Offset: ", fStyle=1, text="DecayY0dXXXX\r"
	Notebook $nb fStyle=-1, text="Amplitude1: ", fStyle=1, text="DecayA1XXXX\r"
	Notebook $nb fStyle=-1, text="Exponential time constant 1: ", fStyle=1, text="DecayTau1XXXX\r"
	Notebook $nb fStyle=-1, text="Amplitude2: ", fStyle=1, text="DecayA2XXXX\r"
	Notebook $nb fStyle=-1, text="Exponential time constant 2: ", fStyle=1, text="DecayTau2XXXX\r"
	Notebook $nb fStyle=-1, text="Weighted mean time constant: ", fStyle=1, text="DecayTauMXXXX\r"
	Notebook $nb fStyle=-1, text="\r"
	Notebook $nb text="The function \"", fStyle=4, text="Burst transform", fStyle=-1
	Notebook $nb text="\" also generates the above waves with a specified postfix.\r"
	Notebook $nb text="\r"
	Notebook $nb text="If you use \"", fStyle=4, text="Further analysis", fStyle=-1
	Notebook $nb text="\", the following values will be created. The postfix YYYY is the name of the analysis.\r"
	Notebook $nb text="For entire time window of original analysis (above XXXX), the following waves will be made:\r"
	Notebook $nb text="Trace number: ", fStyle=1, text="ExEpisodeYYYY\r"
	Notebook $nb fStyle=-1, text="Event peak time: ", fStyle=1, text="ExEventTimeYYYY\r"
	Notebook $nb fStyle=-1, text="Event onset time: ", fStyle=1, text="ExBaseTimeYYYY\r"
	Notebook $nb fStyle=-1, text="Peak amplitude: ", fStyle=1, text="ExEventAmpYYYY\r"
	Notebook $nb fStyle=-1, text="Rise time (20 - 80%): ", fStyle=1, text="ExRise2080YYYY\r"
	Notebook $nb fStyle=-1, text="Rise time (10 - 90%): ", fStyle=1, text="EXRise1090YYYY\r"
	Notebook $nb fStyle=-1, textRGB=(0,15872,65280), text="Half-width", textRGB=(0,1,2), text=": ", fStyle=1
	Notebook $nb text="ExHalfWidthYYYY\r"
	Notebook $nb fStyle=-1, text="Event number in original detection: ", fStyle=1, text="ExEventNumRefYYYY\r"
	Notebook $nb fStyle=-1, text="(if decay time has been measured)\r"
	Notebook $nb text="Decay time Tau (single): ", fStyle=1, text="ExTauYYYY\r"
	Notebook $nb fStyle=-1, text="Decay time Tau1:", fStyle=1, text="ExTau1YYYY\r"
	Notebook $nb fStyle=-1, text="Decay time Tau2:", fStyle=1, text="ExTau2YYYY\r"
	Notebook $nb fStyle=-1, text="Decay time Tau mean:", fStyle=1, text="ExTauMYYYY\r"
	Notebook $nb fStyle=-1, text="Event area:", fStyle=1, text="ExAreaYYYY\r"
	Notebook $nb text="\r"
	Notebook $nb fStyle=2, text="- if you select Raster...\r"
	Notebook $nb fStyle=-1, text="The above ExEventTimeYYYY and ExEpisodeYYYY will be used to make a raster graph.\r"
	Notebook $nb text="\r"
	Notebook $nb text="The following waves will be made for the time range set as \"", fStyle=4, text="Time range 1", fStyle=-1
	Notebook $nb text="\".\r"
	Notebook $nb fStyle=2, text="- if you select PSTH...\r"
	Notebook $nb fStyle=-1, text="Event number (or Event number per trace) in each bin: ", fStyle=1, text="W_PSTHYYYY\r"
	Notebook $nb fStyle=2, text="- if you select Amplitude trend...\r"
	Notebook $nb fStyle=-1, text="Mean amplitude of events in each bin: ", fStyle=1, text="AmpTrendYYYY\r"
	Notebook $nb fStyle=-1, text="Event number per trace in each bin: ", fStyle=1, text="AmpTrendMarkYYY\r"
	Notebook $nb fStyle=2, text="- if you select Area trend...\r"
	Notebook $nb fStyle=-1, text="Sum of event areas in each bin divided by trace number: ", fStyle=1, text="AreaTrendYYYY\r"
	Notebook $nb fStyle=-1, text="All area values separated into bins: ", fStyle=1, text="AreaTrendMxYYYY\r"
	Notebook $nb fStyle=2, text="- if you select Cumulative amp. trend...\r"
	Notebook $nb fStyle=-1, text="Sum of amplitudes in each bin divided by trace number: ", fStyle=1, text="CumulAmpTrendYYYY\r"
	Notebook $nb fStyle=-1, text="All ampliutde values separated into bins: ", fStyle=1, text="AmpTrendMxYYYY\r"
	Notebook $nb fStyle=2, text="- if you select Instant. freq. trend...\r"
	Notebook $nb fStyle=-1, text="Average and sem of instant. interval: ", fStyle=1
	Notebook $nb text="InstIntTrendAveYYYY, InstIntTrendSemYYYY\r"
	Notebook $nb fStyle=-1, text="Average and sem of instant. frequency: ", fStyle=1
	Notebook $nb text="InstFreqTrendAve,InstFreqTrendSemYYYY\r"
	Notebook $nb fStyle=-1, text="Baseline subtracted cumulative PSTH: ", fStyle=1, text="sub_CumPSTHYYYY\r"
	Notebook $nb fStyle=2, text="- if you select Cumulative PSTH...\r"
	Notebook $nb fStyle=-1, text="Cumulative PSTH (1ms bin): ", fStyle=1, text="W_CumPSTHYYYY\r"
	Notebook $nb fStyle=-1, text="Baseline subtracted cumulative PSTH: ", fStyle=1, text="sub_CumPSTHYYYY\r"
	Notebook $nb fStyle=-1, text="\r"
	Notebook $nb text="The following waves will be made for the time range set as \"", fStyle=4, text="Time range 2", fStyle=-1
	Notebook $nb text="\".\r"
	Notebook $nb fStyle=2, text="- if you select Calculate...\r"
	Notebook $nb fStyle=-1, text="Trace number: ", fStyle=1, text="zEpisodeWaveYYYY", fStyle=-1
	Notebook $nb text=" (for event time, amplitude and rise time)\r"
	Notebook $nb text="Event number in the trace: ", fStyle=1, text="zEventCountYYYY", fStyle=-1
	Notebook $nb text=" (for event time and amplitude)\r"
	Notebook $nb text="Event peak (or onset) time: ", fStyle=1, text="zLatencyWaveYYYY\r"
	Notebook $nb fStyle=-1, text="Peak amplitude: ", fStyle=1, text="zAmpWaveYYYY\r"
	Notebook $nb fStyle=-1, text="Rise time (20-80%): ", fStyle=1, text="zRise2080WaveYYYY\r"
	Notebook $nb fStyle=-1, text="Rise time (10-90%): ", fStyle=1, text="zRise1090WaveYYYY\r"
	Notebook $nb fStyle=-1, textRGB=(0,15872,65280), text="Half-width", textRGB=(0,1,2), text=": ", fStyle=1
	Notebook $nb text="zHalfWWaveYYYY\r"
	Notebook $nb fStyle=-1, text="Event number in original detection: ", fStyle=1, text="zEventRefWave\r"
	Notebook $nb fStyle=-1, text="Decay time Tau (single): ", fStyle=1, text="zTauWaveYYYY", fStyle=-1
	Notebook $nb text="(if decay time has been measured)\r"
	Notebook $nb text="Decay time Tau1:", fStyle=1, text="zTau1WaveYYYY", fStyle=-1, text="(if decay time has been measured)\r"
	Notebook $nb text="Decay time Tau2:", fStyle=1, text="zTau2WaveYYYY", fStyle=-1, text="(if decay time has been measured)\r"
	Notebook $nb text="Decay time Tau mean:", fStyle=1, text="zTauMWaveYYYY", fStyle=-1
	Notebook $nb text="(if decay time has been measured)\r"
	Notebook $nb text="Event time (2D): ", fStyle=1, text="zxLatencyMxYYYY", fStyle=-1, text=" (peak or onset)\r"
	Notebook $nb text="Event amplitude (2D): ", fStyle=1, text="zxAmpMxYYYY\r"
	Notebook $nb fStyle=-1, text="Rise time (20-80%) (2D): ", fStyle=1, text="zxRise2080MxYYYY\r"
	Notebook $nb fStyle=-1, text="Rise time (10-90%) (2D): ", fStyle=1, text="zxRise1090MxYYYY\r"
	Notebook $nb fStyle=-1, textRGB=(0,15872,65280), text="Half-width", textRGB=(0,1,2), text="(2D): ", fStyle=1
	Notebook $nb text="zxHalfWMxYYYY\r"
	Notebook $nb fStyle=-1, text="Event number in original detection: ", fStyle=1, text="zEventRefWave\r"
	Notebook $nb fStyle=-1, text="Decay time Tau (single): ", fStyle=1, text="zxTauMxYYYY", fStyle=-1
	Notebook $nb text="(if decay time has been measured)\r"
	Notebook $nb text="Decay time Tau1:", fStyle=1, text="zxTau1MxYYYY", fStyle=-1, text="(if decay time has been measured)\r"
	Notebook $nb text="Decay time Tau2:", fStyle=1, text="zxTau2MxYYYY", fStyle=-1, text="(if decay time has been measured)\r"
	Notebook $nb text="Decay time Tau mean:", fStyle=1, text="zxTauMMxYYYY", fStyle=-1
	Notebook $nb text="(if decay time has been measured)\r"
	Notebook $nb text="\r"
	Notebook $nb text="Trace number: ", fStyle=1, text="zIntEpisodeWaveYYYY", fStyle=-1
	Notebook $nb text=" (for interval, frequency and PPR)\r"
	Notebook $nb text="Event number in the trace: ", fStyle=1, text="zIntEventCountYYYY", fStyle=-1
	Notebook $nb text=" (for interval, frequency and PPR)\r"
	Notebook $nb text="Instantaneous interval: ", fStyle=1, text="zIntervalWaveYYYY\r"
	Notebook $nb fStyle=-1, text="Instantaneous frequency: ", fStyle=1, text="zFreqWaveYYYY\r"
	Notebook $nb fStyle=-1, text="PPR (Px/P1): ", fStyle=1, text="zRatioWaveYYYY\r"
	Notebook $nb fStyle=-1, text="PPR (Px/Px-1): ", fStyle=1, text="zIERWaveYYYY\r"
	Notebook $nb fStyle=-1, text="Instantaneous interval (2D): ", fStyle=1, text="zxIntervalMxYYYY\r"
	Notebook $nb fStyle=-1, text="Instantaneous frequency (2D): ", fStyle=1, text="zxFreqMxYYYY\r"
	Notebook $nb fStyle=-1, text="PPR (Px/P1) (2D): ", fStyle=1, text="zxRatioMxYYYY\r"
	Notebook $nb fStyle=-1, text="PPR (Px/Px-1) (2D): ", fStyle=1, text="zxIERMxYYYY\r"
	Notebook $nb fStyle=-1, text="\r"
	Notebook $nb text="The following waves have values for each trace. (Thus wave points are same as the number of traces.)\r"
	Notebook $nb text="Number of events: ", fStyle=1, text="zzEventsPerEpiYYYY\r"
	Notebook $nb fStyle=-1, text="Min instantaneous interval: ", fStyle=1, text="zzMinIntervalYYYY\r"
	Notebook $nb fStyle=-1, text="Mean instantaneous interval:", fStyle=1, text="zzMeanIntervalYYYY\r"
	Notebook $nb fStyle=-1, text="Max instantaneous frequency: ", fStyle=1, text="zzMaxFreqYYYY\r"
	Notebook $nb fStyle=-1, text="Mean instantaneous frequency: ", fStyle=1, text="zzMeanFreqYYYY\r"
	Notebook $nb fStyle=-1, text="Time from 1st to last event: ", fStyle=1, text="zzDurationTimeYYYY\r"
	Notebook $nb fStyle=-1, text="Mean frequency during the above time: ", fStyle=1, text="zzDurationFreqYYYY\r"
	Notebook $nb fStyle=2, text="\r"
	Notebook $nb text="- if you select Summary list...\r"
	Notebook $nb fStyle=-1, text="Label column (text) for the next 3 waves: ", fStyle=1, text="labelsYYYY\r"
	Notebook $nb fStyle=-1, text="Value (average value when accompanies by SEM and N): ", fStyle=1, text="valueYYYY\r"
	Notebook $nb fStyle=-1, text="S.E.M of collective values: ", fStyle=1, text="semYYYY\r"
	Notebook $nb fStyle=-1, text="Number of averaged values: ", fStyle=1, text="nYYYY\r"
	Notebook $nb fStyle=-1, text="\r"
	Notebook $nb fStyle=2, text="- if you select Amplitude histogram...\r"
	Notebook $nb fStyle=-1, text="Event number in each bin: ", fStyle=1, text="W_AmpHistoYYYY\r"
	Notebook $nb text="\r"
	Notebook $nb fStyle=2, text="- if you select Interval histogram...\r"
	Notebook $nb fStyle=-1, text="Event number in each bin: ", fStyle=1, text="W_IntervalHistoYYYY\r"
	Notebook $nb text="\r"
	Notebook $nb fStyle=2, text="- if you select Rise time histogram...\r"
	Notebook $nb fStyle=-1, text="Event number in each bin: ", fStyle=1, text="W_RiseHistoYYYY\r"
	Notebook $nb text="\r"
	Notebook $nb fStyle=2, text="- if you select ", textRGB=(0,15872,65280), text="Half-width", textRGB=(0,1,2)
	Notebook $nb text=" histogram...\r"
	Notebook $nb fStyle=-1, text="Event number in each bin: ", fStyle=1, text="W_HalfWHistoYYYY\r"
	Notebook $nb text="\r"
	Notebook $nb fStyle=2, text="- if you select Decay time histogram...\r"
	Notebook $nb fStyle=-1, text="Event number in each bin: ", fStyle=1, text="W_DecayHistoYYYY\r"
	Notebook $nb text="\r"
	Notebook $nb fStyle=2, text="- if you select Autocorrelogram...\r"
	Notebook $nb fStyle=-1, text="Event number in each bin: ", fStyle=1, text="W_AutocorrelYYYY\r"

	//
	Notebook $nb findText={"Event detection procedures", 17 }	
	End

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  Event detection program - end here

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  Event detection program - end here


Function TISelectWaves() // Show a panel
	String AllWaveList  = WaveList("*",";","")
	AllWaveList = RemoveFromList ("AllWave", AllWaveList)
	AllWaveList = RemoveFromList ("WaveSel", AllWaveList)
	AllWaveList = RemoveFromList ("SelectedWaveNames", AllWaveList)
	AllWaveList = RemoveFromList ("GraphedWaveNames", AllWaveList)
	AllWaveList = RemoveFromList ("CutOutWaveNames", AllWaveList)
	Variable n= ItemsInList(AllWaveList)
	Make/O/T/N=(n) AllWave = StringFromList(p,AllWaveList)	//convert the dir list to a wave
	Sort/A AllWave AllWave
	Make/O/N=(n) WaveSel
	variable/G SelectedNumDisp
	variable/G InaterleaveNum = 1,InterleaveOf =2
	String/G Keyword=""
	String CurrentDataFolder = getDataFolder(1)
	SetFormula SelectedNumDisp, "sum(WaveSel)"
	

	if (WinType("WaveAnalysisPanel") ==0)	//if the main panels does not exist yet...
		TaroSetFont()
		NewPanel /W=(280,57,580,544)/N= WaveAnalysisPanel as "SelectWaves"
		ListBox LB1,pos={34,27},size={233,220},frame=2,listWave=AllWave
		ListBox LB1,selWave=WaveSel,mode= 4
		Button Button1,pos={32,329},size={110,20},proc=getAverageWave,title="Average waves"
		Button Button1,fColor=(65280,48896,55552)
		Button Button4,pos={32,354},size={110,20},proc=baselinePanel,title="Adjust baseline"
		Button Button4,fColor=(65280,48896,62208)
		Button Button5,pos={32,379},size={110,20},proc=MeasureAreaPanel,title="Measure area"
		Button Button5,fColor=(51456,44032,58880)
		Button Button3,pos={32,404},size={110,20},proc=EventDetectionButtonProc,title="Event detection"
		Button Button3,fColor=(48896,49152,65280)
		Button Button6,pos={32,429},size={110,20},proc=RenameWavesPanel,title="Rename,Duplicate"
		Button Button6,fColor=(48896,52992,65280)
		Button Button0,pos={32,454},size={110,20},proc=DrawGraphButton,title="Graph"
		Button Button0,fColor=(48896,59904,65280)
		Button Button10,pos={152,329},size={110,20},proc=DeleteWavesProc,title="Delete waves"
		Button Button10,fColor=(48896,65280,65280)
		Button Button11,pos={152,354},size={110,20},proc=MakeTableButton,title="Table"
		Button Button11,fColor=(48896,65280,57344)
		Button Button12,pos={152,378},size={110,20},proc=ScaleWavesShowPanel,title="Scale waves"
		Button Button12,fColor=(48896,65280,48896)
		Button Button13,pos={152,402},size={110,20},proc=ShiftWavesShowPanel,title="Shift waves"
		Button Button13,fColor=(57344,65280,48896)
		Button Button2,pos={152,454},size={110,20},proc=CloseWaveAnalysisPanel,title="Close"
		Button Button2,fStyle=1
		Button Button7,pos={30,274},size={75,20},proc=SelectWavesAllOrNone,title="select all"
		Button Button8,pos={113,274},size={75,20},proc=SelectWavesAllOrNone,title="select none"
		Button Button9,pos={195,274},size={75,20},proc=RefreshListButton,title="refresh list"
		SetVariable setvar0,pos={160,252},size={104,16},proc=ChangeKeyword,title="keyword"
		SetVariable setvar0,limits={-inf,inf,0},value= Keyword,bodyWidth= 60
		SetVariable setvar1,pos={37,252},size={109,16},disable=2,title="Selected:"
		SetVariable setvar1,frame=0
		SetVariable setvar1,limits={-inf,inf,0},value= SelectedNumDisp,bodyWidth= 60
		Button Button08,pos={30,298},size={75,20},proc=SelectInterleaveWaves,title="Interleave"
		SetVariable setvar2,pos={116,300},size={40,16},title=" "
		SetVariable setvar2,limits={1,inf,1},value= InaterleaveNum,bodyWidth= 40
		SetVariable setvar3,pos={166,300},size={56,16},title="of "
		SetVariable setvar3,limits={1,inf,1},value= InterleaveOf,bodyWidth= 40
		TitleBox title0,pos={38,9},size={25,13},title=CurrentDataFolder,frame=0
	else 
		DoWindow/F  WaveAnalysisPanel
	endif
	
End

Function CloseWaveAnalysisPanel(ctrlName) : ButtonControl
	String ctrlName
	DoWindow/K WaveAnalysisPanel
	KillVariables/Z SelectedNumDisp,BaselineXfrom,BaselineXto,WaveXFrom,WaveXTo//,SelectedNumMinus
	KillVariables/Z SelectedNum,InaterleaveNum,InterleaveOf, ScaleWavesXDigits, ScaleWavesYDigits,NewXZero, NewYZero
	KillStrings/Z KeyWord,StringToAdd,StringToAdd2,StringToBeReplaced,StringToReplaceWith,postfixstr,StringNewNameOfWave
	KillWaves/Z AllWave, WaveSel, SelectedWaveNames
End


Function SelectWavesAllOrNone(ctrlName) : ButtonControl
	String ctrlName
	wave WaveSel
	if (stringmatch(ctrlName, "Button7"))
		RefreshWaveList()
		WaveSel = 1
	endif
	if (stringmatch(ctrlName, "Button8"))
		RefreshWaveList()
	endif

End

Function SelectInterleaveWaves(ctrlName) : ButtonControl
	String ctrlName
	NVAR InaterleaveNum,InterleaveOf
	wave WaveSel
	variable ListedNum =numpnts(WaveSel)
	variable i = 0
	do
		if (mod(i, InterleaveOf)+1 == InaterleaveNum)
			WaveSel[i] = 1
		else
			WaveSel[i] =0
		endif
	i += 1
	while (i < ListedNum)
End

Function RefreshWaveList()
	Wave/T AllWave
	Wave WaveSel
	SVAR Keyword
	String AllWaveList  = WaveList("*",";","")
	AllWaveList = RemoveFromList ("AllWave", AllWaveList)
	AllWaveList = RemoveFromList ("WaveSel", AllWaveList)
	AllWaveList = RemoveFromList ("SelectedWaveNames", AllWaveList)
	AllWaveList = RemoveFromList ("GraphedWaveNames", AllWaveList)
	AllWaveList = RemoveFromList ("CutOutWaveNames", AllWaveList)
	AllWaveList = ListMatch(AllWaveList, "*"+Keyword+"*")
	Variable n= ItemsInList(AllWaveList)
	Redimension/N =(n)  AllWave
	Redimension/N =(n)  WaveSel
	AllWave = StringFromList(p,AllWaveList)
	Sort/A AllWave AllWave
	WaveSel = 0
End

Function ChangeKeyword(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	RefreshWaveList()
End

Function RefreshListButton(ctrlName) : ButtonControl
	String ctrlName
	SVAR Keyword
	Keyword = ""
	RefreshWaveList()
End


Function MakeSelectedWaveNamesWave()
	wave WaveSel
	wave/T AllWave
	variable/G SelectedNum =sum(WaveSel)
	variable ListedNum =numpnts(WaveSel)
	variable/G WaveXFrom
	variable/G WaveXTo
	if (SelectedNum == 0)
		abort "Select at least one wave."
	endif
	Make/O/T/N=(SelectedNum) SelectedWaveNames
	variable i = 0, k = 0
	do 
		if (WaveSel[i])
			SelectedWaveNames[k] = AllWave[i]
			k += 1
		endif
		i += 1
	while (i < ListedNum)
	
	WaveXFrom = leftx($SelectedWaveNames[0])
	WaveXTo = rightx($SelectedWaveNames[0])
End


Function getAverageWave(ctrlName) : ButtonControl // get Average
	String ctrlName

	MakeSelectedWaveNamesWave()
	wave/T w1 = SelectedWaveNames
	NVAR SelectedNum
	
	String DefaultName = w1[0]+"_etal_ave"
	String RequestName = DefaultName
	Prompt RequestName, "Enter the name of averaged wave."
	DoPrompt "Average waves",RequestName
	if (V_flag == 1)
		abort
	endif
	
	duplicate/O $w1[0] $RequestName
	wave Ave_Wave =$RequestName
	Ave_Wave = 0
	variable i = 0
	do
		wave  WorkingWave = $w1[i]
		Ave_Wave += WorkingWave
		i += 1
	while (i < SelectedNum)
	
	Ave_Wave /= SelectedNum
	RefreshWaveList()
End

Function BaselinePanel(ctrlName) : ButtonControl // Show a panel to set baseline region
	String ctrlName
	MakeSelectedWaveNamesWave()
	NVAR WaveXFrom
	NVAR WaveXTo
	if (WinType("SelectBaselineRegion") >0)
		DoWindow/F SelectBaselineRegion
	else		
		TaroSetFont()
		NewPanel /N = SelectBaselineRegion /W=(329,94,632,294)
		TitleBox title0,pos={64,28},size={44,12},title="Baseline",frame=0
		SetVariable setvar0,pos={68,48},size={130,15},title="From"
		SetVariable setvar0,limits={-inf,inf,0.1},value=WaveXfrom,bodyWidth= 100
		SetVariable setvar1,pos={81,72},size={117,15},title="To"
		SetVariable setvar1,limits={-inf,inf,0.1},value=WaveXto,bodyWidth= 100
		CheckBox check0,pos={97,97},size={103,14},title="Overwrite waves",value= 1
		Button button0,pos={76,126},size={50,20},title="OK",proc = BaselineSubtraction
		Button button1,pos={155,126},size={50,20},title="Cancel",proc=CancelButtonTI
	endif
End

Function BaselineSubtraction(ctrlName) : ButtonControl // Do Baseline adjustment
	String ctrlName
	NVAR WaveXFrom
	NVAR WaveXTo

	Controlinfo /W=SelectBaselineRegion check0
	variable overwrite = V_value

	DoWindow/K SelectBaselineRegion
	wave/T w1 = SelectedWaveNames
	NVAR SelectedNum
	print "Adjust baseline from " + num2str(WaveXFrom)+ " to "+num2str(WaveXTo)+ " (ms):"
	variable i =0
	do
		if (overwrite)
			wave ww = $w1[i]
			print "    wave:" + w1[i]
		else
			String NewName = w1[i] +"_BaseAdjusted"
			Duplicate/O $w1[i] $NewName
			wave ww = $NewName
			print "    wave:" + NewName
		endif
		WaveStats/Q/M=1/R=(WaveXFrom, WaveXTo) ww
		variable base = V_avg
		//variable base = mean(ww, WaveXFrom, WaveXTo)
		ww -= base
		i += 1
	while (i < SelectedNum)
End

Function MeasureAreaPanel(ctrlName) : ButtonControl // Show a panel to set baseline for area measure
	String ctrlName
	MakeSelectedWaveNamesWave()
	variable key = getkeystate(0)
	if (key)//shift
		wave/T w1 = SelectedWaveNames
		NVAR SelectedNum
		variable i =0
		do 
			wave ww = $w1[i]
			if (key == 4)
				Integrate ww /D=$(w1[i] + "_int")
			elseif (key == 5)
				Differentiate ww /D=$(w1[i] + "_dif")
			endif
			i += 1
		while (i < SelectedNum)
		RefreshWaveList()
	else
		NVAR WaveXFrom
		NVAR WaveXTo
		if (WinType("SelectAreaWindow") >0)
			DoWindow/F SelectAreaWindow
		else		
			TaroSetFont()
			NewPanel /N = SelectAreaWindow /W=(329,94,632,294)
			TitleBox title0,pos={64,28},size={44,12},title="Measure",frame=0
			SetVariable setvar0,pos={68,48},size={130,15},title="From"
			SetVariable setvar0,limits={-inf,inf,0.1},value=WaveXFrom,bodyWidth= 100
			SetVariable setvar1,pos={81,72},size={117,15},title="To"
			SetVariable setvar1,limits={-inf,inf,0.1},value=WaveXTo,bodyWidth= 100
			Button button0,pos={76,126},size={50,20},title="OK",proc = PrintMeasuredArea
			Button button1,pos={155,126},size={50,20},title="Cancel",proc=CancelButtonTI
		endif
	endif
End

Function PrintMeasuredArea(ctrlName) : ButtonControl // Do area measurement
	String ctrlName
	wave/T w1 = SelectedWaveNames
	NVAR SelectedNum
	NVAR WaveXFrom
	NVAR WaveXTo

	
	DoWindow/K SelectAreaWindow
	print "Measure area from " + num2str(WaveXFrom) + " to " + num2str(WaveXTo)
	variable i =0
	do 
		wave ww = $w1[i]
		print w1[i] +":\t" + num2str(area(ww, WaveXFrom, WaveXTo))
		i += 1
	while (i < SelectedNum)
End

Function RenameWavesPanel(ctrlName) : ButtonControl // Show a panel to set renaming
	String ctrlName
	String/G StringToAdd,StringToAdd2
	String/G StringToBeReplaced
	String/G StringToReplaceWith
	String/G StringNewNameOfWave
	if (WinType("RenameWaves") >0)
		DoWindow/F RenameWaves
	else		
		TaroSetFont()
		NewPanel /W=(560,93,850,432) /N = RenameWaves
		Button button0,pos={86,302},size={50,20},proc=DoRenameWaves,title="OK"
		Button button1,pos={165,302},size={50,20},proc=CancelButtonTI,title="Cancel"
		CheckBox check0,pos={25,156},size={65,14},proc=RenameWavesPanelCheck,title="Add prefix"
		CheckBox check0,value= 0
		CheckBox check1,pos={25,219},size={70,14},proc=RenameWavesPanelCheck,title="Add postfix"
		CheckBox check1,value= 0
		CheckBox check2,pos={25,90},size={115,14},proc=RenameWavesPanelCheck,title="Replace name string"
		CheckBox check2,value= 0
		CheckBox check3,pos={25,26},size={104,14},proc=RenameWavesPanelCheck,title="Entirely new name"
		CheckBox check3,value= 1
		SetVariable setvar0,pos={49,186},size={90,16},title="Prefix"
		SetVariable setvar0,limits={-inf,inf,0},value= StringToAdd,bodyWidth= 60
		SetVariable setvar1,pos={39,120},size={104,16},title="Replace"
		SetVariable setvar1,limits={-inf,inf,0},value= StringToBeReplaced,bodyWidth= 60
		SetVariable setvar2,pos={153,120},size={83,16},title="with"
		SetVariable setvar2,limits={-inf,inf,0},value= StringToReplaceWith,bodyWidth= 60
		SetVariable setvar3,pos={41,46},size={146,16},title="Replace to"
		SetVariable setvar3,limits={-inf,inf,0},value= StringNewNameOfWave,bodyWidth= 90
		SetVariable setvar4,pos={44,242},size={95,16},title="Postfix"
		SetVariable setvar4,limits={-inf,inf,0},value= StringToAdd2,bodyWidth= 60
		TitleBox title0,pos={42,64},size={224,13},title="For multiple waves, postfix 0, 1 ... will be added."
		TitleBox title0,frame=0
		CheckBox check4,pos={25,272},size={112,14},proc=RenameWavesPanelCheck,title="Duplicate waves"
		CheckBox check4,fStyle=1,value= 0
	endif
End

Function RenameWavesPanelCheck(ctrlName,ctrlValue) : CheckBoxControl
	String ctrlName
	variable ctrlValue	
	if (stringmatch(ctrlName, "check3"))//entirely new name
		CheckBox check0,value= 0
		CheckBox check1,value= 0
		CheckBox check2,value= 0
		CheckBox check3,value= 1
	endif
	
	 if (stringmatch(ctrlName, "check0")||stringmatch(ctrlName, "check1")||stringmatch(ctrlName, "check2"))
		CheckBox check3,value= 0
	endif
	
End

Function DoRenameWaves(ctrlName) : ButtonControl // Do renaming
	String ctrlName
	variable EntirelyNew
	variable replaceflag
	variable DuplicationFlag
	SVAR StringToAdd
	SVAR StringToAdd2
	SVAR StringToBeReplaced
	SVAR StringToReplaceWith
	SVAR StringNewNameOfWave
	
	MakeSelectedWaveNamesWave()
	wave/T w1 = SelectedWaveNames
	NVAR SelectedNum
	
	ControlInfo /W = RenameWaves check4
	if (V_Value)
		DuplicationFlag = 1
	else
		DuplicationFlag = 0
	endif
	
	ControlInfo /W = RenameWaves check3
	if (V_Value)
		EntirelyNew = 1
	else
		EntirelyNew = 0
	endif
	
	ControlInfo /W = RenameWaves check2
	if (V_Value)
		replaceflag = 1
	else
		replaceflag = 0
	endif
	
	ControlInfo /W = RenameWaves check0//add pre
	if (! V_Value)
		StringToAdd = "" //prefix
	endif

	ControlInfo /W = RenameWaves check1//add post
	if (! V_Value)
		StringToAdd2 = "" //postfix
	endif

	String NewWaveName
	variable i =0
	do 
		if (EntirelyNew)
			if (SelectedNum == 1)
				NewWaveName = StringNewNameOfWave
			else
				NewWaveName = StringNewNameOfWave+num2str(i)
			endif
		else
			NewWaveName =  w1[i]
			if (replaceflag)
				NewWaveName = ReplaceString(StringToBeReplaced,NewWaveName,StringToReplaceWith)
			endif
			NewWaveName = StringToAdd + NewWaveName + StringToAdd2
		endif
		if (DuplicationFlag)
			Duplicate/O $w1[i],$NewWaveName
		else
			Rename $w1[i],$NewWaveName
		endif
		i += 1
	while (i < SelectedNum)
	DoWindow /K RenameWaves
	RefreshWaveList()
End

Function DrawGraphButton(ctrlName) : ButtonControl ///////////////// Draw Graph
	String ctrlName
	if (Exists("SimpleGraphName") == 2)
		SVAR SimpleGraphName
	else
		String/g SimpleGraphName =""
	endif
	if (WinType(SimpleGraphName) == 1)
		//KillTheBottomBar	(SimpleGraphName)
		KillTheBottomBarButton("buttonXSimple")//call Button Control
	endif
	
	MakeSelectedWaveNamesWave()
	duplicate/O SelectedWaveNames, GraphedWaveNames
	wave/T w1 = GraphedWaveNames
	variable/g GraphedNum
	NVAR SelectedNum
	GraphedNum = SelectedNum
	variable/G GraphedNumMinus = GraphedNum-1
	variable/g HighLightWaveNum=0
	variable/g ShowFitFlag = 0
	
	Preferences/Q 0
	variable winwidth
	if (stringmatch(IgorInfo(2),"Windows"))
		winwidth = 590
	else
		winwidth = 800
	endif

	Display /W=(0,40,winwidth,400)
	SimpleGraphName = WinName(0,1)
	variable i = 0
	do
		AppendToGraph/W=$SimpleGraphName  $w1[i]
		i += 1
	while (i < GraphedNum)
	ModifyGraph rgb=(0,0,0), lsize=0.5
	
	DoUpdate
	GetAxis/W=$SimpleGraphName/Q bottom
	if (exists("SimpleGraphCursorFrom"))
		NVAR SimpleGraphCursorFrom
	else
		Variable/g SimpleGraphCursorFrom =  round(V_min*0.55+V_max*0.45)
	endif
	if (exists("SimpleGraphCursorTo"))
		NVAR SimpleGraphCursorTo
	else
		Variable/g SimpleGraphCursorTo =  round(V_min*0.45+V_max*0.55)
	endif
	SetWindow $SimpleGraphName, hook=SimpleGraphCursorHook,hookevents=5 // setting cursor,mouse hook	
	
//		Prompt cursorAx, "Cursor A, x value"
//		Prompt cursorBx, "Cursor B, x value"
//		DoPrompt "Enter initial position of cursors", cursorAx, cursorBx
		
	ControlBar/B 40
	TaroSetFont()
	NewPanel/W=(0.2,0.2,0.8,0.8)/FG=(GL,GB,FR,FB)/HOST=# 
	SetVariable setvar0,pos={44,9},size={70,23},title=" ",proc=GraphTraceNumChange,fSize=16
	SetVariable setvar0,limits={0,GraphedNumMinus,1},value= HighLightWaveNum
	SetVariable setvar1,pos={117,13},size={90,19},disable=2,title=" "
	SetVariable setvar1,format="of 0  to  %g",frame=0,fSize=14
	SetVariable setvar1,limits={-inf,inf,0},value= GraphedNumMinus
	SetVariable setvar2,pos={220,13},size={230,19},disable=2,title="wave:",frame=0
	SetVariable setvar2,limits={-inf,inf,0},value= w1[0],bodyWidth= 200//,fSize=14
	Button button0,pos={594,10},size={90,20},title="auto scale",proc=GraphTraceAutoScale//,fSize=14
	Button buttonXSimple,pos={755,9},size={20,20},title="X",proc=KillTheBottomBarButton
	CheckBox check0,pos={697,13},size={47,14},title="cursor",value= 0,proc=GraphCursorCheck
	Button button2,pos={245,42},size={100,20},proc=RemoveArtifactButton,title="remove artifact"
	//Button button2,fSize=14
	Button button3,pos={350,42},size={100,20},proc=AdjustBaselineOfGraph,title="adjust baseline"
	//Button button3,fSize=14
	Button button4,pos={455,42},size={100,20},proc=CurveFitOfGraph,title="fit curve"
	//Button button4,fSize=14
	Button button5,pos={560,42},size={100,20},proc=MeasureValuesOfGraph,title="measure values"
	//Button button5,fSize=14
	Button button6,pos={665,42},size={100,20},proc=TI_AnalyseIV,title=" I V "
	SetVariable setvar4,pos={13,43},size={134,18},bodyWidth=70,proc=SimpleGraphFromToChange,title="Cursor From"
	SetVariable setvar4,limits={-inf,inf,0.1},value=SimpleGraphCursorFrom
	SetVariable setvar5,pos={152,43},size={83,18},bodyWidth=70,proc=SimpleGraphFromToChange,title="to"
	SetVariable setvar5,limits={-inf,inf,0.1},value=SimpleGraphCursorTo	
	RenameWindow #,PBottom
	SetActiveSubwindow ##
	if (GraphedNum > 1)
		Duplicate/O $w1[0] RedTrace
		AppendToGraph/W=$SimpleGraphName  RedTrace
		ModifyGraph rgb(RedTrace)=(65280,0,0)
	endif
	String/g SimpleGraphNameList = TraceNameList("",";",1)
//	CheckBox check0,value= 1
//	GraphCursorCheck("check0",1)	//calling a CheckBoxControl
//   decomentarized above to activate cursors upon window creation
End

Function SimpleGraphFromToChange(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	NVAR SimpleGraphCursorFrom,SimpleGraphCursorTo
	String sametrace
	if (stringmatch(ctrlName, "setvar4"))//From change	
		sametrace = StringByKey("TNAME", csrinfo(A))
		Cursor/A=1 A  $sametrace SimpleGraphCursorFrom
	endif	
	
	if (stringmatch(ctrlName, "setvar5"))//To change
		sametrace = StringByKey("TNAME", csrinfo(B))
		Cursor/A=1 B  $sametrace SimpleGraphCursorTo
	endif	
End

Function SimpleGraphCursorHook (infoStr)
	String infoStr
	SVAR SimpleGraphName
	NVAR SimpleGraphCursorFrom,SimpleGraphCursorTo
	String event = StringByKey("EVENT",infoStr)
	if (stringmatch(event, "cursormoved"))
		String tracename = StringByKey("TNAME",infoStr)
		String cursorname = StringByKey("CURSOR",infoStr)
		String cursorpoint = StringByKey("POINT",infoStr)
		if (!stringmatch(cursorpoint,""))
			variable cursortime = pnt2x(TraceNameToWaveRef(SimpleGraphName, tracename ), str2num(cursorpoint))
			if (stringmatch(cursorname,"A"))
				SimpleGraphCursorFrom = cursortime
			endif
			if (stringmatch(cursorname,"B"))
				SimpleGraphCursorTo = cursortime
			endif
		endif	
	endif
	
	if (stringmatch(event, "mouseup"))
		//String modifiers = StringByKey("MODIFIERS",infoStr)
		String mousex = StringByKey("MOUSEX",infoStr)
		String mousey = StringByKey("MOUSEY",infoStr)
		variable mox=str2num(mousex)
		variable moy=str2num(mousey)
		//print mox,moy
		String TraceString
		TraceString = TraceFromPixel(mox, moy, "")
		//print TraceString
		String clicktrace = StringByKey("TRACE",TraceString)
		//print clicktrace
		if ((stringmatch(clicktrace,"RedTrace"))||(stringmatch(clicktrace,"BlueTrace"))||(stringmatch(clicktrace,"")))
			abort
		else
			SVAR SimpleGraphNameList
			variable tracenum = WhichListItem(clicktrace, SimpleGraphNameList)
			//print tracenum
			NVAR HighLightWaveNum
			HighLightWaveNum= tracenum
			GraphTraceNumChangeDo(tracenum)
		endif
		
	endif
	return 0
End

Function GraphTraceNumChange(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	GraphTraceNumChangeDo(varNum)
End

Function GraphTraceNumChangeDo(num)
	variable num
	wave/T w1 = GraphedWaveNames
	NVAR ShowFitFlag
	SVAR SimpleGraphName
	Duplicate/O $w1[num], RedTrace
	if (ShowFitFlag)
		wave CurveFit2D
		Duplicate/O/R=[][num] CurveFit2D,BlueTrace
	endif
	SetActiveSubwindow $SimpleGraphName#PBottom
	SetVariable setvar2,value= w1[num]
End

Function GraphTraceAutoScale(ctrlName) : ButtonControl 
	String ctrlName
	SetAxis/A
End

Function KillTheBottomBarButton(ctrlName) : ButtonControl 
	String ctrlName
	if (stringmatch(ctrlName,"buttonXSimple"))
		SVAR SimpleGraphName
		KillTheBottomBar(SimpleGraphName)
		killwaves/Z RedTrace, BlueTrace,GraphedWaveNames
		SetWindow $SimpleGraphName  hook=$""
	endif
	if (stringmatch(ctrlName,"buttonXCutOut"))
		SVAR CutOutGraphName
		KillTheBottomBar(CutOutGraphName)
		killwaves/Z RedTrace2, BlueTrace2,CutOutWaveNames
		SetWindow $CutOutGraphName hook=$""
	endif
End	

Function KillTheBottomBar	(GraphName)
	String GraphName
	RemoveFromGraph/Z/W=$GraphName RedTrace
	RemoveFromGraph/Z/W=$GraphName BlueTrace
	RemoveFromGraph/Z/W=$GraphName RedTrace2
	RemoveFromGraph/Z/W=$GraphName BlueTrace2
//	print GraphName
//	SetActiveSubwindow $GraphName#PBottom
//	print WinType(GraphName+"#PBottom")	
	if (WinType(GraphName+"#PBottom") > 0)
		killwindow $(GraphName+"#PBottom")
	endif
	ControlBar/W=$GraphName/B 0
	HideInfo /W=$GraphName
	Cursor/K A
	Cursor/K B
End

Function GraphCursorCheck(ctrlName,checked) : CheckBoxControl//cursor show hide
	String ctrlName
	Variable checked
	SVAR SimpleGraphName
	NVAR GraphedNum
	//variable cursorAx, cursorBx
	NVAR SimpleGraphCursorFrom,SimpleGraphCursorTo
	wave/T w1 = GraphedWaveNames
	String t1
	if (GraphedNum == 1)
		t1 = w1[0]
	else
		t1 = "RedTrace"
	endif

	GetWindow $SimpleGraphName wsize
	if (checked)
//		GetAxis/W=$SimpleGraphName/Q bottom
//		cursorAx = round(V_min*0.55+V_max*0.45)
//		cursorBx = round(V_min*0.45+V_max*0.55)
//		Prompt cursorAx, "Cursor A, x value"
//		Prompt cursorBx, "Cursor B, x value"
//		DoPrompt "Enter initial position of cursors", cursorAx, cursorBx
//		if (V_flag)
//		 CheckBox check0,value= 0,win=$SimpleGraphName#PBottom
//		 abort
//		endif
		MoveWindow /W=$SimpleGraphName V_left, V_top, V_right, (V_bottom+26)
		ShowInfo/W=$SimpleGraphName
		Cursor/A=1/C=(0,65280,0)/H=2/S=0 A $t1 SimpleGraphCursorFrom
		Cursor/A=1/C=(0,65280,0)/H=2/S=0 B $t1 SimpleGraphCursorTo
	
		ControlBar/W=$SimpleGraphName/B 75
	else
		MoveWindow /W=$SimpleGraphName V_left, V_top, V_right, (V_bottom-26)
		HideInfo/W=$SimpleGraphName
		Cursor/K A
		Cursor/K B
		ControlBar/W=$SimpleGraphName/B 40
	endif
End

Function RemoveArtifactButton(ctrlName) : ButtonControl//remove artifact
	String ctrlName
	if (WinType("SelectionForArtifactRemove") > 0)
		DoWindow/K SelectionForArtifactRemove
	endif
	NVAR GraphedNum
	TaroSetFont()
	NewPanel /W=(278,148,510,286)/N=SelectionForArtifactRemove as "Select"
	PopupMenu popup0,pos={15,32},size={99,21},title="Fill with:"
	PopupMenu popup0,mode=1,value= #"\"Nan;0;Mean;InterPol\""
	Button button0,pos={50,74},size={50,20},title="OK",proc = RemoveArtifactDo,disable =0
	Button button1,pos={125,74},size={50,20},title="Cancel",proc=CancelButtonTI,disable =0
	PopupMenu popup1,pos={139,32},size={57,21}
	PopupMenu popup1,mode=1,value= #"\"This trace;All traces\""	
	if (GraphedNum == 1)
		PopupMenu popup1,disable =2
	else
		PopupMenu popup1,disable =0
	endif

End

Function RemoveArtifactDo(ctrlName) : ButtonControl
	String ctrlName
	variable Filler, FillerType
	NVAR GraphedNum
	wave/T w1 = GraphedWaveNames
	SVAR SimpleGraphName
	variable xfrom = pcsr(A, SimpleGraphName)//p
	variable xto = pcsr(B, SimpleGraphName)//p
	if (xfrom > xto)
		variable xtemp = xto
		xto = xfrom
		xfrom = xtemp
	endif
	ControlInfo/W=$SimpleGraphName#PBOTTOM	setvar0
	Variable varNum = V_Value
	
	ControlInfo/W=SelectionForArtifactRemove popup0
	FillerType = V_Value
		
	ControlInfo/W=SelectionForArtifactRemove popup1	
	variable trFrom,trTo
	if (stringmatch(S_Value, "This trace"))
		trFrom = varNum
		trTo = varNum+1
	elseif (stringmatch(S_Value, "All traces"))
		trFrom = 0
		trTo = GraphedNum
	endif
	
	variable i = trFrom
	do
		wave w2 = $w1[i]
		if (FillerType == 1)//Nan
			w2[xfrom,xto] = Nan
		elseif (FillerType == 2)// zero
			w2[xfrom,xto] = 0
		elseif (FillerType == 3)//mean
			WaveStats/Q/M=1/R=[xfrom,xto] w2
			w2[xfrom,xto] = V_avg
		elseif (FillerType == 4)//interpolate
			variable y1= w2[xfrom]
			variable y2= w2[xto]
			w2[xfrom,xto] = (y2 - y1)/(xto - xfrom)*(p - xfrom) + y1
		endif
		i += 1
	while (i < trTo)
	
	if (GraphedNum > 1)
		Duplicate/O $w1[varNum] RedTrace
	endif 

	DoWindow/K SelectionForArtifactRemove
End


Function AdjustBaselineOfGraph(ctrlName) : ButtonControl //adjust base line
	String ctrlName
	
	DoAlert 1, "All traces will be baseline-adjusted. This is irreversible. Do you want to proceed?"
	if (V_flag == 1)
		NVAR GraphedNum
		wave/T w1 = GraphedWaveNames
		SVAR SimpleGraphName
		variable xfrom = xcsr(A, SimpleGraphName)//x
		variable xto = xcsr(B, SimpleGraphName)//x
		if (xfrom > xto)
			variable xtemp = xto
			xto = xfrom
			xfrom = xtemp
		endif
		ControlInfo/W=$SimpleGraphName#PBOTTOM	setvar0
		Variable varNum = V_Value
		print "Adjust baseline from " + num2str(xfrom)+ " to "+num2str(xto)+ " (ms):"
		variable i = 0
		do
			wave w2 = $w1[i]
			print "    wave:" + w1[i]
			//variable baseline = mean(w2, xfrom,xto)
			WaveStats/Q/M=1/R=(xfrom,xto) w2
			variable baseline = V_avg
			w2 -= baseline
		i += 1
		while (i < GraphedNum)
		if (GraphedNum > 1)
			Duplicate/O $w1[varNum] RedTrace
		endif
	endif
End

Function CurveFitOfGraph(ctrlName) : ButtonControl //Curve fitting
	String ctrlName
	if (WinType("CurveFitOfGraphPanel") > 0)
		DoWindow/K CurveFitOfGraphPanel
	endif
	String/g FittingPostFix =""
	TaroSetFont()
	NewPanel /W=(130,163,395,345)/N=CurveFitOfGraphPanel
	PopupMenu popup0,pos={17,38},size={206,21},title="Fit type"
	PopupMenu popup0,mode=1,bodyWidth= 167,popvalue="single exponential",value= #"\"single exponential;double exponential\""
	SetVariable setvar0,pos={54,105},size={136,16},title="Enter: Postfix"
	SetVariable setvar0,limits={-inf,inf,0},value= FittingPostFix,bodyWidth= 70
	Button button0,pos={69,133},size={50,20},title="OK",proc=CurveFitOfGraphDo
	Button button1,pos={133,133},size={50,20},title="Cancel",proc=CancelButtonTI
	CheckBox check0,pos={45,76},size={145,14},title="Constriction: Decay to zero"
	CheckBox check0,value= 0
End

Function CurveFitOfGraphDo(ctrlName) : ButtonControl
	String ctrlName
	NVAR GraphedNum
	wave/T w1 = GraphedWaveNames
	SVAR SimpleGraphName
	NVAR HighLightWaveNum
	SVAR FittingPostFix
	NVAR ShowFitFlag
	variable fittype
	ControlInfo/W=CurveFitOfGraphPanel popup0
	fittype = V_Value//1 single exp; 2 double exp
	ControlInfo/W=CurveFitOfGraphPanel check0
	if (V_Value)
		fittype += 2//3 single exp y0; 4 double exp y0
	endif
	
	variable xfrom = pcsr(A, SimpleGraphName)//p
	variable xto = pcsr(B, SimpleGraphName)//p
	if (xfrom > xto)
		variable xtemp = xto
		xto = xfrom
		xfrom = xtemp
	endif
	
	Duplicate/O/D/R=[xfrom,xto] $w1[0], CurveFit2D, BlueTrace
	Redimension/N=(-1,GraphedNum) CurveFit2D
	Make/O/N=(GraphedNum) CoefWave0, CoefWave1, CoefWave2
	if (fittype == 2)
		Make/O/N=(GraphedNum) CoefWave3,CoefWave4, TauMean
	endif
	variable i = 0
	do
		Duplicate/O/D/R=[xfrom,xto] $w1[i], workingdatawave, workingfitwave
		workingfitwave = nan
		if (fittype == 1)
			CurveFit/N/Q exp workingdatawave /D=workingfitwave
		elseif (fittype == 2)
			CurveFit/N/Q dblexp workingdatawave /D=workingfitwave
		elseif (fittype == 3)
			K0=0
			CurveFit/N/Q/H="100" exp workingdatawave /D=workingfitwave
		elseif (fittype == 4)
			K0=0
			CurveFit/N/Q/H="100" dblexp workingdatawave /D=workingfitwave
		endif
		CurveFit2D[][i] = workingfitwave[p]
		wave W_coef
		CoefWave0[i] = W_coef[0]
		CoefWave1[i] = W_coef[1]
		CoefWave2[i] = W_coef[2]
		if ((fittype == 2)||(fittype == 4))
			CoefWave3[i] = W_coef[3]
			CoefWave4[i] = W_coef[4]
		endif
		i += 1
	while (i < GraphedNum)
	DoWindow/K CurveFitOfGraphPanel
	BlueTrace = CurveFit2D[p][HighLightWaveNum]
	if (ShowFitFlag == 0)		
		AppendToGraph/W=$SimpleGraphName BlueTrace
		ModifyGraph rgb(BlueTrace)=(0,65280,65280)
		ShowFitFlag = 1
	endif
	CoefWave2 = 1/CoefWave2
	if ((fittype == 2)||(fittype == 4))
		CoefWave4 = 1/CoefWave4
		TauMean = (CoefWave1*CoefWave2+CoefWave3*CoefWave4)/(CoefWave1+CoefWave3)
	endif
	if ((fittype == 1)||(fittype == 3))
		Duplicate/O CoefWave0, $("y0"+FittingPostFix)
		Duplicate/O CoefWave1, $("A"+FittingPostFix)
		Duplicate/O CoefWave2, $("Tau"+FittingPostFix)
		Edit $("y0"+FittingPostFix), $("A"+FittingPostFix), $("Tau"+FittingPostFix)
		GetWaveNamesOfTable()
	elseif ((fittype == 2)||(fittype == 4))
		Duplicate/O CoefWave0, $("y0"+FittingPostFix)
		Duplicate/O CoefWave1, $("A1"+FittingPostFix)
		Duplicate/O CoefWave2, $("Tau1"+FittingPostFix)
		Duplicate/O CoefWave3, $("A2"+FittingPostFix)
		Duplicate/O CoefWave4, $("Tau2"+FittingPostFix)
		Duplicate/O TauMean, $("TauMean"+FittingPostFix)
		Edit $("y0"+FittingPostFix), $("A1"+FittingPostFix), $("Tau1"+FittingPostFix), $("A2"+FittingPostFix), $("Tau2"+FittingPostFix), $("TauMean"+FittingPostFix)
		GetWaveNamesOfTable()
	endif
End

Function MeasureValuesOfGraph(ctrlName) : ButtonControl //measure values
	String ctrlName
	if (WinType("MeasureValuesOfGraphPanel") > 0)
		DoWindow/K MeasureValuesOfGraphPanel
	endif
	String/g MeasuringPostFix =""
	Variable/g PrintDest=0
	TaroSetFont()
	NewPanel /W=(130,163,395,345)/N=MeasureValuesOfGraphPanel as "Measure values"
	SetVariable setvar0,pos={85,92},size={105,16},disable=2,title="Postfix"
	SetVariable setvar0,limits={-inf,inf,0},value= MeasuringPostFix,bodyWidth= 70
	CheckBox check0,pos={45,32},size={190,14},proc=MeasureValuesOfGraphCheckBox,title="Print results to the command window"
	CheckBox check0,value= 1
	CheckBox check1,pos={45,71},size={124,14},proc=MeasureValuesOfGraphCheckBox,title="Make waves of results"
	CheckBox check1,value= 0
	Button button0,pos={69,133},size={50,20},proc=MeasureValuesOfGraphDo,title="OK"
	Button button1,pos={133,133},size={50,20},proc=CancelButtonTI,title="Cancel"
End

Function MeasureValuesOfGraphCheckBox(ctrlName,ctrlValue) : CheckBoxControl
	String ctrlName
	variable ctrlValue
	NVAR PrintDest
	if (stringmatch(ctrlName, "check0"))
		CheckBox check0,value=1
		CheckBox check1,value=0
		SetVariable setvar0,disable=2
		PrintDest=0
	endif
	if (stringmatch(ctrlName, "check1"))
		CheckBox check0,value=0
		CheckBox check1,value=1
		SetVariable setvar0,disable=0
		PrintDest=1
	endif
End

Function MeasureValuesOfGraphDo(ctrlName) : ButtonControl //measure values
	String ctrlName
	NVAR GraphedNum
	SVAR MeasuringPostFix
	NVAR PrintDest
	if (stringmatch(MeasuringPostFix,"") && PrintDest)
		abort "Enter Postfix string."
	endif
	wave/T w1 = GraphedWaveNames
	SVAR SimpleGraphName
	//NVAR HighLightWaveNum
	variable i
	variable xfrom = xcsr(A, SimpleGraphName)//x
	variable xto = xcsr(B, SimpleGraphName)//x
	if (xfrom > xto)
		variable xtemp = xto
		xto = xfrom
		xfrom = xtemp
	endif
	
	print "Measure from "+num2str(xfrom)+" to "+num2str(xto)
	if (PrintDest)
		print "Results are in waves with postfix: " +MeasuringPostFix	
		Make/T/O/N=(GraphedNum) $("trace"+MeasuringPostFix)
		Make/O/N=(GraphedNum) $("min"+MeasuringPostFix)
		Make/O/N=(GraphedNum) $("minloc"+MeasuringPostFix)
		Make/O/N=(GraphedNum) $("max"+MeasuringPostFix)
		Make/O/N=(GraphedNum) $("maxloc"+MeasuringPostFix)
		Make/O/N=(GraphedNum) $("average"+MeasuringPostFix)
		Make/O/N=(GraphedNum) $("area"+MeasuringPostFix)
		wave/T Wtrace = $("trace"+MeasuringPostFix)
		wave Wmin =  $("min"+MeasuringPostFix)
		wave Wminloc =  $("minloc"+MeasuringPostFix)
		wave Wmax =  $("max"+MeasuringPostFix)
		wave Wmaxloc =  $("maxloc"+MeasuringPostFix)
		wave Waverage =  $("average"+MeasuringPostFix)
		wave Warea =  $("area"+MeasuringPostFix)
		i =0
		do
			wave w2 = $w1[i]
			WaveStats/W/Q/M=1/R=(xfrom,xto) w2
			wave w3 = M_WaveStats
			Wtrace[i] = w1[i]
			Wmin[i] = w3[10]
			Wminloc[i] = w3[9]
			Wmax[i] = w3[12]
			Wmaxloc[i] = w3[11]
			Waverage[i] = w3[3]
			//Warea[i] = w3[23]
			Warea[i] = area(w2, xfrom,xto)
		i += 1
		while (i < GraphedNum)
		Edit Wtrace,Wmin,Wminloc,Wmax,Wmaxloc,Waverage,Warea
		GetWaveNamesOfTable()
	else
		print "trace\tmin\tminloc\tmax\tmaxloc\taverage\tarea"
		i =0
		do
			wave w2 = $w1[i]
			WaveStats/W/Q/M=1/R=(xfrom,xto) w2
			wave w3 = M_WaveStats
			printf "%s\t%g\t%g\t%g\t%g\t%g\t%g\r", w1[i], w3[10], w3[9],w3[12], w3[11],w3[3], area(w2, xfrom,xto)
		i += 1
		while (i < GraphedNum)
	Endif
	Dowindow/K MeasureValuesOfGraphPanel
	killwaves/z M_WaveStats
End

Function TI_AnalyseIV(ctrlName) : ButtonControl //IV
	String ctrlName
	variable BaseFrom,BaseTo
	variable IStep
	Prompt BaseFrom, "Base line from (ms)"
	Prompt BaseTo, "to (ms)"
	Prompt IStep, "Sinngle current step (pA)"
	DoPrompt "Enter baseline and current step", BaseFrom, BaseTo, IStep
	if (V_flag)
		abort
	endif
	wave/T w1 = GraphedWaveNames
	SVAR SimpleGraphName
	NVAR GraphedNum
	variable xfrom = xcsr(A, SimpleGraphName)//x
	variable xto = xcsr(B, SimpleGraphName)//x
	if (xfrom > xto)
		variable xtemp = xto
		xto = xfrom
		xfrom = xtemp
	endif
	String PostFix = "_" + SimpleGraphName
	Make/O/N=(GraphedNum) $("RmWave"+PostFix)
	Make/O/N=(GraphedNum) $("CurrentStep"+PostFix)
	Make/O/N=(GraphedNum) $("OriginalVoltage"+PostFix)
	Make/O/N=(GraphedNum) $("DeltaVoltage"+PostFix)
	Wave RmWave = $("RmWave"+PostFix)
	Wave CurrentStep = $("CurrentStep"+PostFix)
	Wave OriginalVoltage = $("OriginalVoltage"+PostFix)
	Wave DeltaVoltage = $("DeltaVoltage"+PostFix)
	
	variable i =0
	do
		wave w2 = $w1[i]
		OriginalVoltage[i] = mean(w2,xfrom,xto)
		DeltaVoltage[i] = OriginalVoltage[i] - mean(w2,BaseFrom,BaseTo)

		//WaveStats/W/Q/M=1/R=(BaseFrom,BaseTo) w2
		i += 1
	while (i < GraphedNum)
	variable Pzero
	variable RmMinus,RmPlus
	FindLevel/P/Q DeltaVoltage,0
	if (V_flag)
		Pzero = 0
	else				
		Pzero = round(V_LevelX)// P
	endif
	//Print Pzero
	CurrentStep = (p - Pzero) * IStep
	RmWave = DeltaVoltage / CurrentStep
	If (V_rising)
		if (Pzero > 0)
			RmMinus = RmWave[Pzero-1]
		else
			RmMinus = Nan
		endif
		RmPlus = RmWave[Pzero+1]
	else
		RmMinus = RmWave[Pzero+1]
		if (Pzero > 0)
			RmPlus = RmWave[Pzero-1]
		else
			RmPlus = Nan
		endif
	endif
	RmWave[Pzero] = Nan
	//print "Rm- = ", RmMinus, "Rm+ = ",RmPlus
	Edit CurrentStep, OriginalVoltage, DeltaVoltage, RmWave
	Display OriginalVoltage vs CurrentStep
	ModifyGraph width=150,height=100,margin(right)=50
	ModifyGraph mode=4,marker=8,mrkThick=1
	ModifyGraph zero=2
	Label left "Membrane potential ()"
	Label bottom "Current (pA)"
	RmMinus = round(RmMinus*1000)/1000
	RmPlus = round(RmPlus*1000)/1000
	string anno =  "Rm- = " + num2str(RmMinus)+ "\rRm+ = "+num2str(RmPlus)
	TextBox/C/N=text0/F=0/A=MC/X=55/Y=-30 anno	
End


/////////////////////////////////end of Graph functions

Function DeleteWavesProc(ctrlName) : ButtonControl //Delete waves
	String ctrlName
	MakeSelectedWaveNamesWave()
	wave/T w1 = SelectedWaveNames
	NVAR SelectedNum
	DoAlert 1,"Do you really want to delete these "+num2str(SelectedNum)+" waves ?"
	if (V_flag ==1)
		variable i = 0
		do
			FindWhatThisWaveIsUsedFor($w1[i])
			KillWaves $w1[i]
			i += 1
		while (i < SelectedNum)
		RefreshWaveList()
	endif
End

Function MakeTableButton(ctrlName) : ButtonControl //show table
	String ctrlName
	Variable Keys = GetKeyState(0)
	MakeSelectedWaveNamesWave()
	wave/T w1 = SelectedWaveNames
	NVAR SelectedNum
	Edit
	variable i = 0
	do
		if (Keys == 4)
			AppendToTable $w1[i].id
		else
			AppendToTable $w1[i]
		endif
		i += 1
	while (i < SelectedNum)
	GetWaveNamesOfTable()
End

Function ScaleWavesShowPanel(ctrlName) : ButtonControl //Scale digits of waves
	String ctrlName
	if (WinType("ScaleWavesPanel") > 0)
		DoWindow/K ScaleWavesPanel
	endif
	NVAR SelectedNum
	Variable/g ScaleWavesXDigits, ScaleWavesYDigits, ScaleWavesYMultiply
	ScaleWavesYMultiply =1
	TaroSetFont()
	NewPanel /W=(278,148,501,430)/N=ScaleWavesPanel as "set scale"
	Button button0,pos={50,240},size={50,20},proc=ScaleWavesDo,title="OK"
	Button button1,pos={125,240},size={50,20},proc=CancelButtonTI,title="Cancel"
	TitleBox title0,pos={19,24},size={31,13},title="X axis:",frame=0
	SetVariable setvar0,pos={42,39},size={113,16},title="Add digits:"
	SetVariable setvar0,value= ScaleWavesXDigits,bodyWidth= 60
	TitleBox title1,pos={39,61},size={141,26},title="For example, to change the\r scale from (s) to (ms), enter 3."
	TitleBox title1,frame=0
	TitleBox title2,pos={19,128},size={31,13},title="Y axis:",frame=0
	SetVariable setvar1,pos={42,143},size={113,16},title="Add digits:"
	SetVariable setvar1,value= ScaleWavesYDigits,bodyWidth= 60
	TitleBox title3,pos={39,165},size={149,26},title="For example, to change the\r scale from (A) to (pA), enter 12."
	TitleBox title3,frame=0
	TitleBox title4,pos={39,93},size={131,13},title="Note: the begining will be 0."
	TitleBox title4,frame=0
	SetVariable setvar2,pos={53,207},size={102,18},bodyWidth=60,title="Multiply:"
	SetVariable setvar2,value= ScaleWavesYMultiply
End

Function ScaleWavesDo(ctrlName) : ButtonControl
	String ctrlName
	MakeSelectedWaveNamesWave()
	wave/T w1 = SelectedWaveNames
	NVAR SelectedNum
	NVAR XDigi = ScaleWavesXDigits
	NVAR YDigi = ScaleWavesYDigits
	NVAR Ymulti = ScaleWavesYMultiply
	
	variable i = 0
	do
		wave w2 = $w1[i]
		variable dXw = DeltaX(w2)
		SetScale/P x 0,(dXw*10^Xdigi),"", w2
		w2 *= 10^Ydigi
		w2 *= Ymulti
		i += 1
	while (i < SelectedNum)
	DoWindow/K ScaleWavesPanel
End

Function ShiftWavesShowPanel(ctrlName) : ButtonControl //shift wave
	String ctrlName
	if (WinType("ShiftWavesPanel") > 0)
		DoWindow/K ShiftWavesPanel
	endif
	NVAR SelectedNum
	Variable/g NewXZero = 0, NewYZero = 0
	TaroSetFont()
	NewPanel /W=(278,148,467,354)/N=ShiftWavesPanel
	Button button0,pos={34,142},size={50,20},proc=ShiftWavesDo,title="OK"
	Button button1,pos={109,142},size={50,20},proc=CancelButtonTI,title="Cancel"
	TitleBox title0,pos={19,24},size={31,13},title="X axis:",frame=0
	SetVariable setvar0,pos={19,44},size={149,16},title="Traces start from: "
	SetVariable setvar0,value= NewXZero,bodyWidth= 60
	TitleBox title2,pos={19,80},size={31,13},title="Y axis:",frame=0
	SetVariable setvar1,pos={24,102},size={83,16},title="Set "
	SetVariable setvar1,value= NewYZero,bodyWidth= 60
	TitleBox title3,pos={115,105},size={32,13},title="to zero",frame=0
End


Function ShiftWavesDo(ctrlName) : ButtonControl
	String ctrlName
	MakeSelectedWaveNamesWave()
	wave/T w1 = SelectedWaveNames
	NVAR SelectedNum
	NVAR NewXZero, NewYZero
	
	variable i = 0
	do
		wave w2 = $w1[i]
		variable dXw = DeltaX(w2)
		SetScale/P x NewXZero,dXw,"", w2
		w2 -= NewYZero
		i += 1
	while (i < SelectedNum)
	DoWindow/K ShiftWavesPanel

End


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////  Event detection program - 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Function EventDetectionButtonProc(ctrlName) : ButtonControl 
	String ctrlName
	wave WaveSel
	variable SelectedNum =sum(WaveSel)
	if (SelectedNum == 0)
		abort "Select waves"
	else
		if (WinType("EventDetectionMainPanel") > 0)
			DoWindow/K EventDetectionMainPanel
		Endif
		TaroEventDetection()
		SetParamWaveForNewTraces()
		SetAppearanceForNewTraces()
	endif
End

Function TaroEventDetection()
	TaroSetFont()
	if (WinType("EventDetectionMainPanel") > 0)
		DoWindow/F EventDetectionMainPanel
		abort
	endif
	
	if (!exists("Threshold"))
		Variable/g Threshold = -50
	else
		NVAR Threshold
	endif
	if (!exists("smooth1"))
		Variable/g smooth1 = 1//primary trace for amplitude detection and measurement
	else
		NVAR smooth1
	endif
	if (!exists("smooth2"))
		Variable/g smooth2 = 5//filtered for baseline detection and measurement
	else
		NVAR smooth2
	endif
	if (!exists("smooth3"))
		Variable/g smooth3 = 10000//for smoothing grand base line 
	else
		if (smooth3 < 1000)
			smooth3 = 10000
		else
			NVAR smooth3
		endif
	endif
//	Variable/g smooth3 = 2//grand base line of linear regression
	
	if (!exists("BaseLength"))
		Variable/g BaseLength = 5//in point
	else
		NVAR BaseLength
	endif
	if (!exists("ZoomMag"))
		Variable/g ZoomMag = 3
	else
		NVAR ZoomMag
	endif
	if (exists("TauSub"))
		NVAR TauSub
	else
		Variable/g TauSub = 2.5
	endif
	if (exists("TipRound"))
		NVAR TipRound
	else
		Variable/g TipRound = 100
	endif
	if (exists("ResetValley"))
		NVAR ResetValley
		if(numtype(ResetValley))
			ResetValley = 80
		endif
	else
		Variable/g ResetValley = 80
	endif
	if (exists("GrossBaseMode"))
		NVAR GrossBaseMode
	else
		Variable/g GrossBaseMode = 0//quick and default
	endif

	if (exists("HumpFlag"))
		NVAR HumpFlag
	else
		Variable/g HumpFlag = 0
	endif

	if (exists("SlowFlag"))
		NVAR SlowFlag
	else
		Variable/g SlowFlag = 0
	endif

	Variable/g WindowFrom,WindowTo
	Variable/g WorkingEvent = 0
	Variable/g EventNum // set at the algorithm section
	Variable/g EventNumMinus
	Variable/g MaskedNum=0
	Variable/g EpisodeNum=0,WorkingEpi=0
	Variable/g EpisodeNumMinus
	Variable/g ZoomMode = 0//1-event zoom; 2-free point zoom
	Variable/g CursorsOn=0
	Variable/g VerticalAuto = 1
	Variable/g ShowRef = 0
	Variable/g SubtractDecay = 0
	Variable/g DoNotTriggerHook =0
	String/g WorkingEpiName=""
	SetFormula EventNumMinus, "EventNum-1"
	SetFormula EpisodeNumMinus, "EpisodeNum-1"

	make/O/N =1 c1w=nan, c2w=nan, c3w=nan, c4w=nan, c5w=nan
	make/O/N =1 EpiEventTime=nan,EpiEventAmplitudeAbs =nan,EpiBaseTime=nan,EpiBaseAmplitude=nan,EpiBaseTimeL=nan
	make/O/N =1 EpiColour=nan,EpiMarkSize=nan,EpiBaseMark=nan,EpiBaseMarkL=nan,EpiEventMark=nan
	make/O/N = 0 Episode,BaseTime,EventTime
	make/O/N = 0 EventAmplitudeAbs,EventAmplitudeSub,BaseAmplitude,RiseTime,RiseTime2,AreaAbs,HalfWidth
	make/O/N = 0/D TauFitWave
	make/O/N = 0 EventSelection,EventHide
	
	variable winwidth
	if (stringmatch(IgorInfo(2),"Windows"))
		winwidth = 680//650
	else
		winwidth = 920//880
	endif
	Display /W=(0,40,winwidth,500)/N=EventDetectionMainPanel as "Event detection"
	AppendToGraph/W=EventDetectionMainPanel  c1w,c2w,c3w,c4w,c5w
	AppendToGraph EpiEventAmplitudeAbs vs EpiEventTime
	AppendToGraph EpiBaseAmplitude vs EpiBaseTime
	AppendToGraph EpiBaseAmplitude vs EpiBaseTimeL
	ModifyGraph mode(EpiEventAmplitudeAbs)=3,mode(EpiBaseAmplitude)=3,mode(EpiBaseAmplitude#1)=3
	ModifyGraph rgb(c2w)=(65280,43520,0),rgb(c1w)=(0,0,0),rgb(c3w)=(65280,65280,0),rgb(c4w)=(0,65280,0),rgb(c5w)=(0,65280,0)
	ModifyGraph lsize(c4w)=1.5
	ModifyGraph lsize(c5w)=1.5
	ModifyGraph zmrkNum(EpiEventAmplitudeAbs)={EpiEventMark}
	ModifyGraph zmrkNum(EpiBaseAmplitude)={EpiBaseMark}
	ModifyGraph zmrkNum(EpiBaseAmplitude#1)={EpiBaseMarkL}
	ModifyGraph zColor(EpiEventAmplitudeAbs)={EpiColour,0,15,Rainbow16}
	ModifyGraph zColor(EpiBaseAmplitude)={EpiColour,0,15,Rainbow16}
	ModifyGraph zColor(EpiBaseAmplitude#1)={EpiColour,0,15,Rainbow16}
	ModifyGraph zmrkSize(EpiEventAmplitudeAbs)={EpiMarkSize,1,10,1,10}
	ModifyGraph zmrkSize(EpiBaseAmplitude)={EpiMarkSize,1,10,1,10}
	ModifyGraph zmrkSize(EpiBaseAmplitude#1)={EpiMarkSize,1,10,1,10}		
	ModifyGraph margin(left)=50,margin(bottom)=40,margin(top)=30,margin(right)=40
	ModifyGraph hideTrace(c2w)=1
	ModifyGraph hideTrace(c3w)=1
	ModifyGraph hideTrace(c4w)=1
	ModifyGraph hideTrace(c5w)=1
	SetAxis/A
		
	ControlBar/B 150
	TaroSetFont()
	NewPanel/W=(0.2,0.2,0.8,0.8)/FG=(GL,GB,FR,FB)/HOST=#
	GroupBox group0,pos={152,9},size={263,132}
	SetVariable setvar0,pos={159,15},size={112,18},proc=OnParamaterChange,title="Threshold"
	SetVariable setvar0,value= Threshold,bodyWidth= 60
	SetVariable setvar1,pos={161,37},size={109,18},proc=OnParamaterChange,title="Smooth 1"
	SetVariable setvar1,limits={1,inf,2},value= smooth1,bodyWidth= 60
	SetVariable setvar2,pos={161,59},size={109,18},proc=OnParamaterChange,title="Smooth 2"
	SetVariable setvar2,limits={1,inf,2},value= smooth2,bodyWidth= 60
	SetVariable setvar3,pos={422,81},size={103,22},proc=EpisodeEventChange,title="Event"
	SetVariable setvar3,limits={0,14,1},value= WorkingEvent,bodyWidth= 60,fSize=16
	SetVariable setvar4,pos={648,94},size={118,18},proc=EpisodeEventChange,title="Onset (ms)"
	SetVariable setvar4,limits={0,1032.24,0.02},bodyWidth= 60
	SetVariable setvar5,pos={654,119},size={112,18},proc=EpisodeEventChange,title="Peak (ms)"
	SetVariable setvar5,limits={0,1032.24,0.02},bodyWidth= 60
//	SetVariable setvar6,pos={143,3},size={111,15},disable=1,proc=OnParamaterChange,title="smooth 3"
//	SetVariable setvar6,limits={3,20,1},value= smooth3,bodyWidth= 60
	SetVariable setvar7,pos={286,15},size={121,18},proc=OnParamaterChange,title="Base points"
	SetVariable setvar7,limits={1,inf,1},value= BaseLength,bodyWidth= 60
//	SetVariable setvar25,pos={286,15},size={121,18},title="Valley (%)",limits={0,100,1}
//	SetVariable setvar25,value= ResetValley,bodyWidth= 60
	SetVariable setvar8,pos={294,37},size={113,18},proc=OnParamaterChange,title="From (ms)"
	SetVariable setvar8,limits={0,1032.24,1},value= WindowFrom,bodyWidth= 60
	SetVariable setvar9,pos={306,59},size={101,18},proc=OnParamaterChange,title="To (ms)"
	SetVariable setvar9,limits={0,1032.24,1},value= WindowTo,bodyWidth= 60
	SetVariable setvar10,pos={422,16},size={103,23},proc=EpisodeEventChange,title="Trace"
	SetVariable setvar10,limits={0,1,1},value= WorkingEpi,bodyWidth= 60,fSize=16
	CheckBox check1,pos={661,14},size={56,14},proc=ZoomCheckBox,title="Zoom"
	CheckBox check1,value= 0
	Button button2,pos={540,10},size={100,20},proc=EventHideButton,title="Mask event"
	Button button2,fColor=(65280,65280,32768)
	Button button3,pos={540,54},size={100,20},proc=DeleteMasked,title="Delete masked"
	Button button3,fColor=(65280,32512,16384)
	Button button4,pos={540,32},size={100,20},proc=EventHideButton,title="Unmask event"
	Button button4,fColor=(48896,65280,48896)
	Button button5,pos={540,76},size={100,20},proc=InsertEventButton,title="Insert event"
	Button button5,fColor=(48896,49152,65280)
	Button button06,pos={540,98},size={100,20},proc=ConditionalMaskButton,title="Conditional mask"
	Button button06,fColor=(65280,65280,48896)
	Slider slider0,pos={720,12},size={90,22},proc=ZoomMagChangeS
	Slider slider0,limits={0,6,0},variable= ZoomMag,vert= 0,ticks= -7
	SetVariable setvar16,pos={834,12},size={25,16},title=" ",format="%.1f"
	SetVariable setvar16,limits={0,6,0},value= ZoomMag,proc=ZoomMagChangeV
	SetVariable setvar11,pos={478,108},size={55,16},disable=2,title=" "
	SetVariable setvar11,format="(0  - %g)",frame=0
	SetVariable setvar11,limits={0,-1,0},value= EventNumMinus,bodyWidth= 55
	SetVariable setvar12,pos={417,124},size={115,16},title=" ",disable=2
	SetVariable setvar12,format="( %g masked events )",frame=0
	SetVariable setvar12,limits={0,-1,0},value= MaskedNum,bodyWidth= 115
	SetVariable setvar13,pos={478,60},size={55,16},disable=2,title=" "
	SetVariable setvar13,format="(0  - %g)",frame=0
	SetVariable setvar13,limits={0,1,0},value= EpisodeNumMinus,bodyWidth= 55
	SetVariable setvar14,pos={777,121},size={114,16},title="Amplitude:",format="%.4g"
	SetVariable setvar14,frame=0,disable=2
	SetVariable setvar14,limits={0,1,0},bodyWidth= 60
	SetVariable setvar15,pos={777,64},size={116,18},title="Rise:"
	SetVariable setvar15,format="%.2f ms(20-80%)",frame=0
	SetVariable setvar15,limits={0,1,0},bodyWidth= 88,disable=2
	SetVariable setvar18,pos={805,82},size={88,16},title=" "
	SetVariable setvar18,format="%.2f ms(10-90%)",frame=0
	SetVariable setvar18,limits={0,1,0},bodyWidth= 88,disable=2
	CheckBox check2,pos={661,69},size={50,14},proc=CursorCheckBox,title="Draggable marks"
	CheckBox check2,value= 0
	CheckBox check4,pos={661,44},size={105,14},proc=ZoomVerticalCheck,title="Vertical auto zoom"
	CheckBox check4,value= VerticalAuto
	Button button6,pos={18,11},size={120,20},proc=LoadWavesButtonProc,title="Load new traces"
	Button button6, fColor=(48896,49152,65280)
	Button button7,pos={18,33},size={120,20},proc=SaveResultsButtonProc,title="Save results"
	Button button7, fColor=(65280,48896,55552)
	Button button8,pos={18,55},size={120,20},proc=LoadResultsButtonProc,title="Load results"
	Button button8, fColor=(48896,65280,48896)
	Button button9,pos={18,77},size={120,20},proc=EventCutOut,title="Event cut out"
	Button button9, fColor=(65280,65280,48896)
	Button button0,pos={162,118},size={110,20},proc=EventDetectionButton,title="Detect events"
	Button button0, fColor=(16384,65280,65280)
//	Button button1,pos={290,92},size={110,20},proc=RestoreParamsButton,title="Restore params"
	Button button12,pos={18,121},size={120,20},proc=FurtherAnalysisButton,title="Further analysis"
	Button button12, fColor=(48896,59904,65280)
	CheckBox check6,pos={160,81},size={132,14},proc=ShowRefCheck,title="Show reference traces"
	CheckBox check6,value= 0
	SetVariable setvar17,pos={423,42},size={115,16},disable=2,title=" ",frame=0//episode name
	SetVariable setvar17,limits={0,-1,0},value= WorkingEpiName
	//Button button13,pos={817,41},size={40,20},proc=ShowEventDetectionHelp,title="Help"
	SetWindow EventDetectionMainPanel, hook=TaroCursorMoveHook,hookevents=5 // setting mouse and cursor hook
	SetVariable setvar19,pos={420,60},size={60,16},disable=2,title=" "
	SetVariable setvar19,format="%g traces",frame=0
	SetVariable setvar19,limits={0,1,0},value= EpisodeNum,bodyWidth= 60
	SetVariable setvar20,pos={420,108},size={60,16},disable=2,title=" "
	SetVariable setvar20,format="%g events",frame=0
	SetVariable setvar20,limits={0,-1,0},value= EventNum,bodyWidth= 60
	
	SetVariable setvar21,pos={300,118},size={107,18},proc=OnParamaterChange,title="Tau (ms)",fstyle=2
	SetVariable setvar21,limits={0,inf,0.1},value= TauSub,bodyWidth= 60//, disable = 2
//	SetVariable setvar22,pos={308,119},size={99,18},proc=OnParamaterChange,title="Peak (%)"
//	SetVariable setvar22,limits={0,inf,1},value= TipRound,bodyWidth= 60, disable = 2
	CheckBox check7,pos={300,99},size={106,14},proc=SubtractDecayCheck,title="Decay subtraction"
	CheckBox check7,value= SubtractDecay,fstyle=2
//	SetVariable setvar24,pos={835,86},size={60,18},title="Decay:",disable=0///
//	SetVariable setvar24,labelBack=(0,65280,0),format="%.2f ms",frame=0
//	SetVariable setvar24,limits={0,1,0},bodyWidth= 50
	SetVariable setvar24,pos={542,122},size={98,18},title="Decay:",disable=1
	SetVariable setvar24,labelBack=(0,65280,0),format="%.2f ms",frame=0
	SetVariable setvar24,limits={0,1,0},bodyWidth= 60
//	TitleBox title0,pos={808,88},size={21,14},title="Dacay:",labelBack=(0,65280,0)
//	TitleBox title0,frame=0,disable =0///
	Button button15,pos={18,99},size={120,20},proc=CheckErrorsButton,title="Check errors"
	Button button15, fColor=(65280,48896,48896)
	Button button16,pos={176,97},size={90,20},proc=MoreSettingsButton,title="More settings"
	SetVariable setvar25,pos={791,46},size={98,18},title="Area:",format="%.3f"
	SetVariable setvar25,frame=0,limits={0,1,0},bodyWidth= 67, disable =2
	Button button17,pos={862,11},size={35,20},proc=ZoomMagChangeB,title="set"
	Button button18,pos={813,8},size={18,18},proc=ZoomMagChangeInc,title="+"
	Button button19,pos={813,25},size={18,18},proc=ZoomMagChangeDec,title="-"
	
	SetVariable setvar26,pos={777,102},size={122,18},title="Half-width:"
	SetVariable setvar26,format="%.2f ms",frame=0
	SetVariable setvar26,limits={0,1,0},bodyWidth= 65,disable=2
	RenameWindow #,EventDetectionControlPanel
	SetActiveSubwindow ##
End

Function LoadWavesButtonProc(ctrlName) : ButtonControl 
	String ctrlName
	TISelectWaves()
End

Function MoreSettingsButton(ctrlName) : ButtonControl 
	String ctrlName
	MoreSettingsPanelShow()
End

Function MoreSettingsPanelShow()
	NVAR TipRound, ResetValley,GrossBaseMode,BaseLength, HumpFlag,SlowFlag
	NVAR smooth3
	if (WinType("MoreSettingsPanel") > 0)
		DoWindow/F MoreSettingsPanel
		abort
	endif	
	TaroSetFont()
//	NewPanel /W=(150,177,365,457)/N=MoreSettingsPanel as "More settings"
	make/O/N=4 bwave=0
	//print GrossBaseMode
	bwave[GrossBaseMode] = 1
//	NewPanel /FLT/k=1/W=(150,177,365,457)/N=MoreSettingsPanel as "More settings"
	NewPanel /k=1/W=(150,177,365,457+28)/N=MoreSettingsPanel as "More settings"
	variable ypos = 13
	TitleBox title0,pos={23,ypos},size={147,14},title="Gross base line (light yellow)"
	TitleBox title0,frame=0
	ypos += 22
	CheckBox check0,pos={36,ypos},size={117,14},title="Linear fit (default)"
	CheckBox check0,value= bwave[0],proc=MoreSettingPanelCheck
	ypos += 20
	CheckBox check1,pos={36,ypos},size={116,14},title="Polarity-dependent horizontal"
	CheckBox check1,value= bwave[1],proc=MoreSettingPanelCheck
	ypos += 20
	CheckBox check4,pos={36,ypos},size={116,14},title="Cubic polynomial"
	CheckBox check4,value= bwave[2],proc=MoreSettingPanelCheck
	ypos += 20
	CheckBox check5,pos={36,ypos},size={116,14},title="Smoothing"
	CheckBox check5,value= bwave[3],proc=MoreSettingPanelCheck
	SetVariable setvar90,pos={107,ypos-1},size={60,18},title=" ",limits={1000,inf,1000}
	SetVariable setvar90,value= smooth3,bodyWidth= 60,proc=OnParamaterChange
	ypos += 28
	TitleBox title1,pos={23,ypos},size={74,14},title="Event detection",frame=0
	ypos += 17
	SetVariable setvar27,pos={32,ypos},size={115,18},title="Valley (%)",limits={0,100,1}
	SetVariable setvar27,value= ResetValley,bodyWidth= 60
	ypos += 27
	CheckBox check2,pos={36,ypos},size={152,14},title="detect humps on rise phase"
	CheckBox check2,value= HumpFlag, proc=MoreSettingPanelCheck
	ypos += 24
	CheckBox check3,pos={36,ypos},size={140,14},proc=MoreSettingPanelCheck,title="detect slow rising events"
	CheckBox check3,value= SlowFlag
//	SetVariable setvar7,pos={41,114},size={121,18},proc=OnParamaterChange,title="Base points"
//	SetVariable setvar7,limits={1,inf,1},value= BaseLength,bodyWidth= 60
	ypos += 28
	TitleBox title2,pos={23,ypos},size={135,14},title="Decay subtraction auxiliary"
	TitleBox title2,frame=0,fstyle=2
	ypos += 17
	SetVariable setvar22,pos={50,ypos},size={108,18},title="Peak (%)",limits={0,200,1},fstyle=2
	SetVariable setvar22,value= TipRound,bodyWidth= 60,proc=OnParamaterChange
	ypos += 34
	Button button0,pos={143,ypos},size={50,20},proc=MoreSettingsPanelClose,title="OK"
	
	killwaves/z bwave
End

Function MoreSettingsPanelClose(ctrlName) : ButtonControl 
	String ctrlName
//	DoWindow/k/W=MoreSettingsPanel MoreSettingsPanel
	DoWindow/k MoreSettingsPanel
End

Function MoreSettingPanelCheck(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	NVAR GrossBaseMode, HumpFlag, SlowFlag
	//SetActiveSubwindow MoreSettingsPanel
	if (stringmatch(ctrlName,"check0"))
		CheckBox check0,value= 1
		CheckBox check1,value= 0
		CheckBox check4,value= 0
		CheckBox check5,value= 0
		GrossBaseMode = 0
		RedrawWaves("c3w")	
	elseif (stringmatch(ctrlName,"check1"))
		CheckBox check0,value= 0
		CheckBox check1,value= 1
		CheckBox check4,value= 0
		CheckBox check5,value= 0
		GrossBaseMode = 1
		RedrawWaves("c3w")	
	elseif (stringmatch(ctrlName,"check4"))
		CheckBox check0,value= 0
		CheckBox check1,value= 0
		CheckBox check4,value= 1
		CheckBox check5,value= 0
		GrossBaseMode = 2
		RedrawWaves("c3w")	
	elseif (stringmatch(ctrlName,"check5"))
		CheckBox check0,value= 0
		CheckBox check1,value= 0
		CheckBox check4,value= 0
		CheckBox check5,value= 1
		GrossBaseMode = 3
		RedrawWaves("c3w")	
	endif
	if (stringmatch(ctrlName,"check2"))
		ControlInfo/W=MoreSettingsPanel check2
		HumpFlag = V_Value
		//print V_Value
	endif
	if (stringmatch(ctrlName,"check3"))
		ControlInfo/W=MoreSettingsPanel check3
		SlowFlag = V_Value
	endif

End

Function SubtractDecayCheck(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	NVAR SubtractDecay
	NVAR TauSub, TipRound
	wave AreaAbs
	SubtractDecay = checked
	if (checked)
//		SetVariable setvar21, disable = 0
//		SetVariable setvar22, disable = 0
		ModifyGraph/W=EventDetectionMainPanel hideTrace(c4w)=0
		ModifyGraph/W=EventDetectionMainPanel hideTrace(c5w)=0
		if (numtype(TauSub))
			TauSub = 2.5
		endif
		if (numtype(TipRound))
			TipRound = 100
		endif		
	else
//		SetVariable setvar21, disable = 2
//		SetVariable setvar22, disable = 2
		ModifyGraph/W=EventDetectionMainPanel hideTrace(c4w)=1
		ModifyGraph/W=EventDetectionMainPanel hideTrace(c5w)=1
		AreaAbs = NaN
	endif
	RedrawWaves("c4w")
	RedrawWaves("marks")
	AllValuesFill()	
End

Function ShowRefCheck(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	NVAR ShowRef
//	NVAR SubtractDecay
	ShowRef = checked
	if (checked)
		ModifyGraph/W=EventDetectionMainPanel hideTrace(c2w)=0
		ModifyGraph/W=EventDetectionMainPanel hideTrace(c3w)=0
		RedrawWaves("c2w")
		RedrawWaves("c3w")
//		if (SubtractDecay)
//			ModifyGraph/W=EventDetectionMainPanel hideTrace(c4w)=0
//			RedrawWaves("c4w")
//		endif
	else
		ModifyGraph/W=EventDetectionMainPanel hideTrace(c2w)=1
		ModifyGraph/W=EventDetectionMainPanel hideTrace(c3w)=1		
//		ModifyGraph/W=EventDetectionMainPanel hideTrace(c4w)=1		
	endif
End

Function SetParamWaveForNewTraces()
	NVAR EpisodeNum
	variable i, k 	
	wave WaveSel
	wave/T AllWave
	EpisodeNum =sum(WaveSel)
	variable ListedNum =numpnts(WaveSel)	
	Make/T/O/N=(10 + EpisodeNum) ParamWave=""
	String/g resultpostfix=""
	//print "Event detection program is loading "+num2str(EpisodeNum)+" traces."
	i = 0
	k= 0
	do
		if (WaveSel[i] )
			string WNS = AllWave[i]
			//print "Loading "+ WNS
			ParamWave[k+10] = WNS
			k += 1
		endif
		i += 1
	while (i < ListedNum)	
End	

Function SetAppearanceForNewTraces()
	NVAR WindowFrom, WindowTo
	NVAR EpisodeNum,WorkingEpi
	wave EventSelection,EventHide
	NVAR ZoomMode,VerticalAuto
	variable/g dX, LX, RX
	wave/T ParamWave
	killwaves/Z MoreMarkWave, EpiMoreMarkWave, BurstMarkConditionalMask
	LX = leftx($ParamWave[10])
	RX = rightx($ParamWave[10])
	if (WindowFrom == 0 && WindowTo ==0)
		WindowFrom = LX
		WindowTo = RX
	endif
	dX = deltax($ParamWave[10])
	SetActiveSubwindow EventDetectionMainPanel#EventDetectionControlPanel
	SetVariable setvar8 ,limits={LX,RX,1}
	SetVariable setvar9 ,limits={LX,RX,1}
	SetVariable setvar10 ,limits={0,EpisodeNum-1,1}
	SetVariable setvar4 ,limits={WindowFrom,WindowTo,dX}
	SetVariable setvar5 ,limits={WindowFrom,WindowTo,dX}
	//SaveParamsToWave()		
	WorkingEpi = 0
	RedrawWaves("c1w")
	RedrawWaves("c2w")
	RedrawWaves("c3w")
	RedrawWaves("c4w")
	if (!ZoomMode)
		SetAxis/W=EventDetectionMainPanel bottom, WindowFrom, WindowTo
	endif
	if (VerticalAuto)
		SetAxis/A=2/N=2 left
	endif
	
End

Function OnParamaterChange(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	if ((stringmatch(ctrlName, "setvar1")) || (stringmatch(ctrlName, "setvar7")))//smoth1,BaseLength
		AllValuesFill()
		RedrawWaves("c1w")
		RedrawWaves("marks")
		RedrawWaves("c4w")
	endif
	
	if (stringmatch(ctrlName, "setvar2"))//smooth2
		RedrawWaves("c2w")
	endif
	
//	if (stringmatch(ctrlName, "setvar6"))//smooth3
//		RedrawWaves("c3w")
//	endif

	if (stringmatch(ctrlName, "setvar90"))//smooth3
		NVAR smooth3
		smooth3 = 1000*round(smooth3/1000)
		AllValuesFill()		
		RedrawWaves("c3w")
	endif
	
	if ((stringmatch(ctrlName, "setvar8")) || (stringmatch(ctrlName, "setvar9")))//From,To
		NVAR WindowFrom, WindowTo,dX
		NVAR VerticalAuto,ZoomMode
		RedrawWaves("c2w")
		RedrawWaves("c3w")
		if (!ZoomMode)
			SetAxis/W=EventDetectionMainPanel bottom, WindowFrom, WindowTo
		endif
		if (VerticalAuto)
			SetAxis/A=2/N=2 left
		endif
		SetActiveSubwindow EventDetectionMainPanel#EventDetectionControlPanel
		SetVariable setvar4 ,limits={WindowFrom,WindowTo,dX}
		SetVariable setvar5 ,limits={WindowFrom,WindowTo,dX}		
	endif
	
	if ((stringmatch(ctrlName, "setvar21")) || (stringmatch(ctrlName, "setvar22")))//tau, Tip
		AllValuesFill()
		RedrawWaves("c4w")
	endif

	if (stringmatch(ctrlName, "setvar0"))
		AllValuesFill()
		RedrawWaves("c3w")
	endif
End

Function EpisodeEventChange(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	//print ctrlName
	if (stringmatch(ctrlName, "setvar10"))//WorkingEpi change
		SetWorkingEpisode()
	endif
	
	if (stringmatch(ctrlName, "setvar3"))//WorkingEvent change
		SetWorkingEvent()
	endif
	
	if (stringmatch(ctrlName, "setvar4") || stringmatch(ctrlName, "setvar5"))//WorkingEvent change
		BaseOrEventTimeChange()
	endif
End


Function NextEventFromShortCut()// ctrl + 6
	NVAR WorkingEvent, EventNum
	if (WorkingEvent < EventNum-1)
		WorkingEvent += 1
	endif
	SetWindow EventDetectionMainPanel
	SetWorkingEvent()
End

Function PreviousEventFromShortCut()// ctrl + 5
	NVAR WorkingEvent
	if (WorkingEvent > 0)
		WorkingEvent -= 1
	endif
	SetWindow EventDetectionMainPanel
	SetWorkingEvent()
End

Function ScrollToLeftFromShortCut()// ctrl + 7
	Variable ZoomWidth
	variable ZoomFrom,ZoomTo
	NVAR ZoomMode,dX,ZoomMag
	ZoomWidth = dX*round(10^ZoomMag)
	GetAxis/W=EventDetectionMainPanel/Q bottom
	ZoomTo = V_min//////
	ZoomFrom = ZoomTo - ZoomWidth
	SetAxis/W=EventDetectionMainPanel bottom, ZoomFrom, ZoomTo
	ZoomMode = 2
	SetActiveSubWindow EventDetectionMainPanel#EventDetectionControlPanel
	CheckBox check1, value = 1
	SetWorkingEvent()
End

Function ScrollToRightFromShortCut()// ctrl + 8
	Variable ZoomWidth
	variable ZoomFrom,ZoomTo
	NVAR ZoomMode,dX,ZoomMag
	ZoomWidth = dX*round(10^ZoomMag)
	GetAxis/W=EventDetectionMainPanel/Q bottom
	ZoomFrom = V_max
	ZoomTo = ZoomFrom + ZoomWidth//////
	SetAxis/W=EventDetectionMainPanel bottom, ZoomFrom, ZoomTo
	ZoomMode = 2
	SetActiveSubWindow EventDetectionMainPanel#EventDetectionControlPanel
	CheckBox check1, value = 1
	SetWorkingEvent()
End


Function SetWorkingEpisode()
	NVAR WorkingEvent,WorkingEpi
	wave Episode,EventSelection
	NVAR EventNum
	variable i = 0
	do
		if (WorkingEpi == NaN)
			WorkingEpi = 0
		endif
		if (Episode[i] == WorkingEpi)
			WorkingEvent = i
			EventSelection=0
			EventSelection[WorkingEvent] = 1	
			break
		endif
		i += 1
	while (i < EventNum)
	RedrawWaves("c1w")
	RedrawWaves("c2w")
	RedrawWaves("c3w")
	RedrawWaves("c4w")
	RedrawWaves("marks")
End

Function SetWorkingEvent()
	NVAR WorkingEvent,WorkingEpi
	wave Episode,EventSelection
	EventSelection=0
	EventSelection[WorkingEvent] = 1	
	if (!(Episode[WorkingEvent] == WorkingEpi))//when episode is changed
		WorkingEpi = Episode[WorkingEvent]
		RedrawWaves("c1w")
		RedrawWaves("c2w")
		RedrawWaves("c3w")
		RedrawWaves("c4w")
	endif
	//print "set working event"
	RedrawWaves("marks")
	ZoomDraw()
	
	/// linking to EventCutOut window
	if (exists("CutOutGraphName"))
		SVAR CutOutGraphName
	else
		String/g CutOutGraphName = "CutOutGraph"
	endif
	wave EventHide,CutOutRefWave
	NVAR ExcludeMaskedFlag,HighLightWaveNum2
	if (wintype(CutOutGraphName) ==1)
		if ((EventHide[WorkingEvent] ==0) || (ExcludeMaskedFlag == 0))
			//print " EventCutOut window exists."
			FindLevel/P/Q CutOutRefWave,WorkingEvent
			//Print WorkingEvent,V_LevelX
			if (!(HighLightWaveNum2 == V_LevelX))
				HighLightWaveNum2 =  V_LevelX
				CutOutTraceNumChangeDo(HighLightWaveNum2)
			endif
		endif
	endif
End

Function RedrawWaves(WaveNameStr)
	String WaveNameStr
	wave/T ParamWave
	NVAR EpisodeNum,WorkingEpi
	NVAR BaseLength
	NVAR dX
	NVAR WindowFrom,WindowTo
	wave WorkingTrace = $ParamWave[WorkingEpi + 10]

	strswitch (WaveNameStr)
		case "c1w":
			NVAR smooth1
			SVAR WorkingEpiName
			duplicate/O WorkingTrace, c1w
			Smooth/B smooth1, c1w
			WorkingEpiName = ParamWave[WorkingEpi + 10]
			break
		case "c2w":
			NVAR ShowRef
			if (ShowRef)
				NVAR smooth2
//				duplicate/O $ParamWave[WorkingEpi + 10] c2w,c2wm
				duplicate/O/R=(WindowFrom,WindowTo) WorkingTrace, c2w
				Smooth/B smooth2, c2w
//				c2wm = c2w[p-1]
//				c2w -= c2wm
//				c2w[0]=c2w[1]
			endif
			break
		case "c3w":
			NVAR ShowRef
			if (ShowRef)
				//NVAR smooth3,smooth1
//				duplicate/O/R=(WindowFrom,WindowTo) WorkingTrace, c3w,c3wdn
				duplicate/O/R=(WindowFrom,WindowTo) WorkingTrace, c3w
				ConvertToC3WaveType(c3w)
				//Smooth/B smooth1, c3w
//				variable c3wpnt = numpnts(c3w)
//				if (c3wpnt > 1000)
//					Resample/DOWN=100 c3wdn
//				endif
//				NVAR GrossBaseMode
//				if (GrossBaseMode == 0)
//					CurveFit/N/Q line,  c3wdn  /D=c3wdn
//					c3w = K0+K1*x
//				elseif (GrossBaseMode == 1)					
//					NVAR Threshold
//					sort c3wdn, c3wdn
//					variable npall = numpnts(c3wdn)
//					variable npcut
//					if (Threshold>0)
//						npcut = round(npall*0.1)
//					else
//						npcut= round(npall*0.9)
//					endif
//					variable newbase = c3wdn[npcut]
//					c3w = newbase
//				elseif (GrossBaseMode == 2)
//					CurveFit/N/Q poly 4,  c3wdn
//					c3w = K0+K1*x+K2*x^2+K3*x^3	
//				endif
//				killwaves/z c3wdn
			endif
			break
		case "c4w":
			NVAR SubtractDecay
			if (SubtractDecay)
				//NVAR TauSub,TipRound
				//duplicate/O $ParamWave[WorkingEpi + 10] c4w	
				//c4w = mod(p, 10)/////////////////////////////////////
				MakeDecaySubTrace(WorkingEpi,"c4w","c5w")
//			else
//				wave c4w
//				c4w =Nan
			endif
			break
		case "marks":
			//print "marks on"
			variable EventFrom, EventTo
			variable i = 0,flag1=0,flag2=0
			wave Episode
			wave EventTime
			wave EventAmplitudeAbs
			wave BaseTime
			wave BaseAmplitude
			wave BaseTime
			wave EventSelection
			wave EventHide
			wave RiseTime, RiseTime2,AreaAbs,HalfWidth
			wave/D TauFitWave
			NVAR EventNum
			variable EventNumInEpi
			NVAR WorkingEvent
			NVAR CursorsOn
			NVAR SubtractDecay
			NVAR DoNotTriggerHook
			do
				if (Episode[i] == WorkingEpi)
					EventNumInEpi += 1
					EventTo = i
				endif
				i += 1
			while (i < EventNum)
			
			if (EventNumInEpi)
				EventFrom = EventTo- EventNumInEpi+1
				Duplicate/O/R=[EventFrom, EventTo] EventTime, EpiEventTime
				Duplicate/O/R=[EventFrom, EventTo] EventAmplitudeAbs, EpiEventAmplitudeAbs
				Duplicate/O/R=[EventFrom, EventTo] BaseTime, EpiBaseTime
				Duplicate/O/R=[EventFrom, EventTo] BaseAmplitude, EpiBaseAmplitude
				Duplicate/O/R=[EventFrom, EventTo] BaseTime, EpiBaseTimeL
				Duplicate/O/R=[EventFrom, EventTo] EventSelection,EpiColour, EpiMarkSize
				Duplicate/O/R=[EventFrom, EventTo] EventHide, EpiBaseMark, EpiBaseMarkL, EpiEventMark
				EpiColour = (1-EpiColour[p])*10// 10 or 0
				EpiMarkSize += 4//5 or 6
				EpiEventMark = (1 - EpiEventMark[p])*7+1		//8 or 1
				EpiBaseMark =  (1 - EpiBaseMark[p])*45		//45 or 0
				EpiBaseMarkL =  (1 - EpiBaseMarkL[p])*48		//48 or 0
				EpiBaseTimeL -= BaseLength * dX
				if (WaveExists(MoreMarkWave))//override event mark shape
					wave MoreMarkWave
					Duplicate/O/R=[EventFrom, EventTo] MoreMarkWave, EpiMoreMarkWave
					variable np = numpnts(EpiMoreMarkWave)
					i = 0
					do
						if (EpiMoreMarkWave[i])
							EpiEventMark[i] = EpiMoreMarkWave[i]
							EpiColour[i] = 12//purple
							EpiMarkSize[i] = 6
						endif
						i += 1
					while (i < np)
				endif
				if (CursorsOn)
					DoNotTriggerHook =1
					Cursor/A=1/C=(65280,0,52224)/H=0/S=2 I c1w EventTime[WorkingEvent]
					DoNotTriggerHook =1
					Cursor/A=1/C=(65280,0,52224)/H=0/S=0 J c1w BaseTime[WorkingEvent]
					DoNotTriggerHook =0
					//print WorkingEvent,EventTime[WorkingEvent]
				endif
				//SetActiveSubwindow EventDetectionMainPanel
				SetActiveSubwindow EventDetectionMainPanel#EventDetectionControlPanel
				SetVariable setvar4 ,value=BaseTime[WorkingEvent], win= EventDetectionMainPanel#EventDetectionControlPanel
				SetVariable setvar5 ,value=EventTime[WorkingEvent], win= EventDetectionMainPanel#EventDetectionControlPanel
				SetVariable setvar14 ,value=EventAmplitudeSub[WorkingEvent], win= EventDetectionMainPanel#EventDetectionControlPanel
				SetVariable setvar15 ,value=RiseTime[WorkingEvent], win= EventDetectionMainPanel#EventDetectionControlPanel
				SetVariable setvar18 ,value=RiseTime2[WorkingEvent], win= EventDetectionMainPanel#EventDetectionControlPanel
				SetVariable setvar26 ,value=HalfWidth[WorkingEvent], win= EventDetectionMainPanel#EventDetectionControlPanel
							
				if (RiseTime[WorkingEvent] > 0)
					SetVariable setvar15 labelBack=0, win= EventDetectionMainPanel#EventDetectionControlPanel//normal
				else
					SetVariable setvar15 labelBack=(65280,0,0), win= EventDetectionMainPanel#EventDetectionControlPanel//red
				endif
				if (RiseTime2[WorkingEvent] > 0)
					SetVariable setvar18 labelBack=0, win= EventDetectionMainPanel#EventDetectionControlPanel//normal
				else
					SetVariable setvar18 labelBack=(65280,65280,0), win= EventDetectionMainPanel#EventDetectionControlPanel//yellow
				endif
				if (HalfWidth[WorkingEvent] > 0)
					SetVariable setvar26 labelBack=0, win= EventDetectionMainPanel#EventDetectionControlPanel//normal
				else
					SetVariable setvar26 labelBack=(65280,65280,0), win= EventDetectionMainPanel#EventDetectionControlPanel//yellow
				endif
				
				if (numtype(TauFitWave[WorkingEvent]) || (!SubtractDecay))	//nan or SubtractDecay off
					SetVariable setvar24,disable =1, win= EventDetectionMainPanel#EventDetectionControlPanel				
					//TitleBox title0,disable =1
					SetVariable setvar25,disable =1, win= EventDetectionMainPanel#EventDetectionControlPanel				
				else
					SetVariable setvar24,disable =2, value = TauFitWave[WorkingEvent], win= EventDetectionMainPanel#EventDetectionControlPanel
					//TitleBox title0,disable =0
				endif
				if (SubtractDecay)
					SetVariable setvar25,disable =2, value = AreaAbs[WorkingEvent], win= EventDetectionMainPanel#EventDetectionControlPanel
				else
					SetVariable setvar25,disable =1, win= EventDetectionMainPanel#EventDetectionControlPanel
				endif
				if (numtype(AreaAbs[WorkingEvent])|| (AreaAbs[WorkingEvent] <= 0))
					SetVariable setvar25 labelBack=(65280,0,0), win= EventDetectionMainPanel#EventDetectionControlPanel//red
				else
					SetVariable setvar25 labelBack=0, win= EventDetectionMainPanel#EventDetectionControlPanel//normal
				endif
			else
				EpiEventTime=nan
				EpiEventAmplitudeAbs =nan
				EpiBaseTime=nan
				EpiBaseAmplitude=nan
				EpiBaseTimeL=nan
				Cursor/K I
				Cursor/K J
			endif
//			Print "WorkingEpi Num: " +num2str(WorkingEpi)
//			Print "EventFrom: " +num2str(EventFrom)
//			Print "EventTo: " +num2str(EventTo)
			//print "mark end"
			break
		endswitch		
End

Function ConvertToC3WaveType(w)
	wave w
	NVAR GrossBaseMode,smooth3
	duplicate/o w,wdn
	variable wpnt = numpnts(w)
	if (wpnt > 1000)
		Resample/DOWN=100 wdn
	endif
	if (GrossBaseMode == 0)
		CurveFit/N/Q line,  wdn  /D=wdn
		w = K0+K1*x
	elseif (GrossBaseMode == 1)					
		NVAR Threshold
		sort wdn, wdn
		variable npall = numpnts(wdn)
		variable npcut
		if (Threshold>0)
			npcut = round(npall*0.1)
		else
			npcut= round(npall*0.9)
		endif
		variable newbase = wdn[npcut]
		w = newbase
	elseif (GrossBaseMode == 2)
		CurveFit/N/Q poly 4,  wdn
		w = K0+K1*x+K2*x^2+K3*x^3	
	elseif (GrossBaseMode == 3)///////////////
//		CurveFit/N/Q poly 7,  wdn
//		w = K0+K1*x+K2*x^2+K3*x^3+K4*x^4+K5*x^5+K6*x^6	
		Smooth/F/B smooth3, w		
//		if (wpnt > 1000)
//			//Smooth/B smooth4, wdn
//			Resample/DOWN=100 wdn
//			Resample/UP=10000 wdn
//			w = wdn
//		else
//			abort "Smoothing cannot be applied to short traces (< 1000 pnts)."
//		endif	
//		Smooth/B smooth4, w
	endif
	killwaves/z wdn
End

Function BaseOrEventTimeChange()
	wave c1w,c4w
	NVAR WorkingEvent,WorkingEpi,SubtractDecay
//	NVAR SubtractDecay
//	if (SubtractDecay)
//		MakeDecaySubTrace(WorkingEpi,"c4w")
//	endif
	//ValuesFill(c1w, c4w, WorkingEvent) /////removed this line, 2010.11.22 OK?
	RedrawWaves("c4w")
	//print "change"
	wave Episode
	variable i = 0
	if (WorkingEvent > 0)
		if (Episode[WorkingEvent-1] == WorkingEpi)
			i = WorkingEvent - 1
		else
			i = WorkingEvent
		endif
	endif
	
	if (SubtractDecay)
		do
			ValuesFill(c1w, c4w, i)
			i += 1
		while (Episode[i] < WorkingEpi +1)
	else
		do
			ValuesFill(c1w, c4w, i)
			i += 1
		while (i < WorkingEvent +1)
	endif	
	RedrawWaves("marks")
End

Function CursorCheckBox(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	wave BaseTime, EventTime
	NVAR WorkingEvent
	NVAR CursorsOn
	
	if (stringmatch(ctrlName,"check2"))
		if (checked)
			CursorsOn = 1
			Cursor/A=1/C=(65280,0,52224)/H=0/S=2 I c1w EventTime[WorkingEvent]
			Cursor/A=1/C=(65280,0,52224)/H=0/S=0 J c1w BaseTime[WorkingEvent]
			// This setting will be overridden by cursormoved and thus RedrawWaves("marks")			
		else
			CursorsOn = 0
			Cursor/K I
			Cursor/K J
		endif
	endif
End

Function TaroCursorMoveHook (infoStr)
	String infoStr
	String event = StringByKey("EVENT",infoStr)
	variable key = getkeystate(0)
//	print "getkey", key
	if (stringmatch(event, "kill"))
		//-------------------tidy up events here
		if (WinType("MoreSettingsPanel"))
			DoWindow/k/W=MoreSettingsPanel MoreSettingsPanel
		endif
		RemoveFromGraph/Z c1w,c2w,c3w
		RemoveFromGraph/Z EpiBaseAmplitude#1,EpiEventAmplitudeAbs,EpiBaseAmplitude
		KillWaves/Z c1w,c2w,c3w,EpiBaseAmplitude,EpiBaseMark,EpiBaseMarkL,EpiBaseTime,EpiBaseTimeL,EpiColour
		KillWaves/Z EpiEventAmplitudeAbs,EpiEventMark,EpiEventTime,EpiMarkSize,W_coef,W_ParamConfidenceInterval,W_sigma
		KillWaves/Z c1wh, c2wh, c3wh, TauFitWave
		KillWaves/Z MoreMarkWave, EpiMoreMarkWave, BurstMarkConditionalMask
		KillVariables/Z CursorsOn,EpisodeNum,EpisodeNumMinus,EventNum,EventNumMinus,MaskedNum,ShowRef
		KillVariables/Z VerticalAuto,WorkingEpi,WorkingEvent,ZoomMag,ZoomMode,dX,V_endChunk,V_endLayer,V_startChunk,V_startLayer
		KillVariables/Z WindowFrom,WindowTo,PeakAlignFlag, BaseAdjustFlag
		KillVariables/Z CMMinAmp,CMMaxAmp,CMMinRise,CMMaxRise,CMPreEI,CMPostEI, SubtractDecay
		KillStrings/Z AllWaves,AllWavesT,CutOutGraphName,resultpostfix
		//KillStrings/Z name0,name1,name2,name3,name4,name5,name6
	endif
	
	NVAR DoNotTriggerHook
	if (stringmatch(event, "cursormoved"))
		if (DoNotTriggerHook)
			DoNotTriggerHook = 0
			//print "reset hook"
		else
			wave c1w,EventTime, BaseTime
			NVAR WorkingEvent,cursorsOn
			String cursorname = StringByKey("CURSOR",infoStr)
			String cursorpoint = StringByKey("POINT",infoStr)
			if (!stringmatch(cursorpoint,""))
				variable cursortime = pnt2x(c1w, str2num(cursorpoint))
				if (stringmatch(cursorname,"I") && cursorsOn)
					EventTime[WorkingEvent] = cursortime
				endif
				if (stringmatch(cursorname,"J") && cursorsOn)
					BaseTime[WorkingEvent] = cursortime
				endif
				BaseOrEventTimeChange()
	//			print infoStr
			endif
		endif
	endif
	
	if (stringmatch(event, "mouseup"))
		String modifiers = StringByKey("MODIFIERS",infoStr)
		String mousex = StringByKey("MOUSEX",infoStr)
		String mousey = StringByKey("MOUSEY",infoStr)
		GetWindow EventDetectionMainPanel, psizeDC
		//print V_left, V_top, V_right, V_bottom
		//print mousex,mousey
		variable outofbounds=0
		variable rightorleftend = 0
		variable inframe = 0
		variable mox=str2num(mousex)
		variable moy=str2num(mousey)
		variable ratio=(mox - V_left)/(V_right-V_left)
		//print V_top,V_bottom,moy
		if (moy<V_bottom+50)
			inframe = 1
		endif
		if (((mox<V_left)||(mox>V_right)||(moy>V_bottom)||(moy<V_top))&& inframe)
			outofbounds=1// but in frame
			//print "out"
		endif
		
//		if ((mox>726)&&(mox<832)&&(moy>461)&&(moy<489))
//			if (mox<746)
//				ZoomMagChangeH(-1)
//			elseif(mox>812)
//				ZoomMagChangeH(1)
//			endif
//		endif
//		if (mox<V_left)
//			rightorleftend = 1//left
//		elseif (mox>V_right)
//			rightorleftend = 2 //right
//		endif
		if ((ratio < 0.5) && (key == 12))
			rightorleftend = 1//left
		elseif (key == 12)
			rightorleftend = 2 //right
		endif
		//print ratio, rightorleftend
		GetAxis/W=EventDetectionMainPanel/Q bottom
		variable Xcoordinate = V_min+ratio*(V_max - V_min)
		//print modifiers

		NVAR ZoomMag
		NVAR ZoomMode		
		if (stringmatch(modifiers,"2") && inframe)//shift key
			Variable ZoomWidth
			NVAR dX
			variable ZoomFrom,ZoomTo
			ZoomWidth = dX*round(10^ZoomMag)
			if  (rightorleftend == 1)//left
				 ZoomFrom = V_min - ZoomWidth
			elseif (rightorleftend == 2)//right
				ZoomFrom = V_max
			else
				ZoomFrom = Xcoordinate - 0.4*ZoomWidth
			endif
			ZoomTo = ZoomFrom + ZoomWidth
			SetAxis/W=EventDetectionMainPanel bottom, ZoomFrom, ZoomTo
			ZoomMode = 2
			SetActiveSubWindow EventDetectionMainPanel#EventDetectionControlPanel
			CheckBox check1, value = 1//Zoom
		endif
				
		if  (stringmatch(modifiers,"10") && inframe)//shift+Ctrl key		
			SetActiveSubWindow EventDetectionMainPanel#EventDetectionControlPanel
			CheckBox check1, value = 1//Zoom
			InsertEvent(Xcoordinate)
		endif		
		
		if  (stringmatch(modifiers,"8") && inframe)//Ctrl key
			wave EpiEventTime,Episode
			NVAR WorkingEpi,EventNum,WorkingEvent
			variable FirstEvent
			variable i = 0
			do
				if (Episode[i] == WorkingEpi)
					FirstEvent = i
					break
				endif
				i += 1
			while (i < EventNum)
			
			variable EpiEvent = BinarySearch(EpiEventTime, Xcoordinate)
			if (EpiEvent == -1)
				EpiEvent = 0
			elseif (EpiEvent == -2)
				EpiEvent = numpnts(EpiEventTime)-1
			else
				EpiEvent = round(BinarySearchInterp(EpiEventTime, Xcoordinate))
			endif
			//print EpiEvent
			//print FirstEvent
			WorkingEvent = FirstEvent + EpiEvent
			//print WorkingEvent
			ZoomMode = 1
			SetWorkingEvent()
			SetActiveSubWindow EventDetectionMainPanel#EventDetectionControlPanel
			CheckBox check1, value = 1//Zoom
		endif
		
		if  (stringmatch(modifiers,"0")&&(outofbounds))//just click outside of the graph
			ZoomMode = 0
			NVAR WindowFrom, WindowTo
			NVAR VerticalAuto
			if (numtype(WindowFrom) || numtype(WindowTo))
				SetAxis/W=EventDetectionMainPanel/A=1/N=0 bottom
			else
				SetAxis/W=EventDetectionMainPanel bottom, WindowFrom, WindowTo
			endif
			if (VerticalAuto)
				SetAxis/A=2/N=2 left			
			endif
			SetActiveSubWindow EventDetectionMainPanel#EventDetectionControlPanel
			CheckBox check1,value= 0
		endif
	endif
	return 0
End

Function ZoomVerticalCheck(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	NVAR VerticalAuto
	if (checked)
		VerticalAuto = 1
		SetAxis/W=EventDetectionMainPanel/A=2/N=2 left
	else
		VerticalAuto = 0
		GetAxis/W=EventDetectionMainPanel/Q left
//		SetAxis/A=0 left, V_min,V_max
		SetAxis left, V_min,V_max
	endif
	
End

Function ZoomCheckBox(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	NVAR ZoomMode
	NVAR VerticalAuto
	if (checked)
		ZoomMode = 1
		variable key
		key = getkeystate(0)
		if (key == 4)// shift
			variable lefttime
			Prompt lefttime, "Zoom window starts from (ms)"
			DoPrompt "Zoom to:", lefttime
			if (V_flag == 0)//ok
				SetLeftEnd(lefttime)
			else
				ZoomDraw()
			endif
		else
			ZoomDraw()
		endif
	else
		ZoomMode = 0
		NVAR WindowFrom, WindowTo
		if (numtype(WindowFrom) || numtype(WindowTo))
			SetAxis/W=EventDetectionMainPanel/A=1/N=0 bottom
		else
			SetAxis/W=EventDetectionMainPanel bottom, WindowFrom, WindowTo
		endif
		if (VerticalAuto)
			SetAxis/A=2/N=2 left
		endif
	endif
End

Function ZoomMagChangeS(ctrlName,sliderValue,event) : SliderControl
	String ctrlName
	Variable sliderValue
	Variable event	// bit field: bit 0: value set, 1: mouse down, 2: mouse up, 3: mouse moved
	//if(event %& 0x1)	// bit 0, value set
	if(event %& 0x1)
		ZoomDraw()
//	elseif	(event %& 0x4)
//			print "mouse up",sliderValue
	endif

	return 0
End

//Function ZoomMagChangeH(LR)
//	variable LR
//	NVAR ZoomMag
//	if (LR == -1)
//		ZoomMag -= 0.5
//		if (ZoomMag <0)
//			ZoomMag = 0
//		endif
//	elseif (LR == 1)
//		ZoomMag += 0.5
//		if (ZoomMag > 6)
//			ZoomMag = 6
//		endif
//	endif
//	ZoomDraw()
//End

Function ZoomMagChangeV(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	ZoomDraw()
End

Function ZoomMagChangeB(ctrlName) : ButtonControl 
	String ctrlName
	NVAR ZoomMag,dX
	if (numtype(dx)>0)
		abort "Load traces before using this button."
	endif
	variable timems = round(10^ZoomMag * dX)
	Prompt timems, "Enter window width (ms) of zoom-in."
	DoPrompt "Zoom set", timems
		if ((V_flag == 0) && (timems > 0))//ok
		ZoomMag = log(timems/dx)
	endif
	ZoomDraw()
End

Function ZoomMagChangeInc(ctrlName) : ButtonControl 
	String ctrlName
	NVAR ZoomMag
	ZoomMag += 0.5
	if (ZoomMag > 6)
		ZoomMag = 6
	endif
	ZoomDraw()	
End

Function ZoomMagChangeDec(ctrlName) : ButtonControl 
	String ctrlName
	NVAR ZoomMag
	ZoomMag -= 0.5
	if (ZoomMag < 0)
		ZoomMag = 0
	endif
	ZoomDraw()	
End

Function SetLeftEnd(lefttime)
	variable lefttime
	NVAR ZoomMag
	NVAR dX
	variable ZoomWidth = dX*round(10^ZoomMag)
	variable ZoomFrom,ZoomTo
	ZoomFrom = lefttime
	ZoomTo = ZoomFrom + ZoomWidth
	SetAxis/W=EventDetectionMainPanel bottom, ZoomFrom, ZoomTo
End

Function ZoomDraw()
	NVAR ZoomMode
	if (ZoomMode)
		Variable ZoomWidth
		NVAR ZoomMag
		NVAR WorkingEvent
		NVAR dX
		wave EventTime
		variable ZoomFrom,ZoomTo
		ZoomWidth = dX*round(10^ZoomMag)
		if (waveexists(EventTime) && (ZoomMode ==1))
			ZoomFrom = EventTime[WorkingEvent] - 0.4*ZoomWidth
		else// ZoomMode == 2, free zoom
			GetAxis/W=EventDetectionMainPanel/Q bottom
			variable Xcoordinate = 0.6*V_min+0.4*V_max
			ZoomFrom = Xcoordinate - 0.4*ZoomWidth
		endif
		ZoomTo = ZoomFrom + ZoomWidth
		SetAxis/W=EventDetectionMainPanel bottom, ZoomFrom, ZoomTo
	endif
End


Function EventHideButton(ctrlName) : ButtonControl 
	String ctrlName
	NVAR WorkingEvent,WorkingEpi
	NVAR EventNum
	wave EventHide
	wave EventTime, Episode

	NVAR MaskedNum

	variable key
	key = GetKeyState(0)
	GetAxis/W=EventDetectionMainPanel/Q bottom
	variable HideFrom = V_min
	variable HideTo = V_max
	
	variable hideset
	if (stringmatch(ctrlName, "Button2"))//mask
		hideset = 1
	elseif  (stringmatch(ctrlName, "Button4"))//unmask
		hideset = 0
	endif
	
	variable i = 0
	if (key == 4)// shift
		do
			if ((Episode[i] == WorkingEpi)&&(EventTime[i] > HideFrom)&&(EventTime[i] < HideTo))
				EventHide[i] = hideset
			endif
			if (Episode[i] > WorkingEpi)
				break
			endif
			i += 1
		while (i < EventNum)
	else
		EventHide[WorkingEvent] = hideset
	endif
	MaskedNum = sum(EventHide)
	
	// Chose one of the following lines:
	RedrawWaves("marks")	//default: not moving after event mask 
	//NextEventFromShortCut() //move to next event after event mask
End

Function EventMaskFromShortCut()// ctrl + 4
	NVAR WorkingEvent
	wave EventHide
	NVAR MaskedNum
	//print "OK"
	EventHide[WorkingEvent] = 1
	MaskedNum = sum(EventHide)
	RedrawWaves("marks")	
End

Function DeleteMasked(ctrlName) : ButtonControl 
	String ctrlName
	variable key = getkeystate(0)
	SVAR resultpostfix
	NVAR WorkingEvent,EventNum,MaskedNum
	wave EventTime,EventAmplitudeAbs,EventAmplitudeSub,BaseTime,BaseAmplitude
	wave Episode,EventSelection,EventHide,RiseTime,RiseTime2,AreaAbs,HalfWidth
	wave/D TauFitWave
	//if (key == 5) //ctl+shift
	if (key) //any key
			deletepoints WorkingEvent,1,EventTime,EventAmplitudeAbs,EventAmplitudeSub,BaseTime,BaseAmplitude
			deletepoints WorkingEvent,1,Episode,EventSelection,EventHide,RiseTime,RiseTime2,TauFitWave,AreaAbs,HalfWidth
			EventNum = numpnts(Episode)
			print "Deleted the selected event"
			MaskedNum = sum(EventHide)
	else
		variable i = 0
		do
			if (EventHide[i] == 1) 
				deletepoints i,1,EventTime,EventAmplitudeAbs,EventAmplitudeSub,BaseTime,BaseAmplitude
				deletepoints i,1,Episode,EventSelection,EventHide,RiseTime,RiseTime2,TauFitWave,AreaAbs,HalfWidth
				i -= 1
				EventNum = numpnts(Episode)
			endif
			i += 1
		while (i < EventNum)
		print "Deleted "+ num2str(MaskedNum)+" masked events"
		MaskedNum = 0
	endif
	killwaves/Z MoreMarkWave, EpiMoreMarkWave,BurstMarkConditionalMask
	AllValuesFill()
	SetActiveSubwindow EventDetectionMainPanel#EventDetectionControlPanel
	SetVariable setvar3 ,limits={0,EventNum-1,1}
	if (key == 5) //ctl+shift
		if (WorkingEvent > 0)
			WorkingEvent -=1
		endif
		SetWorkingEvent()
	else
		SetWorkingEpisode()
	endif
	
	if (!(stringmatch(resultpostfix,"")))
		if (WaveExists($("DecayTau"+resultpostfix)) || WaveExists($("DecayTauM"+resultpostfix)))
			DoAlert 0,"Masked events are deleted. If you have already done decay time fitting, you have to do it again because the program does not take care of the adjustment of decay time waves."
		endif
	endif
	
End

Function InsertEventButton(ctrlName) : ButtonControl
	String ctrlName
	GetAxis/Q/W=EventDetectionMainPanel bottom
	variable wincentre = 0.6*V_min + 0.4*V_max
	InsertEvent(wincentre)
End

Function InsertEvent(insertpoint)
	variable insertpoint
	wave EventTime,EventAmplitudeAbs,EventAmplitudeSub,BaseTime,BaseAmplitude,RiseTime,RiseTime2,AreaAbs,HalfWidth
	wave Episode,EventSelection,EventHide
	wave/D TauFitWave
	wave c1w
	NVAR WorkingEpi
	NVAR EventNum,WorkingEvent
	//variable wincentre
	NVAR cursorsOn
	NVAR ZoomMode
	variable leftInterval,rightInterval,minInterval	
	variable newEN
	variable i = 0
	do
		if (((Episode[i] == WorkingEpi)&&(EventTime[i] > insertpoint)) || (Episode[i] > WorkingEpi) || (i == EventNum))
			newEN = i
			break
		endif
		i +=1
	while(i < EventNum+1)
	//print newEN
	//print V_min,V_max
	//print wincentre
	if ((Episode[newEN-1] == WorkingEpi) && (newEN > 0))
		leftInterval = insertpoint - EventTime[newEN-1]
	else
		leftInterval = inf
	endif
	if ((Episode[newEN] == WorkingEpi) && (newEN < EventNum))
		rightInterval =  EventTime[newEN] - insertpoint
	else
		rightInterval = inf
	endif
	minInterval = min(leftInterval,rightInterval)
	//print leftInterval,rightInterval
	if (minInterval < 1.4)
		DoAlert 1, "Do you really want to insert a new event within 1.4 ms from an existing event?\r(This is a dialog to avoid multiple insertion by a mistake.)"
		if (V_flag == 2)//No clicked
		 	abort
		 endif
	endif
	Insertpoints newEN,1,EventTime,EventAmplitudeAbs,EventAmplitudeSub,BaseTime,BaseAmplitude
	Insertpoints newEN,1,Episode,EventSelection,EventHide,RiseTime,RiseTime2,TauFitWave,AreaAbs,HalfWidth
	Episode[newEN] = WorkingEpi
	WorkingEvent = newEN
	EventHide[newEN] = 0
	EventSelection=0
	EventSelection[newEN] = 1	
	EventTime[newEN] = insertpoint
	TauFitWave[newEN]= nan
//	BaseTime[newEN] =insertpoint - 1// 1ms earlier
	FindBaseFromPeakSingle()//
//	if (SubtractDecay)
//		MakeDecaySubTrace(WorkingEpi,"c4w")
//	endif
//	wave c4w
//	//ValuesFill(c1w, c4w, newEN)	 /////removed this line, 2010.11.22 OK?
//	RedrawWaves("c4w")
//	ValuesFill(c1w, c4w, newEN)
	BaseOrEventTimeChange()	
	EventNum = numpnts(Episode)
	CursorsOn = 1
//	Cursor/A=1/C=(65280,0,52224)/H=0/S=2 I c1w EventTime[WorkingEvent]
//	Cursor/A=1/C=(65280,0,52224)/H=0/S=2 J c1w BaseTime[WorkingEvent]
	print "Inserted a new event "
	SetActiveSubwindow EventDetectionMainPanel#EventDetectionControlPanel
	SetVariable setvar3 ,limits={0,EventNum-1,1}
	CheckBox check2, value=1
	killwaves/Z MoreMarkWave, EpiMoreMarkWave,BurstMarkConditionalMask
	RedrawWaves("marks")
End

Function ConditionalMaskButton(ctrlName) : ButtonControl 
	String ctrlName
	if (WinType("ConditionalMaskPanel") > 0)
		DoWindow/F ConditionalMaskPanel
		abort
	endif	

	Variable/G CMMinAmp=0, CMMaxAmp=inf, CMMinRise=0, CMMaxRise=inf
	Variable/G CMPreEI = 0, CMPostEI = 0
	Variable/G CMWinFrom = 0, CMWinTo = inf
	Variable/G CMBurstNum = 2, CMBurstEI = 0
	Variable/G CMWaveMin = -inf, CMWaveMax= inf
	Variable/G CMMinHW = 0, CMMaxHW = inf
	String/G CMWaveNameList
	NVAR EventNum
	string EventNumStr = Num2Str(EventNum)
	string WaveListCondition = "TEXT:0,MAXCOLS:1,MAXLAYERS:1,MAXROWS:"+EventNumStr+",MINROWS:"+EventNumStr
	//string WaveListCondition = "TEXT:0,MAXCOLS:1,MAXLAYERS:1"
	CMWaveNameList = WaveList("!Epi*",";",WaveListCondition)
	CMWaveNameList = RemoveFromList ("EventHide", CMWaveNameList)
	CMWaveNameList = RemoveFromList ("EventSelection", CMWaveNameList)
	CMWaveNameList = RemoveFromList ("CutOutRefWave", CMWaveNameList)
	
	TaroSetFont()
	NewPanel /W=(150,77,775,440)/N=ConditionalMaskPanel
	DrawLine 305,44,305,334
	TitleBox title0,pos={22,10},size={255,12},title="Mask events that satisfy at least one of following criteria:"
	TitleBox title0,frame=0
	TitleBox title4,pos={23,23},size={255,12},title="(Masking is additive and existing masks will be kept.)"
	TitleBox title4,frame=0
	
	variable ypos =45
	SetVariable setvar0,pos={89,ypos},size={197,15},title="If amplitude is smaller than:"
	SetVariable setvar0,limits={-inf,inf,1},value= CMMinAmp,bodyWidth= 60
	ypos += 24
	SetVariable setvar1,pos={95,ypos},size={191,15},title="If amplitude is larger than:"
	SetVariable setvar1,limits={-inf,inf,1},value= CMMaxAmp,bodyWidth= 60
	ypos += 30
	PopupMenu popup0,pos={216,ypos},size={73,20}
	PopupMenu popup0,mode=1,popvalue="20-80%",value= #"\"20-80%;10-90%\""
	TitleBox title1,pos={154,ypos+3},size={51,12},title="Rise time:",frame=0
	ypos += 24
	SetVariable setvar2,pos={65,ypos},size={221,15},title="If rise time is shorter than: (ms)"
	SetVariable setvar2,limits={0,inf,0.01},value= CMMinRise,bodyWidth= 60
	ypos += 24
	SetVariable setvar3,pos={70,ypos},size={216,15},title="If rise time is longer than: (ms)"
	SetVariable setvar3,limits={0,inf,0.01},value= CMMaxRise,bodyWidth= 60
	ypos += 30
	SetVariable setvar10,pos={21,ypos},size={265,15},title="If half-width is smaller than: (ms)"
	SetVariable setvar10,limits={0,inf,1},value= CMMinHW,bodyWidth= 60
	ypos += 24
	SetVariable setvar11,pos={15,ypos},size={271,15},title="If half-width is larger than: (ms)"
	SetVariable setvar11,limits={0,inf,1},value= CMMaxHW,bodyWidth= 60
	ypos += 30
	SetVariable setvar4,pos={21,ypos},size={265,15},title="If pre-event interval is shorter than: (ms)"
	SetVariable setvar4,limits={0,inf,1},value= CMPreEI,bodyWidth= 60
	ypos += 24
	SetVariable setvar5,pos={15,ypos},size={271,15},title="If post-event interval is shorter than: (ms)"
	SetVariable setvar5,limits={0,inf,1},value= CMPostEI,bodyWidth= 60
	ypos += 30
	SetVariable setvar6,pos={51,ypos},size={235,18},title="If event peak time is earlier than: (ms)"
	SetVariable setvar6,limits={0,inf,1},value= CMWinFrom,bodyWidth= 60
	ypos += 24
	SetVariable setvar7,pos={60,ypos},size={226,18},title="If event peak time is later than: (ms)"
	SetVariable setvar7,limits={0,inf,1},value= CMWinTo,bodyWidth= 60
	//ypos += 30
	ypos =45
	variable shft=300
	SetVariable setvar8,pos={48+shft,ypos},size={188,18},title="If each interval is shorter than"
	SetVariable setvar8,limits={0,inf,1},value= CMBurstEI,bodyWidth= 60
	TitleBox title3,pos={242+shft,ypos+3},size={22,14},title="(ms)",frame=0
	ypos += 24
	SetVariable setvar9,pos={100+shft,ypos},size={136,18},title="for more than"
	SetVariable setvar9,limits={2,inf,1},value= CMBurstNum,bodyWidth= 60
	TitleBox title2,pos={242+shft,ypos+3},size={33,14},title="events",frame=0
	ypos += 34
	PopupMenu popup1,pos={120+shft,ypos},size={150,20},bodyWidth=150
	PopupMenu popup1,mode=1,popvalue="select wave",value= #"CMWaveNameList"
	TitleBox title5,pos={28+shft,ypos+3},size={75,14},title="If value of wave:",frame=0
	ypos += 24
	SetVariable setvar01,pos={134+shft,ypos},size={136,18},bodyWidth=60,title="is smaller than:"
	SetVariable setvar01,value= CMWaveMin
	ypos += 24
	SetVariable setvar02,pos={138+shft,ypos},size={132,18},bodyWidth=60,title="or larger than:"
	SetVariable setvar02,value= CMWaveMax
	ypos =278
	Button button0,pos={60+shft,ypos},size={100,20},proc=ConditionalMaskDo,title="OK"
	Button button1,pos={170+shft,ypos},size={100,20},proc=CancelButtonTI,title="Cancel"
	ypos += 30
	Button button2,pos={60+shft,ypos},size={100,20},proc=UnmaskAllEvents,title="Unmask all"
	Button button3,pos={170+shft,ypos},size={100,20},proc=InverseMasking,title="Invert mask"
End

Function UnmaskAllEvents(ctrlName) : ButtonControl 
	String ctrlName
	wave EventHide
	NVAR MaskedNum
	EventHide = 0
	MaskedNum = 0
	killwaves/z BurstMarkConditionalMask
	killwaves/Z MoreMarkWave, EpiMoreMarkWave	
	DoWindow/K ConditionalMaskPanel	
	RedrawWaves("marks")	
End

Function InverseMasking(ctrlName) : ButtonControl 
	String ctrlName
	wave EventHide
	NVAR MaskedNum
	EventHide = 1 - EventHide
	MaskedNum = sum(EventHide)
	DoWindow/K ConditionalMaskPanel	
	RedrawWaves("marks")		
End

Function ConditionalMaskDo(ctrlName) : ButtonControl 
	String ctrlName
	wave EventTime,EventAmplitudeSub
	wave Episode, EventHide,HalfWidth
	NVAR MaskedNum, EventNum
	NVAR  CMMinAmp, CMMaxAmp, CMMinRise, CMMaxRise, CMPreEI, CMPostEI
	NVAR CMWinFrom, CMWinTo
	NVAR CMBurstNum, CMBurstEI
	NVAR CMWaveMin,CMWaveMax
	NVAR CMMinHW,CMMaxHW
	String CMWaveName
	variable CMWaveFlag
	variable i 
	
	ControlInfo popup0
	if (V_Value == 1)
		wave sRiseTime = RiseTime
	else
		wave sRiseTime = RiseTime2
	endif
	
	ControlInfo popup1
	CMWaveName = S_Value
	if (stringmatch(CMWaveName, "select wave"))
		CMWaveFlag = 0
	else
		CMWaveFlag = 1
		wave CMWave = $CMWaveName
	endif
	
	Make/O/N=(EventNum) PreEI
	Make/O/N=(EventNum) PostEI
	Make/O/N=(EventNum) BurstNumWave
	Make/O/N=(EventNum) BurstMarkConditionalMask = 0
	wave BurstMark = BurstMarkConditionalMask
	killwaves/Z MoreMarkWave, EpiMoreMarkWave
	i = 0
	do
		if (Episode[i] == Episode[i-1])
			PreEI[i] = EventTime[i] - EventTime[i-1]
		else
			PreEI[i] = inf
		endif
		if (Episode[i] == Episode[i+1])
			PostEI[i] = EventTime[i+1] - EventTime[i]
		else
			PostEI[i] = inf
		endif		
		i += 1
	while (i < EventNum)
	PreEI[0] = inf
	PostEI[EventNum-1] = inf
	
	variable BurstCount = 1
	i = 0
	do
		if (PreEI[i] < CMBurstEI)
			BurstCount +=1
		else
			BurstCount = 1
		endif
		BurstNumWave[i] = BurstCount
		i +=1
	while (i < EventNum)
	
	i = 0
	do
		if (EventAmplitudeSub[i] < CMMinAmp)
			EventHide[i] = 1
		endif
		if (EventAmplitudeSub[i] > CMMaxAmp)
			EventHide[i] = 1
		endif
		if (sRiseTime[i] < CMMinRise)
			EventHide[i] = 1
		endif
		if (sRiseTime[i] > CMMaxRise)
			EventHide[i] = 1
		endif
		if (HalfWidth[i] < CMMinHW)
			EventHide[i] = 1
		endif
		if (HalfWidth[i] > CMMaxHW)
			EventHide[i] = 1
		endif
		if (PreEI[i] < CMPreEI)
			EventHide[i] = 1
		endif
		if (PostEI[i] < CMPostEI)
			EventHide[i] = 1
		endif
		if (EventTime[i] < CMWinFrom)
			EventHide[i] = 1
		endif
		if (EventTime[i] > CMWinTo)
			EventHide[i] = 1
		endif
		if (BurstNumWave[i] >= CMBurstNum)
			variable k = BurstNumWave[i]
			EventHide[i-k+1,i] = 1
			BurstMark[i-k+1] = 49// begin triangle	
			BurstMark[i-k+2,i-1] = 0
			BurstMark[i] = 46//end triangle
		endif
		if (CMWaveFlag)
			if (CMWave[i] < CMWaveMin)
				EventHide[i] = 1
			endif
			if (CMWave[i] > CMWaveMax)
				EventHide[i] = 1
			endif
		endif
		i += 1
	while (i < EventNum)

	MaskedNum = sum(EventHide)
	RedrawWaves("marks")	
	
	DoWindow/K ConditionalMaskPanel
	KillWaves/Z PreEI, PostEI
	//KillWaves/Z BurstNum
End

Function EventDetectionButton(ctrlName) : ButtonControl 
	String ctrlName
	variable key
	key = GetKeyState(0)
	//print key
	if (key == 4)
		//RestoreParamsFill()
		DoAlert 0,"Restore Param function has been deleted."
	else
		EventDetectionAlgorithm()
	endif
End

Function FindPeakFromBaseTimeSingle()///not linked
	NVAR WorkingEvent, WorkingEpi
	Wave BaseTime,EventTime,c4w
	Wave/T ParamWave
	NVAR Threshold
	NVAR smooth1
	//SVAR WorkingEpiName
	variable mi = 2 //ms
	variable timefrom = BaseTime[WorkingEvent]
	duplicate/O $ParamWave[WorkingEpi + 10] w
	Smooth/B smooth1, w
	//WorkingEpiName = ParamWave[WorkingEpi + 10]
	WaveStats/Q/M=1/R=(timefrom, timefrom+mi) w
	if (Threshold > 0)
		EventTime[WorkingEvent] = V_maxloc
	else
		EventTime[WorkingEvent] = V_minloc
	endif
//	if (SubtractDecay)
//		MakeDecaySubTrace(WorkingEpi,"c4w")
//	endif

	//ValuesFill(w, c4w, WorkingEvent)  /////removed this line, 2010.11.22 OK?
	RedrawWaves("c4w")
	ValuesFill(w, c4w, WorkingEvent)
	RedrawWaves("marks")
	//print "Peak set for event "+num2str(WorkingEvent)
End

Function FindPeakFromBaseTimeAll()
	NVAR WorkingEvent, WorkingEpi
	NVAR EventNum
	Wave BaseTime,EventTime,Episode
	Wave/T ParamWave
	NVAR Threshold
	NVAR smooth1
	//SVAR WorkingEpiName
	variable mi = 4 //ms
	variable timefrom
	variable i = 0
	do
		timefrom = BaseTime[i]
		duplicate/O $ParamWave[Episode[i] + 10] w
		Smooth/B smooth1, w
		//WorkingEpiName = ParamWave[i + 10]
		WaveStats/Q/M=1/R=(timefrom, timefrom+mi) w
		if (Threshold > 0)
			EventTime[i] = V_maxloc
		else
			EventTime[i] = V_minloc
		endif
		i += 1
	while (i < EventNum)
	AllValuesFill()
	RedrawWaves("c4w")
	RedrawWaves("marks")
	//print "Peak set for event "+num2str(WorkingEvent)
End

Function FindBaseFromPeakSingle()
	NVAR WorkingEvent, WorkingEpi
	Wave BaseTime,EventTime
	Wave/T ParamWave
	NVAR Threshold
	NVAR smooth1, smooth2
	//SVAR WorkingEpiName
	NVAR WindowFrom
	NVAR ZoomMag
	variable minback = round(10^ZoomMag)/100
//	variable minback = 10 //pnt
	variable maxback = 200 //pnt
	duplicate/O $ParamWave[WorkingEpi + 10] w1, w2
	Smooth/B smooth1, w1
	Smooth/B smooth2, w2
	variable peakx = EventTime[WorkingEvent]
	variable peakp = x2pnt(w2, peakx)
	variable winfromp = x2pnt(w2, WindowFrom)
	variable backfrom = peakp - minback
	variable backto = max(peakp-maxback, winfromp+1)
	if (Threshold < 0)
		w1 *= -1
		w2 *= -1
	endif
	variable basep = backto
	variable i = backfrom
	do
		if ((w2[i] < w2[i-1]) && (w1[i] < w1[peakp]))
			basep = i
			break
		endif
		i -= 1
	while (i >= backto)
	BaseTime[WorkingEvent] = pnt2x(w1, basep)
End


Function EventDetectionAlgorithm()
	variable key
	variable WorkingEpiOnly=0
	key = GetKeyState(0)
	if (key == 1)
		WorkingEpiOnly = 1
	endif
	NVAR WorkingEpi
	variable jstart, jstop
	variable kflag,vp,EN,bp,Peak,PeakT,BaseAmp,BaseT
	variable bps,BaseAmpS,BaseTS
	variable i,k, j
	NVAR dX
	NVAR Threshold
	NVAR EpisodeNum
	NVAR smooth1, smooth2, smooth3
	NVAR BaseLength
	NVAR WindowFrom,WindowTo
	wave/T ParamWave
	variable NP = x2pnt($ParamWave[10],WindowTo) - x2pnt($ParamWave[10],WindowFrom) +1
//	variable FP = x2pnt($ParamWave[10],WindowFrom)
//	variable FP = 0//first point
		/// note: FP is now set 0 always, as cXwh waves are cut out from selected region.
	NVAR ResetValley, HumpFlag, SlowFlag
	variable valley, slopethre
	if (HumpFlag)
		slopethre = 0.5
	endif
	valley = ResetValley/100

	variable polarity
	variable AbsThre = Abs(Threshold)
	variable RiseT1,RiseT2
	
	if (Threshold < 0)
		polarity = -1
	else
		polarity = 1
	endif
	
	if (WorkingEpiOnly)
		jstart = WorkingEpi
		jstop = WorkingEpi
	else
		jstart = 0
		jstop = EpisodeNum
	endif
	make/O/N = 50000 Episode=nan,BaseTime=nan,EventTime=nan
	make/O/N = 50000 EventAmplitudeAbs =nan,EventAmplitudeSub =nan,BaseAmplitude=nan
	make/O/N = 50000 RiseTime =nan, RiseTime2 =nan, AreaAbs = nan,HalfWidth=nan
	make/O/N = 50000/D TauFitWave =nan
	

	j = jstart//episodenum
	do
		print "Scanning trace "+num2str(j)
		wave w = $ParamWave[j+10]
		duplicate/O/R=(WindowFrom, WindowTo) w c1wh,c2wh,c3wh
		c1wh*= polarity
		c2wh*= polarity
		Smooth/B smooth1, c1wh
		Smooth/B smooth2, c2wh
		Differentiate/METH=2 c2wh/D=c2whDif
		if (SlowFlag)
			duplicate/O/R=(WindowFrom, WindowTo) c2whDif c2whDifSlow
			Smooth/B smooth2, c2whDifSlow
		endif
		ConvertToC3WaveType(c3wh)
		c3wh*= polarity		

		variable mink=1
		variable PeakP = 1
		variable bpsearchstart
		
		i = 1
		do
			//print "point:" + num2str(i)
			if ((c1wh[i] - c3wh[i] > AbsThre)&&(c2whDif[i] > 0))// cross threshold and rising
				//print "--------Hit threshold: "+ num2str(i)
				k = i+1
				kflag= 0
				variable MaxLocalSlope = 0
				variable trough_flag = 0
				variable trough_from = k
				do //search peak and valley point after peak
					MaxLocalSlope = max(MaxLocalSlope, c2whDif[k])//slope judge
					if ((c2whDif[k] < 0)||(k == NP-1))//falling
						WaveStats/M=1/Q/R=[i,k] c1wh
						Peak = V_max
						PeakT = V_maxloc
						PeakP = x2pnt(c1wh, PeakT)
						if ((c1wh[k] - c1wh[i] < (Peak - c1wh[i])*valley)||(k == NP-1))//cross valley threshold
							vp = k
							kflag= 1
							bpsearchstart = i
							//print "detected for amplitude criterion"
							//print "fall at " + num2str(vp)
						endif
					elseif ((HumpFlag)&&(trough_flag == 0)&&(c2whDif[k] < MaxLocalSlope* (slopethre-0.05)))
						trough_flag = 1
						trough_from = k
					elseif ((k>trough_from+2)&&(trough_flag == 1)&&(c2whDif[k] > MaxLocalSlope* (slopethre+0.05)))
						variable ki = 1
						variable nextPeak
						do
							if ((c2whDif[k+ki] < 0)||(k+ki == NP-1))//falling
								WaveStats/M=1/Q/R=[k,k+ki] c1wh
								nextPeak = V_max
								break
							endif
							ki += 1
						while (k+ki < NP)
						if (nextPeak - c1wh[k] > AbsThre)
							WaveStats/M=1/Q/R=[trough_from,k] c2whDif
							//print c2whDif[trough_from], c2whDif[k], MaxLocalSlope* slopethre
							//print (k - trough_from)
							variable MinDefT = V_minloc
							variable MinDefP = x2pnt(c2whDif, MinDefT)
							WaveStats/M=1/Q/R=[trough_from,MinDefP] c1wh
							PeakT = V_maxloc
							PeakP = x2pnt(c1wh, PeakT)
							Peak = c1wh[PeakP]
							vp = PeakP
							bpsearchstart = trough_from
							kflag= 1
						else
							trough_flag = 0
							//print num2str(k)+" below threshold"
						endif
						//print "trough at " + num2str(vp)
					endif
					k += 1
				while (kflag == 0)
				
				k = bpsearchstart
				kflag = 0
				do //search baseline point
					if ((c2whDif[k] < 0)||(k == mink)) //falling
						bp = k
						kflag = 1
						//print "bp: " + num2str(bp)
					endif
					k -= 1
				while (kflag == 0)
				
				if (SlowFlag)
					k = bp
					kflag = 0
					do //search Slow baseline point
						if ((c2whDifSlow[k] < 0)||(k == mink)) //falling
							bps = k
							kflag = 1
						endif
						k -= 1
					while (kflag == 0)
				endif
									
				BaseT = pnt2x(c1wh,bp)
				BaseAmp = mean(c1wh,BaseT-BaseLength*dX,BaseT)
				if (SlowFlag)
					BaseTS = pnt2x(c1wh,bps)
					BaseAmpS = mean(c1wh,BaseTS-BaseLength*dX,BaseTS)
				endif
				
				if ((Peak - BaseAmp > AbsThre) || (SlowFlag &&(Peak - BaseAmpS > AbsThre)))
					if (EN == 50000)
						abort "Too many (> 50000) events. "
					endif
					EventTime[EN] = PeakT
					Episode[EN] = j
					EN += 1
					mink = PeakP+1
				endif
				if (Peak - BaseAmp > AbsThre)
					BaseTime[EN-1] = BaseT
				elseif (SlowFlag &&(Peak - BaseAmpS > AbsThre))
					BaseTime[EN-1] = BaseTS
				endif

				i = vp +1
			else	 
				i += 1
			endif	
		while (i < NP-1)
		j += 1
	while (j < jstop)
	killwaves/Z c1wh,c2wh,c3wh, c2whDif, c2whDifSlow
//	EventAmplitudeAbs *= polarity
//	BaseAmplitude *= polarity

	NVAR EventNum
	WaveStats /M=1/Q Episode
	DeletePoints V_npnts, V_numNans, EventTime,BaseTime,Episode,EventAmplitudeAbs,EventAmplitudeSub,BaseAmplitude
	DeletePoints V_npnts, V_numNans, RiseTime,RiseTime2,TauFitWave,AreaAbs,HalfWidth
	EventNum = V_npnts
	Make/O/N=(EventNum) EventSelection=0,EventHide=0
	NVAR MaskedNum
	MaskedNum=0
	AllValuesFill()
	SaveParamsToWave(1)
	print "Event detection: "+num2str(EventNum)+ " events have been detected"
	SetActiveSubwindow EventDetectionMainPanel#EventDetectionControlPanel
	SetVariable setvar3 ,limits={0,EventNum-1,1}
	//RedrawWaves("marks")
	SetWorkingEpisode()
End



Function CheckErrorsButton(ctrlName) : ButtonControl 
	String ctrlName
	variable key = getkeystate(0)
	variable onlyreds = 0
	if (key == 4)
		onlyreds = 1
	endif
	wave Episode,EventTime,BaseTime,EventHide
	wave RiseTime,RiseTime2, AreaAbs,HalfWidth
	wave/D TauFitWave
	NVAR WorkingEvent
	NVAR SubtractDecay, TauSub

	Sort {Episode, EventTime} Episode,EventTime,BaseTime,EventHide
	AllValuesFill()
	variable FromEvent = WorkingEvent
	variable StopEvent, checkEvent
	variable EventNum = numpnts(Episode)
	variable flag = 0
	//StopEvent = FromEvent
	variable i = 0
	do
		checkEvent = FromEvent + i + 1
		if (checkEvent >= EventNum)
			checkEvent -= EventNum
		endif
		if (numtype(RiseTime[checkEvent]))
			flag = 1
		endif
		if (numtype(RiseTime2[checkEvent]) && !onlyreds)
			flag = 1
		endif
		if (numtype(HalfWidth[checkEvent]) && !onlyreds)
			flag = 1
		endif
		
		if (SubtractDecay)
			//if (numtype(TauFitWave[checkEvent]))
			//	flag = 1
			//endif
			//variable tfw = TauFitWave[checkEvent]
			if ((TauFitWave[checkEvent] == TauSub*5)  && !onlyreds)
				flag = 1
			endif
			if ((TauFitWave[checkEvent] == TauSub/5) && !onlyreds)
				flag = 1
			endif
			if  (AreaAbs[checkEvent]<=0)
				flag = 1
			endif
			
		endif
		if ((checkEvent > 0) && (Episode[checkEvent] == Episode[checkEvent-1]))
			if (BaseTime[checkEvent] <= EventTime[checkEvent-1])
				flag = 1
			endif
		endif
		if (flag)
			StopEvent = checkEvent
			break
		endif
		i += 1
	while (i < EventNum)

	if (flag)
		WorkingEvent = StopEvent
		SetWorkingEvent()
	else
		DoAlert 0, "No error was found."
	endif
End

Function SaveResultsButtonProc(ctrlName) : ButtonControl 
	String ctrlName
	
	String/g oldresultpostfix
	if (exists("resultpostfix"))
		SVAR resultpostfix
		oldresultpostfix = resultpostfix
	else
		String/g resultpostfix
	endif
	
	NVAR MaskedNum
	if (WinType("SaveResultsPanel") > 0)
		DoWindow/F SaveResultsPanel
		abort
	endif	
	TaroSetFont()
	NewPanel /W=(54,94,302,285)/N=SaveResultsPanel
	TitleBox title0,pos={20,17},size={154,12},title="Enter a name for the detection data set."
	TitleBox title0,frame=0
	TitleBox title1,pos={20,33},size={179,10},title="(The name will be the postfix of data waves.)"
	TitleBox title1,fSize=10,frame=0
	SetVariable setvar0,pos={22,54},size={203,18},bodyWidth=170,title="name:"
	SetVariable setvar0,value= resultpostfix,bodyWidth= 170
	Button button0,pos={24,86},size={200,20},proc=DoSaveResults,title="OK (Save all events)"
	Button button1,pos={24,152},size={200,20},proc=CancelButtonTI,title="Cancel"
	Button button2,pos={24,119},size={200,20},proc=DoSaveResults,title="Save only non-masked events"

	if (MaskedNum)
		Button button2,disable=0
	else
		Button button2,disable=2
	endif
			
//	if (MaskedNum)
//		TitleBox title2,pos={2,100},size={242,13},title="Masked events will be unmasked in the saved data"
//		TitleBox title2,frame=0,fColor=(65280,0,0)
//	endif
End

Function DoSaveResults(ctrlName) : ButtonControl 
	String ctrlName
	//print ctrlName
	SVAR resultpostfix
	wave EventTime,BaseTime,Episode,EventAmplitudeAbs,EventAmplitudeSub
	wave BaseAmplitude,RiseTime,RiseTime2,AreaAbs,HalfWidth
	wave EventHide
	wave/T ParamWave
	//NVAR smooth1,smooth3,BaseLength,WindowFrom,WindowTo
	//NVAR TauSub, TipRound, SubtractDecay
	variable key = getkeystate(0)
	variable signed = 0
	if (key == 4)
		signed = 1
	endif
	NVAR Threshold
	NVAR EventNum
	variable OnlyUnmasked = 0
	if (stringmatch(ctrlName, "button2"))
		OnlyUnmasked = 1
	endif

	if (stringmatch(resultpostfix,""))
		DoWindow/F SaveResultsPanel
		abort "Enter a name for the data set."
	elseif (ItemsInList(WaveList("ParamWave"+resultpostfix,";","TEXT:1,MAXCOLS:1,MAXLAYERS:1")))
		DoAlert 1, "Do you want to replace "+resultpostfix+" ?"
		if (V_flag == 2)
			DoWindow/F SaveResultsPanel
			abort
		else
			DoWindow/K SaveResultsPanel
		endif
	else
		DoWindow/K SaveResultsPanel
	endif
	
	SaveParamsToWave(0)
	
	Sort {Episode, EventTime} Episode,EventTime,BaseTime,EventHide
	AllValuesFill()
	Duplicate/O/T ParamWave, $("ParamWave"+resultpostfix)
	Duplicate/O Episode, $("Episode"+resultpostfix)
	Duplicate/O BaseTime, $("BaseTime"+resultpostfix)
	Duplicate/O EventTime, $("EventTime"+resultpostfix)
	Duplicate/O EventAmplitudeAbs, $("EventYValue"+resultpostfix)
	Duplicate/O EventAmplitudeSub, $("EventAmplitude"+resultpostfix)
	Duplicate/O BaseAmplitude, $("BaseYValue"+resultpostfix)
	Duplicate/O RiseTime, $("RiseTime2080"+resultpostfix)	
	Duplicate/O RiseTime2, $("RiseTime1090"+resultpostfix)	
	Duplicate/O AreaAbs, $("AreaAbs"+resultpostfix)
	Duplicate/O EventHide,  $("EventHide"+resultpostfix)
	Duplicate/O HalfWidth,  $("HalfWidth"+resultpostfix)

	Wave EpisodeS = $("Episode"+resultpostfix)
	Wave BaseTimeS = $("BaseTime"+resultpostfix)
	Wave EventTimeS = $("EventTime"+resultpostfix)
	Wave EventAmplitudeAbsS = $("EventYValue"+resultpostfix)
	Wave EventAmplitudeSubS = $("EventAmplitude"+resultpostfix)
	Wave BaseAmplitudeS = $("BaseYValue"+resultpostfix)
	Wave RiseTimeS = $("RiseTime2080"+resultpostfix)	
	Wave RiseTime2S = $("RiseTime1090"+resultpostfix)	
	Wave AreaAbsS = $("AreaAbs"+resultpostfix)	
	Wave EventHideS = $("EventHide"+resultpostfix)	
	Wave HalfWidthS = $("HalfWidth"+resultpostfix)	
	
	if ((Threshold < 0) && (signed))
		EventAmplitudeSubS *= -1
	endif
	
	if (OnlyUnmasked)//
		SVAR oldresultpostfix
		variable EventNumS = EventNum
		variable tauflag1=0,tauflag2=0

		if (WaveExists($("DecayTau"+oldresultpostfix)))
			Wave DecayTau = $("DecayTau"+oldresultpostfix)
			if (numpnts(DecayTau) ==EventNum)
				Duplicate/O $("DecayY0"+oldresultpostfix), $("DecayY0"+resultpostfix)
				Duplicate/O $("DecayA"+oldresultpostfix), $("DecayA"+resultpostfix)
				Duplicate/O DecayTau, $("DecayTau"+resultpostfix)
				Wave DecayY0S = $("DecayY0"+resultpostfix)
				Wave DecayAS= $("DecayA"+resultpostfix)
				Wave DecayTauS = $("DecayTau"+resultpostfix)
				tauflag1 =1
			endif
		endif	
		
		if (WaveExists($("DecayTauM"+resultpostfix)))
			Wave DecayTauM = $("DecayTauM"+resultpostfix)
			if (numpnts(DecayTauM) ==EventNum)
				Duplicate/O $("DecayY0d"+oldresultpostfix), $("DecayY0d"+resultpostfix)
				Duplicate/O $("DecayA1"+oldresultpostfix), $("DecayA1"+resultpostfix)
				Duplicate/O $("DecayTau1"+oldresultpostfix), $("DecayTau1"+resultpostfix)
				Duplicate/O $("DecayA2"+oldresultpostfix), $("DecayA2"+resultpostfix)
				Duplicate/O $("DecayTau2"+oldresultpostfix), $("DecayTau2"+resultpostfix)
				Duplicate/O DecayTauM, $("DecayTauM"+resultpostfix)
				Wave DecayY0dS = $("DecayY0d"+resultpostfix)
				Wave DecayA1S= $("DecayA1"+resultpostfix)
				Wave DecayTau1S = $("DecayTau1"+resultpostfix)
				Wave DecayA2S= $("DecayA2"+resultpostfix)
				Wave DecayTau2S = $("DecayTau2"+resultpostfix)
				Wave DecayTauMS = $("DecayTauM"+resultpostfix)
				tauflag2 =1
			endif
		endif	
						
		variable i = 0
		do
			if (EventHideS[i] == 1) 
				deletepoints i,1,EventTimeS,EventAmplitudeAbsS,EventAmplitudeSubS,BaseTimeS,BaseAmplitudeS
				deletepoints i,1,EpisodeS,RiseTimeS,RiseTime2S,AreaAbsS,EventHideS,HalfWidthS
				if (tauflag1)
					deletepoints i,1,DecayY0S,DecayAS,DecayTauS				
				endif
				if (tauflag2)
					deletepoints i,1,DecayY0dS,DecayA1S,DecayTau1S,DecayA2S,DecayTau2S,DecayTauMS				
				endif
				i -= 1
				EventNumS = numpnts(EpisodeS)
			endif
			i += 1
		while (i < EventNumS)
		
	endif	
End

Function LoadResultsButtonProc(ctrlName) : ButtonControl 
	String ctrlName
	if (WinType("EventLoadForReconstruction") > 0)
		DoWindow/F EventLoadForReconstruction
		abort
	endif	
	TaroSetFont()
	RefreshPostfixListOfResults()
	SVAR PostfixList
	NewPanel /N = EventLoadForReconstruction/W=(151,106,396,210) as "Load Results Panel"
	PopupMenu popup0,pos={16,18},size={213,20},title="Select a data set"
	PopupMenu popup0,mode=1,bodyWidth= 120,popvalue="select a data set",value= #"PostfixList"
	Button button0,pos={72,79},size={50,20},proc=DoLoadResults,title="OK"
	Button button1,pos={136,79},size={50,20},proc=CancelButtonTI,title="Cancel"
	NVAR EventNum
	CheckBox check0,pos={52,51},size={145,14},title="Merge to current detection"
	if (EventNum)
		CheckBox check0,value= 0,disable=0
	else
		CheckBox check0,value= 0,disable=2
	endif
End

Function RefreshPostfixListOfResults()
	String AllWavesT
	String/G PostfixList
	AllWavesT = WaveList("ParamWave*",";","TEXT:1,MAXCOLS:1,MAXLAYERS:1") //only text waves
	AllWavesT = RemoveFromList ("ParamWave", AllWavesT)
	PostfixList = ReplaceString("ParamWave", AllWavesT, "")
End

Function DoLoadResults(ctrlName) : ButtonControl 
	String ctrlName
	ControlInfo /W=EventLoadForReconstruction popup0
	//print S_Value
	String/g resultpostfix = S_Value// to be used at next saving	
	if (stringmatch(resultpostfix,"select a data set"))
		abort "Select a data set"
	endif
	NVAR EpisodeNum
	NVAR EventNum,EpisodeNum,WorkingEvent,MaskedNum
	Wave ParamWaveNew = $("ParamWave"+resultpostfix)
	Wave EpisodeNew = $("Episode"+resultpostfix)
	variable numpointnew = numpnts(ParamWaveNew) -10
	variable EventNumNew =numpnts(EpisodeNew)
	if (WaveExists($("EventHide"+resultpostfix)))
		Duplicate/O $("EventHide"+resultpostfix),EventHideNew
	else
		Make/O/N=(EventNumNew) EventHideNew=0
	endif
	ControlInfo /W=EventLoadForReconstruction check0
	if (V_Value)		
		if (numpointnew==EpisodeNum)
			Concatenate/NP  {$("Episode"+resultpostfix)},  Episode
			Concatenate/NP  {$("BaseTime"+resultpostfix)},  BaseTime
			Concatenate/NP  {$("EventTime"+resultpostfix)},  EventTime
			Concatenate/NP  {EventHideNew},  EventHide
			Sort {Episode, EventTime}, Episode,BaseTime,EventTime,EventHide
		else
			abort "Trace number mismatch."
		endif	
	else
		Duplicate/O/T ParamWaveNew,ParamWave
		Duplicate/O $("Episode"+resultpostfix),Episode
		Duplicate/O $("BaseTime"+resultpostfix),BaseTime
		Duplicate/O $("EventTime"+resultpostfix),EventTime
		//Duplicate/O $("EventHide"+resultpostfix),EventHide
		Duplicate/O EventHideNew,EventHide
	endif
	MaskedNum = sum(EventHide)
//	Killwaves/z EventHideNew,EpisodeNew
	DoWindow/K EventLoadForReconstruction	
	RestoreParamsFill()
//	NVAR WindowFrom,WindowTo,EventNum,dX
	SetWindow EventDetectionMainPanel
//	SetActiveSubwindow #
//	SetVariable setvar4 ,limits={WindowFrom,WindowTo,dX}
//	SetVariable setvar5 ,limits={WindowFrom,WindowTo,dX}	
	EventNum = numpnts(Episode)
	EpisodeNum = numpnts(ParamWave)-10
	Make/O/N=(EventNum) EventAmplitudeAbs =nan,EventAmplitudeSub =nan,BaseAmplitude=nan
	Make/O/N=(EventNum) RiseTime=nan,RiseTime2=nan, AreaAbs = nan,HalfWidth=nan
	Make/O/N=(EventNum)/D TauFitWave = nan
	Make/O/N=(EventNum) EventSelection=0
	
	EventSelection[0]=1
	WorkingEvent = 0
	SetActiveSubwindow EventDetectionMainPanel#EventDetectionControlPanel
	NVAR SubtractDecay
	if (SubtractDecay)
		checkbox check7, value=1
//		SetVariable setvar21, disable = 0
//		SetVariable setvar22, disable = 0
		ModifyGraph/W=EventDetectionMainPanel hideTrace(c4w)=0
		ModifyGraph/W=EventDetectionMainPanel hideTrace(c5w)=0
	else
		checkbox check7, value=0
//		SetVariable setvar21, disable = 2
//		SetVariable setvar22, disable = 2
		ModifyGraph/W=EventDetectionMainPanel hideTrace(c4w)=1
		ModifyGraph/W=EventDetectionMainPanel hideTrace(c5w)=1
	endif
	AllValuesFill()	
	SetVariable setvar3 ,limits={0,EventNum-1,1}
//	SetWorkingEpisode()	
	SetAppearanceForNewTraces()	
	RedrawWaves("marks")
	
	if (MaskedNum)
		DoAlert 0,"Note that "+Num2Str(MaskedNum)+" event(s) are masked in this data set."
	endif
End


//Function RestoreParamsButton(ctrlName) : ButtonControl 
//	String ctrlName
//	RestoreParamsFill()
//End

Function SaveParamsToWave(callflag)
	variable callflag
	NVAR Threshold,smooth1,smooth2,smooth3,WindowFrom,WindowTo,BaseLength
	NVAR TauSub, TipRound, SubtractDecay
	NVAR ResetValley,GrossBaseMode, HumpFlag, SlowFlag
	variable sm3
	wave/T ParamWave
	if (GrossBaseMode == 0)
		sm3 = 2
	elseif (GrossBaseMode == 1)
		sm3 = 10
	elseif (GrossBaseMode == 2)
		sm3 = 4
	elseif (GrossBaseMode == 3)
		sm3 = 11
	endif
	ParamWave[1] = num2str(smooth1)
//	ParamWave[3] = num2str(smooth3 + SubtractDecay*10000)
	ParamWave[3] = num2str(sm3 + SubtractDecay*10000)
	ParamWave[4] = num2str(BaseLength)
	ParamWave[5] = num2str(WindowFrom)
	ParamWave[6] = num2str(WindowTo)
	ParamWave[7] = num2str(TauSub)
	ParamWave[8] = num2str(TipRound+smooth3)//smooth3 increases by 1000
	if (callflag)
		ParamWave[0] = num2str(Threshold)
		ParamWave[2] = num2str(smooth2)
		ParamWave[9] = num2str(ResetValley+HumpFlag*50000+SlowFlag*1000000)
	endif	
End

Function RestoreParamsFill()
// soomth3 is always 2 and disconnected from the parameter set
	NVAR Threshold,smooth1,smooth2,smooth3,WindowFrom,WindowTo,BaseLength
	NVAR TauSub, TipRound, SubtractDecay
	NVAR ResetValley,GrossBaseMode,HumpFlag,SlowFlag
	variable sm3
	wave/T ParamWave
	if (stringmatch(ParamWave[0],""))
		DoAlert 0,"Previous parameters are not found."
	else
		Threshold = str2num(ParamWave[0])
		smooth1	 = str2num(ParamWave[1])
		smooth2	 = str2num(ParamWave[2])
		sm3	 = mod(str2num(ParamWave[3]), 10000)
		if (sm3 == 2)
			GrossBaseMode = 0
		elseif (sm3 == 10)
			GrossBaseMode = 1
		elseif (sm3 == 4)
			GrossBaseMode = 2
		elseif (sm3 == 11)
			GrossBaseMode = 3
		endif
		SubtractDecay = floor(str2num(ParamWave[3])/10000)
		BaseLength = str2num(ParamWave[4])
		WindowFrom	= str2num(ParamWave[5])
		WindowTo = str2num(ParamWave[6])
		TauSub = str2num(ParamWave[7])
		TipRound = mod(str2num(ParamWave[8]),1000)
		if (TipRound == 0)
			TipRound = 100
		endif
		smooth3 = floor(str2num(ParamWave[8])/1000)*1000
		if (smooth3 == 0)
			smooth3 = 10000
		endif
		variable PW9 = str2num(ParamWave[9])
		ResetValley = mod(PW9, 1000)
		if (numtype(ResetValley))
			ResetValley = 80
		endif
		PW9 = floor(PW9/1000)
		variable humpvar = mod(PW9, 1000)
		if (humpvar > 0)
			HumpFlag = 1
		else
			HumpFlag = 0
		endif
		PW9 = floor(PW9/1000)		
		SlowFlag = PW9
	endif	
End

Function MakeDecaySubTrace(n,str,str2)//
	variable n// episode num
	String str//output wave name w4
	String str2//w5
	//variable mode// amp=0, area =1
	wave Episode
	wave/T ParamWave
	wave BaseTime,EventTime
	wave BaseAmplitude,EventAmplitudeAbs,AreaAbs//,EventAmplitudeSub,RiseTime,RiseTime2
	wave/D TauFitWave
	NVAR TauSub, TipRound, SubtractDecay
	NVAR EventNum, smooth1
	NVAR Threshold
	EventNum = numpnts(Episode)
//	if (EventNum == 0)
//		abort
//	endif
	variable multiply = 5	//change here for max interval
	wave w = $ParamWave[n+10]
	duplicate/O w c1wh
	Smooth/B smooth1, c1wh
	duplicate/O c1wh, CopyToMeasureArea,CopyToSubtractArea//,SubtractionMonitor
	CopyToMeasureArea = 0
	CopyToSubtractArea = 0
	//SubtractionMonitor = 0
	NVAR BaseLength
	variable dX = DeltaX(w)
	variable rX = rightx(w)
	variable i
	for (i=0; i< EventNum; i +=1)// Fill amplitudes
		if (Episode[i] == n)
			EventAmplitudeAbs[i] = c1wh(EventTime[i])
			BaseAmplitude[i] = mean(c1wh,BaseTime[i]-BaseLength*dX,BaseTime[i])
		endif
		if (Episode[i] > n)
			break
		endif
	endfor	
	
	duplicate/O c1wh, $(str), $(str2)
	wave w4 = $(str)
	wave w5 = $(str2)
	w4 = NaN
	w5 = NaN
	variable tip = TipRound/100
	variable base, TauFit
	//print n
//	if (mode)
//		multiply = 4//area//change here for max interval
//	else
//		multiply = 4//2 amp//change here for max interval
//	endif
	variable from, term, nexon,term2,term3
	for(i = 0; i < EventNum; i += 1)
		if (Episode[i] == n)
			variable thisBaseAmp = BaseAmplitude[i]
			variable thisBaseTime = BaseTime[i]
			variable EventEndTime = min(rX, EventTime[i] + TauSub*multiply)
			variable EventArea
			variable nxtBaseAmp = BaseAmplitude[i+1]
			variable nxtBaseTime = BaseTime[i+1]
			variable dblBaseTime = BaseTime[i+2]
			variable gapping=0
			
//			if ((i == 0) || (Episode[i-1] < n) || (EventTime[i] - EventTime[i-1] > TauSub*multiply) || gapping)//define train
			if ((i == 0) || (Episode[i-1] < n) )//define train
				base = BaseAmplitude[i]
			endif
			if ((Episode[i-1] == n)&&(Threshold > 0) && (BaseAmplitude[i] < base))
				gapping = 1
			elseif ((Episode[i-1] == n)&&(Threshold < 0) && (BaseAmplitude[i] > base))
				gapping = 1
			endif
			if (gapping || (BaseTime[i] - EventTime[i-1] > TauSub*multiply))
				base = BaseAmplitude[i]
			endif
			
			variable nextgapping = 0
			if ((i == EventNum-1) || (Episode[i+1] > n))
				nextgapping = 1
			elseif ((Episode[i+1] == n)&&(Threshold > 0) && (BaseAmplitude[i+1] < base))
				nextgapping = 1
			elseif ((Episode[i+1] == n)&&(Threshold < 0) && (BaseAmplitude[i+1] > base))
				nextgapping = 1
			endif
						
			if ((Episode[i+1] == n) && (BaseTime[i+1] - EventTime[i] < TauSub*multiply) && (nextgapping==0))//change here for max interval
				from = x2pnt(w4, EventTime[i]) +2
				nexon = x2pnt(w4, BaseTime[i+1])
				term = x2pnt(w4, EventTime[i+1])
				term3 = x2pnt(w4, EventEndTime)
//				if (mode)
//					term = x2pnt(w4, EventTime[i] + TauSub*multiply)
//				else
//					term = x2pnt(w4, EventTime[i+1])
//				endif
				
//				if  ((i > 0) && (Episode[i -1] == n) && (EventTime[i] - EventTime[i-1] < TauSub*3))
//					//base = base
//				else
//					base = BaseAmplitude[i] //new base
//				endif
				
				variable dd
				// fitting type 1
//				if (EventTime[i+1] - EventTime[i] < TauSub*1.5) //define "long" interval
//					dd = tip*(EventAmplitudeAbs[i] - base)
//				else	// for longer interval , make more tip rounding
//					dd = (tip*0.8)*(EventAmplitudeAbs[i] - base)
//				endif
//				TauFit = -1 * (BaseTime[i+1]-EventTime[i]) / Ln((BaseAmplitude[i+1] -base )/dd)
				//fitting type1 end
				// type2
				variable peakX, peakY

				if (nexon - from > 20)
					variable midX = round((from + nexon)/2)
					variable midY = mean(c1wh, pnt2x(w4,midX-5), pnt2x(w4,midX+4))			
					peakX = pnt2x(w4,midX)
					peakY = midY
//					print "long"
				else
					peakX = EventTime[i]
					peakY = EventAmplitudeAbs[i]
//					print "short"
				endif
				dd = tip*(peakY - base)
				if ((sign(Threshold) == sign(dd)) && (sign(nxtBaseAmp -base )==sign(dd)))
					TauFit = -1 * (nxtBaseTime-peakX) / Ln((nxtBaseAmp -base )/dd)
				else
					dd = 0
					TauFit = TauSub*5
				endif
				
//				print i, TauFit, dd, (BaseTime[i+1]-peakX),(BaseAmplitude[i+1] -base )
				if ((TauFit > TauSub*5) || (TauFit < 0)) //max acceptable tau
					TauFit = TauSub*5 //max acceptable tau					
				elseif (TauFit < TauSub/5) //min acceptable tau
					TauFit = TauSub/5 //min acceptable tau		//adjust CheckErrorsButton too
				endif
				if (nexon - from < 1)
					TauFit = TauSub*5
				endif
				//if (! mode)
				TauFitWave[i] = TauFit
				//endif
//				w4[from, term] = base + dd*exp(-1*(x-EventTime[i]) / TauFit)
				variable nextbaserawy = base + dd*exp(-1*(nxtBaseTime - peakX) / TauFit)
				variable newbase = nxtBaseAmp - nextbaserawy + base
				if (nexon - from > 20)
					w4[midX - 5, term] = newbase + dd*exp(-1*(x - peakX) / TauFit)
				else
					w4[from, term] = newbase + dd*exp(-1*(x - peakX) / TauFit)
				endif
				//EventEndTime = EventTime[i] + TauFit*multiply
				if ((Episode[i+2] == n) && (dblBaseTime<EventEndTime))
					term2 = x2pnt(w4, dblBaseTime)
				else
					term2 = x2pnt(w4, EventEndTime)
				endif
				w5[term] = Nan
				w5[term+1, term2] = newbase + dd*exp(-1*(x - peakX) / TauFit)
				
			//*measure area*
				CopyToMeasureArea[nexon, term3] = newbase + dd*exp(-1*(x - peakX) / TauFit)
				EventArea = area(c1wh, thisBaseTime, nxtBaseTime)
				EventArea += area(CopyToMeasureArea, nxtBaseTime, EventEndTime)
				EventArea -= area(CopyToSubtractArea, thisBaseTime, EventEndTime)
				EventArea -= base*(EventEndTime - thisBaseTime)
				CopyToSubtractArea[nexon, term3] = newbase + dd*exp(-1*(x - peakX) / TauFit) - base

			else
				TauFitWave[i] = Nan
				EventArea = area(c1wh, thisBaseTime, EventEndTime)
				EventArea -= area(CopyToSubtractArea, thisBaseTime, EventEndTime)
				EventArea -= base*(EventEndTime - thisBaseTime)
			endif
			AreaAbs[i] = EventArea*sign(Threshold)
			if (AreaAbs[i] < 0)
				AreaAbs[i] = 0
			endif
		endif
		if (Episode[i] > n)
			break
		endif
	endfor
	//killwaves/Z  CopyToMeasureArea,CopyToSubtractArea
End


Function AllValuesFill()
//Fill 5 waves (BaseAmplitude,EventAmplitudeAbs,EventAmplitudeSub,RiseTime,RiseTime2) for all events, using Episode wave and waves in ParamWave
	wave Episode
	wave/T ParamWave
	NVAR smooth1,EventNum,SubtractDecay
	EventNum = numpnts(Episode)
	if (EventNum)
		variable i = 0, j = 0	//i=event, j=episode
		make/O c4wh=Nan
		do
			if ((!(j == Episode[i])) || (i == 0))
				//print "Fill values" + num2str(j)
				j = Episode[i]
				wave w = $ParamWave[j+10]
				duplicate/O w c1wh
				Smooth/B smooth1, c1wh
				if (SubtractDecay)
					//print "go to MakeDecaySub" +num2str(j)
					MakeDecaySubTrace(j ,"c4wh","c5wh")
				endif
			endif
			ValuesFill(c1wh,c4wh, i)
			i += 1
		while (i < EventNum)
//		if (SubtractDecay)
//			 wave TauFitWave
//			StatsQuantiles/Q/iNaN TauFitWave
//			print "decay subtraction: recomend Tau", round((V_Median+V_Q25)*50)/100
//			//print "decay subtraction: recomend Tau", round((V_Q25)*100)/100
//		endif
	endif
End

//Function AmpValuesFill(epi)
//	variable epi
//	
//	wave Episode
//	wave BaseTime,EventTime
//	wave BaseAmplitude,EventAmplitudeAbs
//	NVAR BaseLength
//	variable/g dX = DeltaX(w)
//	variable EventNum = numpnts(Episode)
//	variable i
//	for (i=0; i< EventNum; i +=1)
//		if (Episode[i] == epi)
//			EventAmplitudeAbs[i] = w(EventTime[i])
//			BaseAmplitude[i] = mean(w,BaseTime[i]-BaseLength*dX,BaseTime[i])
//		endif
//		if (Episode[i] > epi)
//			break
//		endif
//	endfor	
//End

Function ValuesFill(w,w4,N)
//Fill 6 values (BaseAmplitude,EventAmplitudeAbs,EventAmplitudeSub,RiseTime,RiseTime2,HalfWidth) from given BaseTime,EventTime for a given event
	wave w
	wave w4
	variable N// event number
	wave BaseTime,EventTime
	wave BaseAmplitude,EventAmplitudeAbs,EventAmplitudeSub,RiseTime,RiseTime2,HalfWidth
	NVAR BaseLength
	NVAR SubtractDecay
	variable/g dX = DeltaX(w)
	//print DeltaX(w),  dX
	variable p1=0.2,p2=0.8
	variable p3=0.1,p4=0.9
	NVAR Threshold
	variable pol
	if (Threshold < 0)
		pol = -1
	else
		pol = 1
	endif
	EventAmplitudeAbs[N] = w(EventTime[N])
	BaseAmplitude[N] = mean(w,BaseTime[N]-BaseLength*dX,BaseTime[N])
	//print N, BaseAmplitude[N], BaseTime[N], dX, BaseLength
	if (SubtractDecay)
		variable subbase = w4[x2pnt(w4,EventTime[N])]
		if (numtype(subbase))//nan
			//EventAmplitudeSub[N] = abs(EventAmplitudeAbs[N] - BaseAmplitude[N])
			EventAmplitudeSub[N] = pol*(EventAmplitudeAbs[N] - BaseAmplitude[N])
		else
			//EventAmplitudeSub[N] = abs(EventAmplitudeAbs[N] - subbase)
			EventAmplitudeSub[N] = pol*(EventAmplitudeAbs[N] - subbase)
		endif
	else
		//EventAmplitudeSub[N] = abs(EventAmplitudeAbs[N] - BaseAmplitude[N])
		EventAmplitudeSub[N] = pol*(EventAmplitudeAbs[N] - BaseAmplitude[N])
	endif
	
	variable RiseT1,RiseT2
	Variable BaseT = BaseTime[N]
	Variable EventT = EventTime[N]
	FindLevel/Q/R=(BaseT,EventT) w, (1-p1)*BaseAmplitude[N]+p1*EventAmplitudeAbs[N]
	if (V_flag == 0)//found
		RiseT1 = V_LevelX					
		FindLevel/Q/R=(BaseT,EventT) w, (1-p2)*BaseAmplitude[N]+p2*EventAmplitudeAbs[N]
		if (V_flag == 0)//found
			RiseT2 = V_LevelX
			RiseTime[N] = RiseT2 - RiseT1
			if (RiseTime[N] < 0)
				RiseTime[N] = nan
			endif
		else
			RiseTime[N] = nan
		endif
	else
		RiseTime[N] = nan
	endif	
						
	FindLevel/Q/R=(BaseT,EventT) w, (1-p3)*BaseAmplitude[N]+p3*EventAmplitudeAbs[N]
	if (V_flag == 0)//found
		RiseT1 = V_LevelX					
		FindLevel/Q/R=(BaseT,EventT) w, (1-p4)*BaseAmplitude[N]+p4*EventAmplitudeAbs[N]
		if (V_flag == 0)//found
			RiseT2 = V_LevelX
			RiseTime2[N] = RiseT2 - RiseT1
			if (RiseTime2[N] < 0)
				RiseTime2[N] = nan
			endif
		else
			RiseTime2[N] = nan
		endif
	else
		RiseTime2[N] = nan
	endif
	
	//half-width
	variable HalfWidthT1,HalfWidthT2, EndT
	Wave Episode
	NVAR EventNum,WindowTo
	if ((N==EventNum-1) || (Episode[N] < Episode[N+1]))
		EndT = WindowTo
	else
		EndT = BaseTime[N+1]
	endif
	variable HalfAmp = 0.5*BaseAmplitude[N]+0.5*EventAmplitudeAbs[N]
	FindLevel/Q/R=(BaseT,EventT) w, HalfAmp
	if (V_flag == 0)//found
		HalfWidthT1 = V_LevelX					
		FindLevel/Q/R=(EventT,EndT) w, HalfAmp
		if (V_flag == 0)//found
			HalfWidthT2 = V_LevelX
			HalfWidth[N] = HalfWidthT2 - HalfWidthT1
			if (HalfWidth[N] < 0)
				HalfWidth[N] =nan
			endif
			//print N,HalfWidthT1,HalfWidthT2
		else
			HalfWidth[N] = nan
		endif
	else
		HalfWidth[N] = nan
	endif					
End

Function EventCutOut(ctrlName) : ButtonControl
	String ctrlName
	if (WinType("CutOutGraph") >0)
		DoAlert 1, "Do you want to delete the existing CutOut graph window?\r(If you want to preserve the existing window rename it before creating a new one.)"
		if (V_flag == 2)
			abort
		else
			DoWindow/K CutOutGraph
		endif
	endif
	variable/g PeakAlignFlag=1, BaseAdjustFlag=0,ExcludeMaskedFlag=1

	String HAlign,VAlign,ExcludeMasked
	Prompt HAlign, "Horizontal alignment", popup, "Peak alignment;Onset alignment;"
	Prompt VAlign, "Vertical alignment", popup, "Adjust baseline to zero;Original baseline;Normalize at peak"
	Prompt ExcludeMasked, "Masked events", popup, "Exclude;Include;"
	DoPrompt "Alignment of cut-out traces" , HAlign, VAlign,ExcludeMasked
	if (V_flag)
		abort
	endif

	if (stringmatch(HAlign, "Peak alignment"))
		PeakAlignFlag = 1
	else
		PeakAlignFlag = 0
	endif
	if (stringmatch(VAlign, "Adjust baseline to zero"))
		BaseAdjustFlag = 1
	elseif (stringmatch(VAlign, "Original baseline"))
		BaseAdjustFlag = 0
	else
		BaseAdjustFlag = 2
	endif
	if (stringmatch(ExcludeMasked, "Exclude"))
		ExcludeMaskedFlag=1
	else
		ExcludeMaskedFlag=0
	endif

	variable winwidth
	if (stringmatch(IgorInfo(2),"Windows"))
		//winwidth =515
		winwidth =608
	else
		//winwidth = 695
		winwidth = 821
	endif

	DrawEventCutOut(5,40,5+winwidth,450)
End	

Function DrawEventCutOut(left, top, right, bottom)
	variable left, top, right, bottom
	NVAR MaskedNum, EventNum
	NVAR smooth1
	variable/g CutOutNum
	NVAR ExcludeMaskedFlag
	if (ExcludeMaskedFlag)
		CutOutNum	= EventNum - MaskedNum
	else
		CutOutNum	= EventNum
	endif
	wave EventHide
	Make/O/N=(CutOutNum) CutOutRefWave
	Make/T/O/N=(CutOutNum) CutOutWaveNames
	wave/T w1 = CutOutWaveNames
	variable/G CutOutNumMinus = CutOutNum-1
	variable/g HighLightWaveNum2=0
	NVAR ZoomMag
	NVAR dX,LX,RX
	Variable ZoomWidth = dX*round(10^ZoomMag)
	Variable PreEventWidth = dX*round(0.4*10^ZoomMag)
	wave BaseTime,EventTime,Episode,BaseAmplitude,EventAmplitudeSub
	wave/T ParamWave
	variable ZoomFrom,ZoomTo
	NVAR PeakAlignFlag, BaseAdjustFlag
	variable/g ShowFitFlag2=0
	SVAR resultpostfix
	Preferences/Q 0

	if (exists("CutoutCursorFrom"))
		NVAR CutoutCursorFrom
	else
		Variable/g CutoutCursorFrom = 0
	endif
	if (exists("CutoutCursorTo"))
		NVAR CutoutCursorTo
	else
		Variable/g CutoutCursorTo = 2
	endif

	Display /W=(left, top, right, bottom)/N=CutOutGraph
	String/G CutOutGraphName ="CutOutGraph"
		
	////// Delete old EventCutOut waves
	String CutOutWavelist = Wavelist("EventCutOut_*", ";","")
	variable COWaveNum = ItemsInList(CutOutWavelist)
	//print COWaveNum
	String COWaveName
	variable v1
	string s1
	variable i = 0
	For (i=0; i < COWaveNum; i+=1)
		COWaveName = StringFromList(i, CutOutWavelist)
		sscanf COWaveName, "%*[EventCutOut_]%d%s", v1,s1
		//print COWaveName, "v1=", v1, "s1=",s1
		if (stringmatch(s1, ""))
			killwaves $COWaveName
		endif
	endfor
	
	variable numpOrig = (RX-LX)/dX +1
	//print numpOrig, dX
	variable k = 0, EpiOfwOrigEx = nan
	i = 0//create new EventCutOut waves
	do
		if ((EventHide[i] == 0)||(ExcludeMaskedFlag==0))
			w1[k] = "EventCutOut_"+num2str(i)
			CutOutRefWave[k] = i
			if (PeakAlignFlag)
				ZoomFrom = EventTime[i] - PreEventWidth
			else
				ZoomFrom = BaseTime[i] - PreEventWidth
			endif
			ZoomTo = ZoomFrom + ZoomWidth
			//
			//if ((i==0)||(!(Episode[i]==Episode[i-1])))
			if (!(Episode[i] ==EpiOfwOrigEx))
				EpiOfwOrigEx = Episode[i]
				wave wOrigFull = $ParamWave[EpiOfwOrigEx+10]
				duplicate/O/R=(LX,RX) wOrigFull, wOrig
				make/O/N=(numpOrig) wPreOrig=Nan, wPostOrig=Nan
				Concatenate/O/NP {wPreOrig,wOrig,wPostOrig},wOrigEx// creating wOrigEx
				SetScale/P x,(LX - numpOrig*dX), dX, "",wOrigEx
				Smooth/B smooth1, wOrigEx
			endif
			duplicate/O/R=(ZoomFrom,ZoomTo) wOrigEx, $w1[k]
			wave w1k = $w1[k]			
			//
			if (BaseAdjustFlag)//1 or 2
				w1k -= BaseAmplitude[i]
			endif
			if (BaseAdjustFlag == 2)
				w1k /= abs(EventAmplitudeSub[i])
			endif
			
			SetScale/P x, (-1*PreEventWidth),dX,"",w1k
			AppendToGraph/W=CutOutGraph w1k
			if (k == 0)
				Duplicate/O $w1[0], EventCutOutAverage
			else
				EventCutOutAverage += w1k
			endif
			k += 1
		endif
		i += 1
	while (i < EventNum)	
	EventCutOutAverage /= CutOutNum
	
	KillWaves/Z 	wPreOrig,wPostOrig,wOrigEx,wOrig
	ModifyGraph rgb=(0,0,0)
//	GetAxis/W=CutOutGraph/Q bottom
//	print V_min,V_max
//	Cursor/A=1/C=(0,65280,0)/H=2 A $w1[0] V_min*0.55+V_max*0.45
//	Cursor/A=1/C=(0,65280,0)/H=2 B $w1[0] V_min*0.10+V_max*0.90
	Cursor/A=1/C=(0,65280,0)/H=2/S=0 G $w1[0] CutoutCursorFrom
	Cursor/A=1/C=(0,65280,0)/H=2/S=0 H $w1[0] CutoutCursorTo
	SetWindow CutOutGraph, hook=CutoutCursorHook,hookevents=5 // setting cursor,mouse hook
	
	//ShowInfo/W=CutOutGraph

	ControlBar/B 75
	TaroSetFont()
	NewPanel/W=(0.2,0.2,0.8,0.8)/FG=(GL,GB,FR,FB)/HOST=# 
	SetVariable setvar0,pos={13,13},size={70,18},title=" ",proc=CutOutTraceNumChange,fSize=11
	SetVariable setvar0,limits={0,CutOutNumMinus,1},value= HighLightWaveNum2
	SetVariable setvar1,pos={84,13},size={85,18},disable=2,title=" "
	SetVariable setvar1,format="of 0  to  %g",frame=0,fSize=11
	SetVariable setvar1,limits={-inf,inf,0},value= CutOutNumMinus
	SetVariable setvar2,pos={167,13},size={105,18},disable=2,title=" ",frame=0
	SetVariable setvar2,limits={-inf,inf,0},value= w1[0],bodyWidth= 105,fSize=11//,disable=1
	Button button0,pos={700,10},size={70,20},title="auto scale",proc=GraphTraceAutoScale
	PopupMenu popup0,pos={310,10},size={115,20},proc=EventCutOutPopMenuProc
	PopupMenu popup0,mode=(1+PeakAlignFlag),value= #"\"Onset alignment;Peak alignment\""
	PopupMenu popup1,pos={428,10},size={116,20},proc=EventCutOutPopMenuProc
	PopupMenu popup1,mode=(1+BaseAdjustFlag),value= #"\"Original baseline;Adjust baseline\""
	Button buttonXCutOut,pos={776,9},size={20,20},title="X",proc=KillTheBottomBarButton
	
	PopupMenu popup2,pos={257,41},size={136,20},title="Fit"
	PopupMenu popup2,mode=1,bodyWidth= 120,popvalue="single exponential",value= #"\"single exponential;double exponential\""
	SetVariable setvar3,pos={505,43},size={110,18},title="Postfix:"
	SetVariable setvar3,limits={-inf,inf,0},value= resultpostfix,bodyWidth= 70
	CheckBox check0,pos={403,45},size={86,14},title="Decay to zero",value= 0
	CheckBox check1,pos={600,14},size={89,14},title="show average",value= 1,proc=ShowAverageCutOut
	Button buttonXCutOut1,pos={623,41},size={80,20},proc=CurveFitOfCutOut,title="Do curve fit"
	Button buttonXCutOut1,fColor=(48896,65280,65280)
	Button buttonXCutOut2,pos={710,41},size={87,20},proc=MeasureValuesOfCutOut,title="Cursor measure"
	Button buttonXCutOut2,fColor=(57344,65280,48896)
	Button buttonXCutOut3,pos={540,10},size={55,20},proc=RefreshEventCutOut,title="Refresh"
	Button buttonXCutOut3,fColor=(65280,65280,48896)
	SetVariable setvar4,pos={13,43},size={134,18},bodyWidth=70,title="Cursor From"
	SetVariable setvar4,limits={-inf,inf,0.1},value= CutoutCursorFrom,proc=CutOutFromToChange
	SetVariable setvar5,pos={152,43},size={83,18},bodyWidth=70,title="to"
	SetVariable setvar5,limits={-inf,inf,0.1},value=CutoutCursorTo,proc=CutOutFromToChange

	RenameWindow #,PBottom
	SetActiveSubwindow ##
	String/g CutOutGraphNameList = TraceNameList("",";",1)
	Variable/g CutOutHookFlag = 0
	// a cursor move triggers both "cursormoved" and "mouseup".  so, this flag blocks "mouseup" just after "cursormoved"

	if (CutOutNum > 1)
		AppendToGraph/W=$CutOutGraphName EventCutOutAverage
		ModifyGraph rgb(EventCutOutAverage)=(0,43520,65280)
		Duplicate/O $w1[0] RedTrace2
		AppendToGraph/W=$CutOutGraphName  RedTrace2
		ModifyGraph rgb(RedTrace2)=(65280,0,0)
	endif	

End

Function CutOutFromToChange(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	NVAR CutoutCursorFrom,CutoutCursorTo
	String sametrace
	NVAR CutOutHookFlag
	if (stringmatch(ctrlName, "setvar4"))//From change	
		sametrace = StringByKey("TNAME", csrinfo(G))
		Cursor/A=1 G  $sametrace CutoutCursorFrom
	endif	
	
	if (stringmatch(ctrlName, "setvar5"))//To change
		sametrace = StringByKey("TNAME", csrinfo(H))
		Cursor/A=1 H  $sametrace CutoutCursorTo
		//print CutoutCursorTo
	endif
	CutOutHookFlag = 0	
End

Function CutoutCursorHook (infoStr)
	String infoStr
	SVAR CutOutGraphName
	NVAR CutoutCursorFrom,CutoutCursorTo
	NVAR CutOutHookFlag
	String event = StringByKey("EVENT",infoStr)
	//print event
	if (stringmatch(event, "cursormoved"))
		String tracename = StringByKey("TNAME",infoStr)
		String cursorname = StringByKey("CURSOR",infoStr)
		String cursorpoint = StringByKey("POINT",infoStr)
		if (!stringmatch(cursorpoint,""))
			variable cursortime = pnt2x(TraceNameToWaveRef(CutOutGraphName, tracename ), str2num(cursorpoint))
			if (stringmatch(cursorname,"G"))
				CutoutCursorFrom = cursortime
			endif
			if (stringmatch(cursorname,"H"))
				CutoutCursorTo = cursortime
			endif
			CutOutHookFlag = 1
		endif	
	endif
	
	if (stringmatch(event, "mouseup"))
		if (CutOutHookFlag)
			CutOutHookFlag = 0
		else
			//String modifiers = StringByKey("MODIFIERS",infoStr)
			String mousex = StringByKey("MOUSEX",infoStr)
			String mousey = StringByKey("MOUSEY",infoStr)
			variable mox=str2num(mousex)
			variable moy=str2num(mousey)
			//print mox,moy
			String TraceString
			TraceString = TraceFromPixel(mox, moy, "")
			//print TraceString
			String clicktrace = StringByKey("TRACE",TraceString)
			//print clicktrace
			if ((stringmatch(clicktrace,"RedTrace2"))||(stringmatch(clicktrace,"EventCutOutAverage"))||(stringmatch(clicktrace,""))||(stringmatch(clicktrace,"BlueTrace2")))
				abort
			else
				SVAR CutOutGraphNameList
				variable tracenum = WhichListItem(clicktrace, CutOutGraphNameList)
				//print tracenum
				NVAR HighLightWaveNum2
				HighLightWaveNum2= tracenum
				CutOutTraceNumChangeDo(tracenum)
			endif
		endif
	endif
	return 0
End

Function ShowAverageCutOut(ctrlName,checked) : CheckBoxControl
	String ctrlName
	variable checked
	if (checked)
		ModifyGraph hideTrace(EventCutOutAverage)=0
	else
		ModifyGraph hideTrace(EventCutOutAverage)=1
	endif
End

Function CutOutTraceNumChange(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	CutOutTraceNumChangeDo(varNum)
End

Function CutOutTraceNumChangeDo(num)
	variable num
	wave/T w1 = CutOutWaveNames
	NVAR ShowFitFlag2
	Duplicate/O $w1[num], RedTrace2
	if (ShowFitFlag2)
		wave CurveFit2D2
		Duplicate/O/R=[][num] CurveFit2D2,BlueTrace2
	endif
	SetActiveSubwindow CutOutGraph#PBottom
	SetVariable setvar2,value= w1[num], win= CutOutGraph#PBottom
	Wave CutOutRefWave
	NVAR WorkingEvent
	WorkingEvent = CutOutRefWave[num]
	SetWindow EventDetectionMainPanel
	SetActiveSubwindow EventDetectionMainPanel#EventDetectionControlPanel
	SetWorkingEvent()
End

Function EventCutOutPopMenuProc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	NVAR PeakAlignFlag,BaseAdjustFlag
	SVAR CutOutGraphName
	if (stringmatch(ctrlName, "popup0") && stringmatch(popStr, "Onset alignment"))
		PeakAlignFlag = 0
	endif
	if (stringmatch(ctrlName, "popup0") && stringmatch(popStr, "Peak alignment"))
		PeakAlignFlag = 1
	endif
	if (stringmatch(ctrlName, "popup1") && stringmatch(popStr, "Original baseline"))
		BaseAdjustFlag = 0
	endif
	if (stringmatch(ctrlName, "popup1") && stringmatch(popStr, "Adjust baseline"))
		BaseAdjustFlag = 1
	endif

	GetWindow $CutOutGraphName, wsize
	//print V_left, V_top, V_right, V_bottom
	DoWindow/K $CutOutGraphName
	DrawEventCutOut(V_left, V_top, V_right, V_bottom)
End

Function RefreshEventCutOut(ctrlName) : ButtonControl
	String ctrlName
	SVAR CutOutGraphName
	GetWindow $CutOutGraphName, wsize
	//print V_left, V_top, V_right, V_bottom
	DoWindow/K $CutOutGraphName
	DrawEventCutOut(V_left, V_top, V_right, V_bottom)
End

Function CurveFitOfCutOut(ctrlName) : ButtonControl
	String ctrlName
	NVAR MaskedNum, EventNum
	NVAR CutOutNum
	wave/T w1 = CutOutWaveNames
	wave CutOutRefWave
	SVAR CutOutGraphName
	SVAR resultpostfix
	NVAR ShowFitFlag2
	NVAR HighLightWaveNum2
	variable fittype
	variable ref
	ControlInfo/W=CutOutGraph#PBottom popup2
	fittype = V_Value//1 single exp; 2 double exp
	ControlInfo/W=CutOutGraph#PBottom check0
	if (V_Value)
		fittype += 2//3 single exp y0; 4 double exp y0
	endif
	
	variable xfrom = pcsr(G, CutOutGraphName)//p
	variable xto = pcsr(H, CutOutGraphName)//p
	if (xfrom > xto)
		variable xtemp = xto
		xto = xfrom
		xfrom = xtemp
	endif
	variable cursorwin =abs(xcsr(G, CutOutGraphName) - xcsr(H, CutOutGraphName))
	variable fastlim = 1/ (0.1 * cursorwin)
	variable slowlim = 1/ (5 * cursorwin)
	Duplicate/O/D/R=[xfrom,xto] $w1[0], CurveFit2D2, BlueTrace2
	Redimension/N=(-1,CutOutNum) CurveFit2D2
	Make/O/N=(EventNum) CoefWave0=nan, CoefWave1=nan, CoefWave2=nan
	if (fittype == 2)
		Make/O/N=(EventNum) CoefWave3=nan,CoefWave4=nan, TauMean=nan
	endif
	variable i = 0
	do
		Duplicate/O/D/R=[xfrom,xto] $w1[i], workingdatawave, workingfitwave
		workingfitwave = nan
		if (fittype == 1)
			CurveFit/N/Q exp workingdatawave /D=workingfitwave
		elseif (fittype == 2)
			CurveFit/N/Q dblexp workingdatawave /D=workingfitwave
		elseif (fittype == 3)
			K0=0
			CurveFit/N/Q/H="100" exp workingdatawave /D=workingfitwave
		elseif (fittype == 4)
			K0=0
			CurveFit/N/Q/H="100" dblexp workingdatawave /D=workingfitwave
		endif
		CurveFit2D2[][i] = workingfitwave[p]
		wave W_coef
		ref = CutOutRefWave[i]
		CoefWave0[ref] = W_coef[0]
		CoefWave1[ref] = W_coef[1]
		CoefWave2[ref] = W_coef[2]
		
		if ((fittype == 1)||(fittype == 3))		
			if ((numtype(W_coef[2])) || (W_coef[2] < slowlim) || (W_coef[2] > fastlim))
				CoefWave2[ref] = NaN
				CurveFit2D2[][i] = NaN
			else
				CoefWave2[ref] = W_coef[2]
			endif		
		else	
			if ((numtype(W_coef[2])) || (W_coef[2] <= 0))
				CoefWave2[ref] = NaN
				CurveFit2D2[][i] = NaN
			else
				CoefWave2[ref] = W_coef[2]
			endif		
			CoefWave3[ref] = W_coef[3]
			if ((numtype(W_coef[4])) || (W_coef[4] <= 0))
				CoefWave4[ref] = NaN
				CurveFit2D2[][i] = NaN
			else
				CoefWave4[ref] = W_coef[4]
			endif
		endif
		i += 1
	while (i < CutOutNum)
	
	BlueTrace2 = CurveFit2D2[p][HighLightWaveNum2]
	if (ShowFitFlag2 == 0)		
		AppendToGraph/W=$CutOutGraphName BlueTrace2
		ModifyGraph rgb(BlueTrace2)=(0,65280,65280)
		ShowFitFlag2 = 1
	endif
	CoefWave2 = 1/CoefWave2
	if ((fittype == 2)||(fittype == 4))
		CoefWave4 = 1/CoefWave4
		TauMean = (CoefWave1*CoefWave2+CoefWave3*CoefWave4)/(CoefWave1+CoefWave3)
	endif

	if ((fittype == 1)||(fittype == 3))
		Duplicate/O CoefWave0, $("DecayY0"+resultpostfix)
		Duplicate/O CoefWave1, $("DecayA"+resultpostfix)
		Duplicate/O CoefWave2, $("DecayTau"+resultpostfix)
		Edit $("DecayY0"+resultpostfix), $("DecayA"+resultpostfix), $("DecayTau"+resultpostfix)
	elseif ((fittype == 2)||(fittype == 4))
		Duplicate/O CoefWave0, $("DecayY0d"+resultpostfix)
		Duplicate/O CoefWave1, $("DecayA1"+resultpostfix)
		Duplicate/O CoefWave2, $("DecayTau1"+resultpostfix)
		Duplicate/O CoefWave3, $("DecayA2"+resultpostfix)
		Duplicate/O CoefWave4, $("DecayTau2"+resultpostfix)
		Duplicate/O TauMean, $("DecayTauM"+resultpostfix)
		Edit $("DecayY0d"+resultpostfix), $("DecayA1"+resultpostfix), $("DecayTau1"+resultpostfix), $("DecayA2"+resultpostfix), $("DecayTau2"+resultpostfix), $("DecayTauM"+resultpostfix)
	endif
	KillWaves/Z CoefWave0, CoefWave1, CoefWave2
	KillWaves/Z CoefWave3,CoefWave4, TauMean
End

Function MeasureValuesOfCutOut(ctrlName) : ButtonControl //measure values
	String ctrlName
	NVAR CutOutNum,EventNum
	SVAR resultpostfix
	wave/T w1 = CutOutWaveNames
	wave CutOutRefWave
	SVAR CutOutGraphName
	variable ref
	variable i
	variable xfrom = xcsr(G, CutOutGraphName)//x
	variable xto = xcsr(H, CutOutGraphName)//x
	if (xfrom > xto)
		variable xtemp = xto
		xto = xfrom
		xfrom = xtemp
	endif
	
	print "Measure from "+num2str(xfrom)+" to "+num2str(xto)
	print "Results are in waves with postfix: " +resultpostfix	
	Make/T/O/N=(EventNum) $("CutTrace"+resultpostfix)=""
	Make/O/N=(EventNum) $("CutMinVal"+resultpostfix)=Nan
	Make/O/N=(EventNum) $("CutMinLoc"+resultpostfix)=Nan
	Make/O/N=(EventNum) $("CutMaxVal"+resultpostfix)=Nan
	Make/O/N=(EventNum) $("CutMaxLoc"+resultpostfix)=Nan
	Make/O/N=(EventNum) $("CutAvrg"+resultpostfix)=Nan
	Make/O/N=(EventNum) $("CutArea"+resultpostfix)=Nan
	wave/T Wtrace = $("CutTrace"+resultpostfix)
	wave Wmin =  $("CutMinVal"+resultpostfix)
	wave Wminloc =  $("CutMinLoc"+resultpostfix)
	wave Wmax =  $("CutMaxVal"+resultpostfix)
	wave Wmaxloc =  $("CutMaxLoc"+resultpostfix)
	wave Waverage =  $("CutAvrg"+resultpostfix)
	wave Warea =  $("CutArea"+resultpostfix)
	i =0
	do
		wave w2 = $w1[i]
		ref = CutOutRefWave[i]
		WaveStats/W/Q/M=1/R=(xfrom,xto) w2
		wave w3 = M_WaveStats
		Wtrace[ref] = w1[i]
		Wmin[ref] = w3[10]
		Wminloc[ref] = w3[9]
		Wmax[ref] = w3[12]
		Wmaxloc[ref] = w3[11]
		Waverage[ref] = w3[3]
		Warea[ref] = area(w2, xfrom,xto)
	i += 1
	while (i < CutOutNum)
	Edit Wtrace,Wmin,Wminloc,Wmax,Wmaxloc,Waverage,Warea
	GetWaveNamesOfTable()
	killwaves/z M_WaveStats
End


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////// Further analysis
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Function FurtherAnalysisButton(ctrlName) : ButtonControl
	String ctrlName
	FurtherAnalysisShowPanel()
End

Function FurtherAnalysisShowPanel()
	TaroSetFont()
	if (WinType("FurtherAnalysisPanel") > 0)
		DoWindow/F FurtherAnalysisPanel
		abort
	endif
	String/g EpiKeyword = ""
	RefreshEpiList()
	Wave/T ShownEpiNames
	Wave EpiSel
	Variable/g SelectedEpiNumDisp
	SetFormula SelectedEpiNumDisp, "sum(EpiSel)"
	variable/g AutoListFlag = 1
	variable/g ListLength = 5
	if (exists("WindowFrom") && exists("WindowTo"))
		NVAR WindowFrom, WindowTo
	else
		variable/g WindowFrom, WindowTo
		WindowFrom = 0
		WindowTo = 1000
	endif
	
	if (exists("Tmin") && exists("Tmax"))
		NVAR Tmin,Tmax
	else
		variable/g Tmin,Tmax
		Tmin = WindowFrom
		Tmax = WindowTo
	endif
	if (exists("BinSize"))
		NVAR BinSize
		if (! (BinSize>0))//nan
			BinSize = round((WindowTo - WindowFrom)/20)
		endif
	else 
		variable/g BinSize
		BinSize = round((WindowTo - WindowFrom)/20)
	endif
	if (exists("BinSizeA") && exists("BinNumA"))
		NVAR BinSizeA, BinNumA
	else
		variable/g BinSizeA = 5, BinNumA = 20
	endif
	if (exists("BinSizeIn") && exists("BinNumIn"))
		NVAR BinSizeIn, BinNumIn
	else
		variable/g BinSizeIn = 5, BinNumIn = 20
	endif
	if (exists("BinSizeRise") && exists("BinNumRise"))
		NVAR BinSizeRise, BinNumRise
	else
		variable/g BinSizeRise = 0.1, BinNumRise = 20
	endif
	if (exists("AmpFrom") && exists("AmpTo"))
		NVAR AmpFrom, AmpTo
	else
		variable/g AmpFrom = 0, AmpTo = inf
	endif
	if (exists("RiseFrom") && exists("RiseTo"))
		NVAR RiseFrom, RiseTo
	else
		variable/g RiseFrom = 0, RiseTo = inf
	endif
	if (exists("BurstLimit"))
		NVAR BurstLimit
	else
		variable/g BurstLimit = 50
	endif
	if (exists("StimTime"))
		NVAR StimTime
	else
		variable/g StimTime = 200
	endif
	if (exists("BinSizeDecay") && exists("BinNumDecay"))
		NVAR BinSizeDecay, BinNumDecay
	else
		variable/g BinSizeDecay = 0.2, BinNumDecay = 20
	endif
		
	String/g NamePostfix=""
	
	if (exists("RasterFrom") && exists("RasterTo"))
		NVAR RasterFrom, RasterTo
	else
		variable/g RasterFrom = Tmin, RasterTo = Tmax
	endif
	
	if (exists("BinSizeCor") && exists("BinNumCor"))
		NVAR BinSizeCor, BinNumCor
	else
		variable/g BinSizeCor = 5, BinNumCor = 51
	endif
	
	if (exists("BinSizeHW") && exists("BinNumHW"))
		NVAR BinSizeHW, BinNumHW
	else
		variable/g BinSizeHW = 0.5, BinNumHW = 20
	endif
	String/g AnalysisParamPopStr
//	Variable/g RasterFrom,RasterTo
//	if (exists("WindowFrom"))
//		RasterFrom = WindowFrom
//		RasterTo = WindowTo
//	endif
	Variable/g ThreInt = 1, InterleaveEpiNum =1,InterleaveEpiOf = 2
	
	if (exists("CumBaseFrom") && exists("CumBaseTo"))
		NVAR CumBaseFrom, CumBaseTo
	else
		variable/g CumBaseFrom = 0, CumBaseTo = 200
	endif	

	if (exists("CumMeasFrom") && exists("CumMeasTo"))
		NVAR CumMeasFrom, CumMeasTo
	else
		variable/g CumMeasFrom = 200, CumMeasTo = 300
	endif	
	
	TaroSetFont()
	NewPanel /W=(30,57,30+900,57+639)/N= FurtherAnalysisPanel
	//
	ListBox LB1,pos={15,13},size={570,220},frame=2
	ListBox LB1,listWave= ShownEpiNames
	ListBox LB1,selWave= EpiSel,mode= 4,widths={100,50,390}
	Button Button7,pos={30,244},size={80,20},proc=SelectEpisAllOrNone,title="select all"
	Button Button8,pos={117,244},size={80,20},proc=SelectEpisAllOrNone,title="select none"
	Button Button9,pos={204,244},size={80,20},proc=RefreshEpiListButton,title="refresh list"
	SetVariable setvar0,pos={477,246},size={107,18},proc=ChangeEpiKeyword,title="keyword"
	SetVariable setvar0,limits={-inf,inf,0},value= EpiKeyword,bodyWidth= 60
	SetVariable setvar1,pos={375,246},size={99,18},disable=2,title="Selected:"
	SetVariable setvar1,frame=0
	SetVariable setvar1,limits={-inf,inf,0},value= SelectedEpiNumDisp,bodyWidth= 50
	
	//Button Button4,pos={58,542},size={50,20},proc=FurtherAnalysisStat,title="Stat"
	//Button Button4,fStyle=0
	//Button Button5,pos={122,542},size={50,20},proc=ShowEventDetectionHelp,title="help"
	//Button Button5,fStyle=0
	Button Button0,pos={30,268},size={80,20},proc=SelectEpisAllOrNone,title="Interleave"
	SetVariable setvar10,pos={120,270},size={50,18},title=" "
	SetVariable setvar10,limits={0,inf,1},value= InterleaveEpiNum,bodyWidth= 50
	SetVariable setvar11,pos={178,270},size={64,18},title="of"
	SetVariable setvar11,limits={0,inf,1},value= InterleaveEpiOf,bodyWidth= 50
	PopupMenu popup1,pos={403,267},size={178,21},proc=AnalysisParamPopProc,title="Analysis parameters"
	PopupMenu popup1,fSize=10
	PopupMenu popup1,mode=1,bodyWidth= 80,popvalue="default",value= #"AnalysisParamPopStr"
	

	CheckBox check20,pos={30,306},size={72,15},title="Time shift",fSize=12,value= 0
	SetVariable setvar19,pos={110,306},size={169,18},title="Time to set zero (ms):"
	SetVariable setvar19,value= StimTime,bodyWidth= 60
	GroupBox group0,pos={13,327},size={269,125},title="Event selection",fSize=14
	CheckBox check14,pos={30,349},size={89,15},title="By amplitude",fSize=12
	CheckBox check14,value= 0
	SetVariable setvar14,pos={38,369},size={140,18},title="Select between"
	SetVariable setvar14,limits={0,inf,1},value= AmpFrom,bodyWidth= 60
	SetVariable setvar15,pos={183,369},size={82,18},title="and"
	SetVariable setvar15,limits={0,inf,1},value= AmpTo,bodyWidth= 60
	CheckBox check15,pos={30,396},size={82,15},title="By rise time",fSize=12
	CheckBox check15,value= 0
	CheckBox check16,pos={150,397},size={56,14},proc=FurtherAnalysisCheckBox,title="20-80%"
	CheckBox check16,value= 1
	CheckBox check17,pos={214,397},size={56,14},proc=FurtherAnalysisCheckBox,title="10-90%"
	CheckBox check17,value= 0
	SetVariable setvar16,pos={38,417},size={140,18},title="Select between"
	SetVariable setvar16,limits={0,inf,0.01},value= RiseFrom,bodyWidth= 60
	SetVariable setvar17,pos={183,417},size={82,18},title="and"
	SetVariable setvar17,limits={0,inf,0.01},value= RiseTo,bodyWidth= 60
	CheckBox check27,pos={30,458},size={98,15},title="Use peak time",fSize=12
	CheckBox check27,value= 1,proc=FurtherAnalysisCheckBox
	CheckBox check28,pos={142,458},size={102,15},title="Use onset time",fSize=12
	CheckBox check28,value= 0,proc=FurtherAnalysisCheckBox
	
	SetVariable setvar6,pos={48,575},size={180,18},title="Name of analysis"
	SetVariable setvar6,labelBack=(48896,59904,65280),fSize=12,fStyle=0
	SetVariable setvar6,limits={-inf,inf,0},value= NamePostfix,bodyWidth= 80
	Button Button2,pos={58,599},size={80,20},proc=FurtherAnalysisDo,title="OK"
	Button Button2,fStyle=1
	Button Button3,pos={147,599},size={80,20},proc=FurtherAnalysisPanelClose,title="Close"
	Button Button3,fStyle=1
	TitleBox title1,pos={36,622},size={208,14},title="Help and Stat buttons were moved to Menu"
	TitleBox title1,frame=0,fColor=(21760,21760,21760)
	
	
	GroupBox group1,pos={309,299},size={270,326},title="Time range 1 (full trace)"
	GroupBox group1,fSize=14	
	SetVariable setvar7,pos={324,322},size={113,18},title="From (ms)"
	SetVariable setvar7,value= RasterFrom,bodyWidth= 60
	SetVariable setvar8,pos={444,322},size={101,18},title="To (ms)"
	SetVariable setvar8,value= RasterTo,bodyWidth= 60
	CheckBox check1,pos={326,346},size={55,15},title="Raster",fSize=11,value= 0
	CheckBox check6,pos={396,347},size={107,14},title="colour interval < (ms)"
	CheckBox check6,fSize=9,value= 0
	SetVariable setvar9,pos={521,346},size={50,18},title=" "
	SetVariable setvar9,limits={0,inf,0.1},value= ThreInt,bodyWidth= 50
	CheckBox check0,pos={326,371},size={50,15},title="PSTH*",fSize=11,value= 0
	CheckBox check5,pos={397,372},size={112,14},title="divide by trace num",value= 1
	CheckBox check18,pos={397,391},size={101,14},title="divide by bin size",value= 1
	CheckBox check30,pos={529,391},size={38,14},title="3SD",value= 0
	CheckBox check7,pos={326,415},size={104,15},title="Amplitude trend*",fSize=11
	CheckBox check7,value= 0
	CheckBox check22,pos={326,439},size={96,15},title="Amplitude plot",fSize=11
	CheckBox check22,value= 0
	CheckBox check24,pos={326,463},size={94,15},title="Area trend*",fSize=11
	CheckBox check24,value= 0
	CheckBox check25,pos={326,487},size={82,15},title="Area plot",fSize=11
	CheckBox check25,value= 0
	CheckBox check26,pos={326,511},size={139,15},title="Cumulative amp. trend*"
	CheckBox check26,fSize=11,value= 0
	CheckBox check31,pos={326,535},size={111,14},title="Instant. freq. trend*"
	CheckBox check31,fSize=11,value= 0

	CheckBox check29,pos={326,563},size={115,15},title="Cumulative PSTH",fSize=11
	CheckBox check29,value= 0
	SetVariable setvar24,pos={331,580},size={142,18},bodyWidth=60,title="Base: from (ms)"
	SetVariable setvar24,value= CumBaseFrom
	SetVariable setvar25,pos={477,580},size={98,18},bodyWidth=60,title="to (ms)"
	SetVariable setvar25,value= CumBaseTo
	SetVariable setvar26,pos={314,600},size={159,18},bodyWidth=60,title="Measure: from (ms)"
	SetVariable setvar26,value= CumMeasFrom
	SetVariable setvar27,pos={477,600},size={98,18},bodyWidth=60,title="to (ms)"
	SetVariable setvar27,value= CumMeasTo

	TitleBox title2,pos={512,445},size={44,14},title="*Bin (ms)",frame=0
	SetVariable setvar5,pos={511,463},size={60,18},bodyWidth=60,title=" "
	SetVariable setvar5,limits={0,inf,1},value= BinSize

	variable ypos = 240
	GroupBox group2,pos={605,ypos},size={270,385},title="Time range 2 (evoked events)"
	GroupBox group2,fSize=14
	ypos += 23
	SetVariable setvar3,pos={619,ypos},size={113,18},title="From (ms)"
	SetVariable setvar3,value= Tmin,bodyWidth= 60
	SetVariable setvar4,pos={749,ypos},size={101,18},title="To (ms)"
	SetVariable setvar4,value= Tmax,bodyWidth= 60
	ypos += 23
	CheckBox check8,pos={622,ypos},size={70,15},proc=FurtherAnalysisCheckBox,title="Calculate"
	CheckBox check8,fSize=12,value= 1
	CheckBox check19,pos={711,ypos+2},size={79,14},title="Limit to burst",value= 0
	SetVariable setvar18,pos={790,ypos},size={76,18},title="(ms)"
	SetVariable setvar18,limits={0,inf,1},value= BurstLimit,bodyWidth= 50
	ypos += 27
	CheckBox check2,pos={630,ypos},size={79,14},proc=FurtherAnalysisCheckBox,title="Summary list"
	CheckBox check2,value= 0
	ypos += 18
	TitleBox title0,pos={637,ypos+1},size={95,13},title="Event number in list:",frame=0	
	CheckBox check3,pos={741,ypos},size={39,14},proc=FurtherAnalysisCheckBox,title="auto"
	CheckBox check3,value= 0
	CheckBox check4,pos={790,ypos},size={30,14},proc=FurtherAnalysisCheckBox,title="fix"
	CheckBox check4,value= 1
	SetVariable setvar2,pos={825,ypos},size={40,18},title=" "
	SetVariable setvar2,limits={5,inf,1},value= ListLength,bodyWidth= 40
	ypos += 27
	CheckBox check9,pos={630,ypos},size={115,14},proc=FurtherAnalysisCheckBox,title="Amplitude histogram"
	CheckBox check9,value= 0
	ypos += 18
	SetVariable setvar06,pos={638,ypos},size={99,18},title="Bin (   )"
	SetVariable setvar06,limits={0,inf,1},value= BinSizeA,bodyWidth= 60
	SetVariable setvar07,pos={763,ypos},size={102,18},title="Bin num"
	SetVariable setvar07,limits={0,inf,1},value= BinNumA,bodyWidth= 60
	ypos += 27
	CheckBox check10,pos={630,ypos},size={103,14},proc=FurtherAnalysisCheckBox,title="Interval histogram"
	CheckBox check10,value= 0
	ypos += 18
	SetVariable setvar08,pos={633,ypos},size={104,18},title="Bin (ms)"
	SetVariable setvar08,limits={0,inf,1},value= BinSizeIn,bodyWidth= 60
	SetVariable setvar09,pos={763,ypos},size={102,18},title="Bin num"
	SetVariable setvar09,limits={0,inf,1},value= BinNumIn,bodyWidth= 60
	ypos += 27
	CheckBox check11,pos={630,ypos},size={111,14},proc=FurtherAnalysisCheckBox,title="Rise time histogram"
	CheckBox check11,value= 0
	CheckBox check12,pos={750,ypos},size={56,14},proc=FurtherAnalysisCheckBox,title="20-80%"
	CheckBox check12,value= 1
	CheckBox check13,pos={814,ypos},size={56,14},proc=FurtherAnalysisCheckBox,title="10-90%"
	CheckBox check13,value= 0
	ypos += 18
	SetVariable setvar12,pos={633,ypos},size={104,18},title="Bin (ms)"
	SetVariable setvar12,limits={0,inf,0.01},value= BinSizeRise,bodyWidth= 60
	SetVariable setvar13,pos={763,ypos},size={102,18},title="Bin num"
	SetVariable setvar13,limits={0,inf,1},value= BinNumRise,bodyWidth= 60
	ypos += 27
	CheckBox check32,pos={630,ypos},size={103,14},proc=FurtherAnalysisCheckBox,title="Half-width histogram"//
	CheckBox check32,value= 0
	ypos += 18
	SetVariable setvar28,pos={633,ypos},size={104,18},title="Bin (ms)"
	SetVariable setvar28,limits={0,inf,1},value= BinSizeHW,bodyWidth= 60
	SetVariable setvar29,pos={763,ypos},size={102,18},title="Bin num"
	SetVariable setvar29,limits={0,inf,1},value= BinNumHW,bodyWidth= 60
	ypos += 27
	CheckBox check21,pos={630,ypos},size={121,14},proc=FurtherAnalysisCheckBox,title="Decay time histogram"
	CheckBox check21,value= 0
	PopupMenu popup0,pos={765,ypos},size={52,21},fSize=9
	PopupMenu popup0,mode=1,popvalue="tau",value= #"\"tau;tau1;tau2;tauM\""//,popvalue="tau"
	ypos += 18	
	SetVariable setvar20,pos={633,ypos},size={104,18},title="Bin (ms)"
	SetVariable setvar20,limits={0,inf,0.01},value= BinSizeDecay,bodyWidth= 60
	SetVariable setvar21,pos={763,ypos},size={102,18},title="Bin num"
	SetVariable setvar21,limits={0,inf,1},value= BinNumDecay,bodyWidth= 60
	ypos += 27
	CheckBox check23,pos={630,ypos},size={99,14},proc=FurtherAnalysisCheckBox,title="Autocorrelogram"
	CheckBox check23,value= 0
	ypos += 18
	SetVariable setvar22,pos={633,ypos},size={104,18},title="Bin (ms)"
	SetVariable setvar22,limits={0,inf,1},value= BinSizeCor,bodyWidth= 60
	SetVariable setvar23,pos={763,ypos},size={102,18},title="Bin num"
	SetVariable setvar23,limits={0,inf,1},value= BinNumCor,bodyWidth= 60
	
		
	SaveAnalysisParameters("default")	
End

Function FurtherAnalysisPanelClose(ctrlName) : ButtonControl
	String ctrlName
	DoWindow/K FurtherAnalysisPanel
	KillVariables/Z AutoListFlag, ListLength, SelectedEpiNumDisp,SelectedEpiNum
	KillVariables/Z NumOfResults, InterleaveEpiNum,InterleaveEpiOf,MakeSummaryList
	KillVariables/Z BinSizeIn, BinNumIn,BinSizeA, BinNumA, BinSizeCor,BinNumCor
	KillVariables/Z CumBaseFrom, CumBaseTo, CumMeasFrom, CumMeasTo
	Killwaves/Z AllEpiNames, EpiSel, ShownEpiNames,SelectedEpiMx,AnalysisParamdefault
	KillStrings/Z EpiKeyWord, NamePostfix, PostfixList,AnalysisParamPopProc
	//stat
	Killwaves/Z AllValWave, ValSel
End


Function RefreshEpiList()
	SVAR EpiKeyword
	String AllWavesT
	AllWavesT = WaveList("ParamWave*",";","TEXT:1,MAXCOLS:1,MAXLAYERS:1") //only text waves
	AllWavesT = RemoveFromList ("ParamWave", AllWavesT)
	String PostfixList//local
	PostfixList = ReplaceString("ParamWave", AllWavesT, "")
	variable NumSet = ItemsInList(PostfixList)
//	Make/O/T/N=0 AllEpiNames
	Make/O/T/N=(0,3) AllEpiNames
	variable NE
	string SN
	variable i = 0
	for (i = 0; i < NumSet; i += 1) 
//	do// for each selected episode
		SN = StringFromList(i, PostfixList)
		NE = numpnts($("ParamWave"+SN)) - 10
		duplicate/O/R=[10,]/T  $("ParamWave"+SN) tempwave
		variable pntadd = numpnts(tempwave)
		Redimension/N=(-1,3) tempwave
		tempwave[][2] = tempwave[p][0]
		tempwave[][1] = num2str(p)
		tempwave[][0] = SN
		
		//concatenate (AllEpiNames + tempwave) 
		variable DS = DimSize(AllEpiNames, 0)
		InsertPoints/M=0 DS, pntadd, AllEpiNames
		variable k = 0
		do
			AllEpiNames[k+DS][] = tempwave[k][q]
			k += 1
		while (k < pntadd)
		
//		i += 1
//	while (i < NumSet)
	endfor
	killwaves/z  tempwave
	//Extract/O/T AllEpiNames, ShownEpiNames, stringmatch(AllEpiNames,"*"+EpiKeyword+"*")
	Duplicate/O/T AllEpiNames,ShownEpiNames
	Variable n=  DimSize(ShownEpiNames, 0)
	i = 0
	do
		if (!((stringmatch(ShownEpiNames[i][0],"*"+EpiKeyword+"*")) ||  (stringmatch(ShownEpiNames[i][2],"*"+EpiKeyword+"*"))))
			DeletePoints/M=0 i, 1, ShownEpiNames
			n -= 1
			i -= 1
		endif
		i += 1
	while (i< n)
	n = DimSize(ShownEpiNames, 0)
	Make/O/N=(n) EpiSel = 0
End

Function FurtherAnalysisCheckBox(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	NVAR AutoListFlag
	if (stringmatch(ctrlName, "check3"))	
		CheckBox check3,value= 1
		CheckBox check4,value= 0
		AutoListFlag = 1
	endif
	if (stringmatch(ctrlName, "check4"))	
		CheckBox check3,value= 0
		CheckBox check4,value= 1
		AutoListFlag = 0		
	endif
	if (stringmatch(ctrlName, "check2"))	//sum list
		if (checked)
			CheckBox check8,value= 1
		endif
	endif
	if (stringmatch(ctrlName, "check9"))	//amp histo
		if (checked)
			CheckBox check8,value= 1
		endif
	endif
	if (stringmatch(ctrlName, "check10"))//int histo
		if (checked)
			CheckBox check8,value= 1
		endif
	endif
	if (stringmatch(ctrlName, "check11"))//rise histo
		if (checked)
			CheckBox check8,value= 1
		endif
	endif
	if (stringmatch(ctrlName, "check21"))//decay histo
		if (checked)
			CheckBox check8,value= 1
		endif
	endif
	if (stringmatch(ctrlName, "check23"))//auto correlogram
		if (checked)
			CheckBox check8,value= 1
		endif
	endif
	if (stringmatch(ctrlName, "check32"))//half-width
		if (checked)
			CheckBox check8,value= 1
		endif
	endif
	if (stringmatch(ctrlName, "check8"))	//calc waves
		if (!checked)
			CheckBox check2,value= 0
			CheckBox check9,value= 0
			CheckBox check10,value= 0			
			CheckBox check11,value= 0			
			CheckBox check21,value= 0			
			CheckBox check23,value= 0			
			CheckBox check32,value= 0			
		endif
	endif
	if (stringmatch(ctrlName, "check12"))//20-80
		CheckBox check12,value= 1
		CheckBox check13,value= 0
	endif
	if (stringmatch(ctrlName, "check13"))//10-90
		CheckBox check12,value= 0
		CheckBox check13,value= 1
	endif
	if (stringmatch(ctrlName, "check16"))//20-80
		CheckBox check16,value= 1
		CheckBox check17,value= 0
	endif
	if (stringmatch(ctrlName, "check17"))//10-90
		CheckBox check16,value= 0
		CheckBox check17,value= 1
	endif
	if (stringmatch(ctrlName, "check27"))//use peak
		CheckBox check27,value= 1
		CheckBox check28,value= 0
	endif
	if (stringmatch(ctrlName, "check28"))//use onset
		CheckBox check27,value= 0
		CheckBox check28,value= 1
	endif
End

Function SelectEpisAllOrNone(ctrlName) : ButtonControl
	String ctrlName
	wave EpiSel
	if (stringmatch(ctrlName, "Button7"))//all
		RefreshEpiList()
		EpiSel = 1
	endif
	if (stringmatch(ctrlName, "Button8"))//none
		RefreshEpiList()
		EpiSel = 0
	endif
	if (stringmatch(ctrlName, "Button0")) // Interleave
		NVAR InterleaveEpiNum,InterleaveEpiOf 
		variable ListedNum =numpnts(EpiSel)
		variable i = 0
		do
			if (mod(i, InterleaveEpiOf)+1 == InterleaveEpiNum)
				EpiSel[i] = 1
			else
				EpiSel[i] =0
			endif
		i += 1
		while (i < ListedNum)	
	endif
End

Function ChangeEpiKeyword(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	RefreshEpiList()
End

Function RefreshEpiListButton(ctrlName) : ButtonControl
	String ctrlName
	SVAR EpiKeyword
	EpiKeyword = ""
	RefreshEpiList()
End

Function FurtherAnalysisDo(ctrlName) : ButtonControl
	String ctrlName
	SVAR NamePostfix	
	wave EpiSel
	wave/T ShownEpiNames//2D
	variable/g SelectedEpiNum =sum(EpiSel)
//	variable ListedNum =numpnts(ShownEpiNames)
	variable ListedNum =DimSize(ShownEpiNames, 0)
	variable i, j, k
	if (SelectedEpiNum == 0)
		abort "Select at least one episode."
	endif
	if (stringmatch(NamePostfix,""))
		abort "Enter a name of this analysis (postfix of result waves)."
	elseif (ItemsInList(WaveList("ExEpisode"+NamePostfix,";","MAXCOLS:1,MAXLAYERS:1")))
		DoAlert 1, "Do you want to replace "+NamePostfix+" ?"
		if (V_flag == 2)
			abort
		endif
	endif		
	Make/O/T/N=(SelectedEpiNum,3) SelectedEpiMx
	variable/G MakeSummaryList
	
	variable DecayAnalysisMode//0 not fitting, 1 single exp , 2 double exp, 3 both
	variable/G DecayAnalysisModeMax

	// make a list of selected episodes
	i = 0
	k = 0
	do 
		if (EpiSel[i])
			SelectedEpiMx[k] = ShownEpiNames[i][q]
			k += 1
		endif
		i += 1
		//print i
	while (i < ListedNum)
	make/O/N=100000 ExEpisode=nan,ExEventTime=nan,ExEventAmp=nan,ExRise=nan,ExRise2=nan, ExBaseTime=nan
	make/O/N=100000 ExEventNumRef=nan,ExTau=nan,ExTau1=nan,ExTau2=nan,ExTauM=nan,ExArea=nan,ExHalfWidth=nan
	i = 0//episode number
	j =0//event number in new waves
	do
		wave ce = $("Episode"+SelectedEpiMx[i][0])
		wave ct = $("EventTime"+SelectedEpiMx[i][0])
		wave cb = $("BaseTime"+SelectedEpiMx[i][0])
		if (WaveExists($("EventAmplitude"+SelectedEpiMx[i][0])))// backward compatibility
			wave ca = $("EventAmplitude"+SelectedEpiMx[i][0])
		else
			wave ca = $("EventAmplitudeSub"+SelectedEpiMx[i][0])
		endif
		if  (WaveExists($("RiseTime2080"+SelectedEpiMx[i][0])))
			wave cr1 = $("RiseTime2080"+SelectedEpiMx[i][0])
			wave cr2 = $("RiseTime1090"+SelectedEpiMx[i][0])
		else
			abort "The wave format is old. Please go back to the event detection and do Load Results and just save it by Save Results (replace the old result)."
		endif
		if  (WaveExists($("AreaAbs"+SelectedEpiMx[i][0])))
			wave cAr = $("AreaAbs"+SelectedEpiMx[i][0])
		else		
			duplicate/O ce, $("AreaAbs"+SelectedEpiMx[i][0])
			wave cAr = $("AreaAbs"+SelectedEpiMx[i][0])
			cAr = nan
		endif
		if (WaveExists($("DecayTau"+SelectedEpiMx[i][0])))
			wave tau = $("DecayTau"+SelectedEpiMx[i][0])
			DecayAnalysisMode= 1
		else
			DecayAnalysisMode= 0
		endif
		if (WaveExists($("DecayTau1"+SelectedEpiMx[i][0])))
			wave tau1 = $("DecayTau1"+SelectedEpiMx[i][0])
			wave tau2 = $("DecayTau2"+SelectedEpiMx[i][0])
			wave tauM = $("DecayTauM"+SelectedEpiMx[i][0])
			DecayAnalysisMode += 2
		endif
		DecayAnalysisModeMax = DecayAnalysisMode | DecayAnalysisModeMax
		if  (WaveExists($("HalfWidth"+SelectedEpiMx[i][0])))
			wave cHW = $("HalfWidth"+SelectedEpiMx[i][0])
		else		
			duplicate/O ce, $("HalfWidth"+SelectedEpiMx[i][0])
			wave cHW = $("HalfWidth"+SelectedEpiMx[i][0])
			cHW = nan
		endif
		
		variable epiN = str2num(SelectedEpiMx[i][1])
		variable eveN = numpnts(ce)
		k = 0//event number in original waves
		do
			if (ce[k] == epiN)
				ExEpisode[j] = i
				ExEventTime[j] = ct[k]
				ExBaseTime[j] = cb[k]
				ExEventAmp[j] = ca[k]
				ExRise[j] = cr1[k]
				ExRise2[j] = cr2[k]
				ExArea[j] = cAr[k]
				ExEventNumRef[j] = k
				if (DecayAnalysisMode & 1)
					ExTau[j] = tau[k]
				endif
				if (DecayAnalysisMode & 2)
					ExTau1[j] = tau1[k]
					ExTau2[j] = tau2[k]
					ExTauM[j] = tauM[k]
				endif
				ExHalfWidth[j] = cHW[k]
				j += 1
			endif
			k += 1
		while (k < eveN)
		i += 1
	while (i < SelectedEpiNum)
	WaveStats /M=1/Q ExEpisode
	DeletePoints V_npnts, V_numNans, ExEpisode,ExEventTime,ExEventAmp,ExRise,ExRise2,ExBaseTime
	DeletePoints V_npnts, V_numNans, ExEventNumRef,ExTau,ExTau1,ExTau2,ExTauM, ExArea,ExHalfWidth
	
	ControlInfo /W=FurtherAnalysisPanel check20// time shift
	if (V_value)
		NVAR StimTime
		ExEventTime -= StimTime
		ExBaseTime -= StimTime		
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check14
	if (V_value) // select by amplitude
		NVAR AmpFrom, AmpTo
		eveN = numpnts(ExEpisode)
		i = 0
		do
			if ((ExEventAmp[i] < AmpFrom) || (ExEventAmp[i] > AmpTo))
				deletepoints i,1,ExEpisode,ExEventTime,ExEventAmp,ExRise,ExRise2,ExBaseTime
				deletepoints i,1,ExEventNumRef,ExTau,ExTau1,ExTau2,ExTauM, ExArea,ExHalfWidth
				i -= 1
			endif
			i += 1
		while (i < eveN)
	endif

	ControlInfo /W=FurtherAnalysisPanel check15
	if (V_value) // select by rise
		NVAR RiseFrom, RiseTo
		ControlInfo /W=FurtherAnalysisPanel check16
		if (V_value)
			wave sRise = ExRise//20-80
		else
			wave sRise = ExRise2//10-90
		endif
		
		eveN = numpnts(ExEpisode)
		i = 0
		do
			if ((sRise[i] < RiseFrom) || (sRise[i] > RiseTo))
				deletepoints i,1,ExEpisode,ExEventTime,ExEventAmp,ExRise,ExRise2,ExBaseTime
				deletepoints i,1,ExEventNumRef,ExTau,ExTau1,ExTau2,ExTauM, ExArea,ExHalfWidth
				i -= 1
			endif
			i += 1
		while (i < eveN)	
	endif
	
	Duplicate/O ExEpisode, $("ExEpisode"+NamePostfix)
	Duplicate/O ExEventTime, $("ExEventTime"+NamePostfix)
	Duplicate/O ExBaseTime, $("ExBaseTime"+NamePostfix)
	Duplicate/O ExEventAmp, $("ExEventAmp"+NamePostfix)
	Duplicate/O ExRise, $("ExRise2080"+NamePostfix)
	Duplicate/O ExRise2, $("ExRise1090"+NamePostfix)
	Duplicate/O ExEventNumRef, $("ExEventNumRef"+NamePostfix)
	Duplicate/O ExArea, $("ExArea"+NamePostfix)
	Duplicate/O SelectedEpiMx, $("SelectedEpiMx"+NamePostfix)	
	if (DecayAnalysisModeMax & 1)
		Duplicate/O ExTau, $("ExTau"+NamePostfix)
	endif
	if (DecayAnalysisModeMax & 2)
		Duplicate/O ExTau1, $("ExTau1"+NamePostfix)
		Duplicate/O ExTau2, $("ExTau2"+NamePostfix)
		Duplicate/O ExTauM, $("ExTauM"+NamePostfix)
	endif
	Duplicate/O ExHalfWidth, $("ExHalfWidth"+NamePostfix)
	KillWaves/Z ExEpisode,ExEventTime,ExEventAmp,ExRise,ExRise2,ExBaseTime
	KillWaves/Z ExEventNumRef,ExTau,ExTau1,ExTau2,ExTauM,ExArea,ExHalfWidth
	
	String toprint = ""
	i = 0
	do
		toprint += SelectedEpiMx[i][2]+";"
		i += 1
	while (i < SelectedEpiNum)
	print "Further analysis <"+NamePostfix+"> on "+num2str(SelectedEpiNum)+" waves: "+toprint

	ControlInfo/W=FurtherAnalysisPanel check28
	if (V_value)
		Print "Using Onset time for all timing information"
	else
		Print "Using Peak time for all timing information"
	endif
	
	SaveAnalysisParameters(NamePostfix)
	
	ControlInfo /W=FurtherAnalysisPanel check0
	if (V_value)
		//PSTH
		MakePSTH()
	endif
	ControlInfo /W=FurtherAnalysisPanel check1
	if (V_value)
		//Raster
		MakeRaster()
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check7
	if (V_value)
		//Amplitude trend
		MakeAmplitudeTrend()
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check22
	if (V_value)
		//Amplitude plot
		MakeAmplitudePlot()
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check24
	if (V_value)
		//Amplitude plot
		MakeEventAreaTrend()
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check25
	if (V_value)
		//Amplitude plot
		MakeEventAreaPlot()
	endif

	ControlInfo /W=FurtherAnalysisPanel check26
	if (V_value)
		//Amplitude plot
		MakeCumulativeAmpPlot()
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check31
	if (V_value)
		//Instant. freq. trend.
		MakeInstantFreqTrend()
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check29
	if (V_value)
		//cumulative PSTH
		MakeCumulativePSTH()
	endif

	ControlInfo /W=FurtherAnalysisPanel check2//Summary list
	if (V_value)
		MakeSummaryList =1
	else
		MakeSummaryList =0
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check8/////Calculate
	if (V_value)
		//calc waves and summary list
		CalculateWavesAndMakeList()
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check9
	if (V_value)
		//amplitude histogram
		MakeAmplitudeHistogram()
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check10
	if (V_value)
		//interval histogram
		MakeIntervalHistogram()
	endif

	ControlInfo /W=FurtherAnalysisPanel check11
	if (V_value)
		//rise time histogram
		MakeRiseTimeHistogram()
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check21
	if (V_value)
		//decay time histogram
		MakeDecayTimeHistogram()
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check23
	if (V_value)
		//autocorrelogram
		MakeAutocorrelogram()
	endif
	
	ControlInfo /W=FurtherAnalysisPanel check32
	if (V_value)
		//Half-width Histogram
		MakeHalfWidthHistogram()
	endif
	
End

Function SaveAnalysisParameters(postfixstr)
	String postfixstr

	Make/O/N=100 $("AnalysisParam"+postfixstr) =Nan
	wave AnalysisParam = $("AnalysisParam"+postfixstr)
	NVAR StimTime, AmpFrom, AmpTo, RiseFrom, RiseTo
	ControlInfo /W=FurtherAnalysisPanel check20//time shift
	AnalysisParam[1] = V_value
	AnalysisParam[2] = StimTime
	ControlInfo /W=FurtherAnalysisPanel check14//by amp
	AnalysisParam[3] = V_value
	AnalysisParam[4] = AmpFrom 
	AnalysisParam[5] = AmpTo
	ControlInfo /W=FurtherAnalysisPanel check15//by rise
	AnalysisParam[6] = V_value
	ControlInfo /W=FurtherAnalysisPanel check16//20-80
	AnalysisParam[7] = V_value
	ControlInfo /W=FurtherAnalysisPanel check17//10-90
	AnalysisParam[8] = V_value
	AnalysisParam[9] = RiseFrom
	AnalysisParam[10] = RiseTo
	
	NVAR RasterFrom, RasterTo,ThreInt,BinSize
	AnalysisParam[11] = RasterFrom
	AnalysisParam[12] = RasterTo
	ControlInfo /W=FurtherAnalysisPanel check1//Raster
	AnalysisParam[13] = V_value
	ControlInfo /W=FurtherAnalysisPanel check6//colour
	AnalysisParam[14] = V_value
	AnalysisParam[15] = ThreInt
	ControlInfo /W=FurtherAnalysisPanel check0//PSTH
	AnalysisParam[16] = V_value
	ControlInfo /W=FurtherAnalysisPanel check5//divide by trace num
	AnalysisParam[17] = V_value
	ControlInfo /W=FurtherAnalysisPanel check18//divide by bin size	
	AnalysisParam[18] = V_value
	ControlInfo /W=FurtherAnalysisPanel check7// amp trend
	AnalysisParam[19] = V_value
	AnalysisParam[20] = BinSize	
	
	NVAR Tmin,Tmax,BurstLimit,ListLength,BinSizeA,BinNumA,BinSizeIn,BinNumIn
	NVAR BinSizeRise,BinNumRise,BinSizeDecay,BinNumDecay
	AnalysisParam[21] = Tmin
	AnalysisParam[22] = Tmax
	ControlInfo /W=FurtherAnalysisPanel check8//calc
	AnalysisParam[23] = V_value
	ControlInfo /W=FurtherAnalysisPanel check19//limit to burst
	AnalysisParam[24] = V_value
	AnalysisParam[25] = BurstLimit
	ControlInfo /W=FurtherAnalysisPanel check2//list
	AnalysisParam[26] = V_value
	ControlInfo /W=FurtherAnalysisPanel check3//auto
	AnalysisParam[27] = V_value
	ControlInfo /W=FurtherAnalysisPanel check4//fix
	AnalysisParam[28] = V_value
	AnalysisParam[29] = ListLength
	ControlInfo /W=FurtherAnalysisPanel check9//amp histo
	AnalysisParam[30] = V_value
	AnalysisParam[31] = BinSizeA
	AnalysisParam[32] = BinNumA	
	ControlInfo /W=FurtherAnalysisPanel check10//interval histo
	AnalysisParam[33] = V_value
	AnalysisParam[34] = BinSizeIn
	AnalysisParam[35] = BinNumIn		
	ControlInfo /W=FurtherAnalysisPanel check11//rise histo
	AnalysisParam[36] = V_value
	ControlInfo /W=FurtherAnalysisPanel check12//20-80
	AnalysisParam[37] = V_value
	ControlInfo /W=FurtherAnalysisPanel check13//10-90
	AnalysisParam[38] = V_value
	AnalysisParam[39] = BinSizeRise
	AnalysisParam[40] = BinNumRise
	ControlInfo /W=FurtherAnalysisPanel check21//decay histo
	AnalysisParam[41] = V_value
	ControlInfo /W=FurtherAnalysisPanel popup0//select tau //Popup, counting from one
	AnalysisParam[42] = V_value
	AnalysisParam[43] = BinSizeDecay
	AnalysisParam[44] = BinNumDecay
	
	ControlInfo /W=FurtherAnalysisPanel check22// amp plot
	AnalysisParam[45] = V_value
	NVAR BinSizeCor,BinNumCor
	ControlInfo /W=FurtherAnalysisPanel check23//Autocorrelogram
	AnalysisParam[46] = V_value
	AnalysisParam[47] = BinSizeCor
	AnalysisParam[48] = BinNumCor	
		
	ControlInfo /W=FurtherAnalysisPanel check24// area PSTH
	AnalysisParam[49] = V_value
	ControlInfo /W=FurtherAnalysisPanel check25// area plot
	AnalysisParam[50] = V_value
	ControlInfo /W=FurtherAnalysisPanel check26// cumulative amp trend
	AnalysisParam[51] = V_value

	ControlInfo /W=FurtherAnalysisPanel check28// Use onset time (instead of peak)
	AnalysisParam[52] = V_value
	
	NVAR CumBaseFrom, CumBaseTo, CumMeasFrom, CumMeasTo
	ControlInfo /W=FurtherAnalysisPanel check29// make cumulative PSTH
	AnalysisParam[53] = V_value
	AnalysisParam[54] = CumBaseFrom	
	AnalysisParam[55] = CumBaseTo	
	AnalysisParam[56] = CumMeasFrom	
	AnalysisParam[57] = CumMeasTo
	
	ControlInfo /W=FurtherAnalysisPanel check30// 3SD on
	AnalysisParam[58] = V_value
	
	NVAR BinSizeHW, BinNumHW
	ControlInfo /W=FurtherAnalysisPanel check32// half-width
	AnalysisParam[59] = V_value	
	AnalysisParam[60] = BinSizeHW	
	AnalysisParam[61] = BinNumHW	
	
	SVAR AnalysisParamPopStr
	AnalysisParamPopStr = WaveList("AnalysisParam*",";","")
	AnalysisParamPopStr = ReplaceString("AnalysisParam", AnalysisParamPopStr, "")
	AnalysisParamPopStr = RemoveFromList (ListMatch(AnalysisParamPopStr, "default"), AnalysisParamPopStr)
	AnalysisParamPopStr = "default;"+ AnalysisParamPopStr
	variable popmode = WhichListItem(postfixstr, AnalysisParamPopStr) +1 
	PopupMenu popup1, win=FurtherAnalysisPanel, mode =popmode
End

Function AnalysisParamPopProc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	wave AnalysisParam = $("AnalysisParam" + popStr)

	NVAR StimTime, AmpFrom, AmpTo, RiseFrom, RiseTo
	CheckBox check20, win=FurtherAnalysisPanel, value = AnalysisParam[1] //time shift
	StimTime = AnalysisParam[2]
	CheckBox check14, win=FurtherAnalysisPanel, value = AnalysisParam[3]//by amp
	AmpFrom = AnalysisParam[4]
	AmpTo = AnalysisParam[5]
	CheckBox check15, win=FurtherAnalysisPanel, value = AnalysisParam[6]//by rise
	CheckBox check16, win=FurtherAnalysisPanel, value = AnalysisParam[7]//20-80
	CheckBox check17, win=FurtherAnalysisPanel, value = AnalysisParam[8]//10-90
	RiseFrom = AnalysisParam[9]
	RiseTo = AnalysisParam[10]
	
	NVAR RasterFrom, RasterTo,ThreInt,BinSize
	RasterFrom = AnalysisParam[11]
	RasterTo = AnalysisParam[12]
	CheckBox check1, win=FurtherAnalysisPanel, value = AnalysisParam[13]//Raster
	CheckBox check6, win=FurtherAnalysisPanel, value = AnalysisParam[14]//colour
	ThreInt = AnalysisParam[15]
	CheckBox check0, win=FurtherAnalysisPanel, value = AnalysisParam[16]//PSTH
	CheckBox check5, win=FurtherAnalysisPanel, value = AnalysisParam[17]//divide by trace num
	CheckBox check18, win=FurtherAnalysisPanel, value = AnalysisParam[18]//divide by bin size	
	CheckBox check7, win=FurtherAnalysisPanel, value = AnalysisParam[19]// amp trend
	BinSize = AnalysisParam[20]
	
	NVAR Tmin,Tmax,BurstLimit,ListLength,BinSizeA,BinNumA,BinSizeIn,BinNumIn
	NVAR BinSizeRise,BinNumRise,BinSizeDecay,BinNumDecay
	Tmin = AnalysisParam[21]
	Tmax = AnalysisParam[22]
	CheckBox check8, win=FurtherAnalysisPanel, value = AnalysisParam[23]//calc
	CheckBox check19, win=FurtherAnalysisPanel, value = AnalysisParam[24]//limit to burst
	BurstLimit = AnalysisParam[25]
	CheckBox check2, win=FurtherAnalysisPanel, value = AnalysisParam[26]//list
	CheckBox check3, win=FurtherAnalysisPanel, value = AnalysisParam[27]//auto
	CheckBox check4, win=FurtherAnalysisPanel, value = AnalysisParam[28]//fix
	ListLength = AnalysisParam[29]
	CheckBox check9, win=FurtherAnalysisPanel, value = AnalysisParam[30]//amp histo
	BinSizeA = AnalysisParam[31]
	BinNumA = AnalysisParam[32]
	CheckBox check10, win=FurtherAnalysisPanel, value = AnalysisParam[33]//interval histo
	BinSizeIn = AnalysisParam[34]
	BinNumIn = AnalysisParam[35]
	CheckBox check11, win=FurtherAnalysisPanel, value = AnalysisParam[36]//rise histo
	CheckBox check12, win=FurtherAnalysisPanel, value = AnalysisParam[37]//20-80
	CheckBox check13, win=FurtherAnalysisPanel, value = AnalysisParam[38]//10-90
	BinSizeRise = AnalysisParam[39]
	BinNumRise = AnalysisParam[40]
	CheckBox check21, win=FurtherAnalysisPanel, value = AnalysisParam[41]//decay histo
	PopupMenu popup0, win=FurtherAnalysisPanel, mode = AnalysisParam[42]
	BinSizeDecay = AnalysisParam[43]
	BinNumDecay = AnalysisParam[44]
	
	if (numtype(AnalysisParam[45]))
		AnalysisParam[45] = 0
	endif
	CheckBox check22, win=FurtherAnalysisPanel, value = AnalysisParam[45]//amp plot
	
	NVAR BinSizeCor, BinNumCor
	if (numtype(AnalysisParam[46]))// autocorrelogram check
		AnalysisParam[46] = 0
		AnalysisParam[47] = 5
		AnalysisParam[48] = 51
	endif
	CheckBox check23, win=FurtherAnalysisPanel, value = AnalysisParam[46]
	BinSizeCor = AnalysisParam[47]
	BinNumCor = AnalysisParam[48]
	
	if (numtype(AnalysisParam[49]))
		AnalysisParam[49] = 0
	endif
	CheckBox check24, win=FurtherAnalysisPanel, value = AnalysisParam[49]//area PSTH
	if (numtype(AnalysisParam[50]))
		AnalysisParam[50] = 0
	endif
	CheckBox check25, win=FurtherAnalysisPanel, value = AnalysisParam[50]//area plot
	if (numtype(AnalysisParam[51]))
		AnalysisParam[51] = 0
	endif
	CheckBox check26, win=FurtherAnalysisPanel, value = AnalysisParam[51]//cumulative amp plot
	if (numtype(AnalysisParam[52]))
		AnalysisParam[52] = 0
	endif
	if (AnalysisParam[52])
		CheckBox check27, win=FurtherAnalysisPanel, value = 0
		CheckBox check28, win=FurtherAnalysisPanel, value = 1// use onset
	else
		CheckBox check27, win=FurtherAnalysisPanel, value = 1//use peak
		CheckBox check28, win=FurtherAnalysisPanel, value = 0
	endif
	
	NVAR CumBaseFrom, CumBaseTo, CumMeasFrom, CumMeasTo
	if (numtype(AnalysisParam[53]))
		AnalysisParam[53] = 0
		AnalysisParam[54] = 0
		AnalysisParam[55] = 200
		AnalysisParam[56] = 200
		AnalysisParam[57] = 300
	endif
	CheckBox check29, win=FurtherAnalysisPanel, value = AnalysisParam[53]//cumuPSTH
	CumBaseFrom = AnalysisParam[54]
	CumBaseTo = AnalysisParam[55]
	CumMeasFrom = AnalysisParam[56]
	CumMeasTo = AnalysisParam[57]
	
	if (numtype(AnalysisParam[58]))
		AnalysisParam[58] = 0
	endif
	CheckBox check30, win=FurtherAnalysisPanel, value = AnalysisParam[58]//cumuPSTH
	
	NVAR BinSizeHW, BinNumHW
	if (numpnts(AnalysisParam) > 60)
		CheckBox check30, win=FurtherAnalysisPanel, value = AnalysisParam[59]//half-width
		BinSizeHW =  AnalysisParam[60]
		BinNumHW =  AnalysisParam[61]
	else
		CheckBox check30, win=FurtherAnalysisPanel, value =0
		// no change to BinSizeHW and BinNumHW
	endif
	
	SelectEpiUsingSavedMx(popStr)		
End

Function SelectEpiUsingSavedMx(popStr)
	string popStr
	Wave SelMx = $("SelectedEpiMx"+popStr) 
	Wave AllEpiNames,EpiSel
	

End

Function MakeRaster()
	SVAR NamePostfix
	Wave Episode = $("ExEpisode"+NamePostfix)
	ControlInfo/W=FurtherAnalysisPanel check28
	if (V_value)
		Wave EventTime = $("ExBaseTime"+NamePostfix)
	else
		Wave EventTime = $("ExEventTime"+NamePostfix)
	endif
	NVAR ThreInt
	ControlInfo/W=FurtherAnalysisPanel check6
	if (V_value)
		variable n = numpnts(EventTime)
		Make/O/N=(n) $("RasterMark"+NamePostfix) = 0
		wave RasterMark = $("RasterMark"+NamePostfix)
		variable i = 0
		do
			if ((Episode[i] == Episode[i+1])&&(EventTime[i+1] - EventTime[i] < ThreInt))
				RasterMark[i] = 1
				RasterMark[i+1] =1
			endif
			i += 1
		while (i < n-1 )
	endif
	Display /W=(10,40,300,40+160) Episode vs EventTime
	ModifyGraph mode=3,marker=10,rgb=(0,0,0),mrkThick=2
	if (V_value)
		ModifyGraph zColor={RasterMark,0,2,Red}
	endif 
	Label left "Trace number"
	Label bottom "Time (ms)"
//	NVAR EpisodeNum,WindowFrom,WindowTo
	NVAR SelectedEpiNum,RasterFrom,RasterTo
	SetAxis bottom RasterFrom,RasterTo
	SetAxis left 0,(SelectedEpiNum-1)
End

Function MakePSTH()
//	NVAR EpisodeNum,WindowFrom,WindowTo
	NVAR SelectedEpiNum,RasterFrom,RasterTo
	NVAR BinSize
	SVAR NamePostfix
	variable mode
	String YLabel
	ControlInfo/W=FurtherAnalysisPanel check5//divide by trace num
	mode = V_Value
	ControlInfo/W=FurtherAnalysisPanel check18//divide by bin size
//	mode = V_Value | 2
	mode += V_Value *2
	if (mode == 3)
		YLabel = "Frequency (Hz)"
	elseif (mode == 2)
//		YLabel = "Event number/bin"
		YLabel = "Frequency summation (Hz)"
	elseif (mode == 1)
		YLabel = "Event number/trace"
	else
		YLabel = "Event number"
	endif
	//print "mode "+ num2str(mode)	////
	//print SelectedEpiNum	////
	variable BinNum = ceil((RasterTo - RasterFrom)/ BinSize)
	Make/N=(BinNum)/O $("W_PSTH"+NamePostfix)
	wave W_PSTH = $("W_PSTH"+NamePostfix)
	ControlInfo/W=FurtherAnalysisPanel check28
	if (V_value)
		Wave EventTime = $("ExBaseTime"+NamePostfix)
	else
		Wave EventTime = $("ExEventTime"+NamePostfix)
	endif
	Histogram/B={RasterFrom,BinSize,BinNum} EventTime,W_PSTH
	if (mode & 1) 
		W_PSTH /= SelectedEpiNum
	endif
	if (mode & 2)
		W_PSTH /= BinSize/1000
	endif
	
	Display/W=(10,230,300,230+160)  W_PSTH
	ModifyGraph mode=5
	ModifyGraph marker=10
	ModifyGraph rgb=(0,0,0)
	ModifyGraph msize=1
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	Label left YLabel
	Label bottom "Time (ms)"
	SetAxis/A/E=1 left
	SetAxis bottom RasterFrom,RasterTo
	
	//add 090713
	ControlInfo/W=FurtherAnalysisPanel check30
	if (V_value)
		NVAR CumBaseFrom, CumBaseTo, CumMeasFrom, CumMeasTo
		variable basemean,basesd,W_max
		variable eventbinnum = (CumMeasTo-CumMeasFrom)/BinSize
		variable basebinnum = (CumBaseTo-CumBaseFrom)/BinSize
		variable ThreProb = 0.95^(1/eventbinnum)/2+0.5
		variable ThreZ = StatsInvNormalCDF(ThreProb, 0, 1)
		if (basebinnum < 2)
			abort "Error: Base period bin number < 2"
		endif
		WaveStats/Q/R=(CumBaseFrom, CumBaseTo-BinSize) W_PSTH
		basemean = V_avg
		basesd = V_sdev		
		duplicate/o W_PSTH, $("W_PSTH_0sd"+NamePostfix)
		duplicate/o W_PSTH, $("W_PSTH_3sd"+NamePostfix)
		duplicate/o W_PSTH, $("W_PSTH_Thre"+NamePostfix)
		wave W_0sd = $("W_PSTH_0sd"+NamePostfix)
		wave W_3sd = $("W_PSTH_3sd"+NamePostfix)
		wave W_Thre = $("W_PSTH_Thre"+NamePostfix)
		W_0sd = basemean
		W_3sd = basemean + basesd *3
		W_Thre = basemean + basesd *ThreZ
		WaveStats/Q/R=(CumMeasFrom, CumMeasTo-BinSize) W_PSTH
		W_max = V_max
		AppendToGraph W_0sd,W_3sd,W_Thre
		ModifyGraph lStyle[1]=2, lStyle[2]=2,lStyle[3]=2
		ModifyGraph rgb[1]=(0,0,0),rgb[2]=(0,0,65280),rgb[3]=(65280,0,0)
		print "PSTH info <"+ NamePostfix +">;  black dotted line, Mean; blue, 3SD; red, Threshold for P<.05"
		print "  Baseline",CumBaseFrom,"-",CumBaseTo, " ;", basebinnum, "bins"
		print "  Event win",CumMeasFrom, "-",CumMeasTo, " ;", eventbinnum, "bins"
		print "  Mean", basemean, "  ;SD",basesd
		variable Zval =(W_max - basemean)/basesd
		variable prob = 2*(1-StatsNormalCDF(Zval,0,1))
		variable totalprob = 1-(1-prob)^eventbinnum
		printf "  Peak value: %g   ; Z = %.2W1P\r"W_max, Zval
		print "  Threshold Z (for P<.05) = ", ThreZ
		printf "  Total P value (for %g bins) = %g\r" eventbinnum, totalprob
		
		// find onset time
//		Make/N=(BinNum)/O $("W_PSTH1ms"+NamePostfix)
//		wave W_PSTH1ms = $("W_PSTH1ms"+NamePostfix)
//		variable BinNum1ms = round(RasterTo - RasterFrom)
//		Histogram/B={RasterFrom,1,BinNum1ms} EventTime,W_PSTH1ms//fix 1ms
//		W_PSTH1ms /= SelectedEpiNum
//		duplicate/O W_PSTH1ms, W_PSTHpost,W_PSTHpre,W_PSTHdif
//		W_PSTHpost = sum(W_PSTH1ms,x,x+BinSize-1)
//		W_PSTHpre = W_PSTHpost(x-BinSize)
//		W_PSTHdif = W_PSTHpost - W_PSTHpre
//		appendtograph W_PSTHpost,W_PSTHpre, W_PSTHdif
		//killwaves/z W_PSTHpost,W_PSTHpre
		 
	endif
	//end add
	
End

Function MakeAmplitudeTrend()
	NVAR SelectedEpiNum,RasterFrom,RasterTo
	NVAR BinSize
	SVAR NamePostfix
	variable BinNum = ceil((RasterTo - RasterFrom)/ BinSize)
	Make/N=(BinNum)/O $("AmpTrend"+NamePostfix)
	Make/N=(BinNum)/O $("AmpTrendMark"+NamePostfix)
	wave Trend = $("AmpTrend"+NamePostfix)
	wave W_PSTHM = $("AmpTrendMark"+NamePostfix)
	ControlInfo/W=FurtherAnalysisPanel check28
	if (V_value)
		Duplicate/O $("ExBaseTime"+NamePostfix), $("ExEventTimeS"+NamePostfix)
	else
		Duplicate/O $("ExEventTime"+NamePostfix), $("ExEventTimeS"+NamePostfix)
	endif
	Duplicate/O $("ExEventAmp"+NamePostfix), $("ExEventAmpS"+NamePostfix)
	wave EventTime = $("ExEventTimeS"+NamePostfix)
	wave EventAmp = $("ExEventAmpS"+NamePostfix)

	Histogram/B={RasterFrom,BinSize,BinNum} EventTime,W_PSTHM
	W_PSTHM /= SelectedEpiNum
		
	Sort EventTime, EventTime, EventAmp
	variable p1,p2
	variable i = 0
	do
		p1 = BinarySearch(EventTime, RasterFrom + i*BinSize)+1
		p2 = BinarySearch(EventTime, RasterFrom + (i+1)*BinSize)
		if (p2 == -2)
			p2 = numpnts(EventTime)-1
		endif
		
		if ((p1 == -1) || (p1 > p2))
			Trend[i] = 0
		else
			WaveStats/Q/M=1/R=[p1,p2]/Z EventAmp
			Trend[i] = V_avg
		endif
//		print p1,p2,V_avg
		i += 1
	while (i < BinNum)
	SetScale/P x (RasterFrom+BinSize/2),BinSize,"", Trend
	Display/W=(10,420,300,420+160)  Trend
	ModifyGraph mode=8,marker=8
	ModifyGraph lSize=0.5
	ModifyGraph rgb=(0,0,0)
	ModifyGraph zmrkSize={W_PSTHM,0,*,1,6}
	Label bottom "Time (ms)"
	SetAxis bottom RasterFrom,RasterTo
	SetAxis/A/E=1 left
	Label left "Amplitude "
	killwaves/Z EventTime,EventAmp

End

Function MakeAmplitudePlot()
	SVAR NamePostfix
	Wave Amplitude = $("ExEventAmp"+NamePostfix)
	ControlInfo/W=FurtherAnalysisPanel check28
	if (V_value)
		Wave EventTime = $("ExBaseTime"+NamePostfix)
	else
		Wave EventTime = $("ExEventTime"+NamePostfix)
	endif
	
	Display /W=(10,130,300,130+160) Amplitude vs EventTime
	
	Label left "Amplitude ( )"
	Label bottom "Time (ms)"
	NVAR RasterFrom,RasterTo
	SetAxis bottom RasterFrom,RasterTo
	SetAxis left 0,*
	ModifyGraph mode=3,marker=8,rgb=(0,0,0)
End


Function MakeEventAreaTrend()
	NVAR SelectedEpiNum,RasterFrom,RasterTo
	NVAR BinSize
	SVAR NamePostfix
	wave ExArea = $("ExArea"+NamePostfix)
	ControlInfo/W=FurtherAnalysisPanel check28
	if (V_value)
		Wave ExEventTime = $("ExBaseTime"+NamePostfix)
	else
		Wave ExEventTime = $("ExEventTime"+NamePostfix)
	endif

	if (numtype(ExArea[0]))
		abort "Area information was not found."
	endif
	variable BinNum = ceil((RasterTo - RasterFrom)/ BinSize)
	Duplicate/O ExEventTime, $("ExEventTimeS"+NamePostfix)
	Duplicate/O ExArea, $("ExAreaS"+NamePostfix)
	wave EventTime = $("ExEventTimeS"+NamePostfix)
	wave EventArea = $("ExAreaS"+NamePostfix)
	variable eventnum = numpnts(EventTime)
	Make/O/N=(eventnum) BinNumWave, CountWave
	Sort EventTime, EventTime, EventArea
	BinNumWave = floor((EventTime-RasterFrom)/BinSize)
	variable i = 0
	variable k = 0
	do
		if ((i == 0)||!(BinNumWave[i] == BinNumWave[i-1]))
			k = 0
			CountWave[i] = 0
		else
			k += 1
			CountWave[i] = k
		endif
		i += 1
	while (i < eventnum)
	WaveStats/Q/M=1 CountWave
	variable maxnum = V_max+1
	
	Make/O/N= (maxnum, BinNum) $("AreaTrendMx"+NamePostfix)
	Wave Mx = $("AreaTrendMx"+NamePostfix)
	Mx =nan
	//Make/O/N= (maxnum, BinNum) TimeCheckMx = nan//temporal
	
	Make/N=(BinNum)/O $("AreaTrend"+NamePostfix)
	wave AreaTrend = $("AreaTrend"+NamePostfix)
	
	i = 0
	do
		Mx[CountWave[i]][BinNumWave[i]] = EventArea[i]
		//TimeCheckMx[CountWave[i]][BinNumWave[i]] = EventTime[i]//temporal
		i += 1
	while (i < eventnum)

	i = 0
	do
		Duplicate/O/R=[][i] Mx WorkingWave
		WaveStats/Q/M=1 WorkingWave
		AreaTrend[i] = V_sum
		i += 1
	while (i < BinNum)
	AreaTrend /= SelectedEpiNum
	SetScale/P x RasterFrom,BinSize,"", AreaTrend
	Display/W=(10,320,300,320+160)  AreaTrend	
	ModifyGraph mode=5
	ModifyGraph marker=10
	ModifyGraph rgb=(0,0,0)
	ModifyGraph msize=1
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	Label left "Area/Trace (YUnit*ms)"
	Label bottom "Time (ms)"
	SetAxis/A/E=1 left
	SetAxis bottom RasterFrom,RasterTo

	killwaves/Z EventTime,EventArea,BinNumWave, CountWave,WorkingWave
//	Edit BinNumWave, CountWave
//	Edit EventTime,EventArea
//	Edit Mx
//	Edit TimeCheckMx
	
End

Function MakeEventAreaPlot()
	SVAR NamePostfix
	Wave ExArea = $("ExArea"+NamePostfix)
	ControlInfo/W=FurtherAnalysisPanel check28
	if (V_value)
		Wave EventTime = $("ExBaseTime"+NamePostfix)
	else
		Wave EventTime = $("ExEventTime"+NamePostfix)
	endif
	
	Display /W=(10,510,300,510+160) ExArea vs EventTime
	
	Label left "Area (YUnit*ms)"
	Label bottom "Time (ms)"
	NVAR RasterFrom,RasterTo
	SetAxis bottom RasterFrom,RasterTo
	SetAxis left 0,*
	ModifyGraph mode=3,marker=8,rgb=(0,0,0)
End

Function MakeCumulativeAmpPlot()
	NVAR SelectedEpiNum,RasterFrom,RasterTo
	NVAR BinSize
	SVAR NamePostfix
	ControlInfo/W=FurtherAnalysisPanel check28
	if (V_value)
		Wave ExEventTime = $("ExBaseTime"+NamePostfix)
	else
		Wave ExEventTime = $("ExEventTime"+NamePostfix)
	endif

	Wave ExAmplitude = $("ExEventAmp"+NamePostfix)

	variable BinNum = ceil((RasterTo - RasterFrom)/ BinSize)
	Duplicate/O ExEventTime, $("ExEventTimeS"+NamePostfix)
	Duplicate/O ExAmplitude, $("ExAmpS"+NamePostfix)
	wave EventTime = $("ExEventTimeS"+NamePostfix)
	wave Amplitude = $("ExAmpS"+NamePostfix)
	variable eventnum = numpnts(EventTime)
	Make/O/N=(eventnum) BinNumWave, CountWave
	Sort EventTime, EventTime, Amplitude
	BinNumWave = floor((EventTime-RasterFrom)/BinSize)
	variable i = 0
	variable k = 0
	do
		if ((i == 0)||!(BinNumWave[i] == BinNumWave[i-1]))
			k = 0
			CountWave[i] = 0
		else
			k += 1
			CountWave[i] = k
		endif
		i += 1
	while (i < eventnum)
	WaveStats/Q/M=1 CountWave
	variable maxnum = V_max+1
	
	Make/O/N= (maxnum, BinNum) $("AmpTrendMx"+NamePostfix)
	Wave Mx = $("AmpTrendMx"+NamePostfix)
	Mx =nan
	
	Make/N=(BinNum)/O $("CumulAmpTrend"+NamePostfix)
	wave CumulAmpTrend = $("CumulAmpTrend"+NamePostfix)
	
	i = 0
	do
		Mx[CountWave[i]][BinNumWave[i]] = Amplitude[i]
		i += 1
	while (i < eventnum)

	i = 0
	do
		Duplicate/O/R=[][i] Mx WorkingWave
		WaveStats/Q/M=1 WorkingWave
		CumulAmpTrend[i] = V_sum
		i += 1
	while (i < BinNum)
	CumulAmpTrend /= SelectedEpiNum
	SetScale/P x RasterFrom,BinSize,"", CumulAmpTrend
	Display/W=(10,450,300,450+160)  CumulAmpTrend	
	ModifyGraph mode=5
	ModifyGraph marker=10
	ModifyGraph rgb=(0,0,0)
	ModifyGraph msize=1
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	Label left "Cumulative amplitude/Trace"
	Label bottom "Time (ms)"
	SetAxis/A/E=1 left
	SetAxis bottom RasterFrom,RasterTo

	killwaves/Z EventTime,Amplitude,BinNumWave, CountWave,WorkingWave
End

Function MakeCumulativePSTH()
	NVAR SelectedEpiNum,RasterFrom,RasterTo
	NVAR CumBaseFrom, CumBaseTo, CumMeasFrom, CumMeasTo
	Variable BinSize//local
	BinSize =1//(ms) fixed
	SVAR NamePostfix
	variable mode
	String YLabel
//	ControlInfo/W=FurtherAnalysisPanel check5//divide by trace num
//	mode = V_Value
//	ControlInfo/W=FurtherAnalysisPanel check18//divide by bin size
//	mode += V_Value *2

	mode = 1 //fixed
	if (mode == 3)
		YLabel = "Frequency (Hz)"
	elseif (mode == 2)
		YLabel = "Frequency summation (Hz)"
	elseif (mode == 1)
		YLabel = "Cumulative event number/trace"
	else
		YLabel = "Cumulative event number"
	endif

	//print "mode "+ num2str(mode)	////
	//print SelectedEpiNum	////
	variable BinNum = ceil((RasterTo - RasterFrom)/ BinSize)
	Make/N=(BinNum)/O $("W_CumPSTH"+NamePostfix),$("fit_CumPSTH"+NamePostfix),$("sub_CumPSTH"+NamePostfix)
	wave W_CumPSTH = $("W_CumPSTH"+NamePostfix)
	wave fit_CumPSTH = $("fit_CumPSTH"+NamePostfix)
	wave sub_CumPSTH = $("sub_CumPSTH"+NamePostfix)
	
	ControlInfo/W=FurtherAnalysisPanel check28
	if (V_value)
		Wave EventTime = $("ExBaseTime"+NamePostfix)
	else
		Wave EventTime = $("ExEventTime"+NamePostfix)
	endif
	Histogram/CUM/B={RasterFrom,BinSize,BinNum} EventTime,W_CumPSTH
	if (mode & 1) 
		W_CumPSTH /= SelectedEpiNum
	endif
	if (mode & 2)
		W_CumPSTH /= BinSize/1000
	endif
	
	//CurveFit/Q/N/
//	k0=0
//	CurveFit/H="10"/X=1/N/NTHR=0/Q line W_CumPSTH(CumBaseFrom,CumBaseTo)
//	fit_CumPSTH = k0+k1*x
	variable cumslope
	variable fx1,fy1,fx2,fy2
	fx2 = CumBaseTo-BinSize
	fy2 = W_CumPSTH(CumBaseTo-BinSize)
	fx1 = CumBaseFrom
	fy1 = W_CumPSTH(CumBaseFrom)
	cumslope = (fy2 - fy1)/(fx2 - fx1)
	fit_CumPSTH = cumslope*(x - fx1) + fy1
	sub_CumPSTH = W_CumPSTH - fit_CumPSTH
	variable sub_value
	//sub_value =mean(sub_CumPSTH, CumMeasFrom, CumMeasTo)
	sub_value =sub_CumPSTH(CumMeasTo-BinSize) - sub_CumPSTH(CumMeasFrom-BinSize)
	print "Event number from cumulative PSTH of "+NamePostfix
	print "Baseline from "+num2str(CumBaseFrom)+" to " +num2str(CumBaseTo)
	print "Measure from "+ num2str(CumMeasFrom) + " to "+num2str(CumMeasTo)
	print sub_value
	
	// find onset and end //
	Duplicate/O/R=(CumMeasFrom-BinSize, CumMeasFrom+BinSize) sub_CumPSTH $("mFrom_CumPSTH"+NamePostfix)
	Duplicate/O/R=(CumMeasTo-BinSize, CumMeasTo+BinSize) sub_CumPSTH $("mTo_CumPSTH"+NamePostfix)
	wave mFrom_CumPSTH = $("mFrom_CumPSTH"+NamePostfix)
	wave mTo_CumPSTH = $("mTo_CumPSTH"+NamePostfix)

	Duplicate/O sub_CumPSTH, $("subDif1_CumPSTH"+NamePostfix),$("subDif2_CumPSTH"+NamePostfix)
	wave dif1 = $("subDif1_CumPSTH"+NamePostfix)
	wave dif2 = $("subDif2_CumPSTH"+NamePostfix)
	Smooth 25, dif1
	Differentiate dif1
	dif2 = dif1
	Smooth 25, dif2
	Differentiate dif2

	variable judge_line_x
	variable max_x, max_y
	WaveStats/Q/M=1/R=(CumMeasFrom, CumMeasTo) sub_CumPSTH
	max_x = V_maxloc
	max_y = V_max
	variable end_cum = 0.25//fixed
	if (max_x<end_cum) 
		judge_line_x = max_y
	else
		FindLevel/Q/R=(CumMeasFrom, CumMeasTo) sub_CumPSTH,end_cum
		judge_line_x = V_LevelX
	endif
	
	variable p1 =x2pnt(dif1, CumMeasFrom)
	variable p2 =x2pnt(dif1, judge_line_x)	
	dif1[ ,p1] =Nan
	dif1[p2,]=Nan
	dif2[ ,p1] =Nan
	dif2[p2,]=Nan
	WaveStats/Q/M=1 dif2
	variable onsettime = V_maxloc - BinSize
	print "Onset time (ms): ",onsettime
	print "End time (ms): ",max_x
	Make/O/N=2 $("OnsetMark"+NamePostfix) = 0
	wave OnsetMark = $("OnsetMark"+NamePostfix)
	SetScale/I x onsettime,max_x,"", OnsetMark
	OnsetMark[1] = max_y
	
	Display/W=(10,220,300,220+160)  W_CumPSTH, fit_CumPSTH, sub_CumPSTH, mFrom_CumPSTH, mTo_CumPSTH, OnsetMark
	ModifyGraph lStyle[1]=2
	ModifyGraph rgb[0]=(47872,47872,47872), rgb[1]=(47872,47872,47872),  rgb[2]=(0,0,0)
	ModifyGraph lSize[0]=0.5,lSize[1]=0.5, lSize[2]=0.5, lSize[3]=2, lSize[4]=2
	ModifyGraph mode[5]=3,marker[5]=10
	ModifyGraph msize[5]=5
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	ModifyGraph zero(left)=3
	ModifyGraph zeroThick(left)=0.5
	Label left YLabel
	Label bottom "Time (ms)"
	SetAxis/A left
	SetAxis bottom RasterFrom,RasterTo	
End

Function MakeInstantFreqTrend()
	NVAR SelectedEpiNum,RasterFrom,RasterTo
	NVAR BinSize
	SVAR NamePostfix
	ControlInfo/W=FurtherAnalysisPanel check28
	if (V_value)
		Wave EventTime = $("ExBaseTime"+NamePostfix)
	else
		Wave EventTime = $("ExEventTime"+NamePostfix)
	endif

//	Wave ExAmplitude = $("ExEventAmp"+NamePostfix)
	Wave Episode = $("ExEpisode"+NamePostfix)
	make/O/N=0 $("InstInterval"+NamePostfix),$("InstTime"+NamePostfix)
	wave InstInterval = $("InstInterval"+NamePostfix)
	wave InstTime = $("InstTime"+NamePostfix)
	variable eventnum = numpnts(EventTime)
	if (eventnum < 2)
		abort
	endif
	variable interval
	variable i = 0, k = 0
	for(i = 0; i < eventnum-1; i+=1)
		if (Episode[i+1] == Episode[i])
			InsertPoints k,1, InstInterval
			InsertPoints k,1, InstTime
			interval = EventTime[i+1] - EventTime[i]
			InstInterval[k] = interval
			InstTime[k] = EventTime[i]///Time of 1st event of a pair
			//InstTime[k] = EventTime[i+1]///Time of 2st event of a pair
			k +=1
		endif
	endfor
	duplicate/O InstInterval, $("InstFreq"+NamePostfix)
	wave InstFreq = $("InstFreq"+NamePostfix)
	InstFreq = 1000/InstFreq

	variable BinNum = ceil((RasterTo - RasterFrom)/ BinSize)
	Make/O/N=(BinNum) $("InstIntTrendAve"+NamePostfix),$("InstIntTrendSem"+NamePostfix)
	Make/O/N=(BinNum) $("InstFreqTrendAve"+NamePostfix),$("InstFreqTrendSem"+NamePostfix)
	wave InstIntTrendAve = $("InstIntTrendAve"+NamePostfix)
	wave InstIntTrendSem = $("InstIntTrendSem"+NamePostfix)
	wave InstFreqTrendAve = $("InstFreqTrendAve"+NamePostfix)
	wave InstFreqTrendSem = $("InstFreqTrendSem"+NamePostfix)
	
	Sort InstTime, InstTime, InstInterval, InstFreq
	variable p1,p2
	i = 0
	do
		p1 = BinarySearch(InstTime, RasterFrom + i*BinSize)+1
		p2 = BinarySearch(InstTime, RasterFrom + (i+1)*BinSize)
		if (p2 == -2)
			p2 = numpnts(InstTime)-1
		endif
		
		if ((p1 == -1) || (p1 > p2))
			InstIntTrendAve[i] = NaN
			InstFreqTrendAve[i] = NaN
			InstIntTrendSem[i] = NaN
			InstFreqTrendSem[i] = NaN
		else
			WaveStats/Q/R=[p1,p2]/Z InstInterval
			InstIntTrendAve[i] = V_avg
			InstIntTrendSem[i] = V_sdev/sqrt(V_npnts)
			WaveStats/Q/R=[p1,p2]/Z InstFreq
			InstFreqTrendAve[i] = V_avg
			InstFreqTrendSem[i] = V_sdev/sqrt(V_npnts)
		endif
		//print p1,p2, V_avg,V_sdev,V_npnts
		i += 1
	while (i < BinNum)
	SetScale/P x (RasterFrom+BinSize/2),BinSize,"", InstIntTrendAve,InstIntTrendSem,InstFreqTrendAve,InstFreqTrendSem
	Display/W=(10,420,300,420+160)  InstFreqTrendAve
	ModifyGraph mode=3,marker=19
	ErrorBars $("InstFreqTrendAve"+NamePostfix) Y,wave=(InstFreqTrendSem,InstFreqTrendSem)	
	ModifyGraph rgb=(0,0,0)
	Label bottom "Time (ms)"
	SetAxis bottom RasterFrom,RasterTo
	SetAxis/A/E=1 left
	Label left "Instant.Freq (Hz) "

	Display/W=(40,420,330,420+160)  InstIntTrendAve
	ModifyGraph mode=3,marker=19
	ErrorBars $("InstIntTrendAve"+NamePostfix) Y,wave=(InstIntTrendSem,InstIntTrendSem)	
	ModifyGraph rgb=(0,0,0)
	Label bottom "Time (ms)"
	SetAxis bottom RasterFrom,RasterTo
	SetAxis/A/E=1 left
	Label left "Instant.Interval (ms) "
	killwaves/Z  InstTime, InstInterval, InstFreq

End

Function CalculateWavesAndMakeList()//////////////////////////////////////////////////////////////////////////////////
	SVAR NamePostfix
	NVAR Tmin, Tmax
	NVAR AutoListFlag, ListLength
	variable EventNumInTable
	NVAR TotalEpisodeNum = SelectedEpiNum
	NVAR MakeSummaryList
	NVAR BurstLimit
	variable BurstLimitFlag, EpisodeInCheck
	variable BurstMode//0 before burst, 1 during burst, 2 after burst
	NVAR DAMM = DecayAnalysisModeMax//0 not fitting, 1 single exp , 2 double exp, 3 both
	variable i 
	//print DAMM
	
	ControlInfo /W=FurtherAnalysisPanel check19
	if (V_Value)
		BurstLimitFlag = 1
	else
		BurstLimitFlag = 0
	endif
	
	ControlInfo/W=FurtherAnalysisPanel check28
	if (V_value)
		Duplicate/O $("ExBaseTime"+NamePostfix), LatencyWave
	else
		Duplicate/O $("ExEventTime"+NamePostfix), LatencyWave
	endif
	
	Duplicate/O $("ExEpisode"+NamePostfix), EpisodeWave
	//Duplicate/O $("ExEventTime"+NamePostfix), LatencyWave
	Duplicate/O $("ExEventAmp"+NamePostfix), AmpWave
	Duplicate/O $("ExRise2080"+NamePostfix), RiseWave
	Duplicate/O $("ExRise1090"+NamePostfix), Rise2Wave	
	Duplicate/O $("ExEventNumRef"+NamePostfix), EventNumRefWave
	
	variable TotalEventNum = numpnts(EpisodeWave)

	if (DAMM & 1)
		Duplicate/O $("ExTau"+NamePostfix), TauWave
	else 
		Make/O/N=(TotalEventNum) TauWave=Nan
	endif
	if (DAMM & 2)
		Duplicate/O $("ExTau1"+NamePostfix), Tau1Wave
		Duplicate/O $("ExTau2"+NamePostfix), Tau2Wave
		Duplicate/O $("ExTauM"+NamePostfix), TauMWave
	else
		Make/O/N=(TotalEventNum) Tau1Wave = Nan
		Make/O/N=(TotalEventNum) Tau2Wave = Nan
		Make/O/N=(TotalEventNum) TauMWave = Nan
	endif
	Duplicate/O $("ExHalfWidth"+NamePostfix), HalfWWave	
	
	i = 0 
	do
		if ((LatencyWave[i]<Tmin)||(LatencyWave[i]>Tmax))
			LatencyWave[i] = NaN
			EpisodeWave[i] = NaN
			AmpWave[i] = NaN
			RiseWave[i] = NaN
			Rise2Wave[i] = NaN
			EventNumRefWave[i] = NaN
			TauWave[i] = Nan
			Tau1Wave[i]= Nan
			Tau2Wave[i]= Nan
			TauMWave[i]= Nan			
			HalfWWave[i]= Nan			
		endif		
		i += 1
	while (i< TotalEventNum)
	Sort {EpisodeWave,LatencyWave} EpisodeWave,LatencyWave,AmpWave,RiseWave,Rise2Wave,EventNumRefWave,TauWave,Tau1Wave,Tau2Wave,TauMWave,HalfWWave
	WaveStats/Q/M=1 EpisodeWave
	DeletePoints V_npnts,V_numNaNs, EpisodeWave,LatencyWave,AmpWave,RiseWave,Rise2Wave,EventNumRefWave,TauWave,Tau1Wave,Tau2Wave,TauMWave,HalfWWave
	
	if (BurstLimitFlag)// check burst
		TotalEventNum = numpnts(EpisodeWave)
		Make/O/N=(TotalEventNum) BurstWave=0
		Make/O/N=(TotalEventNum) BurstModeWave=0
		i = 0 
		do
			if ((EpisodeWave[i] == EpisodeWave[i+1]) && (LatencyWave[i+1] - LatencyWave[i] <=  BurstLimit))
				BurstWave[i] = 1
			endif
			i += 1
		while (i< TotalEventNum-1)
		
		i = 0 
		do		
			if ((EpisodeWave[i] > EpisodeInCheck) || (i == 0))
				BurstMode = 0
				EpisodeInCheck = EpisodeWave[i]
			endif
			if ((BurstMode == 0) && (BurstWave[i] == 1))
				BurstMode =1
			elseif ((BurstMode == 1) && (BurstWave[i] == 0))
				BurstMode = 2
			endif
			if (BurstMode == 2)
				BurstWave[i] = 0
			endif
			BurstModeWave[i] = BurstMode
			i += 1
		while (i< TotalEventNum-1)
		
		i = TotalEventNum-2
		do
			if ((EpisodeWave[i] == EpisodeWave[i+1]) && (BurstWave[i] ==1))
				BurstWave[i+1] = 1
			endif
			i -= 1
		while (i > -1)

		i = 0
		do
		if (BurstWave[i] == 0)	
			LatencyWave [i] = NaN
			EpisodeWave [i] = NaN
			AmpWave [i] = NaN
			RiseWave [i] = NaN
			Rise2Wave [i] = NaN
			EventNumRefWave[i] = NaN
			TauWave[i] = Nan
			Tau1Wave[i]= Nan
			Tau2Wave[i]= Nan
			TauMWave[i]= Nan	
			HalfWWave[i]= Nan			
		endif
		i += 1
		while (i< TotalEventNum)
		Sort {EpisodeWave,LatencyWave} EpisodeWave,LatencyWave,AmpWave,RiseWave,Rise2Wave,EventNumRefWave,TauWave,Tau1Wave,Tau2Wave,TauMWave,HalfWWave	
		WaveStats/Q/M=1 EpisodeWave
		DeletePoints V_npnts,V_numNaNs, EpisodeWave,LatencyWave,AmpWave,RiseWave,Rise2Wave,EventNumRefWave,TauWave,Tau1Wave,Tau2Wave,TauMWave,HalfWWave
		KillWaves/Z BurstWave, BurstModeWave// BurstModeWave can be removed.
	endif // end of (BurstLimitFlag)
	
	//
	TotalEventNum = numpnts( EpisodeWave)
	Duplicate/O EpisodeWave, EventCountWave
	variable k=1
	EventCountWave[0] = 1
	i = 1
	do
		if (EpisodeWave[i] == EpisodeWave[i-1])
			k +=1
			EventCountWave[i] = k
		else
			k = 1
			EventCountWave[i] = 1
		endif
		i += 1
	while (i< TotalEventNum)
	
	// make a 2D waves
	Wavestats/Q/M=1 EventCountWave
	variable MaxEN = V_max
	Make/O/N=(MaxEN, TotalEpisodeNum) LatencyMx = NaN
	Make/O/N=(MaxEN, TotalEpisodeNum) AmpMx = NaN
	Make/O/N=(MaxEN, TotalEpisodeNum) RiseMx = NaN
	Make/O/N=(MaxEN, TotalEpisodeNum) Rise2Mx = NaN
	Make/O/N=(MaxEN, TotalEpisodeNum) EventNumRefMx = NaN
	Make/O/N=(MaxEN, TotalEpisodeNum) TauMx = NaN
	Make/O/N=(MaxEN, TotalEpisodeNum) Tau1Mx = NaN
	Make/O/N=(MaxEN, TotalEpisodeNum) Tau2Mx = NaN
	Make/O/N=(MaxEN, TotalEpisodeNum) TauMMx = NaN
	Make/O/N=(MaxEN, TotalEpisodeNum) HalfWMx = NaN
	
	Make /O/N=(MaxEN-1,TotalEpisodeNum) IntervalMx=NaN
	Make /O/N=(MaxEN-1,TotalEpisodeNum) RatioMx=NaN
	Make /O/N=(MaxEN-1,TotalEpisodeNum) IERMx=NaN
	Make /O/N=(MaxEN-1,TotalEpisodeNum) FreqMx=NaN
		
	variable Lraw, Lcol
	
	i = 0
	do
		Lraw = EventCountWave[i] - 1
		Lcol = EpisodeWave[i]
		LatencyMx[Lraw][Lcol] = LatencyWave[i]
		AmpMx[Lraw][Lcol] = AmpWave[i]
		RiseMx[Lraw][Lcol] = RiseWave[i]
		Rise2Mx[Lraw][Lcol] = Rise2Wave[i]
		EventNumRefMx[Lraw][Lcol] = EventNumRefWave[i]
		TauMx[Lraw][Lcol] = TauWave[i]
		Tau1Mx[Lraw][Lcol] = Tau1Wave[i]
		Tau2Mx[Lraw][Lcol] = Tau2Wave[i]
		TauMMx[Lraw][Lcol] = TauMWave[i]	
		HalfWMx[Lraw][Lcol] = HalfWWave[i]	
		if (Lraw > 0)
			IntervalMx[Lraw-1][Lcol] = LatencyMx[Lraw][Lcol] - LatencyMx[Lraw-1][Lcol]
			RatioMx[Lraw-1][Lcol] = AmpMx[Lraw][Lcol] / AmpMx[0][Lcol]
			IERMx[Lraw-1][Lcol] = AmpMx[Lraw][Lcol] / AmpMx[Lraw-1][Lcol]
		endif
		i += 1
	while (i< TotalEventNum)
	FreqMx = 1/ IntervalMx
	FreqMx *= 1000 // for ms scale traces
		
	//make some result waves ("zz" waves) from 2D waves
	Make/O/N=(TotalEpisodeNum) EventNumberOfEpisode=NaN
	Make/O/N=(TotalEpisodeNum) MinInterval=NaN
	Make/O/N=(TotalEpisodeNum) MeanInterval=NaN
	Make/O/N=(TotalEpisodeNum) MaxFreq=NaN
	Make/O/N=(TotalEpisodeNum) MeanFreq=NaN	
	Make/O/N=(TotalEpisodeNum) DurationTime=NaN	
	Make/O/N=(TotalEpisodeNum) DurationFreq=NaN	
	Make/O/N=(TotalEpisodeNum) MeanLatency=NaN	
	
	Make/O/N=(MaxEN) CopiedWave=NaN
	i =0
	do
		CopiedWave = LatencyMx[p][i]
		WaveStats/Q/M=1 CopiedWave
		EventNumberOfEpisode[i] = V_npnts
		DurationTime[i] = V_max - V_min
		MeanLatency[i] = V_avg
		if (V_npnts > 1)
			DurationFreq[i] = 1000*(V_npnts - 1)/(V_max - V_min)
		endif
		
		CopiedWave=NaN
		CopiedWave = IntervalMx[p][i]
		WaveStats/Q/M=1 CopiedWave
		MinInterval[i] = V_min
		MeanInterval[i] = V_avg
		
		CopiedWave=NaN
		CopiedWave = FreqMx[p][i]
		WaveStats/Q/M=1 CopiedWave
		MaxFreq[i] = V_max
		MeanFreq[i] = V_avg
		
		i +=1
	while (i< TotalEpisodeNum)
	
	//Make interval, Freq, Ratio 1D waves (Mx -> wave)
	Duplicate/O IntervalMx, IntervalWave, intervalEpisodeWave,intervalEventCountWave
	Duplicate/O FreqMx, FreqWave
	Duplicate/O RatioMx, RatioWave
	Duplicate/O IERMx, IERWave
	intervalEpisodeWave = q+1
	intervalEventCountWave = p+1
	variable newN = DimSize(intervalEpisodeWave,0)*DimSize(intervalEpisodeWave,1)
	Redimension/n=(newN) intervalEpisodeWave,IntervalWave,RatioWave,intervalEventCountWave, FreqWave,IERWave
	i = 0
	do
		if (numtype(IntervalWave[i]) == 2) //if NaN
			intervalEpisodeWave[i] = NaN
			intervalEventCountWave[i] = NaN
		endif
		i +=1
	while (i<newN)
	Sort {intervalEpisodeWave,intervalEventCountWave} intervalEpisodeWave,intervalEventCountWave,IntervalWave,RatioWave,FreqWave,IERWave
	if (numpnts(intervalEpisodeWave)> 0)
		WaveStats/Q/M=1 intervalEpisodeWave
		DeletePoints V_npnts,V_numNaNs,  intervalEpisodeWave,intervalEventCountWave,IntervalWave,RatioWave,FreqWave,IERWave
	endif
	
	////////////////////////////////////////make a summary wave
	if (AutoListFlag)
		EventNumInTable = DimSize(LatencyMx, 0)
		if (EventNumInTable<5)
			EventNumInTable = 5
		elseif (EventNumInTable>100)
			EventNumInTable = 100
		endif		
	else
		EventNumInTable = ListLength
	endif

	i = 29 + EventNumInTable*6/// --------- Length of Result waves
	//i = 31 + EventNumInTable*7
	if (DAMM) // if there is decay info
		i += 3+EventNumInTable
	endif
	//i +=1 // to add peak or onset time
	Variable MxSize
	String ResultLabelStr = "labels"+NamePostfix
	String ResultValueStr = "value"+NamePostfix
	String ResultSemStr ="sem"+NamePostfix
	String ResultNStr = "n"+NamePostfix
	Make/O/T/N=(i) $ResultLabelStr
	Make/O/N=(i) $ResultValueStr=NaN	
	Make/O/N=(i) $ResultSemStr=NaN
	Make/O/N=(i) $ResultNStr=NaN
	
	Wave/T ResultLabelWave = $ResultLabelStr
	Wave ResultValueWave =$ResultValueStr
	Wave ResultSemWave =$ResultSemStr
	Wave ResultNWave = $ResultNStr

	
	//header domain
	i = 0
	ResultLabelWave[i] = "Episode number"
	ResultValueWave[i] = TotalEpisodeNum
	i+=1
	ResultLabelWave[i] = "Time period from"
	ResultValueWave[i] = Tmin
	i+=1
	ControlInfo/W=FurtherAnalysisPanel check28
	if (V_value)
		ResultLabelWave[i] = "to (use onset time)"
	else
		ResultLabelWave[i] = "to (use peak time)"
	endif	
	ResultValueWave[i] = Tmax
	i+=1
	ResultLabelWave[i] = "Burst interval limit"
	if (BurstLimitFlag)
		ResultValueWave[i] = BurstLimit
	else
		ResultValueWave[i] = NaN
	endif 

	// event number domain
	WaveStats/Q EventNumberOfEpisode
	i+=1
	ResultLabelWave[i] = "Total event number"
	ResultValueWave[i] = V_Sum
	i+=1	
	ResultLabelWave[i] = "Event number per episode"
	ResultValueWave[i] =  V_avg
	ResultSemWave[i] = V_sdev/sqrt(V_npnts)
	ResultNWave[i] = V_npnts
	i+=1
	ResultLabelWave[i] = "Mean frequency"
	ResultValueWave[i] =  1000*V_avg/(Tmax-Tmin)
	i+=1	
	ResultLabelWave[i] = "Min event number"
	ResultValueWave[i] =  V_min
	i+=1	
	ResultLabelWave[i] = "Max event number"
	ResultValueWave[i] =  V_max

	// Burst duration domain
	WaveStats/Q DurationTime
	i+=1	
	ResultLabelWave[i] = "Mean time (1-last)"
	ResultValueWave[i] =  V_avg
	ResultSemWave[i] = V_sdev/sqrt(V_npnts)
	ResultNWave[i] = V_npnts
	i+=1	
	ResultLabelWave[i] = "Min time (1-last)"
	ResultValueWave[i] =  V_min
	i+=1	
	ResultLabelWave[i] = "Max time (1-last)"
	ResultValueWave[i] =  V_max

	WaveStats/Q DurationFreq
	i+=1	
	ResultLabelWave[i] = "Mean freq (1-last)"
	ResultValueWave[i] =  V_avg
	ResultSemWave[i] = V_sdev/sqrt(V_npnts)
	ResultNWave[i] = V_npnts
	i+=1	
	ResultLabelWave[i] = "Min freq (1-last)"
	ResultValueWave[i] =  V_min
	i+=1	
	ResultLabelWave[i] = "Max freq (1-last)"
	ResultValueWave[i] =  V_max

	// event time domain
	/////////////////////////////////////// added May 2009
	WaveStats/Q MeanLatency
	i+=1	
	ResultLabelWave[i] = "Mean event time"
	ResultValueWave[i] =  V_avg
	ResultSemWave[i] = V_sdev/sqrt(V_npnts)
	ResultNWave[i] = V_npnts
	/////////////////////////////////////// added May 2009 end
	
	Make/O/N=(TotalEpisodeNum) CopiedWave=0 // change length of CopiedWave
	ResultLabelWave[i+1] = "1st event time"
	ResultLabelWave[i+2] = "2nd event time"
	ResultLabelWave[i+3] = "3rd event time"
	k = 4
	do
		ResultLabelWave[i+k] = num2str(k) + "th event time"
		k += 1
	while (k <= EventNumInTable)
	
	MxSize = DimSize(LatencyMx, 0)
	k=0
	do
		i+=1	
		if (k < MxSize)
			CopiedWave = LatencyMx[k][p]
			WaveStats/Q CopiedWave			
			ResultValueWave[i] =  V_avg
			ResultSemWave[i] = V_sdev/sqrt(V_npnts)
			ResultNWave[i] = V_npnts
		else
			ResultNWave[i] = 0
		endif
		k +=1
	while (k < EventNumInTable)
	
	// interval domain
	if (numpnts(IntervalWave)>0)
		WaveStats/Q IntervalWave	
	else
		V_avg = nan
		V_sdev = nan
		V_npnts = 0
		V_min = nan
		V_max = nan
	endif
	i+=1	
	ResultLabelWave[i] = "All intervals"
	ResultValueWave[i] =  V_avg
	ResultSemWave[i] = V_sdev/sqrt(V_npnts)
	ResultNWave[i] = V_npnts
	i+=1	
	ResultLabelWave[i] = "Min of all intervals"
	ResultValueWave[i] =  V_min
	i+=1	
	ResultLabelWave[i] = "Max of all intervals"
	ResultValueWave[i] =  V_max
	
	WaveStats/Q MeanInterval
	i+=1
	ResultLabelWave[i] = "Mean interval per episode"
	ResultValueWave[i] =  V_avg
	ResultSemWave[i] = V_sdev/sqrt(V_npnts)
	ResultNWave[i] = V_npnts
	
	WaveStats/Q MinInterval
	i+=1
	ResultLabelWave[i] = "Min interval per episode"
	ResultValueWave[i] =  V_avg
	ResultSemWave[i] = V_sdev/sqrt(V_npnts)
	ResultNWave[i] = V_npnts
	
	ResultLabelWave[i+1] = "1st interval"
	ResultLabelWave[i+2] = "2nd interval"
	ResultLabelWave[i+3] = "3rd interval"
	k = 4
	do
		ResultLabelWave[i+k] = num2str(k) + "th interval"
		k += 1
	while (k <= EventNumInTable-1)

	MxSize = DimSize(IntervalMx, 0)
	k=0
	do
		i+=1	
		if (k < MxSize)
			CopiedWave = IntervalMx[k][p]
			WaveStats/Q CopiedWave			
			ResultValueWave[i] =  V_avg
			ResultSemWave[i] = V_sdev/sqrt(V_npnts)
			ResultNWave[i] = V_npnts
		else
			ResultNWave[i] = 0
		endif
		k +=1
	while (k < EventNumInTable-1)
	
	// frequency domain
	if (numpnts(FreqWave)>0)
		WaveStats/Q FreqWave	
	else
		V_avg = nan
		V_sdev = nan
		V_npnts = 0
		V_min = nan
		V_max = nan
	endif
		
	i+=1	
	ResultLabelWave[i] = "All instant. frequecies"
	ResultValueWave[i] =  V_avg
	ResultSemWave[i] = V_sdev/sqrt(V_npnts)
	ResultNWave[i] = V_npnts
	i+=1	
	ResultLabelWave[i] = "Min of all frequecies"
	ResultValueWave[i] =  V_min
	i+=1	
	ResultLabelWave[i] = "Max of all frequecies"
	ResultValueWave[i] =  V_max
	
	WaveStats/Q MeanFreq
	i+=1
	ResultLabelWave[i] = "Mean freq per episode"
	ResultValueWave[i] =  V_avg
	ResultSemWave[i] = V_sdev/sqrt(V_npnts)
	ResultNWave[i] = V_npnts
	
	WaveStats/Q MaxFreq
	i+=1
	ResultLabelWave[i] = "Max freq per episode"
	ResultValueWave[i] =  V_avg
	ResultSemWave[i] = V_sdev/sqrt(V_npnts)
	ResultNWave[i] = V_npnts
	
	ResultLabelWave[i+1] = "1st frequency"
	ResultLabelWave[i+2] = "2nd frequency"
	ResultLabelWave[i+3] = "3rd frequency"
	k = 4
	do
		ResultLabelWave[i+k] = num2str(k) + "th frequency"
		k += 1
	while (k <= EventNumInTable-1)
	
	MxSize = DimSize(FreqMx, 0)
	k=0
	do
		i+=1	
		if (k < MxSize)
			CopiedWave = FreqMx[k][p]
			WaveStats/Q CopiedWave			
			ResultValueWave[i] =  V_avg
			ResultSemWave[i] = V_sdev/sqrt(V_npnts)
			ResultNWave[i] = V_npnts
		else
			ResultNWave[i] = 0
		endif
		k +=1
	while (k < EventNumInTable-1)
	
	//amplitude domain
	WaveStats/Q AmpWave
	i+=1	
	ResultLabelWave[i] = "All amplitudes"
	ResultValueWave[i] =  V_avg
	ResultSemWave[i] = V_sdev/sqrt(V_npnts)
	ResultNWave[i] = V_npnts
	i+=1	
	ResultLabelWave[i] = "Min amplitude"
	ResultValueWave[i] =  V_min
	i+=1	
	ResultLabelWave[i] = "Max amplitude"
	ResultValueWave[i] =  V_max

	ResultLabelWave[i+1] = "1st amplitude"
	ResultLabelWave[i+2] = "2nd amplitude"
	ResultLabelWave[i+3] = "3rd amplitude"
	k = 4
	do
		ResultLabelWave[i+k] = num2str(k) + "th amplitude"
		k += 1
	while (k <= EventNumInTable)

	MxSize = DimSize(AmpMx, 0)
	k=0
	do
		i+=1	
		if (k < MxSize)
			CopiedWave = AmpMx[k][p]
			WaveStats/Q CopiedWave			
			ResultValueWave[i] =  V_avg
			ResultSemWave[i] = V_sdev/sqrt(V_npnts)
			ResultNWave[i] = V_npnts
		else
			ResultNWave[i] = 0
		endif
		k +=1
	while (k < EventNumInTable)

	// Ratio domain
	k = 1
	do
		ResultLabelWave[i+k] = "P"+num2str(k+1) + "/P1"
		k += 1
	while (k <= EventNumInTable-1)
	
	MxSize = DimSize(RatioMx, 0)
	k=0
	do
		i+=1	
		if (k < MxSize)
			CopiedWave = RatioMx[k][p]
			WaveStats/Q CopiedWave			
			ResultValueWave[i] =  V_avg
			ResultSemWave[i] = V_sdev/sqrt(V_npnts)
			ResultNWave[i] = V_npnts
		else
			ResultNWave[i] = 0
		endif
		k +=1
	while (k < EventNumInTable-1)
	
	// Rise time domain
	ControlInfo /W=FurtherAnalysisPanel check12
	string risefromto
	if (V_value)
		wave sRiseWave = RiseWave//20-80
		wave sRiseMx = RiseMx//20-80
		risefromto = "(20-80%)"
	else
		wave sRiseWave = Rise2Wave	//10-90
		wave sRiseMx = Rise2Mx	//10-90
		risefromto = "(10-90%)"
	endif
	WaveStats/Q sRiseWave
	i+=1	
	ResultLabelWave[i] = "All rise time"+risefromto
	ResultValueWave[i] =  V_avg
	ResultSemWave[i] = V_sdev/sqrt(V_npnts)
	ResultNWave[i] = V_npnts
	i+=1	
	ResultLabelWave[i] = "Min rise time"+risefromto
	ResultValueWave[i] =  V_min
	i+=1	
	ResultLabelWave[i] = "Max rise time"+risefromto
	ResultValueWave[i] =  V_max

	ResultLabelWave[i+1] = "1st rise time"+risefromto
	ResultLabelWave[i+2] = "2nd rise time"+risefromto
	ResultLabelWave[i+3] = "3rd rise time"+risefromto
	k = 4
	do
		ResultLabelWave[i+k] = num2str(k) + "th rise time"+risefromto
		k += 1
	while (k <= EventNumInTable)

	MxSize = DimSize(sRiseMx, 0)
	k=0
	do
		i+=1	
		if (k < MxSize)
			CopiedWave = sRiseMx[k][p]
			WaveStats/Q CopiedWave			
			ResultValueWave[i] =  V_avg
			ResultSemWave[i] = V_sdev/sqrt(V_npnts)
			ResultNWave[i] = V_npnts
		else
			ResultNWave[i] = 0
		endif
		k +=1
	while (k < EventNumInTable)

	// Decay time domain
	if (DAMM)
		ControlInfo /W=FurtherAnalysisPanel popup0
		string decaylabel
		
		if (V_Value == 1)
			wave sTauWave =  TauWave
			wave sTauMx =  TauMx
			decaylabel = "Tau"
		elseif (V_Value == 2)
			wave sTauWave =  Tau1Wave
			wave sTauMx =  Tau1Mx
			decaylabel = "Tau1"
		elseif (V_Value == 3)
			wave sTauWave =  Tau2Wave
			wave sTauMx =  zTau2Mx
			decaylabel = "Tau2"
		elseif (V_Value == 4)
			wave sTauWave =  TauMWave
			wave sTauMx =  TauMMx
			decaylabel = "TauM"
		endif
		
		WaveStats/Q sTauWave
		i+=1	
		ResultLabelWave[i] = "All "+decaylabel
		ResultValueWave[i] =  V_avg
		ResultSemWave[i] = V_sdev/sqrt(V_npnts)
		ResultNWave[i] = V_npnts
		i+=1	
		ResultLabelWave[i] = "Min "+decaylabel
		ResultValueWave[i] =  V_min
		i+=1	
		ResultLabelWave[i] = "Max "+decaylabel
		ResultValueWave[i] =  V_max
	
		ResultLabelWave[i+1] = "1st "+decaylabel
		ResultLabelWave[i+2] = "2nd "+decaylabel
		ResultLabelWave[i+3] = "3rd "+decaylabel
		k = 4
		do
			ResultLabelWave[i+k] = num2str(k) + "th "+decaylabel
			k += 1
		while (k <= EventNumInTable)
	
		MxSize = DimSize(sTauMx, 0)
		k=0
		do
			i+=1	
			if (k < MxSize)
				CopiedWave = sTauMx[k][p]
				WaveStats/Q CopiedWave			
				ResultValueWave[i] =  V_avg
				ResultSemWave[i] = V_sdev/sqrt(V_npnts)
				ResultNWave[i] = V_npnts
			else
				ResultNWave[i] = 0
			endif
			k +=1
		while (k < EventNumInTable)
	endif //end of decay domain
	
	//DoWindow/K SummaryTable
	if (MakeSummaryList)
		Edit/K=0/W=(306,44,764,446) ResultLabelWave,ResultValueWave,ResultSemWave,ResultNWave
		ModifyTable width[1]=120,sigDigits[2]=4,sigDigits[3]=4
		GetWaveNamesOfTable()
	endif
	
	//cleaning
	Duplicate/O EpisodeWave, $"zEpisodeWave"+NamePostfix
	Duplicate/O EventCountWave, $"zEventCount"+NamePostfix
	Duplicate/O LatencyWave, $"zLatencyWave"+NamePostfix
	Duplicate/O AmpWave, $"zAmpWave"+NamePostfix
	Duplicate/O RiseWave, $"zRise2080Wave"+NamePostfix
	Duplicate/O Rise2Wave, $"zRise1090Wave"+NamePostfix	
	Duplicate/O EventNumRefWave, $"zEventRefWave"+NamePostfix	
	Duplicate/O HalfWWave, $"zHalfWWave"+NamePostfix	

	Duplicate/O LatencyMx, $"zxLatencyMx"+NamePostfix
	Duplicate/O AmpMx, $"zxAmpMx"+NamePostfix
	Duplicate/O RiseMx, $"zxRise2080Mx"+NamePostfix
	Duplicate/O Rise2Mx, $"zxRise1090Mx"+NamePostfix
	Duplicate/O IntervalMx, $"zxIntervalMx"+NamePostfix
	Duplicate/O RatioMx, $"zxRatioMx"+NamePostfix
	Duplicate/O IERMx, $"zxIERMx"+NamePostfix
	Duplicate/O FreqMx, $"zxFreqMx"+NamePostfix
	Duplicate/O EventNumRefMx, $"zxEventRefMx"+NamePostfix	
	Duplicate/O HalfWMx, $"zxHalfWMx"+NamePostfix	
	
	Duplicate/O intervalEpisodeWave, $"zIntEpisodeWave"+NamePostfix/// 1D
	Duplicate/O intervalEventCountWave, $"zIntEventCount"+NamePostfix///1D
	Duplicate/O IntervalWave, $"zIntervalWave"+NamePostfix///1D
	Duplicate/O RatioWave, $"zRatioWave"+NamePostfix///1D
	Duplicate/O IERWave, $"zIERWave"+NamePostfix///1D
	Duplicate/O FreqWave, $"zFreqWave"+NamePostfix///1D
	//In the following 7 waves, numpnt is equal to EpisodeNumber
	Duplicate/O EventNumberOfEpisode, $"zzEventsPerEpi"+NamePostfix
	Duplicate/O MinInterval, $"zzMinInterval"+NamePostfix
	Duplicate/O MeanInterval, $"zzMeanInterval"+NamePostfix
	Duplicate/O MaxFreq, $"zzMaxFreq"+NamePostfix
	Duplicate/O MeanFreq, $"zzMeanFreq"+NamePostfix
	Duplicate/O DurationTime, $"zzDurationTime"+NamePostfix
	Duplicate/O DurationFreq, $"zzDurationFreq"+NamePostfix
	Duplicate/O MeanLatency, $"zzMeanLatency"+NamePostfix
	
	if (DAMM & 1)
		Duplicate/O TauWave, $"zTauWave"+NamePostfix
		Duplicate/O TauMx, $"zTauMx"+NamePostfix		
	endif
	if (DAMM & 2)
		Duplicate/O Tau1Wave, $"zTau1Wave"+NamePostfix	
		Duplicate/O Tau2Wave, $"zTau2Wave"+NamePostfix	
		Duplicate/O TauMWave, $"zTauMWave"+NamePostfix	
		Duplicate/O Tau1Mx, $"zTau1Mx"+NamePostfix	
		Duplicate/O Tau2Mx, $"zTau2Mx"+NamePostfix	
		Duplicate/O TauMMx, $"zTauMMx"+NamePostfix	
	endif	
	
	Killwaves/Z EpisodeWave
	Killwaves/Z LatencyWave
	Killwaves/Z AmpWave
	Killwaves/Z RiseWave
	Killwaves/Z Rise2Wave
	Killwaves/Z LatencyMx
	Killwaves/Z AmpMx
	Killwaves/Z RiseMx
	Killwaves/Z Rise2Mx
	Killwaves/Z IntervalMx
	Killwaves/Z RatioMx
	Killwaves/Z IERMx
	Killwaves/Z FreqMx
	Killwaves/Z EventNumberOfEpisode
	Killwaves/Z MinInterval
	Killwaves/Z MeanInterval
	Killwaves/Z MaxFreq
	Killwaves/Z MeanFreq
	Killwaves/Z intervalEpisodeWave
	Killwaves/Z intervalEventCountWave
	Killwaves/Z IntervalWave
	Killwaves/Z RatioWave
	Killwaves/Z FreqWave
	Killwaves/Z EventCountWave
	Killwaves/Z EventNumRefWave,EventNumRefMx
	Killwaves/Z TauWave,TauMx
	Killwaves/Z Tau1Wave,Tau1Mx
	Killwaves/Z Tau2Wave,Tau2Mx
	Killwaves/Z TauMWave,TauMMx
	Killwaves/Z HalfWWave,HalfWMx
	
	Killwaves/Z CopiedWave
	Killwaves/Z EpisodesToBeSelected
	Killwaves/Z SelectedEpisodes

End

//--------------------------------------------------------------------------------------------
Function MakeAmplitudeHistogram()
	SVAR NamePostfix
	NVAR BinSizeA, BinNumA
	wave w = $("zAmpWave" + NamePostfix)	
	Make/N=(BinNumA)/O $("W_AmpHisto"+NamePostfix)
	wave W_AmpHisto = $("W_AmpHisto"+NamePostfix)
	Histogram/B={0,BinSizeA,BinNumA} w,W_AmpHisto
	Display/W=(310,230,600,390)  W_AmpHisto
	ModifyGraph mode=5
	ModifyGraph marker=10
	ModifyGraph rgb=(0,0,0)
	ModifyGraph msize=1
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	Label left "Event number"
	Label bottom "Amplitude ( )"
	SetAxis/A/E=1 left
	SetAxis/A bottom
End

Function MakeIntervalHistogram()
	SVAR NamePostfix
	NVAR BinSizeIn, BinNumIn
	wave w = $("zIntervalWave" + NamePostfix)	
	Make/N=(BinNumIn)/O $("W_IntervalHisto"+NamePostfix)
	wave W_IntervalHisto = $("W_IntervalHisto"+NamePostfix)
	Histogram/B={0,BinSizeIn,BinNumIn} w,W_IntervalHisto
	Display/W=(310,420,600,580)  W_IntervalHisto
	ModifyGraph mode=5
	ModifyGraph marker=10
	ModifyGraph rgb=(0,0,0)
	ModifyGraph msize=1
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	Label left "Event number"
	Label bottom "Interval (ms)"
	SetAxis/A/E=1 left
	SetAxis/A bottom
End

Function MakeRiseTimeHistogram()
	SVAR NamePostfix
	NVAR BinSizeRise, BinNumRise
	string risefromto
		
	ControlInfo /W=FurtherAnalysisPanel check12
	if (V_value)
		wave w = $("zRise2080Wave" + NamePostfix)
		risefromto = "(20-80%)"	
	else
		wave w = $("zRise1090Wave" + NamePostfix)	
		risefromto = "(10-90%)"	
	endif
	Make/N=(BinNumRise)/O $("W_RiseHisto"+NamePostfix)
	wave W_RiseHisto = $("W_RiseHisto"+NamePostfix)
	Histogram/B={0,BinSizeRise,BinNumRise} w,W_RiseHisto
	Display/W=(610,230,900,390)  W_RiseHisto
	ModifyGraph mode=5
	ModifyGraph marker=10
	ModifyGraph rgb=(0,0,0)
	ModifyGraph msize=1
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	Label left "Event number"
	Label bottom "Rise time "+ risefromto + " (ms)"
	SetAxis/A/E=1 left
	SetAxis/A bottom
End

Function MakeDecayTimeHistogram()
	SVAR NamePostfix
	NVAR BinSizeDecay, BinNumDecay
	string decaylabel
	
	ControlInfo /W=FurtherAnalysisPanel popup0
	//print V_Value
	if (V_Value == 1)
		wave w =  $("zTauWave" + NamePostfix)
		decaylabel = "Tau (single)"
	elseif (V_Value == 2)
		wave w =  $("zTau1Wave" + NamePostfix)
		decaylabel = "Tau1"
	elseif (V_Value == 3)
		wave w =  $("zTau2Wave" + NamePostfix)
		decaylabel = "Tau2"
	elseif (V_Value == 4)
		wave w =  $("zTauMWave" + NamePostfix)
		decaylabel = "TauMean"
	endif
	
	Make/N=(BinNumDecay)/O $("W_DecayHisto"+NamePostfix)
	wave W_DecayHisto = $("W_DecayHisto"+NamePostfix)
	Histogram/B={0,BinSizeDecay,BinNumDecay} w,W_DecayHisto
	Display/W=(610,420,900,580)  W_DecayHisto
	ModifyGraph mode=5
	ModifyGraph marker=10
	ModifyGraph rgb=(0,0,0)
	ModifyGraph msize=1
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	Label left "Event number"
	Label bottom decaylabel + " (ms)"
	SetAxis/A/E=1 left
	SetAxis/A bottom
End

Function MakeAutocorrelogram()
	SVAR NamePostfix
	NVAR BinSizeCor, BinNumCor
	NVAR Tmin,Tmax
	wave w1 = $("zEpisodeWave" + NamePostfix)	
	wave w2 = $("zLatencyWave" + NamePostfix)	
	variable wWidth = BinSizeCor*BinNumCor
	variable wFrom = -0.5*wWidth
	variable wTo = 0.5*wWidth

	Make/N=0/O w3
	variable w3p = 0
	variable w1pnts = numpnts(w1)
	variable i = 0
	do
		if ((w2[i] > Tmin - wFrom)&& (w2[i] < Tmax - wTo))
			//variable w2i = w2[i]
			variable k = 0
			do
				variable interval = w2[k] - w2[i] 
				if ((interval> wFrom) && (interval< wTo) && (w1[k] == w1[i]))
					InsertPoints w3p,1, w3
					w3[w3p] = interval
					w3p += 1
				endif
				if (w1[k] > w1[i])
					break
				endif
				k+=1
			while (k < w1pnts)
		endif
		i += 1
	while (i < w1pnts)
	Make/N=(BinNumCor)/O $("W_Autocorrel"+NamePostfix)
	wave W_Autocorrel = $("W_Autocorrel"+NamePostfix)
	
	Histogram/B={wFrom,BinSizeCor,BinNumCor} w3,W_Autocorrel
	Duplicate/O W_Autocorrel, w4
	Wavestats/Q/M=1 w4
	w4[x2pnt(w4,V_maxloc)] = 0
	variable GraphYTop = round(WaveMax(w4) * 1.4)
	
	Display/W=(310, 330,600,490)  W_Autocorrel
	ModifyGraph mode=5
	ModifyGraph marker=10
	ModifyGraph rgb=(0,0,0)
	ModifyGraph msize=1
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	Label left "Event number"
	Label bottom "Interval (ms)"
//	SetAxis/A/E=1 left
	SetAxis left,0,GraphYTop
	SetAxis/A bottom
	killwaves/z w3,w4
End

Function MakeHalfWidthHistogram()
	SVAR NamePostfix
	NVAR BinSizeHW, BinNumHW
	wave w = $("zHalfWWave" + NamePostfix)
	Make/N=(BinNumHW)/O $("W_HalfWHisto"+NamePostfix)
	wave W_HalfWHisto = $("W_HalfWHisto"+NamePostfix)
	Histogram/B={0,BinSizeHW, BinNumHW} w,W_HalfWHisto
	Display/W=(310,230,600,390)  W_HalfWHisto
	ModifyGraph mode=5
	ModifyGraph marker=10
	ModifyGraph rgb=(0,0,0)
	ModifyGraph msize=1
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	Label left "Event number"
	Label bottom "Half-width (ms)"
	SetAxis/A/E=1 left
	SetAxis/A bottom
	Wavestats/Q/M=1 w
	if (V_npnts == 0)
		DoAlert 0, "Half-width histogram is empty. This might be caused by version mismatch. Go back to Event detection and do SaveResults."
	endif
End


////////////

Function RefreshFurtherAnalysisStat()
	String/g ResultWaveList
	variable/g NumOfResults

	ResultWaveList = WaveList("value*",";","")
	ResultWaveList = RemoveFromList (ListMatch(ResultWaveList, "valuelabels*"), ResultWaveList)
	ResultWaveList = ReplaceString("value", ResultWaveList, "")
	NumOfResults = ItemsInList(ResultWaveList)
	Make/O/T/N=(NumOfResults) AllValWave = StringFromList(p,ResultWaveList)	//convert the  list to a wave
	Make/O/N=(NumOfResults) ValSel = 0
End

	
Function FurtherAnalysisSummaryStat()
	variable/g StatListLength
	RefreshFurtherAnalysisStat()
	SVAR ResultWaveList
	NVAR NumOfResults	
	wave/T AllValWave
	wave  ValSel

	if (WinType("FurtherAnalysisStatPanel") >0)
		DoWindow/F FurtherAnalysisStatPanel
	else
		TaroSetFont()
		NewPanel /W=(197,81,497,456)/N = FurtherAnalysisStatPanel	
		DrawLine 15,241,290,241
		DrawLine 15,175,290,175
		ListBox LB1,pos={34,27},size={233,110},frame=2
		ListBox LB1,listWave=AllValWave
		ListBox LB1,selWave=ValSel,mode= 4
		Button button0,pos={90,338},size={50,20},proc=FurtherAnalysisTtest,title="OK"
		Button button1,pos={154,338},size={50,20},proc=CancelButtonTI,title="Close"
		Button button2,pos={24,189},size={100,20},proc=FurtherAnalysisAdjust,title="Adjust length"
		Button button2,fStyle=1
		Button button3,pos={38,147},size={65,20},proc=FurtherAnalysisSelectAllVal,title="select all"
		TitleBox title0,pos={36,248},size={229,13},title="Unpaired t-test for <Analysis 1> and <Analysis 2>"
		TitleBox title0,frame=0
		PopupMenu popup0,pos={36,270},size={175,21},title="Analysis 1 "
		PopupMenu popup0,mode=1,bodyWidth= 120,popvalue="select",value= #"ResultWaveList"
		PopupMenu popup1,pos={36,302},size={175,21},title="Analysis 2 "
		PopupMenu popup1,mode=1,bodyWidth= 120,popvalue="select",value= #"ResultWaveList"
		TitleBox title1,pos={138,185},size={95,13},title="Event number in list:",frame=0
		CheckBox check3,pos={137,201},size={105,14},proc=FurtherAnalysisCheckBox,title="auto (max number)"
		CheckBox check3,value= 0
		CheckBox check4,pos={137,220},size={28,14},proc=FurtherAnalysisCheckBox,title="fix"
		CheckBox check4,value= 1
		SetVariable setvar2,pos={172,219},size={40,16},title=" "
		SetVariable setvar2,limits={0,inf,1},value= StatListLength,bodyWidth= 40
		TitleBox title2,pos={14,8},size={94,13},title="Select summary lists",frame=0
		Button button4,pos={110,147},size={75,20},proc=FurtherAnalysisStatTable,title="make tables"
		Button button5,pos={191,147},size={75,20},proc=FurtherAnalysisStatTable,title="make copies"
	endif
End

Function FurtherAnalysisAdjust(ctrlName) : ButtonControl
	String ctrlName
	AdjustResultWaveLength()
End

Function FurtherAnalysisSelectAllVal(ctrlName) : ButtonControl
	String ctrlName
	wave ValSel
	ValSel = 1
End



Function AdjustResultWaveLength()
	//SVAR ResultWaveList
	String SelResultWaveList = ""
	//NVAR NumOfResults
	NVAR LimEN = StatListLength
	variable wavelength
	variable maxwavelength = 0
	string LongestAnaName,ananame
	variable EN
	variable MaxEN
	string LastCellStr
	variable v1
	string s1
	variable insertP
	variable delP
	//
	wave ValSel
	wave/T AllValWave
	variable SelectedNum =sum(ValSel)
	variable ListedNum =numpnts(ValSel)
	if (SelectedNum == 0)
		abort "Select at least one wave."
	endif
	variable i = 0, k = 0
	do 
		if (ValSel[i])
			SelResultWaveList += AllValWave[i] + ";"
			k += 1
		endif
		i += 1
	while (i < ListedNum)	
	//
	i = 0
	do
		ananame = StringFromList(i, SelResultWaveList)
		wave valuewave = $("value"+ananame)
		wave/T labelswave = $("labels"+ananame)
		if (stringmatch(labelswave[3],"Burst interval limit"))//latest version
			//wavelength = numpnts(valuewave)
			wavelength = numpnts(labelswave)
			LastCellStr = labelswave[wavelength-1]
			sscanf LastCellStr, "%d%*[th ] %s", v1, s1
			//print v1
			//print s1
			//EN = (wavelength -31)/7
			EN = v1
			//if ((wavelength > maxwavelength) &&(EN==round(EN)))
			if (wavelength > maxwavelength)
				maxwavelength = wavelength
				MaxEN = EN
				LongestAnaName = ananame
			endif
		endif
		i += 1
	//while (i < NumOfResults)
	while (i < SelectedNum)
	//print maxwavelength, NumOfResults
	
	ControlInfo /W= FurtherAnalysisStatPanel check4
	variable FixfFag =V_Value
	if (!FixfFag)
		DoAlert 1, "Event number in the selected lists will be "+num2str(MaxEN)+". Do you want to proceed?"
		if (V_flag == 2)
			abort
		endif
	endif	
	if ((FixfFag)&&(LimEN > MaxEN))
		DoAlert 1, "Event number will be adjusted to the auto value (max number), which is "+num2str(MaxEN)+" in the current selection. Do you want to proceed?"
		if (V_flag == 2)
			abort
		endif
	endif
	
	Duplicate/O/T $("labels"+LongestAnaName) longestlabelswave
//	wave/T longestlabelswave = $("labels"+LongestAnaName)
	i = 0
	do
		ananame = StringFromList(i, SelResultWaveList)
		wave valuewave = $("value"+ananame)
		wave semwave = $("sem"+ananame)
		wave nwave = $("n"+ananame)
		wave/T labelswave = $("labels"+ananame)
		if (stringmatch(labelswave[3],"Burst interval limit"))//latest version
	
	//		wavelength = numpnts(valuewave)
	//		EN = (wavelength -31)/7
			wavelength = numpnts(labelswave)
			LastCellStr = labelswave[wavelength-1]
			sscanf LastCellStr, "%d%*[th ] %s", v1, s1
			EN = v1
	
			//print "check "+ananame
			//if ((wavelength <  maxwavelength)&&(EN==round(EN)))
			if (wavelength <  maxwavelength)
				 //print "Adjusting the length of : "+ananame + " from "+num2str(EN)+" to "+ num2str(MaxEN)
	//			 InsertPointsToResult(15+EN, MaxEN-EN, valuewave,semwave,nwave,labelswave)
	//			 InsertPointsToResult(19+EN+MaxEN, MaxEN-EN, valuewave,semwave,nwave,labelswave)
	//			 InsertPointsToResult(23+EN+2*MaxEN, MaxEN-EN, valuewave,semwave,nwave,labelswave)
	//			 InsertPointsToResult(26+EN+3*MaxEN, MaxEN-EN, valuewave,semwave,nwave,labelswave)
	//			 InsertPointsToResult(25+EN+4*MaxEN, MaxEN-EN, valuewave,semwave,nwave,labelswave)
	//			 InsertPointsToResult(28+EN+5*MaxEN, MaxEN-EN, valuewave,semwave,nwave,labelswave)
	//			 InsertPointsToResult(31+EN+6*MaxEN, MaxEN-EN, valuewave,semwave,nwave,labelswave)
				 insertP = WhichTextwaveItem(num2str(EN)+"th event time",labelswave) +1
				 InsertPointsToResult(insertP, MaxEN-EN, valuewave,semwave,nwave,labelswave,longestlabelswave)
				 insertP = WhichTextwaveItem(num2str(EN-1)+"th interval",labelswave) +1
				 InsertPointsToResult(insertP, MaxEN-EN, valuewave,semwave,nwave,labelswave,longestlabelswave)
				 insertP = WhichTextwaveItem(num2str(EN-1)+"th frequency",labelswave) +1
				 InsertPointsToResult(insertP, MaxEN-EN, valuewave,semwave,nwave,labelswave,longestlabelswave)
				 insertP = WhichTextwaveItem(num2str(EN)+"th amplitude",labelswave) +1
				 InsertPointsToResult(insertP, MaxEN-EN, valuewave,semwave,nwave,labelswave,longestlabelswave)
				 insertP = WhichTextwaveItem("P"+num2str(EN)+"/P1",labelswave) +1
				 InsertPointsToResult(insertP, MaxEN-EN, valuewave,semwave,nwave,labelswave,longestlabelswave)
				 insertP = WhichTextwaveItem(num2str(EN)+"th rise time*",labelswave) +1
				 InsertPointsToResult(insertP, MaxEN-EN, valuewave,semwave,nwave,labelswave,longestlabelswave)
				 if (! stringmatch(s1, "rise"))//if there is decay values
					 insertP = WhichTextwaveItem(num2str(EN)+"th Tau*",labelswave) +1
					 InsertPointsToResult(insertP, MaxEN-EN, valuewave,semwave,nwave,labelswave,longestlabelswave)
				 endif
			endif

			if ((FixfFag)&&(LimEN < MaxEN))
				//print "Adjusting the length of : "+ananame + " from "+num2str(MaxEN)+" to "+ num2str(LimEN)
				delP = WhichTextwaveItem(num2str(MaxEN)+"th event time",labelswave) +1 - (MaxEN - LimEN)
				DeletePoints delP, (MaxEN - LimEN), valuewave,semwave,nwave,labelswave
				delP = WhichTextwaveItem(num2str(MaxEN-1)+"th interval",labelswave) +1 - (MaxEN - LimEN)
				DeletePoints delP, (MaxEN - LimEN), valuewave,semwave,nwave,labelswave
				delP = WhichTextwaveItem(num2str(MaxEN-1)+"th frequency",labelswave) +1 - (MaxEN - LimEN)
				DeletePoints delP, (MaxEN - LimEN), valuewave,semwave,nwave,labelswave
				delP = WhichTextwaveItem(num2str(MaxEN)+"th amplitude",labelswave) +1 - (MaxEN - LimEN)
				DeletePoints delP, (MaxEN - LimEN), valuewave,semwave,nwave,labelswave
				delP = WhichTextwaveItem("P"+num2str(MaxEN)+"/P1",labelswave) +1 - (MaxEN - LimEN)
				DeletePoints delP, (MaxEN - LimEN), valuewave,semwave,nwave,labelswave
				delP = WhichTextwaveItem(num2str(MaxEN)+"th rise time*",labelswave) +1 - (MaxEN - LimEN)
				DeletePoints delP, (MaxEN - LimEN), valuewave,semwave,nwave,labelswave
				//	print delP, MaxEN , LimEN
				 if (! stringmatch(s1, "rise"))//if there is decay values
					 delP = WhichTextwaveItem(num2str(MaxEN)+"th Tau*",labelswave) +1 - (MaxEN - LimEN)
					DeletePoints delP, (MaxEN - LimEN), valuewave,semwave,nwave,labelswave
				//	print delP, MaxEN , LimEN
				 endif			
			endif
		endif // 			
		i += 1
//	while (i < NumOfResults)	
	while (i < SelectedNum)	
	//print "Adjusted waves have "+num2str(MaxEN)+ " events."
	killwaves/Z longestlabelswave
End

Function FurtherAnalysisStatTable(ctrlName) : ButtonControl
	String ctrlName
	variable table
	if (stringmatch(ctrlName, "button4"))
		table = 1//make table
	else
		table=0//make copies
	endif
	String SelResultWaveList = ""
	//
	wave ValSel
	wave/T AllValWave
	variable SelectedNum =sum(ValSel)
	variable ListedNum =numpnts(ValSel)
	if (SelectedNum == 0)
		abort "Select at least one wave."
	endif
	variable i = 0, k = 0
	do 
		if (ValSel[i])
			SelResultWaveList += AllValWave[i] + ";"
			k += 1
		endif
		i += 1
	while (i < ListedNum)	
	//
	string ananame
	if (table)
		Edit
	endif
	i = 0
	do
		ananame = StringFromList(i, SelResultWaveList)
		wave valuewave = $("value"+ananame)
		wave semwave = $("sem"+ananame)
		wave nwave = $("n"+ananame)
		wave/T labelswave = $("labels"+ananame)
		if (table)
			AppendToTable labelswave,valuewave,semwave,nwave
		else
			duplicate/T labelswave, $("labels"+ananame+"_copy")
			duplicate valuewave, $("value"+ananame+"_copy")
			duplicate semwave, $("sem"+ananame+"_copy")
			duplicate nwave, $("n"+ananame+"_copy")
		endif
		i += 1
	while (i < SelectedNum)
	if (table)
		GetWaveNamesOfTable()
	else
		RefreshFurtherAnalysisStat()
	endif
End


Function WhichTextwaveItem(itemStr, w)
	String itemStr
	wave/T w
	//print w
	variable matchP = 0
	variable wavelength = numpnts(w)
	variable i = 0
	do
		if (stringmatch(w[i], itemStr))
			matchP = i
			break
		endif
		i += 1
	while (i < wavelength)
	//print itemStr, matchP
	return matchP
End

Function InsertPointsToResult(at, n, w1,w2,w3,w4,w5)
	variable at,n
	wave w1,w2,w3
	wave/T w4,w5//w5 is to fill the inserted labels
	InsertPoints at,n, w1,w2,w3,w4
	w1[at,at+n-1] = nan
	w2[at,at+n-1] = nan
	w4[at, at+n-1] = w5
End
	
Function FurtherAnalysisTtest(ctrlName) : ButtonControl
	String ctrlName	

	ControlInfo /W=FurtherAnalysisStatPanel popup0
	String ana1 = S_Value
	ControlInfo /W=FurtherAnalysisStatPanel popup1
	String ana2 = S_Value
	if (stringmatch(ana1,"select") || stringmatch(ana2,"select"))
		abort "Select proper analysis sets."
	endif
	wave valuewave1 = $("value"+ana1)
	wave semwave1 = $("sem"+ana1)
	wave nwave1 = $("n"+ana1)
	wave/T labelswave1 = $("labels"+ana1)
	wave valuewave2 = $("value"+ana2)
	wave semwave2 = $("sem"+ana2)
	wave nwave2 = $("n"+ana2)
	//wave/T labelswave2 = $("labels"+ana2)
	
	if (!(numpnts(valuewave1)==numpnts(valuewave2)))
		SVAR ResultWaveList
		NVAR NumOfResults
		ResultWaveList = ana1+";"+ana2+";"
		NumOfResults = 2
		AdjustResultWaveLength()
	endif
	
	String PvalueWaveStr = "P"+ana1+"vs"+ana2
	PvalueWaveStr = CleanupName(PvalueWaveStr, 1)
	
	Duplicate/O valuewave1 $PvalueWaveStr
	Wave Pvalues = $PvalueWaveStr
	Pvalues = NaN
	variable P1
	variable i = 0
	do
		P1 =  QuickTtest(valuewave1[i], semwave1[i], nwave1[i], valuewave2[i], semwave2[i], nwave2[i])
		Pvalues[i] = ceil(P1*1000)/1000
		i+=1
	while (i<numpnts(Pvalues))
	DoWindow/k FurtherAnalysisStatPanel
	Edit labelswave1,Pvalues
	GetWaveNamesOfTable()	
End

Function GetWaveNamesOfTable()

		String TableWindowList = WinList("*",";","WIN:2")
		if (ItemsInList(TableWindowList) == 0)
			abort "No tables"
		endif
		String toptable = StringFromList(0,TableWindowList)
		String info = TableInfo(toptable, -2)
		String selectionInfo
		selectionInfo = StringByKey("COLUMNS", info)
		variable numCol = str2num(selectionInfo) - 1
		//print numCol
		string WaveNameList = ""
		string NameInfo, TypeInfo
		variable i = 0
		do
			info = TableInfo(toptable, i)
			TypeInfo = StringByKey("DATATYPE", info)
			NameInfo = StringByKey("WAVE", info)
			//print NameInfo
			//if (stringmatch(TypeInfo, "0"))
			//endif
			Wave w1 = $NameInfo
			WaveNameList += NameOfWave(w1)
			if (mod(i+1,8))
				WaveNameList += "\t"
			else
				WaveNameList += "\r"
			endif
			i += 1
		while (i < numCol)
		WaveNameList = RemoveEnding(WaveNameList)
		print toptable
		print WaveNameList
End

Function ShuffleTable1()/////////not in menu
		String TableWindowList = WinList("*",";","WIN:2")
		if (ItemsInList(TableWindowList) == 0)
			abort "No tables"
		endif
		variable RawNum 
		Prompt RawNum, "Raw number in each set:" 
		DoPrompt "Enter values" , RawNum
		//print RawNum
		if (V_flag)
			abort
		endif
		String toptable = StringFromList(0,TableWindowList)
		String info = TableInfo(toptable, -2)
		String selectionInfo
		selectionInfo = StringByKey("COLUMNS", info)
		variable numCol = str2num(selectionInfo) - 1
		selectionInfo = StringByKey("ROWS", info)
		variable origRaw = str2num(selectionInfo)
		variable setNum =ceil(origRaw/RawNum)
		variable newRaw = RawNum*setNum
		//print numCol
		string origWaveName
		string NameInfo, TypeInfo
		variable raw, k
		Edit
		variable i = 0// each column
		do
			info = TableInfo(toptable, i)
			TypeInfo = StringByKey("DATATYPE", info)
			NameInfo = StringByKey("WAVE", info)
			if (stringmatch(TypeInfo, "0"))
				Wave/T wt1 = $NameInfo
				origWaveName = NameOfWave(wt1)
				Make/T/O/N=(newRaw) $(origWaveName + "_shuffle")=""
				Wave/T wt2 = $(origWaveName + "_shuffle")
			else
				Wave w1 = $NameInfo
				origWaveName = NameOfWave(w1)
				Make/O/N=(newRaw) $(origWaveName + "_shuffle")=Nan
				Wave w2 = $(origWaveName + "_shuffle")
			endif
			k = 0 //each raw of w2
			do
				raw = floor(k/setNum) + RawNum * mod(k, setNum)
				if (raw < origRaw)
					if (stringmatch(TypeInfo, "0"))
						wt2[k] = wt1[raw]
					else
						w2[k] = w1[raw]
					endif
				endif
				k += 1
			while (k < origRaw)
			if (stringmatch(TypeInfo, "0"))
				AppendToTable wt2
			else
				AppendToTable w2
			endif			
			i += 1
		while (i < numCol)		
End

Function MergeTables()
		variable TableNum
		variable allTableNum
		variable numCol
		string tablename
		String info, selectionInfo
		String YesNo
		variable copyflag = 0
		Prompt TableNum, "How many tables (from top) do you want to merge:" 
		Prompt YesNo, "Make copies of waves in the tables? (postfix _copy)", popup, "No;Yes;"
		DoPrompt "Enter values" , TableNum, YesNo
		if (TableNum < 1)
			abort
		endif
		if (stringmatch(YesNo, "Yes"))
			//print "make copy"
			copyflag = 1
		endif
		String TableWindowList = WinList("*",";","WIN:2")
		allTableNum = ItemsInList(TableWindowList)
		if (allTableNum < TableNum)
			abort "You have only " + num2str(allTableNum) + " tables"
		endif
		Edit
		variable k
		variable i = 0//for each table
		do
			tablename = StringFromList(i,TableWindowList)
//			print tablename
			info = TableInfo(tablename, -2)
			selectionInfo = StringByKey("COLUMNS", info)
			numCol = str2num(selectionInfo) - 1
			k = 0
			do
				Wave w1 = WaveRefIndexed(tablename, k, 3)
				if (copyflag)
					string newname = NameOfWave(w1)+"_copy"
					Duplicate/O w1 $newname
					AppendToTable $newname
				else
					AppendToTable w1
				endif
//			info = TableInfo(tablename, k)
//			TypeInfo = StringByKey("DATATYPE", info)
//			NameInfo = StringByKey("WAVE", info)
				k += 1
			while (k < numCol)
			i += 1
		while (i < TableNum)
		GetWaveNamesOfTable()
End


Function BurstTransformPanelShow()
	String AllWavesT
	Variable/g BurstTransIEI
	String/g BurstResultpostfix
//	AllWavesT = WaveList("ParamWave*",";","TEXT:1,MAXCOLS:1,MAXLAYERS:1") //only text waves
//	AllWavesT = RemoveFromList ("ParamWave", AllWavesT)
//	AllWavesT = ReplaceString("ParamWave", AllWavesT, "")
//
//
//	//String/G PostfixList
	TaroSetFont()
	RefreshPostfixListOfResults()
	SVAR PostfixList

	if (WinType("BurstTransformPanel")  > 0)
		DoWindow/F  BurstTransformPanel
	else
		NewPanel /N = BurstTransformPanel/W=(151,106,396,273) as "Burst transform"
		PopupMenu popup0,pos={24,18},size={205,21},title="Select a data set"
		PopupMenu popup0,mode=1,bodyWidth= 120,popvalue="select a data set",value= #"PostfixList"
		Button button0,pos={72,129},size={50,20},proc=BurstTransformDo,title="OK"
		Button button1,pos={136,129},size={50,20},proc=CancelButtonTI,title="Cancel"
		SetVariable setvar0,pos={25,101},size={202,16},title="Max inver-event interval (ms):"
		SetVariable setvar0,value= BurstTransIEI,bodyWidth= 60
		SetVariable setvar1,pos={28,51},size={199,16},title="New data set name:"
		SetVariable setvar1,value= BurstResultpostfix,bodyWidth= 100
		TitleBox title1,pos={20,72},size={210,13},title="(The name will be the postfix of data waves.)"
		TitleBox title1,fSize=10,frame=0
	endif
End


Function BurstTransformDo(ctrlName) : ButtonControl
	String ctrlName	
	NVAR BurstTransIEI
	SVAR newpostfix = BurstResultpostfix
	ControlInfo /W=BurstTransformPanel popup0
	if (stringmatch(S_Value,"select a data set"))
		abort "Select a data set"
	endif
	String origpostfix = S_Value
	if (BurstTransIEI <= 0)
		abort "Set interval > 0 ms"
	endif
	if (stringmatch(newpostfix,""))
		DoWindow/F BurstTransformPanel
		abort "Enter a name for the data set."
	elseif (ItemsInList(WaveList("ParamWave"+newpostfix,";","TEXT:1,MAXCOLS:1,MAXLAYERS:1")))
		DoAlert 1, "Do you want to replace "+newpostfix+" ?"
		if (V_flag == 2)
			DoWindow/F BurstTransformPanel
			abort
		else
			DoWindow/K BurstTransformPanel
		endif
	else
		DoWindow/K BurstTransformPanel
	endif
	
	wave origEpisode = $("Episode"+origpostfix)
	wave origEventTime = $("EventTime"+origpostfix)
	wave origBaseTime = $("BaseTime"+origpostfix)
	Duplicate/O origEpisode, $("Episode"+newpostfix), $("BurstMark"+newpostfix)
	Duplicate/O origEventTime, $("EventTime"+newpostfix)
	Duplicate/O origBaseTime, $("BaseTime"+newpostfix)
	wave newEpisode = $("Episode"+newpostfix)
	wave newEventTime = $("EventTime"+newpostfix)
	wave newBaseTime = $("BaseTime"+newpostfix)
	wave BurstMark = $("BurstMark"+newpostfix)
	BurstMark = 0
	variable eventnum = numpnts(origEpisode)
	variable prevEpi = -1
	variable Eve1Time
	variable i = 0
	do
		if (origEpisode[i] != prevEpi)// first event of each original trace
			Eve1Time = origEventTime[i]
			newEventTime[i] = 0
			newBaseTime[i] = origBaseTime[i] - origEventTime[i]
			BurstMark[i] = 49// begin triangle
			if (i ==0)
				newEpisode[i] = 0
			else
				newEpisode[i] = newEpisode[i -1] +1
				if (BurstMark[i-1] == 0)
					BurstMark[i-1] = 46// end triangle
				else
					BurstMark[i-1] = 15// single event burst
				endif
			endif
			prevEpi = origEpisode[i]
		else
			if (origEventTime[i] - origEventTime[i-1] > BurstTransIEI)// first event of a burst
				Eve1Time = origEventTime[i]
				newEventTime[i] = 0
				newBaseTime[i] = origBaseTime[i] - origEventTime[i]
				newEpisode[i] = newEpisode[i -1] +1
				if (BurstMark[i-1] == 0)
					BurstMark[i-1] = 46// end triangle
				else
					BurstMark[i-1] = 15// single event burst
				endif
				BurstMark[i] = 49// begin triangle							
			else	// following events of a burst
				newEventTime[i] = origEventTime[i] - Eve1Time
				newBaseTime[i] = origBaseTime[i] - Eve1Time
				newEpisode[i] = newEpisode[i -1]
			endif
		endif
		i += 1
	while (i < eventnum)
	
	if (BurstMark[eventnum -2] == 0)//to correct the very last event  
		BurstMark[eventnum -1] = 46// end triangle
	else
		BurstMark[eventnum -1] = 15// single event burst
	endif
	
	variable numburst = newEpisode[eventnum-1]+1
	wave/T origParamWave = $("ParamWave"+origpostfix)
	Duplicate/O/T origParamWave,$("ParamWave"+newpostfix)
	wave/T newParamWave = $("ParamWave"+newpostfix)
	
	Redimension/N=(10+numburst) newParamWave
	newParamWave[10,] = newpostfix+"_"+num2str(p-10)

	//Duplicate/O $("BaseTime"+origpostfix),  $("BaseTime"+newpostfix)
	Duplicate/O $("EventYValue"+origpostfix), $("EventYValue"+newpostfix)
	Duplicate/O $("EventAmplitude"+origpostfix), $("EventAmplitude"+newpostfix)
	Duplicate/O $("BaseYValue"+origpostfix), $("BaseYValue"+newpostfix)
	Duplicate/O $("RiseTime2080"+origpostfix), $("RiseTime2080"+newpostfix)	
	Duplicate/O $("RiseTime1090"+origpostfix), $("RiseTime1090"+newpostfix)
	
	if (WaveExists($("DecayTau"+origpostfix)))
		Duplicate/O $("DecayTau"+origpostfix), $("DecayTau"+newpostfix)
	endif
	if (WaveExists($("DecayY0"+origpostfix)))
		Duplicate/O $("DecayY0"+origpostfix), $("DecayY0"+newpostfix)
	endif
	if (WaveExists($("DecayA"+origpostfix)))
		Duplicate/O $("DecayA"+origpostfix), $("DecayA"+newpostfix)
	endif
	if (WaveExists($("Y0d"+origpostfix)))
		Duplicate/O $("Y0d"+origpostfix), $("Y0d"+newpostfix)
	endif
	if (WaveExists($("DecayA1"+origpostfix)))
		Duplicate/O $("DecayA1"+origpostfix), $("DecayA1"+newpostfix)
	endif
	if (WaveExists($("DecayTau1"+origpostfix)))
		Duplicate/O $("DecayTau1"+origpostfix), $("DecayTau1"+newpostfix)
	endif
	if (WaveExists($("DecayA2"+origpostfix)))
		Duplicate/O $("DecayA2"+origpostfix), $("DecayA2"+newpostfix)
	endif
	if (WaveExists($("DecayTau2"+origpostfix)))
		Duplicate/O $("DecayTau2"+origpostfix), $("DecayTau2"+newpostfix)
	endif
	if (WaveExists($("DecayTauM"+origpostfix)))
		Duplicate/O $("DecayTauM"+origpostfix), $("DecayTauM"+newpostfix)
	endif
	if (WaveExists($("AreaAbs"+origpostfix)))
		Duplicate/O $("AreaAbs"+origpostfix), $("AreaAbs"+newpostfix)
	endif
	
	variable BurstCutOutFlag = 1
	if (BurstCutOutFlag)
		variable BustCutFrom, BustCutTo
		variable scalebegin, dxdx, firstEventTime
		variable maxx = 0
		variable Margin = BurstTransIEI * 0.95
		variable k = 0//new trace num
		i = 0//each event
		do
			variable EN = origEpisode[i]
			string origTraceName = origParamWave[10+EN]
			wave OrigTrace = $(origTraceName)
			string newTraceName = newpostfix+"_"+num2str(k)
			if (BurstMark[i] == 15)// single event burst
				BustCutFrom = origEventTime[i] - Margin
				BustCutTo = origEventTime[i] + Margin
				Duplicate/O/R=(BustCutFrom, BustCutTo) OrigTrace, $(newTraceName)
				wave NewTrace = $(newTraceName)
				scalebegin = pnt2x(NewTrace, 0) - origEventTime[i]
				dxdx = deltax(OrigTrace)
				SetScale/P x scalebegin,dxdx,"", NewTrace
				maxx = max(maxx, RightX(NewTrace))
				k += 1
			elseif (BurstMark[i] == 49)// begin triangle	
				firstEventTime = origEventTime[i]
			elseif (BurstMark[i] == 46)//end 
				BustCutFrom = firstEventTime - Margin
				BustCutTo = origEventTime[i] + Margin
				Duplicate/O/R=(BustCutFrom, BustCutTo) OrigTrace, $(newTraceName)
				wave NewTrace = $(newTraceName)
				scalebegin = pnt2x(NewTrace, 0) - firstEventTime
				dxdx = deltax(OrigTrace)
				SetScale/P x scalebegin,dxdx,"", NewTrace
				maxx = max(maxx, RightX(NewTrace))
				k += 1
			endif
			i += 1
		while (i < eventnum)
		newParamWave[5] = num2str(-1* Margin)
		newParamWave[6] = num2str(maxx)
	endif
	print "Burst transform finish: "+num2str(numburst)+" burts in "+newpostfix
	
End

Function BurstMarkingPanelShow()
	TaroSetFont()
	String AllWavesT
	String/G BurstPostfixList
	AllWavesT = WaveList("BurstMark*",";","") 
	BurstPostfixList = ReplaceString("BurstMark", AllWavesT, "")

	if (WinType("BurstMarkingPanel")  > 0)
		DoWindow/F  BurstMarkingPanel
	else
		NewPanel /N = BurstMarkingPanel/W=(151,106,396,273) as "Burst marking"
		PopupMenu popup0,pos={24,18},size={205,21},title="Select a burst file"
		PopupMenu popup0,mode=1,bodyWidth= 120,popvalue="select",value= #"BurstPostfixList"
		Button button0,pos={24,129},size={50,20},proc=BurstMarkingDo,title="OK"
		Button button1,pos={88,129},size={50,20},proc=CancelButtonTI,title="Cancel"
		Button button2,pos={152,129},size={80,20},proc=BurstMarkingClear,title="Clear Marks"
		TitleBox title1,pos={20,72},size={204,13},title="(Make sure that the original event detection"
		TitleBox title1,fSize=10,frame=0
		TitleBox title2,pos={20,88},size={109,13},title=" result is already open.)"
		TitleBox title2,fSize=10,frame=0
	endif
End

Function BurstMarkingDo(ctrlName) : ButtonControl
	String ctrlName	
	ControlInfo /W=BurstMarkingPanel popup0
	String burstname = S_Value
	wave BurstMark = $("BurstMark"+ S_Value)
	Duplicate/O BurstMark, MoreMarkWave
	DoWindow/K BurstMarkingPanel
	DoWindow/F EventDetectionMainPanel
	RedrawWaves("marks")
End	

Function BurstMarkingClear(ctrlName) : ButtonControl
	String ctrlName	
	killwaves/Z MoreMarkWave, EpiMoreMarkWave
	DoWindow/K BurstMarkingPanel
	DoWindow/F EventDetectionMainPanel
	RedrawWaves("marks")
End


Function NewStatPanelShow()
	if (WinType("NewStatPanel") > 0)
		DoWindow/F NewStatPanel
		abort
	endif

	Variable/g StatNth=0
	String/g NewStatPanelList
	NewStatPanelList = WaveList("zAmpWave*",";","")
	NewStatPanelList = ReplaceString("zAmpWave", NewStatPanelList, "")
	variable aa = 30,bb = 30
	TaroSetFont()
	NewPanel /N=NewStatPanel/W=(197,81,497,456)
	TitleBox title0,pos={20,9},size={244,14},title="This panel should be used after \"Further analysis\"."
	TitleBox title0,frame=0
	TitleBox title1,pos={20,25},size={250,14},title="Statistics will be applied to events in \"Time range 2\"."
	TitleBox title1,frame=0
	Button button0,pos={90,aa+10*bb},size={50,20},proc=NewStatPanelDo,title="OK"
	Button button1,pos={154,aa+10*bb},size={50,20},proc=CancelButtonTI,title="Close"
	PopupMenu popup2,pos={32,aa+bb},size={179,22},title="Compare"
	PopupMenu popup2,mode=1,bodyWidth= 120,popvalue="select"
	PopupMenu popup2,value="Amplitude;Time(Latency);Rise20-80;Rise10-90;Interval"
	PopupMenu popup0,pos={32,aa+3*bb},size={179,22},title="Analysis 1 "
	PopupMenu popup0,mode=1,bodyWidth= 120,popvalue="select",value= #"NewStatPanelList"
	PopupMenu popup1,pos={32,aa+4*bb},size={179,22},title="Analysis 2 "
	PopupMenu popup1,mode=1,bodyWidth= 120,popvalue="select",value= #"NewStatPanelList"
	SetVariable setvar2,pos={172,aa+2*bb},size={40,18},title="Nth event (0:all)"
	SetVariable setvar2,limits={0,inf,1},value= StatNth,bodyWidth= 40
	CheckBox check0,pos={30,aa+6*bb},size={49,15},title="T test (unpaired, unequal variance)",value= 1
	CheckBox check1,pos={30,aa+7*bb},size={49,15},title="Kolmogorov-Smirnov test",value= 1
	CheckBox check2,pos={30,aa+8*bb},size={49,15},title="Mann-Whitney test (very slow, risk of hung up)",value= 0
End

Function NewStatPanelDo(ctrlName) : ButtonControl
	String ctrlName
	NVAR StatNth
	String compare,basename,ana1,ana2
	
	ControlInfo popup2
	compare = S_value
	if (stringmatch(compare, "Amplitude"))
		if (StatNth == 0)
			basename = "zAmpWave"
		else
			basename = "zxAmpMx"
		endif
	endif
	if (stringmatch(compare, "Time(Latency)"))
		if (StatNth == 0)
			basename = "zLatencyWave"
		else
			basename = "zxLatencyMx"
		endif
	endif
	if (stringmatch(compare, "Rise20-80"))
		if (StatNth == 0)
			basename = "zRise2080Wave"
		else
			basename = "zxRise2080Mx"
		endif
	endif
	if (stringmatch(compare, "Rise10-90"))
		if (StatNth == 0)
			basename = "zRise1090Wave"
		else
			basename = "zxRise1090Mx"
		endif
	endif
	if (stringmatch(compare, "Interval"))
		if (StatNth == 0)
			basename = "zIntervalWave"
		else
			basename = "zxIntervalMx"
		endif
	endif
	
	ControlInfo popup0
	ana1 = basename+S_value
	ControlInfo popup1
	ana2 = basename+S_value
	
	Print StatNth, ana1, ana2
	if (StatNth == 0)
		Duplicate/O $ana1, statwave1
		Duplicate/O $ana2, statwave2
	else
		variable len
		len = DimSize($ana1, 1)
		Make/O/n=(len) statwave1
		wave ana1w = $ana1
		statwave1 = ana1w[StatNth-1][p]
		sort statwave1,statwave1
		WaveStats/Q/M=1 statwave1
		DeletePoints V_npnts,V_numNaNs, statwave1

		len = DimSize($ana2, 1)
		Make/O/n=(len) statwave2		
		wave ana2w = $ana2
		statwave2 = ana2w[StatNth-1][p]
		sort statwave2,statwave2
		WaveStats/Q/M=1 statwave2
		DeletePoints V_npnts,V_numNaNs, statwave2	
	endif
	//Edit statwave1,statwave2
	
	ControlInfo check0
	if (V_Value)
		print " -----------------------------------------"
		print "T test ---------------------------------"
		StatsTTest statwave1,statwave2
		wave W_StatsTTest
		Print "P = ", W_StatsTTest[9]
	endif
	ControlInfo check1
	if (V_Value)
		print " ------------------------------------------"
		print "KS test --------------------------------"
		StatsKSTest statwave1,statwave2
	endif
	ControlInfo check2
	if (V_Value)
		print " ----------------------------------------------------------------"
		print "  Mann-Whitney Wilcoxon test -----------------------"
		StatsWilcoxonRankTest statwave1,statwave2
	endif
	Dowindow/K NewStatPanel
	Killvariables/Z StatNth
	KillStrings/Z NewStatPanelList
	//killwaves/z statwave1,statwave2
End


Function FindWhatThisWaveIsUsedFor(ww)
	wave ww
	String WindowList = WinList("*",";","WIN:1")
	Variable WinNum = ItemsInList(WindowList)
	variable i
	For (i = 0; i<WinNum;i+=1)
		String WindowName = StringFromList(i,WindowList)
		CheckDisplayed/W=$WindowName ww
		if (V_flag>0)
			print NameOfWave(ww) + " is used in "+WindowName
		endif
	Endfor
End

Function MakeBlankTextWaves()
	variable howmany
	string namestr
	prompt howmany, "How many text waves?"
	DoPrompt "Make text waves", howmany
	if (V_flag)
		abort
	endif
	variable i = 0
	do
		namestr = "txw"+num2str(i)
		make/o/t/n=0 $namestr
		if (i == 0)
			Edit $namestr
		else
			AppendToTable $namestr
		endif	
		i += 1
	while (i < howmany)
End

Function MoveAllControls(shift)//not used
	variable shift
	string AllControls = controlnamelist("")
	string AControl
	variable numControls = ItemsInList(AllControls)
	variable i = 0
	do
		AControl = StringFromList(i, AllControls)
		//print AControl
		ControlInfo $AControl
		//print V_top, V_left
		if (V_flag == 1)
			Button $AControl, pos={V_left,V_top + shift }
		elseif (V_flag == 6)
			Chart $AControl, pos={V_left,V_top + shift }
		elseif (V_flag == 2)
			CheckBox $AControl, pos={V_left,V_top + shift }
		elseif (V_flag == 12)
			CustomControl $AControl, pos={V_left,V_top + shift }
		elseif (V_flag == 9)
			GroupBox $AControl, pos={V_left,V_top + shift }
		elseif (V_flag == 11)
			ListBox $AControl, pos={V_left,V_top + shift/2 },size={V_Width,V_Height+shift/2}
			//ListBox $AControl, pos={V_left,V_top + shift}
		elseif (V_flag == 3)
			PopupMenu $AControl, pos={V_left,V_top + shift }
		elseif (V_flag == 5)
			SetVariable $AControl, pos={V_left,V_top + shift }
		elseif (V_flag == 7)
			Slider $AControl, pos={V_left,V_top + shift }
		elseif (V_flag == 8)
			TabControl $AControl, pos={V_left,V_top + shift }
		elseif (V_flag == 10)
			TitleBox $AControl, pos={V_left,V_top + shift }
		elseif (V_flag == 4)
			ValDisplay $AControl, pos={V_left,V_top + shift }
		endif
		i += 1
	while (i < numControls) 

End 


Function MixPlusAndMinusPanel()
	String/g MixResultpostfix
	variable/g mixinterval =2
	TaroSetFont()
	RefreshPostfixListOfResults()
	SVAR PostfixList

	if (WinType("MixResultsPanel")  > 0)
		DoWindow/F  MixResultsPanel
	else
		NewPanel/N=MixResultsPanel /W=(251,81,496,377) as "Mix results"
		PopupMenu popup0,pos={24,18},size={205,21},title="Select # 1"
		PopupMenu popup0,mode=1,bodyWidth= 120,popvalue="select a data set",value= #"PostfixList"
		PopupMenu popup1,pos={23,74},size={205,21},title="Select # 2"
		PopupMenu popup1,mode=1,bodyWidth= 120,popvalue="select a data set",value= #"PostfixList"
		Button button0,pos={72,257},size={50,20},proc=MixPlusAndMinusDo,title="OK"
		Button button1,pos={136,257},size={50,20},proc=CancelButtonTI,title="Cancel"
		SetVariable setvar1,pos={26,133},size={201,18},bodyWidth=100,title="New data set name:"
		SetVariable setvar1,value= MixResultpostfix
		TitleBox title1,pos={20,154},size={210,13},title="(The name will be the postfix of data waves.)"
		TitleBox title1,fSize=10,frame=0
		CheckBox check0,pos={120,48},size={107,14},title="negative amplitude",value= 0
		CheckBox check1,pos={120,104},size={107,14},title="negative amplitude",value= 0
		CheckBox check2,pos={56,197},size={162,14},title="Set max interval from #1 to #2"
		CheckBox check2,value= 0
		SetVariable setvar0,pos={142,219},size={76,18},bodyWidth=50,title="(ms)"
		SetVariable setvar0,limits={0,inf,1},value= mixinterval
	endif

End


Function MixPlusAndMinusDo(ctrlName) : ButtonControl
	String ctrlName	
	SVAR newpostfix = MixResultpostfix
	NVAR mixinterval
	ControlInfo /W=MixResultsPanel popup0
	if (stringmatch(S_Value,"select a data set"))
		abort "Select a data set"
	endif
	String origpostfix1 = S_Value
	ControlInfo /W=MixResultsPanel popup1
	if (stringmatch(S_Value,"select a data set"))
		abort "Select a data set"
	endif
	String origpostfix2 = S_Value
	
	variable pol1=1, pol2=1
	ControlInfo /W=MixResultsPanel check0
	if (V_Value)
		pol1 = -1
	endif
	ControlInfo /W=MixResultsPanel check1
	if (V_Value)
		pol2 = -1
	endif
	
	variable maxlimit = 0
	ControlInfo /W=MixResultsPanel check2
	if (V_Value)
		maxlimit = 1
	endif
		
	if (stringmatch(newpostfix,""))
		DoWindow/F MixResultsPanel
		abort "Enter a name for the data set."
	elseif (ItemsInList(WaveList("ParamWave"+newpostfix,";","TEXT:1,MAXCOLS:1,MAXLAYERS:1")))
		DoAlert 1, "Do you want to replace "+newpostfix+" ?"
		if (V_flag == 2)
			DoWindow/F MixResultsPanel
			abort
		else
			DoWindow/K MixResultsPanel
		endif
	else
		DoWindow/K MixResultsPanel
	endif
	
	Duplicate/O $("EventAmplitude"+origpostfix1), ampw1,ref1
	Duplicate/O $("EventAmplitude"+origpostfix2), ampw2,ref2
	Duplicate/O $("AreaAbs"+origpostfix1), areaw1
	Duplicate/O $("AreaAbs"+origpostfix2), areaw2
	Duplicate/O $("ParamWave"+origpostfix1), $("ParamWave"+newpostfix)//
	
	ref1=1
	ref2=2
	ampw1 *= pol1
	ampw2 *= pol2
	areaw1 *= pol1
	areaw2 *= pol2
	Concatenate/O/KILL {ref1,ref2}, refmix
	Concatenate/O/KILL {ampw1,ampw2}, $("EventAmplitude"+newpostfix)
	Concatenate/O/KILL {areaw1,areaw2}, $("AreaAbs"+newpostfix)
	Concatenate/O {$("Episode"+origpostfix1), $("Episode"+origpostfix2)},  $("Episode"+newpostfix)
	Concatenate/O {$("EventTime"+origpostfix1), $("EventTime"+origpostfix2)},  $("EventTime"+newpostfix)
	Concatenate/O {$("BaseTime"+origpostfix1), $("BaseTime"+origpostfix2)},  $("BaseTime"+newpostfix)
	Concatenate/O {$("EventYValue"+origpostfix1), $("EventYValue"+origpostfix2)},  $("EventYValue"+newpostfix)
	Concatenate/O {$("BaseYValue"+origpostfix1), $("BaseYValue"+origpostfix2)},  $("BaseYValue"+newpostfix)
	Concatenate/O {$("RiseTime2080"+origpostfix1), $("RiseTime2080"+origpostfix2)},  $("RiseTime2080"+newpostfix)
	Concatenate/O {$("RiseTime1090"+origpostfix1), $("RiseTime1090"+origpostfix2)},  $("RiseTime1090"+newpostfix)
	
	wave epiw = $("Episode"+newpostfix)
	wave timew = $("EventTime"+newpostfix)
	Duplicate/O epiw, seq1,seq2
	seq1 = p
	seq2 = p
	sort {epiw, timew}, seq1
	sort seq1,seq2
	
	sort seq2, epiw, timew, refmix
	sort seq2, $("EventAmplitude"+newpostfix),  $("AreaAbs"+newpostfix)
	sort seq2, $("BaseTime"+newpostfix), $("EventYValue"+newpostfix),  $("BaseYValue"+newpostfix)
	sort seq2, $("RiseTime2080"+newpostfix), $("RiseTime1090"+newpostfix)
	
	if (WaveExists($("DecayTau"+origpostfix1)) && WaveExists($("DecayTau"+origpostfix2)))
		Concatenate/O {$("DecayTau"+origpostfix1), $("DecayTau"+origpostfix2)},  $("DecayTau"+newpostfix)
		sort seq2, $("DecayTau"+newpostfix)
	endif
	if (WaveExists($("DecayY0"+origpostfix1)) && WaveExists($("DecayY0"+origpostfix2)))
		Concatenate/O {$("DecayY0"+origpostfix1), $("DecayY0"+origpostfix2)},  $("DecayY0"+newpostfix)
		sort seq2,  $("DecayY0"+newpostfix)
	endif
	if (WaveExists($("DecayA"+origpostfix1)) && WaveExists($("DecayA"+origpostfix2)))
		Concatenate/O {$("DecayA"+origpostfix1), $("DecayA"+origpostfix2)},  $("DecayA"+newpostfix)
		sort seq2, $("DecayA"+newpostfix)
	endif
	if (WaveExists($("Y0d"+origpostfix1)) && WaveExists($("Y0d"+origpostfix2)))
		Concatenate/O {$("Y0d"+origpostfix1), $("Y0d"+origpostfix2)},  $("Y0d"+newpostfix)
		sort seq2,  $("Y0d"+newpostfix)
	endif
	if (WaveExists($("DecayA1"+origpostfix1)) && WaveExists($("DecayA1"+origpostfix2)))
		Concatenate/O {$("DecayA1"+origpostfix1), $("DecayA1"+origpostfix2)},  $("DecayA1"+newpostfix)
		sort seq2, $("DecayA1"+newpostfix)
	endif
	if (WaveExists($("DecayTau1"+origpostfix1)) && WaveExists($("DecayTau1"+origpostfix2)))
		Concatenate/O {$("DecayTau1"+origpostfix1), $("DecayTau1"+origpostfix2)},  $("DecayTau1"+newpostfix)
		sort seq2,  $("DecayTau1"+newpostfix)
	endif
	if (WaveExists($("DecayA2"+origpostfix1)) && WaveExists($("DecayA2"+origpostfix2)))
		Concatenate/O {$("DecayA2"+origpostfix1), $("DecayA2"+origpostfix2)},  $("DecayA2"+newpostfix)
		sort seq2,  $("DecayA2"+newpostfix)
	endif
	if (WaveExists($("DecayTau2"+origpostfix1)) && WaveExists($("DecayTau2"+origpostfix2)))
		Concatenate/O {$("DecayTau2"+origpostfix1), $("DecayTau2"+origpostfix2)},  $("DecayTau2"+newpostfix)
		sort seq2, $("DecayTau2"+newpostfix)
	endif
	if (WaveExists($("DecayTauM"+origpostfix1)) && WaveExists($("DecayTauM"+origpostfix2)))
		Concatenate/O {$("DecayTauM"+origpostfix1), $("DecayTauM"+origpostfix2)},  $("DecayTauM"+newpostfix)
		sort seq2,   $("DecayTauM"+newpostfix)
	endif
	
	if (maxlimit)
		variable reflen = numpnts(refmix) 
		Make/O/N=(reflen) keepw=Nan
		variable i=0
		do
			if ((refmix[i] == 1)&&(refmix[i+1]==2)&&(timew[i+1]-timew[i] < mixinterval)&&(epiw[i]==epiw[i+1]))
				keepw[i] = 1
				keepw[i+1]=1
				i += 1
			endif
			i += 1
		while (i < reflen - 1)
		DeleteNanPoints(keepw, timew)
		DeleteNanPoints(keepw, epiw)
		DeleteNanPoints(keepw, $("EventAmplitude"+newpostfix))
		DeleteNanPoints(keepw, $("AreaAbs"+newpostfix))
		DeleteNanPoints(keepw, $("BaseTime"+newpostfix))
		DeleteNanPoints(keepw, $("EventYValue"+newpostfix))
		DeleteNanPoints(keepw, $("BaseYValue"+newpostfix))
		DeleteNanPoints(keepw, $("RiseTime2080"+newpostfix))
		DeleteNanPoints(keepw, $("RiseTime1090"+newpostfix))

		if (WaveExists($("DecayTau"+newpostfix)))
			DeleteNanPoints(keepw, $("DecayTau"+newpostfix))
		endif
		if (WaveExists($("DecayY0"+newpostfix)))
			DeleteNanPoints(keepw, $("DecayY0"+newpostfix))
		endif
		if (WaveExists($("DecayA"+newpostfix)))
			DeleteNanPoints(keepw, $("DecayA"+newpostfix))
		endif
		if (WaveExists($("Y0d"+newpostfix)))
			DeleteNanPoints(keepw, $("Y0d"+newpostfix))
		endif
		if (WaveExists($("DecayA1"+newpostfix)))
			DeleteNanPoints(keepw, $("DecayA1"+newpostfix))
		endif
		if (WaveExists($("DecayTau1"+newpostfix)))
			DeleteNanPoints(keepw, $("DecayTau1"+newpostfix))
		endif
		if (WaveExists($("DecayA2"+newpostfix)))
			DeleteNanPoints(keepw, $("DecayA2"+newpostfix))
		endif
		if (WaveExists($("DecayTau2"+newpostfix)))
			DeleteNanPoints(keepw, $("DecayTau2"+newpostfix))
		endif
		if (WaveExists($("DecayTauM"+newpostfix)))
			DeleteNanPoints(keepw, $("DecayTauM"+newpostfix))
		endif
	
	endif
		
	killwaves/z seq1,seq2,refmix,keepw
	print "Mix results: Made "+newpostfix+" from "+ origpostfix1+" and "+origpostfix2
End

Function DeleteNanPoints(refw, w)
	wave refw
	wave w
	// a point of w will be deleted if its corresponding point of refw is Nan.
	// refw will not be affected. 
	Duplicate/O refw, numw
	numw = p
	sort {refw,numw} w,numw
	wavestats/Q/M=1 refw
	Deletepoints V_npnts, V_numNans,w,numw
	sort numw,w
	killwaves/z numw
End

////

//Function CombineResultsPanel()
//	String/g CombineResultsPostfix
//	variable/g CombineDTFrom = 0, CombineDTTo = 0
//	TaroSetFont()
//	RefreshPostfixListOfResults()
//	SVAR PostfixList
//
//	if (WinType("CombineResultsPanel")  > 0)
//		DoWindow/F  CombineResultsPanel
//	else
//		NewPanel/N=CombineResultsPanel /W=(250,80,250+280,80+350) as "Combine results"
//		PopupMenu popup0,pos={58,30},size={171,20},bodyWidth=120,title="Select # 1"
//		PopupMenu popup0,mode=1,popvalue="select a data set",value= #"PostfixList"
//		PopupMenu popup1,pos={58,80},size={171,20},bodyWidth=120,title="Select # 2"
//		PopupMenu popup1,mode=1,popvalue="select a data set",value= #"PostfixList"
//		Button button0,pos={93,315},size={50,20},proc=CombineResultsDo,title="OK"
//		Button button1,pos={157,315},size={50,20},proc=CancelButtonTI,title="Cancel"
//		SetVariable setvar1,pos={30,270},size={201,18},bodyWidth=100,title="New data set name:"
//		SetVariable setvar1,value= CombineResultsPostfix
//		TitleBox title1,pos={30,291},size={218,13},title="(This name will be the postfix of new data set.)"
//		TitleBox title1,fSize=10,frame=0
//		CheckBox check0,pos={160,57},size={68,14},title="invert sign",value= 0
//		CheckBox check1,pos={160,106},size={68,14},title="invert sign",value= 0
//		PopupMenu popup2,pos={30,155},size={98,20},bodyWidth=80,title="but"
//		PopupMenu popup2,mode=1,popvalue="delete",value= #"\"delete;keep only\""
//		TitleBox title2,pos={30,134},size={144,14},title="Combine two data sets above"
//		TitleBox title2,fSize=11,frame=0
//		PopupMenu popup3,pos={126,155},size={106,20},bodyWidth=100,title=" "
//		PopupMenu popup3,mode=1,popvalue="#1 events",value= #"\"#1 events;#2 events;both #1 & #2\""
//		TitleBox title3,pos={30,189},size={196,14},title="if the interval (dT) between #1 and #2 is "
//		TitleBox title3,fSize=11,frame=0
//		SetVariable setvar2,pos={30,211},size={122,18},bodyWidth=50,title="between (ms)"
//		SetVariable setvar2,limits={-inf,inf,1},value= CombineDTFrom
//		SetVariable setvar3,pos={160,211},size={72,18},bodyWidth=50,title="and"
//		SetVariable setvar3,limits={-inf,inf,1},value= CombineDTTo
//		TitleBox title4,pos={30,234},size={45,14},title="inclusive, where dT = T#1 - T#2.",fSize=11,frame=0
//		TitleBox title5,pos={10,0},size={45,14},title="Combining two detection results from the same traces.",fSize=10,frame=0
//		GroupBox group0,pos={15,127},size={242,130}
//	endif
//
//End
//
//
//Function CombineResultsDo(ctrlName) : ButtonControl
//	String ctrlName	
//	SVAR newpostfix = CombineResultsPostfix
//	NVAR mixinterval
//	ControlInfo /W=CombineResultsPanel popup0
//	if (stringmatch(S_Value,"select a data set"))
//		abort "Select a data set"
//	endif
//	String origpostfix1 = S_Value
//	ControlInfo /W=CombineResultsPanel popup1
//	if (stringmatch(S_Value,"select a data set"))
//		abort "Select a data set"
//	endif
//	String origpostfix2 = S_Value
//	
//	variable pol1=1, pol2=1
//	ControlInfo /W=CombineResultsPanel check0
//	if (V_Value)
//		pol1 = -1
//	endif
//	ControlInfo /W=CombineResultsPanel check1
//	if (V_Value)
//		pol2 = -1
//	endif
//	
////	variable maxlimit = 0
////	ControlInfo /W=CombineResultsPanel check2
////	if (V_Value)
////		maxlimit = 1
////	endif
//		
//	if (stringmatch(newpostfix,""))
//		DoWindow/F CombineResultsPanel
//		abort "Enter a name for the data set."
//	elseif (ItemsInList(WaveList("ParamWave"+newpostfix,";","TEXT:1,MAXCOLS:1,MAXLAYERS:1")))
//		DoAlert 1, "Do you want to replace "+newpostfix+" ?"
//		if (V_flag == 2)
//			DoWindow/F CombineResultsPanel
//			abort
//		else
//			DoWindow/K CombineResultsPanel
//		endif
//	else
//		DoWindow/K CombineResultsPanel
//	endif
//	
//	Duplicate/O $("EventAmplitude"+origpostfix1), ampw1,ref1
//	Duplicate/O $("EventAmplitude"+origpostfix2), ampw2,ref2
//	Duplicate/O $("AreaAbs"+origpostfix1), areaw1
//	Duplicate/O $("AreaAbs"+origpostfix2), areaw2
//	Duplicate/O $("ParamWave"+origpostfix1), $("ParamWave"+newpostfix)//
//	
//	ref1=1
//	ref2=2
//	ampw1 *= pol1
//	ampw2 *= pol2
//	areaw1 *= pol1
//	areaw2 *= pol2
//	Concatenate/O/KILL {ref1,ref2}, refmix
//	Concatenate/O/KILL {ampw1,ampw2}, $("EventAmplitude"+newpostfix)
//	Concatenate/O/KILL {areaw1,areaw2}, $("AreaAbs"+newpostfix)
//	Concatenate/O {$("Episode"+origpostfix1), $("Episode"+origpostfix2)},  $("Episode"+newpostfix)
//	Concatenate/O {$("EventTime"+origpostfix1), $("EventTime"+origpostfix2)},  $("EventTime"+newpostfix)
//	Concatenate/O {$("BaseTime"+origpostfix1), $("BaseTime"+origpostfix2)},  $("BaseTime"+newpostfix)
//	Concatenate/O {$("EventYValue"+origpostfix1), $("EventYValue"+origpostfix2)},  $("EventYValue"+newpostfix)
//	Concatenate/O {$("BaseYValue"+origpostfix1), $("BaseYValue"+origpostfix2)},  $("BaseYValue"+newpostfix)
//	Concatenate/O {$("RiseTime2080"+origpostfix1), $("RiseTime2080"+origpostfix2)},  $("RiseTime2080"+newpostfix)
//	Concatenate/O {$("RiseTime1090"+origpostfix1), $("RiseTime1090"+origpostfix2)},  $("RiseTime1090"+newpostfix)
//
//	variable reflen = numpnts(refmix) 	
//	wave epiw = $("Episode"+newpostfix)
//	wave timew = $("EventTime"+newpostfix)
//	//Duplicate/O epiw, seq1,seq2
//	Make/O/N=(reflen) seq1,seq2
//	seq1 = p
//	seq2 = p
//	sort {epiw, timew}, seq1
//	sort seq1,seq2
//	
//	sort seq2, epiw, timew, refmix
//	sort seq2, $("EventAmplitude"+newpostfix),  $("AreaAbs"+newpostfix)
//	sort seq2, $("BaseTime"+newpostfix), $("EventYValue"+newpostfix),  $("BaseYValue"+newpostfix)
//	sort seq2, $("RiseTime2080"+newpostfix), $("RiseTime1090"+newpostfix)
//	
//	if (WaveExists($("DecayTau"+origpostfix1)) && WaveExists($("DecayTau"+origpostfix2)))
//		Concatenate/O {$("DecayTau"+origpostfix1), $("DecayTau"+origpostfix2)},  $("DecayTau"+newpostfix)
//		sort seq2, $("DecayTau"+newpostfix)
//	endif
//	if (WaveExists($("DecayY0"+origpostfix1)) && WaveExists($("DecayY0"+origpostfix2)))
//		Concatenate/O {$("DecayY0"+origpostfix1), $("DecayY0"+origpostfix2)},  $("DecayY0"+newpostfix)
//		sort seq2,  $("DecayY0"+newpostfix)
//	endif
//	if (WaveExists($("DecayA"+origpostfix1)) && WaveExists($("DecayA"+origpostfix2)))
//		Concatenate/O {$("DecayA"+origpostfix1), $("DecayA"+origpostfix2)},  $("DecayA"+newpostfix)
//		sort seq2, $("DecayA"+newpostfix)
//	endif
//	if (WaveExists($("Y0d"+origpostfix1)) && WaveExists($("Y0d"+origpostfix2)))
//		Concatenate/O {$("Y0d"+origpostfix1), $("Y0d"+origpostfix2)},  $("Y0d"+newpostfix)
//		sort seq2,  $("Y0d"+newpostfix)
//	endif
//	if (WaveExists($("DecayA1"+origpostfix1)) && WaveExists($("DecayA1"+origpostfix2)))
//		Concatenate/O {$("DecayA1"+origpostfix1), $("DecayA1"+origpostfix2)},  $("DecayA1"+newpostfix)
//		sort seq2, $("DecayA1"+newpostfix)
//	endif
//	if (WaveExists($("DecayTau1"+origpostfix1)) && WaveExists($("DecayTau1"+origpostfix2)))
//		Concatenate/O {$("DecayTau1"+origpostfix1), $("DecayTau1"+origpostfix2)},  $("DecayTau1"+newpostfix)
//		sort seq2,  $("DecayTau1"+newpostfix)
//	endif
//	if (WaveExists($("DecayA2"+origpostfix1)) && WaveExists($("DecayA2"+origpostfix2)))
//		Concatenate/O {$("DecayA2"+origpostfix1), $("DecayA2"+origpostfix2)},  $("DecayA2"+newpostfix)
//		sort seq2,  $("DecayA2"+newpostfix)
//	endif
//	if (WaveExists($("DecayTau2"+origpostfix1)) && WaveExists($("DecayTau2"+origpostfix2)))
//		Concatenate/O {$("DecayTau2"+origpostfix1), $("DecayTau2"+origpostfix2)},  $("DecayTau2"+newpostfix)
//		sort seq2, $("DecayTau2"+newpostfix)
//	endif
//	if (WaveExists($("DecayTauM"+origpostfix1)) && WaveExists($("DecayTauM"+origpostfix2)))
//		Concatenate/O {$("DecayTauM"+origpostfix1), $("DecayTauM"+origpostfix2)},  $("DecayTauM"+newpostfix)
//		sort seq2,   $("DecayTauM"+newpostfix)
//	endif
//
//
//	// selection part 
//	Make/O/N=(reflen) keepw=Nan
//	variable i=0
//	do
//		if ((refmix[i] == 1)&&(refmix[i+1]==2)&&(timew[i+1]-timew[i] < mixinterval)&&(epiw[i]==epiw[i+1]))
//			keepw[i] = 1
//			keepw[i+1]=1
//			i += 1
//		endif
//		i += 1
//	while (i < reflen - 1)
//	DeleteNanPoints(keepw, timew)
//	DeleteNanPoints(keepw, epiw)
//	DeleteNanPoints(keepw, $("EventAmplitude"+newpostfix))
//	DeleteNanPoints(keepw, $("AreaAbs"+newpostfix))
//	DeleteNanPoints(keepw, $("BaseTime"+newpostfix))
//	DeleteNanPoints(keepw, $("EventYValue"+newpostfix))
//	DeleteNanPoints(keepw, $("BaseYValue"+newpostfix))
//	DeleteNanPoints(keepw, $("RiseTime2080"+newpostfix))
//	DeleteNanPoints(keepw, $("RiseTime1090"+newpostfix))
//
//	if (WaveExists($("DecayTau"+newpostfix)))
//		DeleteNanPoints(keepw, $("DecayTau"+newpostfix))
//	endif
//	if (WaveExists($("DecayY0"+newpostfix)))
//		DeleteNanPoints(keepw, $("DecayY0"+newpostfix))
//	endif
//	if (WaveExists($("DecayA"+newpostfix)))
//		DeleteNanPoints(keepw, $("DecayA"+newpostfix))
//	endif
//	if (WaveExists($("Y0d"+newpostfix)))
//		DeleteNanPoints(keepw, $("Y0d"+newpostfix))
//	endif
//	if (WaveExists($("DecayA1"+newpostfix)))
//		DeleteNanPoints(keepw, $("DecayA1"+newpostfix))
//	endif
//	if (WaveExists($("DecayTau1"+newpostfix)))
//		DeleteNanPoints(keepw, $("DecayTau1"+newpostfix))
//	endif
//	if (WaveExists($("DecayA2"+newpostfix)))
//		DeleteNanPoints(keepw, $("DecayA2"+newpostfix))
//	endif
//	if (WaveExists($("DecayTau2"+newpostfix)))
//		DeleteNanPoints(keepw, $("DecayTau2"+newpostfix))
//	endif
//	if (WaveExists($("DecayTauM"+newpostfix)))
//		DeleteNanPoints(keepw, $("DecayTauM"+newpostfix))
//	endif
//			
//	killwaves/z seq1,seq2,refmix,keepw
//	print "Combined "+ origpostfix1+" and "+origpostfix2 +" to make "+newpostfix
//End


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Legacy part


//////////////////////////////////////////////////////////////////////////////////
//// Unpaired T test for the result summary
Function QuickTtest(ave1, sem1, n1, ave2, sem2, n2)
	// Return P value of Unpaired T test, assuming unequal variances 
	variable ave1, sem1, n1, ave2, sem2, n2
	variable t0, DegFree, P
	t0 = abs(ave1-ave2)/sqrt(sem1^2+sem2^2)
	DegFree = (sem1^2+sem2^2)^2/(sem1^4/(n1-1)+sem2^4/(n2-1))
	P = 1-StudentA(t0, DegFree)	// StudentA returns 1-alpha
	// print DegFree
	// print t0
	// print P
	return P	
End

/////////////////////// Make a custom graph from a specified points of a wave
Function MakeCustomGraphs()
	MakeListForSpecialGraph()
	SVAR  ListForSpecialGraph1
	SVAR  ListForSpecialGraph2
	variable/g graphXfrom, graphYfrom
	if (exists("numpntgraph"))
		NVAR numpntgraph
	else
		Variable/g numpntgraph = 1
	endif

	TaroSetFont()
	if (WinType("WaveSelectionForGraph")  > 0)
		DoWindow/F  WaveSelectionForGraph
	else
		NewPanel /N = WaveSelectionForGraph /W=(388,154,608,459) as getDataFolder(0)+":forGraph"
		PopupMenu popup0,pos={25,30},size={156,23},proc=Value1Selected,title="Value"
		PopupMenu popup0,mode=1,bodyWidth= 120,popvalue="select wave",value= #"ListForSpecialGraph1"
		PopupMenu popup1,pos={22,60},size={159,23},title="S.E.M.",value= #"ListForSpecialGraph2"
		PopupMenu popup1,mode=1,bodyWidth= 120,popvalue="select wave"//, disable = 2
		Button button0,pos={52,261},size={50,20},proc=DrawCustomGraphs,title="OK"
		Button button1,pos={130,261},size={50,20},proc=CancelButtonTI,title="Cancel"
		SetVariable setvar0,pos={58,157},size={122,18},title="X: from point"
		SetVariable setvar0,value= graphXfrom,bodyWidth= 50,limits={0,inf,1}
		SetVariable setvar1,pos={33,130},size={147,18},title="number of points"
		SetVariable setvar1,value= numpntgraph,bodyWidth= 50,limits={1,inf,1}
		SetVariable setvar2,pos={58,184},size={122,18},title="Y: from point"
		SetVariable setvar2,value= graphYfrom,bodyWidth= 50,limits={0,inf,1}
		CheckBox check0,pos={53,214},size={128,15},title="Append to top graph",value= 0
		CheckBox check1,pos={69,94},size={107,15},title="popup all waves",value= 0,proc=SpecialGraphCheck
		TitleBox title0,pos={185,64},size={21,13},title="autofill",frame=0
	endif
End

Function Value1Selected(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	variable popNum
	String popStr
	
	string post
	String str1,str2
	variable m1=-1
	SVAR AllWaveList =  ListForSpecialGraph2

	sscanf popStr, "value%s",post
	if (V_flag ==1)
		str1 ="sem"+post
		str2 ="n"+post
		m1= WhichListItem(str1,AllWaveList)+1
	endif
	
	if (m1>0)
		PopupMenu popup1,win=WaveSelectionForGraph,mode=m1
	endif
End

Function DrawCustomGraphs(ctrlName) : ButtonControl
	String ctrlName
//	NVAR  graphXfrom, graphXto, graphYfrom, graphYto
	NVAR  graphXfrom, graphYfrom,numpntgraph
	Variable graphXto = graphXfrom+numpntgraph-1
	Variable graphYto = graphYfrom+numpntgraph-1
	String XValueWaveStr,XSemWaveStr,YValueWaveStr,YSemWaveStr
	String OriginalValueWaveStr,OriginalSemWaveStr
	String GraphWindowList
	variable appendFlag

	ControlInfo/W=WaveSelectionForGraph popup0
	OriginalValueWaveStr = S_Value
	XValueWaveStr = "graph_"+S_Value+"_"+num2str(graphXfrom)+"_"+num2str(graphXto)
	YValueWaveStr = "graph_"+S_Value+"_"+num2str(graphYfrom)+"_"+num2str(graphYto)
	ControlInfo/W=WaveSelectionForGraph popup1
	OriginalSemWaveStr = S_Value
	XSemWaveStr = "graph_"+S_Value+"_"+num2str(graphXfrom)+"_"+num2str(graphXto)
	YSemWaveStr = "graph_"+S_Value+"_"+num2str(graphYfrom)+"_"+num2str(graphYto)
	ControlInfo/W=WaveSelectionForGraph check0
	appendFlag = V_Value
	
	Duplicate/O/R=[graphXfrom, graphXto] $OriginalValueWaveStr, $XValueWaveStr
	Duplicate/O/R=[graphXfrom, graphXto] $OriginalSemWaveStr, $XSemWaveStr
	Duplicate/O/R=[graphYfrom, graphYto] $OriginalValueWaveStr, $YValueWaveStr
	Duplicate/O/R=[graphYfrom, graphYto] $OriginalSemWaveStr, $YSemWaveStr
	
	
	Wave XValueWave = $XValueWaveStr
	Wave XSemWave = $XSemWaveStr
	Wave YValueWave =  $YValueWaveStr
	Wave YSemWave =  $YSemWaveStr

	Preferences/Q 0
	if (appendFlag)
		GraphWindowList = WinList("*",";","WIN:1")
		if (ItemsInList(GraphWindowList)==0)
			abort "No graphs"
		endif
		String topgraph = StringFromList(0,GraphWindowList)
		AppendToGraph/W = $topgraph YValueWave vs XValueWave	
	else
		Display YValueWave vs XValueWave
	endif
	
	ErrorBars $YValueWaveStr, XY,wave=(XSemWave,XSemWave),wave=(YSemWave,YSemWave)
	ModifyGraph mode($YValueWaveStr)=4,marker($YValueWaveStr)=18
	DoWindow/K WaveSelectionForGraph
End

Function MakeListForSpecialGraph()
	String/g ListForSpecialGraph1, ListForSpecialGraph2
	String AllWaves
	ControlInfo/W=WaveSelectionForGraph check1
	if (V_Value)
		AllWaves = WaveList("*",";","TEXT:0,MAXCOLS:1,MAXLAYERS:1") //only 1D waves
		AllWaves = RemoveFromList ("AllWave", AllWaves)
		AllWaves = RemoveFromList ("WaveSel", AllWaves)
		AllWaves = RemoveFromList ("valuelabels", AllWaves)
		AllWaves = RemoveFromList (ListMatch(AllWaves, "z*"), AllWaves)
		ListForSpecialGraph1 = AllWaves
		ListForSpecialGraph2 = AllWaves
	else	
		ListForSpecialGraph1 =  WaveList("value*",";","TEXT:0,MAXCOLS:1,MAXLAYERS:1")
		ListForSpecialGraph2 =  WaveList("sem*",";","TEXT:0,MAXCOLS:1,MAXLAYERS:1")
	endif
	
	ListForSpecialGraph1 = SortList (ListForSpecialGraph1, ";",16)
	ListForSpecialGraph2 = SortList (ListForSpecialGraph2, ";",16)
End

Function SpecialGraphCheck(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
//	ControlInfo/W=WaveSelectionForGraph popup1
	if (checked)
		TitleBox title0,title=" "		
		//PopupMenu popup1,disable =0
//		if (stringmatch(S_Value,"auto"))
//			PopupMenu popup1, popvalue="select wave"
//		endif
	else
		TitleBox title0,title="autofill"		
//		if (stringmatch(S_Value,"select wave"))
//			PopupMenu popup1,popvalue="auto"
//		endif
		//PopupMenu popup1,disable =2
	endif
	MakeListForSpecialGraph()
End

/////////////////////////////////////////
Function ShowCrosscorrelogramPanel()
	string/g CrossWaves
	if (exists("BinSizeCross"))
		NVAR BinSizeCross
	else
		variable/g BinSizeCross = 5
	endif
	if (exists("BinNumCross"))
		NVAR BinNumCross
	else
		variable/g BinNumCross = 51
	endif
	if (exists("LagFrom"))
		NVAR LagFrom
	else
		variable/g LagFrom = -5
	endif
	if (exists("LagTo"))
		NVAR LagTo
	else
		variable/g LagTo = 5
	endif
	if (exists("TrendBinCross"))
		NVAR TrendBinCross
	else
		variable/g TrendBinCross = 5000
	endif
	
	variable/g CrossCorMode =2
	string/g CrossCorWaves
	MakeCrosscorrelogramWaveList()
	CrossWaves = SortList (CrossWaves, ";",16)

	if (WinType("CrosscorrelogramPanel") >0)
		DoWindow/F CrosscorrelogramPanel
	else		
		TaroSetFont()
		NewPanel /W=(197,81,697,406)/N = CrosscorrelogramPanel	
		DrawLine 279,27,279,274
		PopupMenu popup0,pos={25,117},size={222,22},bodyWidth=180,title="Wave 1"
		PopupMenu popup0,mode=1,popvalue="select wave",value= #"CrossCorWaves"
		PopupMenu popup1,pos={25,157},size={222,22},bodyWidth=180,title="Wave 2"
		PopupMenu popup1,mode=1,popvalue="select wave",value= #"CrossCorWaves"
		CheckBox check0,pos={42,33},size={156,14},title="From Event Detection results"
		CheckBox check0,value= 0,proc=ShowCrosscorrelogramCheckbox
		CheckBox check1,pos={42,57},size={187,14},title="From FurtherAnalysis Time range 1"
		CheckBox check1,value= 0,proc=ShowCrosscorrelogramCheckbox
		CheckBox check2,pos={42,81},size={187,14},title="From FurtherAnalysis Time range 2"
		CheckBox check2,value= 1,proc=ShowCrosscorrelogramCheckbox
		SetVariable setvar0,pos={69,207},size={134,18},bodyWidth=60,title="Bin width (ms)"
		SetVariable setvar0,limits={0,inf,0.1},value= BinSizeCross
		SetVariable setvar1,pos={85,231},size={118,18},bodyWidth=60,title="Bin number"
		SetVariable setvar1,limits={0,inf,1},value= BinNumCross
		Button button0,pos={37,290},size={80,20},title="OK",proc=MakeCrosscorrelogram
		Button button1,pos={141,290},size={80,20},title="Cancel",proc=CancelButtonTI
		CheckBox check3,pos={110,260},size={89,14},title="Show Z-score",value= 0

		CheckBox check4,pos={301,33},size={131,14},title="Add sliding window analysis"
		CheckBox check4,value= 0
		SetVariable setvar2,pos={300,60},size={153,18},bodyWidth=60,title="Window from (ms)"
		SetVariable setvar2,value= LagFrom
		SetVariable setvar3,pos={355,90},size={98,18},bodyWidth=60,title="to (ms)"
		SetVariable setvar3,value= LagTo
		TitleBox title0,pos={300,116},size={136,14},title="Window = T(wave1) - T(wave2)"
		TitleBox title0,frame=0
		SetVariable setvar4,pos={297,142},size={156,18},bodyWidth=60,title="Time trend bin (ms)"
		SetVariable setvar4,limits={0,inf,1},value= TrendBinCross
	endif
End

Function MakeCrosscorrelogramWaveList()
	NVAR CrossCorMode
	SVAR CrossCorWaves
	string wavenamestring
	if (CrossCorMode == 0)
		CrossCorWaves = WaveList("EventTime*",";","TEXT:0,MAXCOLS:1,MAXLAYERS:1") //only 1D waves
		wavenamestring = WaveList("BaseTime*",";","TEXT:0,MAXCOLS:1,MAXLAYERS:1") //only 1D waves
		CrossCorWaves += wavenamestring
		CrossCorWaves = RemoveFromList ("EventTime", CrossCorWaves)
		CrossCorWaves = RemoveFromList ("BaseTime", CrossCorWaves)
	elseif (CrossCorMode == 1)
		CrossCorWaves = WaveList("ExEventTime*",";","TEXT:0,MAXCOLS:1,MAXLAYERS:1") //only 1D waves
		wavenamestring = WaveList("ExBaseTime*",";","TEXT:0,MAXCOLS:1,MAXLAYERS:1") //only 1D waves
		CrossCorWaves += wavenamestring
	elseif (CrossCorMode == 2)
		CrossCorWaves = WaveList("zLatencyWave*",";","TEXT:0,MAXCOLS:1,MAXLAYERS:1") //only 1D waves
	endif	
	
End

Function ShowCrosscorrelogramCheckbox(ctrlName,ctrlValue) : CheckBoxControl
	String ctrlName
	variable ctrlValue
	NVAR CrossCorMode
	if (stringmatch(ctrlName, "check0"))
		CheckBox check0,value= 1
		CheckBox check1,value= 0
		CheckBox check2,value= 0
		CrossCorMode = 0
	elseif  (stringmatch(ctrlName, "check1"))
		CheckBox check0,value= 0
		CheckBox check1,value= 1
		CheckBox check2,value= 0
		CrossCorMode = 1
	elseif  (stringmatch(ctrlName, "check2"))
		CheckBox check0,value= 0
		CheckBox check1,value= 0
		CheckBox check2,value= 1
		CrossCorMode = 2
	endif
	MakeCrosscorrelogramWaveList()
	PopupMenu popup0,mode=1,popvalue="select wave"
	PopupMenu popup1,mode=1,popvalue="select wave"
End

Function MakeCrosscorrelogram(ctrlName) : ButtonControl
	String ctrlName
	NVAR CrossCorMode
	NVAR BinSizeCross, BinNumCross
	NVAR LagFrom, LagTo, TrendBinCross
	string wave1string,wave2string
	string epi1string,epi2string
	string param1string,param2string
	string selectedMxstring1,selectedMxstring2
	variable ZscoreFlag,TimeTrendFlag
	ControlInfo/W= CrosscorrelogramPanel check3
	if (V_Value)
		ZscoreFlag = 1
	else
		ZscoreFlag = 0
	endif
	ControlInfo/W= CrosscorrelogramPanel check4
	if (V_Value)
		TimeTrendFlag = 1
	else
		TimeTrendFlag = 0
	endif
	ControlInfo/W= CrosscorrelogramPanel popup0
	wave1string = S_Value
	ControlInfo/W= CrosscorrelogramPanel popup1
	wave2string = S_Value
	wave timewave1 = $wave1string
	wave timewave2 = $wave2string
	variable Tfrom1,Tto1,Tfrom2,Tto2,tracenum1,tracenum2
	if (CrossCorMode == 0)
		epi1string = ReplaceString("EventTime", wave1string, "Episode")
		epi2string = ReplaceString("EventTime", wave2string, "Episode")
		epi1string = ReplaceString("BaseTime", epi1string, "Episode")
		epi2string = ReplaceString("BaseTime", epi2string, "Episode")
		param1string =  ReplaceString("Episode", epi1string, "ParamWave")
		param2string =  ReplaceString("Episode", epi2string, "ParamWave")
		wave/T param1T = $param1string
		Tfrom1 = str2num(param1T[5])
		Tto1 = str2num(param1T[6])
		tracenum1 = numpnts(param1T) -10
		wave/T param2T = $param2string
		Tfrom2 = str2num(param2T[5])
		Tto2 = str2num(param2T[6])
		tracenum2 = numpnts(param2T) -10
	elseif (CrossCorMode == 1)
		epi1string = ReplaceString("ExEventTime", wave1string, "ExEpisode")
		epi2string = ReplaceString("ExEventTime", wave2string, "ExEpisode")
		epi1string = ReplaceString("ExBaseTime", epi1string, "ExEpisode")
		epi2string = ReplaceString("ExBaseTime", epi2string, "ExEpisode")
		param1string =  ReplaceString("ExEpisode", epi1string, "AnalysisParam")
		param2string =  ReplaceString("ExEpisode", epi2string, "AnalysisParam")
		selectedMxstring1 =  ReplaceString("ExEpisode", epi1string, "SelectedEpiMx")
		selectedMxstring2 =  ReplaceString("ExEpisode", epi2string, "SelectedEpiMx")
		wave param1 = $param1string
		Tfrom1 = param1[11]
		Tto1 = param1[12]
		wave/T Mx1T = $selectedMxstring1
		tracenum1 = DimSize(Mx1T, 0)
		wave param2 = $param2string
		Tfrom2 = param2[11]
		Tto2 = param2[12]
		wave/T Mx2T = $selectedMxstring2
		tracenum2 = DimSize(Mx2T, 0)
	elseif (CrossCorMode == 2)
		epi1string = ReplaceString("zLatencyWave", wave1string, "zEpisodeWave")
		epi2string = ReplaceString("zLatencyWave", wave2string, "zEpisodeWave")
		param1string =  ReplaceString("zEpisodeWave", epi1string, "AnalysisParam")
		param2string =  ReplaceString("zEpisodeWave", epi2string, "AnalysisParam")
		selectedMxstring1 =  ReplaceString("ExEpisode", epi1string, "SelectedEpiMx")
		selectedMxstring2 =  ReplaceString("ExEpisode", epi2string, "SelectedEpiMx")
		wave param1 = $param1string
		Tfrom1 = param1[21]
		Tto1 = param1[22]
		wave/T Mx1T = $selectedMxstring1
		tracenum1 = DimSize(Mx1T, 0)
		wave param2 = $param2string
		Tfrom2 = param2[21]
		Tto2 = param2[22]
		wave/T Mx2T = $selectedMxstring2
		tracenum2 = DimSize(Mx2T, 0)
	endif

	wave epiwave1 = $epi1string
	wave epiwave2 = $epi2string
//	edit epiwave1,timewave1,epiwave2,timewave2
	variable wWidth = BinSizeCross*BinNumCross
	variable wFrom = -0.5*wWidth
	variable wTo = 0.5*wWidth
	variable TrendNumCross = ceil((Tto2-Tfrom2)/TrendBinCross)
	
	Make/N=0/O w3, w4
	variable w3p = 0
	variable w1pnts = numpnts(epiwave1)
	variable w2pnts = numpnts(epiwave2)
	variable interval, k
	variable i = 0,test = 0
	do
		k = 0
		do
			if (epiwave1[k] == epiwave2[i])
//				test += 1
//				print k,i, epiwave1[k],epiwave2[i]
				interval = timewave1[k] - timewave2[i] // = Lag
				if ((interval> wFrom) && (interval< wTo))
					InsertPoints w3p,1, w3, w4
					w3[w3p] = interval
					w4[w3p] = timewave2[i]// added for trend analysis
					w3p += 1
					
				endif
//			elseif (epiwave1[k] > epiwave2[i])
//				print "break"
//				break
			endif
			k+=1
//			if (k== w1pnts)
//				print "k end"
//			endif
		while (k < w1pnts)
		i += 1
//		if (i == w2pnts)
//			print "i end"
//		endif
	while (i < w2pnts)
	string W_CrossStr=UniqueName("W_Cross",1,0)
	Make/N=(BinNumCross)/O $W_CrossStr
	wave W_Cross = $W_CrossStr
//	print "test ",test
	Histogram/B={wFrom,BinSizeCross,BinNumCross} w3,W_Cross
	duplicate/O W_Cross, $(W_CrossStr +"Norm")
	wave W_CrossNorm = $(W_CrossStr +"Norm")
	variable GraphYTop = round(WaveMax(W_Cross) * 1.4)
	
	variable Freq1 = 1000*w1pnts/tracenum1/(Tto1 - Tfrom1)
	variable Freq2 = 1000*w2pnts/tracenum2/(Tto2 - Tfrom2)
	variable RandMeanCount = Freq1*BinSizeCross/1000*w2pnts
					// or = Freq1*Freq2*(BinSizeCross/1000)*tracenum2*((Tto2 - Tfrom2)/1000)
	variable RandSD = sqrt(RandMeanCount)
	Make/O/N=2 $(W_CrossStr+"Mean"),$(W_CrossStr+"2SDp"),$(W_CrossStr+"2SDn")
	wave MeanW = $(W_CrossStr+"Mean")
	wave SDWp = $(W_CrossStr+"2SDp")
	wave SDWn = $(W_CrossStr+"2SDn")
	SetScale/I x, wFrom, wTo, MeanW,SDWp,SDWn
	MeanW = RandMeanCount
	SDWp = 2*RandSD + RandMeanCount
	SDWn = -2*RandSD + RandMeanCount
	Display/W=(310, 330,600,490)  W_Cross
	ModifyGraph mode=5
	ModifyGraph marker=10
	ModifyGraph rgb=(0,0,0)
	ModifyGraph msize=1
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	string anno =  "Lag = "+wave1string +" - "+wave2string
	TextBox/C/N=text0/F=0/A=MC/X=0/Y=50 anno
	if (ZscoreFlag)
		AppendToGraph   MeanW,SDWp,SDWn
		ModifyGraph lstyle[2]=3,lstyle[3]=3 
		Label left "Event number"
		Label bottom "Lag (ms)"
		SetAxis left,0,GraphYTop
		SetAxis/A bottom
		anno =  anno+"\r\\K(65280,0,0) mean (solid line) +- 2SD (dotted line)"
		TextBox/C/N=text0/F=0/A=MC/X=0/Y=50 anno
	
		W_CrossNorm -=  RandMeanCount
		W_CrossNorm /= RandSD
		Display/W=(600, 330,890,490)  W_CrossNorm
		ModifyGraph mode=5
		ModifyGraph marker=10
		ModifyGraph rgb=(0,0,0)
		ModifyGraph msize=1
		ModifyGraph hbFill=2
		ModifyGraph standoff=0
		Label left "Z-score"
		Label bottom "Lag (ms)"
		SetAxis/A
	endif
	print "wave1: ",wave1string, tracenum1,"traces, from",Tfrom1,"to",Tto1,"ms;",w1pnts,"events",";",Freq1,"Hz (average)."
	print "wave2: ",wave2string, tracenum2,"traces, from",Tfrom2,"to",Tto2,"ms;",w2pnts,"events",";",Freq2,"Hz (average)."
	print "Bin size",BinSizeCross, "ms; ","Randomized mean",RandMeanCount, ", SD",RandSD
	
	if (TimeTrendFlag)
		duplicate/O w3,w5 // w5=weight
		variable np = numpnts(w5)
		i = 0
		variable t
		do
			if ((w5[i] > LagFrom)&&(w5[i] < LagTo))
				w5[i] = 1
			else
				w5[i] = 0
			endif
			i += 1
		while (i < np)
		//LagFrom, LagTo, 
		Make/N=(TrendNumCross)/O $(W_CrossStr+"Trend")
		wave W_CrossTrend = $(W_CrossStr +"Trend")
		Histogram/B={Tfrom2,TrendBinCross,TrendNumCross}/W=w5 w4,W_CrossTrend
		Display/W=(10, 330,300,490)  W_CrossTrend
		ModifyGraph mode=5
		ModifyGraph marker=10
		ModifyGraph rgb=(0,0,0)
		ModifyGraph msize=1
		ModifyGraph hbFill=2
		ModifyGraph standoff=0
		Label left "Event number"
		Label bottom "Time (ms)"
		SetAxis/A
		print "Sliding window analysis:",sum(w5),"events are in the window,", LagFrom,"to",LagTo,"(ms)"
	endif
	//edit w3,w4,w5
	//print Tfrom2,TrendBinCross,TrendNumCross
	killwaves/z w3,w4,w5
	DoWindow/k CrosscorrelogramPanel
End
