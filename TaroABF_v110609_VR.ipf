#pragma rtGlobals=1		// Use modern global access method.

// A simple loader of pClamp ABF files
//long = 32 bit signed integer, 4 byte
//short = 16bit signed integer, 2 byte
//float = single float, 4 byte

// 2011/6/9 Multi-file selection is enabled (internal version 2)

Function LoadABF()
	Variable refNum, FileNum
	String message = "Select one or more ABF files"
	String fileFilters = "ABF files (*.abf):.abf;"
	String FileNameList
	Open/D/R/MULT=1/F=fileFilters/M=message refNum
	FileNameList = S_fileName
	FileNum = ItemsInList(FileNameList,"\r")
	if (FileNum == 0)
		abort
	endif
	string/g FileNameStr
	//Make/O/N=16 nADCPtoLChannelMap	//378(0-15) short
	Make/O/N=16 nADCSamplingSeq  //410(0-15) short
	Make/O/N=16 fInstrumentScaleFactor //922 (0-15) float (Volts at ADC / user unit)
	Make/O/N=16 fInstrumentOffset //986 (0-15)  (user units corresponding to 0 V at the ADC)
	Make/O/N=16 fTelegraphAdditGain //4576 (0-15) float
	Make/T/O/N=16 sADCChannelName // 442(0-15) 10char ADC channel name
	Make/T/O/N=16  sADCUnits //602(0-15)  8char  user units

	variable i = 0
	do
		FileNameStr = StringFromList(i, FileNameList,"\r")
		LoadABFSub()
		i += 1
	while (i < FileNum)
	////cleaning up
	killstrings/z FileNameStr
	killwaves/z nADCSamplingSeq, fInstrumentScaleFactor, fInstrumentOffset, fTelegraphAdditGain
	killwaves/z sADCChannelName, sADCUnits
	Print FileNum, "file(s) have been loaded."
End
	
Function LoadABFSub()
	SVAR FileNameStr	
	WAVE nADCSamplingSeq, fInstrumentScaleFactor, fInstrumentOffset, fTelegraphAdditGain
	WAVE/T sADCChannelName, sADCUnits
	string shortFileName
	string finalwavename
	variable byteoffset
	variable fType
	variable scalingfactor
	variable samplingtime
	variable ChNum
	variable SamplePerTrace
	
	variable nOperationMode //8 short
	variable lActualAcqLength//10 long
	variable lActualEpisodes // 16 long
	variable lDataSectionPtr //40 long
	variable nDataFormat //100 short
	variable nADCNumChannels //120 short 
	variable fADCSampleInterval // in micro sec 122 float
	variable lNumSamplesPerEpisode //138 long
	variable fADCRange //244 float
	variable lADCResolution //252 long
	variable nExperimentType //260 short  Experiment type: 0 = Voltage Clamp; 1 = Current Clamp.
	 
	//bytes to skip before data section: 512 * lDataSectionPtr  
	//Data part is multiplexed two-byte binary integers (short) or  four-byte floating point version (float).
	//(mV or pA) = integervalue * fADCRange /lADCResolution /fTelegraphAdditGain[c] /fInstrumentScaleFactor[c] +fInstrumentOffset[c]
	// where c is a physical channel number
	Print "Loading", FileNameStr
	shortFileName = ParseFilePath(3, FileNameStr, ":", 0, 0)
	nOperationMode = ReadHeaderValue(8, "short")
	//print nOperationMode
	lActualAcqLength = ReadHeaderValue(10, "long")
	//print lActualAcqLength
	lActualEpisodes = ReadHeaderValue(16, "long")
	//print lActualEpisodes
	lDataSectionPtr = ReadHeaderValue(40, "long")
	nDataFormat = ReadHeaderValue( 100, "short") //0 = short; 1 = float
	nADCNumChannels = ReadHeaderValue( 120, "short")	// added in TaroABF_v2
	fADCSampleInterval = ReadHeaderValue( 122,"float")	// in micro sec
	lNumSamplesPerEpisode = ReadHeaderValue( 138, "long")
	//print lNumSamplesPerEpisode
	fADCRange = ReadHeaderValue( 244, "float")
	lADCResolution = ReadHeaderValue(252, "long")
	//nExperimentType //260 short  Experiment type: 0 = Voltage Clamp; 1 = Current Clamp.
	if (nOperationMode == 3)
		lActualEpisodes =1
		lNumSamplesPerEpisode = lActualAcqLength
	endif
		
	variable i =0
	do
		nADCSamplingSeq[i]  = ReadHeaderValue(410+2*i, "short") //ADC physical-to-logical channel map.
		fInstrumentScaleFactor[i] = ReadHeaderValue(922 + 4*i,"float") // (Volts at ADC / user unit). physical
		//(Programs would normally display this information to the user as user units / volt at ADC).
		fInstrumentOffset[i] = ReadHeaderValue(986+4*i, "float")  //(user units corresponding to 0 V at the ADC)physical
		fTelegraphAdditGain[i] = ReadHeaderValue(4576+4*i, "float") //physical
		sADCChannelName[i] =ReadCharacters(442+10*i, 10) // 10char ADC channel name
		//print sADCChannelName[i]
		sADCUnits[i] =ReadCharacters(602+8*i, 8) //  8char  user units
		//print sADCUnits[i]
		i+=1
	while (i <16)
	
	// Now read the data part
	
	if (nDataFormat == 1)
		fType=2 //float
	else
		fType= 16 //short
	endif
	
	byteoffset = 512*lDataSectionPtr
	SamplePerTrace = lNumSamplesPerEpisode/nADCNumChannels
	samplingtime = fADCSampleInterval*nADCNumChannels/1000
	GBLoadWave/Q/B/V/N=workingwave/O/T={fType,4}/S=(byteoffset)/W=(nADCNumChannels)/U=(SamplePerTrace*lActualEpisodes)  FileNameStr
	i=0 //channel number
	do
		ChNum = nADCSamplingSeq[i]
		wave datawave =  $StringFromList(i, S_waveNames)
		redimension/N=(SamplePerTrace,lActualEpisodes) datawave
		scalingfactor = fADCRange /lADCResolution /fTelegraphAdditGain[ChNum] /fInstrumentScaleFactor[ChNum]
		variable j=0 //episode number
		do
			finalwavename = "w"+shortFileName +"_"+num2str(i+1)+"_"+num2str(j+1)
			Make/O/N=(SamplePerTrace) $finalwavename
			wave finalwave = $finalwavename
			finalwave = datawave[p][j]
			if (nDataFormat==0) // scale integer files
				finalwave *= scalingfactor
				finalwave += fInstrumentOffset[ChNum]
			endif
			SetScale/P x 0,samplingtime,"", finalwave //set x values
			
			Note/K finalwave
			Note finalwave, FileNameStr
			Note finalwave, "X: Time (ms)"
			Note finalwave, "Y: "+sADCChannelName[ChNum]+" ("+sADCUnits[ChNum]+")"
			
			j+=1
		while (j<lActualEpisodes)
		killwaves datawave		
		i+=1
	while (i<nADCNumChannels)
	
End

Function ReadHeaderValue(byteoffset,type)
	variable byteoffset
	string type
	variable fType
	string wavenamestring
	SVAR FileNameStr
	
	strswitch (type)
		case "long":
			fType = 32
			break
		case "short":
			fType = 16
			break
		case "float":
			fType = 2
			break
		default:
			abort
	endswitch
	
	GBLoadWave/Q/B/N=workingwave/O/T={fType,4}/S=(byteoffset)/W=1/U=1 FileNameStr
	
	wavenamestring = StringFromList(0, S_waveNames)
	wave w = $wavenamestring
	return w[0]
	killwaves w
End

Function/S ReadCharacters(byteoffset,charnum)
	variable byteoffset,charnum
	string StringRead = ""
	string wavenamestring
	SVAR FileNameStr
	
	GBLoadWave/Q/B/N=workingwave/O/T={8,4}/S=(byteoffset)/W=1/U=(charnum) FileNameStr
	
	wavenamestring = StringFromList(0, S_waveNames)
	wave w = $wavenamestring
	variable i = 0
	do
		StringRead += num2char(w[i])
	i+=1
	while (i<charnum)
	
	i = 0
	do
		StringRead = RemoveEnding (StringRead, " ")
	i+=1		
	while (i<charnum)
	
	return StringRead
	killwaves w
End