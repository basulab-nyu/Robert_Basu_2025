#pragma rtGlobals=1		// Use modern global access method.

//////////////////////////////////////////////////////////////////////////////////
//// Spread traces

Function SpreadTracesInGraph()

	Variable/g	OffsetValueY
	Variable/g	OffsetValueX=0
	
	// Make sure top window is a graph	
	String		GraphList = WinList("*",";","WIN:1")
	if (ItemsInList(GraphList)==0)
		Abort "No graphs open."
	endif
	String/g		NameTop = StringFromList(0,GraphList)
	//Print "Spreading all traces in this graph:",NameTop
	DoWindow/F $NameTop
	
//	String/g		ListOfWaves = WaveList("*",";","WIN:"+NameTop)
	String/g		ListOfTraces = TraceNameList("", ";", 1)
	Variable	nWaves = ItemsInList(ListOfTraces)
	if (nWaves==0)// any use??
		Abort "Igor cannot find waves in this graph. Your choice of data folder may be wrong."
	endif

	// Find x axis range
	GetAxis/Q/W=$(NameTop) bottom
	Variable	x1 = V_min
	Variable	x2 = V_max
	
	// Find Y Max
	String	currTrace
	Variable	maxAmplitude = 0
	Variable	currAmplitude
	variable i = 0
	do
		currTrace = StringFromList(i,ListOfTraces)
		wave currWave = TraceNameToWaveRef("", currTrace)
		WaveStats/Q/R=(x1,x2) currWave
		currAmplitude = V_max-V_min
		if (maxAmplitude<currAmplitude)
			maxAmplitude = currAmplitude
		endif
		i += 1
	while (i<nWaves)
	OffsetValueY = round(maxAmplitude)
	
	// show a panel to enter offset values
	NewPanel /N = OffsetSettingPanel /W=(430,282,668,391) as "Spread traces"
	SetDrawLayer UserBack
	DrawText 23,21,"Set offset values"
	Button button1,pos={23,79},size={50,20},proc=DoSpread,title="OK"
	Button button2,pos={79,79},size={50,20},proc=CancelButtonTI,title="Cancel"
	Button button3,pos={152,79},size={52,20},proc=NoSpread,title="No offset"
	SetVariable setvar0,pos={18,28},size={129,18},title="Y Offest "
	SetVariable setvar0,value= OffsetValueY,bodyWidth= 80
	SetVariable setvar1,pos={19,52},size={128,18},title="X Offest "
	SetVariable setvar1,value= OffsetValueX,bodyWidth= 80
End

Function DoSpread(ctrlName) : ButtonControl	//when "OK" was clicked
	String ctrlName
	NVAR OffsetY = OffsetValueY
	NVAR OffsetX = OffsetValueX
	SVAR ListOfTraces
	Variable	nWaves = ItemsInList(ListOfTraces)
	SVAR GraphName = NameTop
	String	currTrace
//	print "Y offset: "+num2str(OffsetY)+ "; X offset: "+num2str(OffsetX)
	DoWindow/k OffsetSettingPanel
	SetAxis/A left
	Variable	i	
	for (i = 0; i < nWaves; i +=1)
		currTrace = StringFromList(i,ListOfTraces)
		ModifyGraph/W=$(GraphName) offset($currTrace)={OffsetX*i,-OffsetY*i}
	endfor
	print "DoSpreadFromCommand("+num2str(OffsetY)+","+num2str(OffsetX)+")"
	Killvariables/z OffsetValueY,OffsetValueX
	killstrings/z ListOfTraces, NameTop
End

Function DoSpreadFromCommand(OffsetY,OffsetX)
	variable OffsetY,OffsetX
	String ListOfTraces = TraceNameList("", ";", 1)
	Variable	nWaves = ItemsInList(ListOfTraces)
	String	currTrace	
	SetAxis/A left
	Variable	i	
	for (i = 0; i < nWaves; i +=1)
		currTrace = StringFromList(i,ListOfTraces)
		ModifyGraph offset($currTrace)={OffsetX*i,-OffsetY*i}
	endfor
End

Function NoSpread(ctrlName) : ButtonControl	//when "No offset" was clicked
	String ctrlName
	SVAR GraphName = NameTop
	print "DoSpreadFromCommand(0,0)"
	DoWindow/k OffsetSettingPanel
	SetAxis/A left
	ModifyGraph/W=$(GraphName) offset={0,0}
End
//////////////////////////////////////////////////////////////////////////////////// End Spread traces 

//////////////////////////////////////////////////////////////////////////////////// Layout tile
Function TileGraphsInLayouPanel()
	String LayoutName = StringFromList(0,WinList("*",";","WIN:4"))
	String InfoList = LayoutInfo(LayoutName, "Layout")
	variable Num = Str2num(StringByKey("NUMSELECTED",InfoList))
	if (Num == 0)
		abort "Select at least one object"
	endif
	variable/G SelObjNum, AllObjNum
	SelObjNum = Num
	variable/G AllObjNum = Str2num(StringByKey("NUMOBJECTS",InfoList))
	variable/G RawNum=round(sqrt(SelObjNum))
	variable/G ColNum=ceil(SelObjNum/RawNum)
	variable/G GroutNum = 2
	NewPanel /W=(122,94,291,282)/N=TileSetting
	SetVariable setvar0,pos={11,25},size={150,16},title=" "
	SetVariable setvar0,format="%g objects are selected",frame=0
	SetVariable setvar0,limits={-inf,inf,0},value= SelObjNum,noedit= 1
	SetVariable setvar1,pos={45,58},size={79,16},title="Raw:"
	SetVariable setvar1,limits={1,inf,1},value= RawNum,bodyWidth= 50
	SetVariable setvar2,pos={32,82},size={92,16},title="Column:"
	SetVariable setvar2,limits={1,inf,1},value= ColNum,bodyWidth= 50
	SetVariable setvar3,pos={36,106},size={88,16},title="Space:"
	SetVariable setvar3,limits={0,inf,1},value= GroutNum,bodyWidth= 50
	Button button0,pos={26,154},size={50,20},proc=TileGraphsInLayoutDo,title="OK"
	Button button1,pos={82,154},size={50,20},proc=CancelButtonTI,title="Cancel"
	CheckBox check0,pos={9,131},size={155,14},title="tile as original graph windows"
	CheckBox check0,value= 0
End


Function TileGraphsInLayoutDo(ctrlName) : ButtonControl
	String ctrlName
	NVAR SelObjNum, AllObjNum,RawNum,ColNum,GroutNum
	String LayoutName = StringFromList(0,WinList("*",";","WIN:4"))
	if (SelObjNum > RawNum*ColNum)
		abort "too many objects for the raws and the columns"
	endif
	Make/O/N=(SelObjNum)/T GraphNames=""
	Make/O/N=(SelObjNum) GraphTop=0,GraphLeft=0
	Make/O/N=(SelObjNum) RawIndex = floor(p / ColNum)
	ControlInfo /W=TileSetting check0
	variable origplace = V_Value
	variable i = 0,k=0
	do
		String InfoList = LayoutInfo(LayoutName, num2str(i))
		if (Str2num(StringByKey("SELECTED",InfoList)))
			GraphNames[k] = StringByKey("NAME",InfoList)
			if (origplace)
				GetWindow $GraphNames[k], wsize
				//print V_left, V_top, V_right, V_bottom
				GraphTop[k] = V_top
				GraphLeft[k] = V_left
			else
				GraphTop[k] = Str2num(StringByKey("TOP",InfoList))
				GraphLeft[k] = Str2num(StringByKey("LEFT",InfoList))
			endif
			k +=1
		endif
		i += 1
	while (i < AllObjNum)
	
	Sort GraphTop,GraphTop,GraphLeft,GraphNames
//	Sort {RawIndex, GraphLeft} GraphLeft,GraphTop,GraphLeft,GraphNames
	Sort {RawIndex, GraphLeft} GraphLeft,GraphTop,GraphNames
	String NameList=""
	i = 0
	do
		NameList += GraphNames[i]+","
		i += 1
	while (i < SelObjNum)
	Execute/Z "Tile/A=(" + num2str(RawNum)+","+ num2str(ColNum)+")/G="+num2str(GroutNum)+" " +NameList

	DoWindow/K TileSetting
	KillVariables/Z SelObjNum, AllObjNum,RawNum,ColNum,GroutNum
	KillWaves/Z 	GraphNames,GraphTop,GraphLeft,RawIndex
End


Function AlignAllGraphsInLayout()
	String LayoutName = StringFromList(0,WinList("*",";","WIN:4"))
	String InfoList = LayoutInfo(LayoutName, "Layout")
	variable AllObjNum,AllGraphNum
	AllObjNum = Str2num(StringByKey("NUMOBJECTS",InfoList))
	variable i = 0,k=0
	Make/N=0/T/O GraphNames = ""
	Make/N=0/O GraphTop=0,GraphLeft=0,GraphWidth=0,GraphHeight=0
	do
		InfoList = LayoutInfo(LayoutName, num2str(i))
		//print InfoList
		if (Stringmatch(StringByKey("TYPE",InfoList), "Graph"))
			k=numpnts(GraphNames)
			InsertPoints k,1, GraphNames,GraphTop,GraphLeft,GraphWidth,GraphHeight
			GraphNames[k] = StringByKey("NAME",InfoList)
			GraphTop[k] = Str2num(StringByKey("TOP",InfoList))
			GraphLeft[k] = Str2num(StringByKey("LEFT",InfoList))
			GraphWidth[k] = Str2num(StringByKey("WIDTH",InfoList))
			GraphHeight[k] = Str2num(StringByKey("HEIGHT",InfoList))
		endif
		i += 1
	while (i < AllObjNum)
	AllGraphNum =numpnts(GraphNames) 
	//Edit GraphNames,GraphTop,GraphLeft,GraphWidth,GraphHeight
	Sort {GraphTop, GraphLeft}, GraphNames,GraphTop,GraphLeft,GraphWidth,GraphHeight
	i = 0
	do
		variable HW = 0.5* GraphWidth[i]
		k = i + 1
		do
			if ((GraphLeft[k] < GraphLeft[i] + HW) && (GraphLeft[k] > GraphLeft[i] - HW))
				ModifyLayout left($GraphNames[k]) = GraphLeft[i]
				GraphLeft[k] = GraphLeft[i]
				//print "vertical",GraphNames[i], GraphNames[k], GraphLeft[i]
				variable mintop = GraphTop[i] + GraphHeight[i]
				if (GraphTop[k] < mintop)
					ModifyLayout top($GraphNames[k]) = mintop
					GraphTop[k] = mintop
					//print "push down", GraphNames[k]
				endif
				break
			endif
			k += 1
		while (k<	AllGraphNum)
		i += 1
	while (i < AllGraphNum-1)
	
	Sort {GraphLeft, GraphTop}, GraphNames,GraphTop,GraphLeft,GraphWidth,GraphHeight
	i = 0
	do
		variable HH =  0.5* GraphHeight[i]
		k = i + 1
		do
			if ((GraphTop[k] < GraphTop[i] + HH) && (GraphTop[k] > GraphTop[i] - HH))
				ModifyLayout top($GraphNames[k]) = GraphTop[i]
				GraphTop[k] = GraphTop[i]
				//print "horizontal",GraphNames[i], GraphNames[k], GraphTop[i]
				variable minleft = GraphLeft[i] + GraphWidth[i]
				if (GraphLeft[k] < minleft)
					ModifyLayout left($GraphNames[k]) = minleft
					//print "push right", GraphNames[k]
					GraphLeft[k] = minleft
				endif
				break
			endif
			k += 1
		while (k<	AllGraphNum)
		i += 1
	while (i < AllGraphNum-1)
//	Edit 	GraphNames,GraphTop,GraphLeft,GraphWidth,GraphHeight//
//	doupdate
//	doalert 0,"check"//
	
	//repeat all for text boxes
	Make/N=0/T/O GraphNames = ""
	Make/N=0/O GraphTop=0,GraphLeft=0,GraphWidth=0,GraphHeight=0
	i=0
	do
		InfoList = LayoutInfo(LayoutName, num2str(i))
		if (Stringmatch(StringByKey("TYPE",InfoList), "Textbox"))
			k=numpnts(GraphNames)
			InsertPoints k,1, GraphNames,GraphTop,GraphLeft,GraphWidth,GraphHeight
			GraphNames[k] = StringByKey("NAME",InfoList)
			GraphTop[k] = Str2num(StringByKey("TOP",InfoList))
			GraphLeft[k] = Str2num(StringByKey("LEFT",InfoList))
			GraphWidth[k] = Str2num(StringByKey("WIDTH",InfoList))
			GraphHeight[k] = Str2num(StringByKey("HEIGHT",InfoList))
		endif
		i += 1
	while (i < AllObjNum)
	AllGraphNum =numpnts(GraphNames) 
	
	if (AllGraphNum > 1)
		//Edit GraphNames,GraphTop,GraphLeft,GraphWidth,GraphHeight
		Sort {GraphTop, GraphLeft}, GraphNames,GraphTop,GraphLeft,GraphWidth,GraphHeight
		i = 0
		do
			//HW = 0.5* GraphWidth[i]
			HW = 20
			k = i + 1
			do
				if ((GraphLeft[k] < GraphLeft[i] + HW) && (GraphLeft[k] > GraphLeft[i] - HW))
					ModifyLayout left($GraphNames[k]) = GraphLeft[i]
					GraphLeft[k] = GraphLeft[i]
					//print "vertical",GraphNames[i], GraphNames[k], GraphLeft[i]
					mintop = GraphTop[i] + GraphHeight[i] +1
					if (GraphTop[k] < mintop)
						ModifyLayout top($GraphNames[k]) = mintop
						GraphTop[k] = mintop
						//print "push down", GraphNames[k]
					endif
					break
				endif
				k += 1
			while (k<	AllGraphNum)
			i += 1
		while (i < AllGraphNum-1)
		
		Sort {GraphLeft, GraphTop}, GraphNames,GraphTop,GraphLeft,GraphWidth,GraphHeight
		i = 0
		do
			//HH =  0.5* GraphHeight[i]
			HH =  20
			k = i + 1
			do
				if ((GraphTop[k] < GraphTop[i] + HH) && (GraphTop[k] > GraphTop[i] - HH))
					ModifyLayout top($GraphNames[k]) = GraphTop[i]
					GraphTop[k] = GraphTop[i]
					//print "horizontal",GraphNames[i], GraphNames[k], GraphTop[i]
					minleft = GraphLeft[i] + GraphWidth[i] +1
					if (GraphLeft[k] < minleft)
						ModifyLayout left($GraphNames[k]) = minleft
						//print "push right", GraphNames[k]
						GraphLeft[k] = minleft
					endif
					break
				endif
				k += 1
			while (k<	AllGraphNum)
			i += 1
		while (i < AllGraphNum-1)
		//end of repeat (text part)
	endif		
	KillWaves/Z 	GraphNames,GraphTop,GraphLeft,GraphWidth,GraphHeight
End

Proc AdjustSizeOfGraph() : GraphStyle
	PauseUpdate; Silent 1
	ModifyGraph/Z margin(left)=34,margin(bottom)=34,margin(top)=15,margin(right)=15
	ModifyGraph/Z width=110,height=80
EndMacro

Proc RasterStyle() : GraphStyle
	PauseUpdate; Silent 1
	ModifyGraph/Z margin(left)=34,margin(bottom)=34,margin(top)=15,margin(right)=15
	ModifyGraph/Z width=110,height=80
	ModifyGraph/Z mode=3
	ModifyGraph/Z marker=10
	//ModifyGraph/Z rgb=(0,0,0)
	ModifyGraph/Z msize=1
	ModifyGraph/Z mrkThick=1
	ModifyGraph/Z hbFill=2
	//ModifyGraph prescaleExp(bottom)=-3// adjust ms to s
	ModifyGraph/Z standoff(left)=1,standoff(bottom)=1
	//ModifyGraph/Z manTick(bottom)={0,0.2,0,1},manMinor(bottom)={3,50}
	ModifyGraph/Z manTick(bottom)={0,200,0,0},manMinor(bottom)={3,50}
	Label/Z left "Trace number"
	Label/Z bottom "Time (ms)"
	//SetAxis/Z/E=1 left
	//SetAxis/Z bottom 0,1000
EndMacro

Proc ColourAverageTraces() : GraphStyle
	ModifyGraph/Z rgb[0]=(0,65280,0)
	ModifyGraph/Z rgb[1]=(0,43520,65280)
	ModifyGraph/Z rgb[2]=(65280,0,0)
	ModifyGraph/Z rgb[3]=(39168,0,0)
	ModifyGraph/Z rgb[4]=(65280,43520,0)
EndMacro

Proc HistogramStyle() : GraphStyle//PSTH
	PauseUpdate; Silent 1
	ModifyGraph/Z margin(left)=34,margin(bottom)=34,margin(top)=15,margin(right)=15
	ModifyGraph/Z width=110,height=80
	ModifyGraph/Z mode[0]=5
	ModifyGraph/Z marker[0]=10
	ModifyGraph/Z rgb[0]=(0,0,0)
	ModifyGraph/Z msize[0]=1
	ModifyGraph/Z hbFill[0]=2
	//ModifyGraph prescaleExp(bottom)=-3// adjust ms to s
	ModifyGraph/Z standoff(bottom)=0
	ModifyGraph/Z standoff(left)=1//changed from 0
	//ModifyGraph/Z manTick(bottom)={0,0.2,0,1},manMinor(bottom)={3,50}
	ModifyGraph/Z manTick(bottom)={0,200,0,0},manMinor(bottom)={3,50}
	ModifyGraph/Z btLen(left)=4
	Label/Z bottom "Time (ms)"
EndMacro

Proc AmplitudeTrendStyle() : GraphStyle
	PauseUpdate; Silent 1
	ModifyGraph/Z margin(left)=34,margin(bottom)=34,margin(top)=15,margin(right)=15
	ModifyGraph/Z width=110,height=80
	ModifyGraph/Z rgb=(0,0,0)
	//ModifyGraph/Z prescaleExp(bottom)=-3// adjust ms to s
	ModifyGraph/Z standoff(left)=1,standoff(bottom)=1
	//ModifyGraph/Z manTick(bottom)={0,0.2,0,1},manMinor(bottom)={3,50}
	ModifyGraph/Z manTick(bottom)={0,200,0,0},manMinor(bottom)={3,50}
	Label/Z left "Amplitude (pA)"
	Label/Z bottom "Time (ms)"
//	SetAxis/A/Z/E=1 left
//	SetAxis/Z bottom 0,1000
EndMacro

Proc AmplitudePlotStyle() : GraphStyle
	PauseUpdate; Silent 1
	ModifyGraph/Z margin(left)=34,margin(bottom)=34,margin(top)=15,margin(right)=15
	ModifyGraph/Z width=110,height=80
	ModifyGraph/Z rgb=(0,0,0)
	//ModifyGraph/Z prescaleExp(bottom)=-3// adjust ms to s
	ModifyGraph/Z standoff(left)=1,standoff(bottom)=1
	//ModifyGraph/Z manTick(bottom)={0,0.2,0,1},manMinor(bottom)={3,50}
	ModifyGraph/Z manTick(bottom)={0,200,0,0},manMinor(bottom)={3,50}
	Label/Z left "Amplitude (pA)"
	Label/Z bottom "Time (ms)"

EndMacro

Proc SampleTracesStyle() : GraphStyle
	PauseUpdate; Silent 1
	ModifyGraph/Z margin(left)=34,margin(bottom)=34,margin(top)=15,margin(right)=15
	ModifyGraph/Z width=110,height=80
	ModifyGraph/Z lSize=0.1
	ModifyGraph/Z marker=10
	ModifyGraph/Z rgb=(0,0,0)
	ModifyGraph/Z msize=1
	ModifyGraph/Z hbFill=2
	ModifyGraph/Z standoff=0
	ModifyGraph/Z axRGB=(65535,65535,65535)
	ModifyGraph/Z tlblRGB=(65535,65535,65535)
	ModifyGraph/Z alblRGB=(65535,65535,65535)
	//ModifyGraph/Z manTick(bottom)={0,0.2,0,1},manMinor(bottom)={3,50}
	Label/Z left "Current (pA)"
	Label/Z bottom "Time (ms)"
	//SetAxis/Z bottom 0,1000
EndMacro

Proc RemoveAxisStyle() : GraphStyle
//	ModifyGraph/Z axRGB=(65535,65535,65535)
//	ModifyGraph/Z tlblRGB=(65535,65535,65535)
//	ModifyGraph/Z alblRGB=(65535,65535,65535)
	ModifyGraph noLabel=2
	ModifyGraph axThick=0	
EndMacro

Proc ShowAxisStyle() : GraphStyle
	ModifyGraph/Z axRGB=(0,0,0)
	ModifyGraph/Z tlblRGB=(0,0,0)
	ModifyGraph/Z alblRGB=(0,0,0)
	ModifyGraph noLabel=0
	ModifyGraph axThick=1	
EndMacro

Proc HistogramStyle2() : GraphStyle
	ModifyGraph margin(left)=34,margin(bottom)=34,margin(top)=15,margin(right)=15,width=110
	ModifyGraph height=80
	ModifyGraph mode=5
	ModifyGraph marker=10
	ModifyGraph rgb=(0,0,0)
	ModifyGraph msize=1
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	Label left "Event number"
	Label bottom "Amplitude (pA)"
EndMacro

Proc HistogramStyle3() : GraphStyle
	ModifyGraph margin(left)=34,margin(bottom)=34,margin(top)=15,margin(right)=15,width=110
	ModifyGraph height=80
	ModifyGraph mode=5
	ModifyGraph marker=10
	ModifyGraph rgb=(0,0,0)
	ModifyGraph msize=1
	ModifyGraph hbFill=2
	ModifyGraph standoff=0
	Label left "Event number"
	Label bottom "Interval (ms)"
EndMacro

Proc SetToAuto() : GraphStyle
	ModifyGraph width=0, height=0
	ModifyGraph margin=0
	ModifyGraph mode=0
	ModifyGraph/Z lSize=1
	ModifyGraph/Z marker=10
	ModifyGraph/Z rgb=(0,0,0)
	ModifyGraph/Z msize=1
	ModifyGraph/Z hbFill=2
	ModifyGraph/Z standoff=0
	ModifyGraph/Z axRGB=(0,0,0)
	ModifyGraph/Z tlblRGB=(0,0,0)
	ModifyGraph/Z alblRGB=(0,0,0)
	SetAxis/A/Z bottom
	SetAxis/A/Z left
	ModifyGraph prescaleExp=0
	ModifyGraph grid=0
	ModifyGraph manTick=0
	ModifyGraph minor=0
	Label left ""
	Label bottom ""
EndMacro

Proc AddGridToRaster() : GraphStyle
	ModifyGraph manTick(bottom)={0,100,0,0},manMinor(bottom)={9,5}
	ModifyGraph grid(bottom)=1
	ModifyGraph gridStyle(bottom)=1
EndMacro


Window AdjustSizeFor5Columns() : GraphStyle//	"Small size (5 columns)"
	ModifyGraph margin(left)=34,margin(bottom)=34,margin(top)=15,margin(right)=15
	ModifyGraph height=50,width=50
	ModifyGraph manTick(bottom)={0,500,0,1},manMinor(bottom)={4,50}
EndMacro

Proc AddYGridToRaster() : GraphStyle
	ModifyGraph manTick(left)={0,5,0,0},manMinor(left)={4,50}
	ModifyGraph grid(left)=1
	ModifyGraph gridStyle(left)=3
EndMacro


//-----

Function FixGraphsizeAsItIs()
	// Make sure top window is a graph	
	String GraphList = WinList("*",";","WIN:1")
	if (ItemsInList(GraphList)==0)
		Abort "No graphs open."
	endif
	String NameTop = StringFromList(0,GraphList)
	Getwindow $NameTop psize
	variable xsize = round(-V_left+V_right)
	variable ysize = round(-V_top+V_bottom)
	ModifyGraph width=xsize,height=ysize
	//print NameTop, "width=",xsize,"height=",ysize
	print "ModifyGraph width="+num2str(xsize)+",height="+num2str(ysize)
End

Function FreeGraphsize()
	ModifyGraph width=0,height=0
End

Function ScaleWindowSize(ratio)
	variable ratio
		
	if (ratio ==0)
		Prompt ratio, "< 1 to shrink, >1 to enlarge." 
		DoPrompt "Scale the window frame size" , ratio
		print "ScaleWindowSize("+num2str(ratio)+")"
	endif
	if (ratio <= 0)
		abort
	endif
	
	String GraphList = WinList("*",";","WIN:") // all types of windows
//	if (ItemsInList(GraphList)==0)
//		Abort "No window open."
//	endif
	String NameTop = StringFromList(0,GraphList)
//	if (WinType(NameTop) == 1)//if graph
//		ModifyGraph/W=$NameTop  width=0,height=0
//	endif
	Getwindow $NameTop wsize
	variable xsize = round((-V_left+V_right)*ratio)
	variable ysize = round((-V_top+V_bottom)*ratio)
	MoveWindow/W=$NameTop V_left,V_top,V_left+xsize,V_top+ysize
End

Function MoveWindowToTopLeft()
	String GraphList = WinList("*",";","")
	String NameTop = StringFromList(0,GraphList)
	MoveWindow/W=$NameTop 0,0,200,200 
End

Function MergeTopTwoGraphs()
	String GraphWindowList
	GraphWindowList = WinList("*",";","WIN:1")
	if (ItemsInList(GraphWindowList) < 2)
		abort "Cannot find two graphs to merge."
	endif
	String TopGraph = StringFromList(0,GraphWindowList)
	String NextGraph =  StringFromList(1,GraphWindowList)
	//print TopGraph,NextGraph
	String TopGraphMacro
	TopGraphMacro = WinRecreation(TopGraph, 0)
	Execute TopGraphMacro
	//print TopGraph,NextGraph
	String NextTraceNames = TraceNameList(NextGraph, ";",1)//no contour traces
	//print "List:", NextTraceNames
	String CurrentTrace
	variable ExistingNum =  ItemsInList(TraceNameList(TopGraph, ";",1))
	variable TraceNum = ItemsInList(NextTraceNames)
	//print TraceNum
	variable i
	i = 0
	do
		CurrentTrace = StringFromList(i, NextTraceNames)
		//print CurrentTrace
		Variable mode= NumberByKey("mode(x)", TraceInfo(NextGraph,CurrentTrace,0), "=",";" )
		Variable mark= NumberByKey("marker(x)", TraceInfo(NextGraph,CurrentTrace,0), "=",";" )
		Variable lsiz= NumberByKey("lSize(x)", TraceInfo(NextGraph,CurrentTrace,0), "=",";" )
		Variable lsty= NumberByKey("lStyle(x)", TraceInfo(NextGraph,CurrentTrace,0), "=",";" )
		Variable mThi= NumberByKey("mrkThick(x)", TraceInfo(NextGraph,CurrentTrace,0), "=",";" )
		Variable opqe= NumberByKey("opaque(x)", TraceInfo(NextGraph,CurrentTrace,0), "=",";" )
		Variable msiz= NumberByKey("mSize(x)", TraceInfo(NextGraph,CurrentTrace,0), "=",";" )
		
		print mode, msiz, mark
		Wave YWaveToAppend = TraceNameToWaveRef(NextGraph, CurrentTrace)
		Wave XWaveToAppend = XWaveRefFromTrace(NextGraph, CurrentTrace)
		if (WaveExists(XWaveToAppend)) 
			AppendToGraph YWaveToAppend vs XWaveToAppend
		else
			AppendToGraph YWaveToAppend
		endif
		ModifyGraph/Z mode[ExistingNum+i]=mode
		ModifyGraph/Z marker[ExistingNum+i]=mark
		ModifyGraph/Z lSize[ExistingNum+i]=lsiz
		ModifyGraph/Z lStyle[ExistingNum+i]=lsty
		ModifyGraph/Z mrkThick[ExistingNum+i]=mThi
		ModifyGraph/Z opaque[ExistingNum+i]=opqe
		ModifyGraph/Z mSize[ExistingNum+i]=msiz
		i += 1
	while (i < TraceNum)
	
End


/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////


Function SaveAllGraphsOnLayout()
	String LayoutName = StringFromList(0,WinList("*",";","WIN:4"))
	String InfoList = LayoutInfo(LayoutName, "Layout")
	variable AllObjNum
	AllObjNum = Str2num(StringByKey("NUMOBJECTS",InfoList))
	variable i = 0

	NewPath/O/M="Select a destination folder."GraphExport
	if (V_flag)
		abort
	endif

	String GraphName, FileName
	String ExpName = IgorInfo(1)
	do
		InfoList = LayoutInfo(LayoutName, num2str(i))
		//print InfoList//
		if (Stringmatch(StringByKey("TYPE",InfoList), "Graph"))
			GraphName = StringByKey("NAME",InfoList)
			FileName= ExpName + "_"+GraphName+".pxp"
			print Filename//
			SaveGraphCopy/P=GraphExport/W=$GraphName as FileName
		endif
		i += 1
	while (i < AllObjNum)
End

Function KeepOnlyLayouts()
	DoAlert 1,"Do you want to kill all graphs and tables that are not used in layouts?"
	if (V_flag > 1)
		abort
	endif
	String AllLayoutList = WinList("*",";","WIN:4")
	String AllTableGraphList = WinList("*",";","WIN:3")
//	String AllTableList = WinList("*",";","WIN:2")
//	String AllGraphList = WinList("*",";","WIN:1")
	Variable AllLayoutNum = ItemsInList(AllLayoutList)
	Variable AllTableGraphNum = ItemsInList(AllTableGraphList)
//	Variable AllTableNum = ItemsInList(AllTableList)
//	Variable AllGraphNum = ItemsInList(AllGraphList)
	String ItemsToRemainList=""
	String InfoList,ItemName,LayoutName
	variable AllObjNum
	variable i,k
	i = 0
	do
		LayoutName = StringFromList(i,AllLayoutList)
		InfoList = LayoutInfo(LayoutName, "Layout")
		AllObjNum = Str2num(StringByKey("NUMOBJECTS",InfoList))
		//print LayoutName//
		k = 0
		do
			InfoList = LayoutInfo(LayoutName, num2str(k))
			if (Stringmatch(StringByKey("TYPE",InfoList), "Graph") || Stringmatch(StringByKey("TYPE",InfoList), "Table"))
				ItemName =  StringByKey("NAME",InfoList)
				//print ItemName//
				ItemsToRemainList = ItemsToRemainList + ItemName +";"
			endif
			k += 1
		while (k < AllObjNum)
		i +=1
	while (i < AllLayoutNum)
	//print ItemsToRemainList//
		
	i = 0
	do
		ItemName = StringFromList(i,AllTableGraphList)
		if (WhichListItem(ItemName, ItemsToRemainList) < 0)
			DoWindow/k $ItemName
		endif
		i += 1
		
	while (i < AllTableGraphNum)
End

Function CleanUpCurrentFolder()
	DoAlert 1,"Do you want to kill all waves, strings, variable and subfolders that are not used in graphs or tables? Only current folder and subfolders will be affected."
	if (V_flag > 1)
		abort
	endif
	GetAllSubFolders()
	DoWindow/K SubFolderInfo
	wave/T SubFolderName=$"root:SubFolderName"
	wave SubFolderDepth=$"root:SubFolderDepth"
	sort/R SubFolderDepth, SubFolderDepth, SubFolderName
	variable num = numpnts(SubFolderDepth)
	variable i
	i = 0
	do
		SetDataFolder SubFolderName[i]
		killwaves/a/z
		killstrings/a/z
		killvariables/a/z
		if (CountObjects("",1) + CountObjects("",4) < 1)
			string foldername = GetDataFolder(1)
			KillDataFolder/Z $foldername
		endif
		i += 1
	while (i < num)
	killwaves/z SubFolderName, SubFolderDepth
		 
End

Function GetAllSubFolders()
	string path = GetDataFolder(1)
	SetDataFolder root:
	Make/T/O/N=0 SubFolderName
	SetDataFolder path
	GetDataFolderPath(path)
	SetDataFolder root:
	variable wl = numpnts(SubFolderName)
	Make/O/N=(wl) SubFolderDepth
	SubFolderDepth = ItemsInList(SubFolderName[p],":") -1
	Edit SubFolderName, SubFolderDepth
	ModifyTable width(SubFolderName)=250
	DoWindow/K SubFolderInfo
	DoWindow/C SubFolderInfo
	SetDataFolder path
End

Function GetDataFolderPath(path)
	string path
	string savepath = GetDataFolder(1)
	SetDataFolder path
	string foldername = GetDataFolder(1)
	//print foldername
	wave/T SubFolderName=$"root:SubFolderName"
	variable wl = numpnts(SubFolderName)
	InsertPoints wl, 1, SubFolderName
	SubFolderName[wl] = GetDataFolder(1)
	variable i
	variable numSubFolders = CountObjects("",4)
	for (i=0; i < numSubFolders; i +=1)
		string nextpath = GetIndexedObjName(":",4,i)
		GetDataFolderPath(nextpath)
	endfor
	SetDataFolder savepath
End	


Function TI_ScaleImageSize(Scale)
	Variable Scale
	String ImageName = StringFromList(0,ImageNameList("",";"))
	wave ImageWave = ImageNameToWaveRef("",ImageName)
	Variable Nrow = DimSize(ImageWave,0)
	Variable Ncol = DimSize(ImageWave,1)
	Variable ScreenMag = 72/ScreenResolution
	Variable xsize = Nrow *ScreenMag*Scale
	Variable ysize = Ncol *ScreenMag*Scale
	ModifyGraph width=xsize,height=ysize
	print "Image pixel: " +num2str(Nrow)+ " x " +num2str(Ncol)
	print "ModifyGraph width="+num2str(xsize)+",height="+num2str(ysize)	
End