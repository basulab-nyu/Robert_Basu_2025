#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro Matrix_Remove_Zero_Rows()

pMatrix_Remove_Zero_Rows()
proc pMatrix_Remove_Zero_Rows(str_input)
string str_input
prompt str_input "input waves ?"
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
variable var_index
variable var_index1
silent 1
pauseupdate
var_index = 0
do
	make/o/n=(0,dimsize($stringfromlist(var_index,str_list),1)) $(stringfromlist(var_index,str_list)+"_no0")
	var_index1 = 0
	do
		duplicate/o/r=[var_index1][] $stringfromlist(var_index,str_list) tempwave
		matrixtranspose tempwave
		redimension/n=-1 tempwave
		tempwave = (tempwave == 0) ? nan : tempwave
		wavestats/q tempwave
		if(v_numnans < numpnts(tempwave))
			redimension/n=(dimsize($(stringfromlist(var_index,str_list)+"_no0"),0)+1,dimsize($(stringfromlist(var_index,str_list)+"_no0"),1)) $(stringfromlist(var_index,str_list)+"_no0")
			$(stringfromlist(var_index,str_list)+"_no0")[dimsize($(stringfromlist(var_index,str_list)+"_no0"),0)-1][] = nan
			$(stringfromlist(var_index,str_list)+"_no0")[dimsize($(stringfromlist(var_index,str_list)+"_no0"),0)-1][] = $stringfromlist(var_index,str_list)[var_index1][q]
		endif
		var_index1+=1
	while(var_index1<dimsize($stringfromlist(var_index,str_list),1))
	var_index+=1
while(var_index<itemsinlist(str_list))
resumeupdate
end