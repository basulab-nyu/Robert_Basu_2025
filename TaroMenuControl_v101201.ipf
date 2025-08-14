#pragma rtGlobals=1		// Use modern global access method.
Menu "TaroTools"

		//"Ultima...", UltimaStart() //in "TaroUltima"
		
		"Load ABF...", LoadABF() // in "TaroABF"

		"Select waves...", TISelectWaves()
		
		"Event detection...", TaroEventDetection()

		"Further analysis...",  FurtherAnalysisShowPanel()
		
		Submenu "Statistics"
			"On Summary lists...", FurtherAnalysisSummaryStat()
		
			"More statistics...", NewStatPanelShow()
		end
		
		Submenu "More tools"
			"Cross-correlogram",ShowCrosscorrelogramPanel()
			
			"Special graph...",MakeCustomGraphs()
				
			"Merge tables...", MergeTables() 

			"Mix results...", MixPlusAndMinusPanel()
		end
		
		//"Panel Move Up", MoveAllControls(-90)
		
		//"Panel Move Down", MoveAllControls(90)

		Submenu "Burst analysis"
			"Burst transform...", BurstTransformPanelShow()
			
			"Burst Marking...", BurstMarkingPanelShow()
		end			

//		Submenu "More analysis"
//			"Find peaks from base time", FindPeakFromBaseTimeAll() 
//			
//			"Make blank text waves ...",MakeBlankTextWaves() 
//			
//			"Shuffle raws of table ...", ShuffleTable1() 
//			
//			"Print wave names of table", GetWaveNamesOfTable()
//			
//			"Event summary...", SelectWavesToAnalyse() // in "OldAnalysis" 
//		
//			"Quick wave t-test...", WaveQuickTtest() // in "OldAnalysis" 
//		
//			"Combine data sets...",CombineDataSets() // in "OldAnalysis" 
//		
//			"Random deletion...", RandomDeletion() //in "OldAnalysis"
//		end 
		
		Submenu "Shortcuts"
			"Event mask/4", EventMaskFromShortCut()
			"Previous event/5", PreviousEventFromShortCut()
			"Next event/6", NextEventFromShortCut()
			"Scroll to right/7", ScrollToLeftFromShortCut()
			"Scroll to right/8", ScrollToRightFromShortCut()
		end

		"-"

		"Help ", ShowTaroToolsHelp()
		"Check website", BrowseURL"https://sites.google.com/site/tarotoolsmember/"
		
		"-"
		Submenu "Graph tools" // in "TaroGrapher"
			"Spread traces...", SpreadTracesInGraph()
			"Set to auto and default", SetToAuto()
			"Remove axes",RemoveAxisStyle()
			"Show axes",ShowAxisStyle()
			"Graph size -fix",FixGraphsizeAsItIs()
			"Graph size -auto",FreeGraphsize()
			"Scale window size...",ScaleWindowSize(0)//call function from menu
			"Move window to top left",MoveWindowToTopLeft()
			"Merge front 2 graphs", MergeTopTwoGraphs()
//			"-"
//			"Adjust size", AdjustSizeOfGraph()
//			"Add X axis grid", AddGridToRaster()
//			"Add Y axis grid",AddYGridToRaster()
//			"Raster", RasterStyle()
//			"Amplitude trend", AmplitudeTrendStyle()
//			"Amplitude plot", AmplitudePlotStyle()
//			"Coloured Average", ColourAverageTraces()
//			"PST Histogram", HistogramStyle()
//			"Sample Traces", SampleTracesStyle()
//			"Amplitude Histogram", HistogramStyle2()
//			"Interval Histogram", HistogramStyle3()
//			"Small size 5 columns", AdjustSizeFor5Columns()
			"-"
			"Align graphs in layout", AlignAllGraphsInLayout()
			"Tile graphs in layout...", TileGraphsInLayouPanel()
		end
		
		Submenu "Folder cleaning"// in "TaroGrapher"
			"Save all graphs on layout...", SaveAllGraphsOnLayout()
			"Keep only layouts", KeepOnlyLayouts()
			"Clean up current folder", CleanUpCurrentFolder()
		end
		
		
//		"-"
//		"All stimulation", StimulationControlMain() //in "TaroStimControl""		
End


//////////////////////////////////////////////////////////////////////////////////
///////////////////////////	When "cancel" was clicked
Function CancelButtonTI(ctrlName) : ButtonControl 
	String ctrlName
	String TopPanelWiindow =StringFromList(0,WinList("*",";","WIN:64"))
	DoWindow/k $TopPanelWiindow
End
////////////////////////////////////////////////////////////////////////////////
///////////////////////////    Set default font for Mac OS
Function	TaroSetFont()
	DefaultGuiFont/Mac all= {"Arial", 11, 0}
	DefaultGuiFont/Win all= {"Arial", 11, 0}
End