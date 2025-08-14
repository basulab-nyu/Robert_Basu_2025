#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro Arithmetic_Matching_Waves_from_textref()

pArithmetic_Matching_Waves_from_textref()
proc pArithmetic_Matching_Waves_from_textref(str_input1,str_input2,str_op,str_output)
string str_input1
prompt str_input1 "input list #1 (textwave) ?"
string str_input2
prompt str_input2 "input list #2 (textwave) ?"
string str_op
prompt str_op "#1 + (1), - (2), * (3), / (4) #2 ?"
string str_output
prompt str_output "output waves ?"
silent 1
pauseupdate
if(numpnts($str_input1) == numpnts($str_input2))
	variable/g var_index = 0
	do
		duplicate/o $($str_input1[var_index]) $($str_input1[var_index]+"_"+str_output)
		if(str2num(str_op) == 1)
			$($str_input1[var_index]+"_"+str_output) = $($str_input1[var_index]) + $($str_input2[var_index])
		endif
		if(str2num(str_op) == 2)
			$($str_input1[var_index]+"_"+str_output) = $($str_input1[var_index]) - $($str_input2[var_index])
		endif
		if(str2num(str_op) == 3)
			$($str_input1[var_index]+"_"+str_output) = $($str_input1[var_index]) * $($str_input2[var_index])
		endif
		if(str2num(str_op) == 4)
			$($str_input1[var_index]+"_"+str_output) = $($str_input1[var_index]) / $($str_input2[var_index])
		endif
		var_index+=1
	while(var_index<numpnts($str_input1))
endif
resumeupdate
end