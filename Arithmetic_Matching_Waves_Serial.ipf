#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro Arithmetic_Matching_Waves()

pAMWS()
proc pAMWS(str_input,str_target,str_match,str_op,str_output)
string str_input
prompt str_input "input waves ?"
string str_target
prompt str_target "target string ?"
string str_match
prompt str_match "matching string ?"
string str_op
prompt str_op "+ (1), - (2), * (3), / (4) ?"
string str_output
prompt str_output "output waves ?"
string str_index
string/g str_list = sortlist(wavelist(str_input,";",""),";",16)
string/g str_list_match = replacestring(str_target,sortlist(wavelist(str_input,";",""),";",16),str_match)
variable/g var_op = str2num(str_op)
print replacestring(";",str_list,"\r")
print replacestring(";",str_list_match,"\r")
silent 1
pauseupdate
variable/g var_index = 0
do
	duplicate/o $stringfromlist(var_index,str_list) $(stringfromlist(var_index,str_list)+"_"+str_output)
	if(numpnts($stringfromlist(var_index,str_list))>0)
		if(var_op==1)
			$(stringfromlist(var_index,str_list)+"_"+str_output)=($stringfromlist(var_index,str_list))+($stringfromlist(var_index,str_list_match))
		endif
		if(var_op==2)
			$(stringfromlist(var_index,str_list)+"_"+str_output)=($stringfromlist(var_index,str_list))-($stringfromlist(var_index,str_list_match))
		endif
		if(var_op==3)
			$(stringfromlist(var_index,str_list)+"_"+str_output)=($stringfromlist(var_index,str_list))*($stringfromlist(var_index,str_list_match))
		endif
		if(var_op==4)
			$(stringfromlist(var_index,str_list)+"_"+str_output)=($stringfromlist(var_index,str_list))/($stringfromlist(var_index,str_list_match))
		endif
	endif
	var_index+=1
while(var_index<itemsinlist(str_list))
resumeupdate
end