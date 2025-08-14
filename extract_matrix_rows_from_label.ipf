#pragma rtGlobals=1

macro extract_matrix_rows_from_lbl()
pextract_matrix_rows_from_lbl()
proc pextract_matrix_rows_from_lbl(str_input,str_lbl)
string str_input
prompt str_input "input waves ?"
string str_lbl
prompt str_lbl "label ?"
string str_list
string str_name = str_lbl
do
	if(strlen(str_name[strsearch(str_name,"*",0)+1,inf])>0)
		str_name = str_name[strsearch(str_name,"*",0)+1,inf]
	else
		str_name = str_name[0,strsearch(str_name,"*",0)-1]
	endif
while(strsearch(str_name,"*",0)!=-1)
variable var_index
variable var_index1
str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
var_index = 0
do
	make/o/n=(0,dimsize($stringfromlist(var_index,str_list),1)) $(stringfromlist(var_index,str_list)+"_"+str_name)
	var_index1 = 0
	do
		if(stringmatch(getdimlabel($stringfromlist(var_index,str_list),0,var_index1),str_lbl) == 1)
			redimension/n=(dimsize($(stringfromlist(var_index,str_list)+"_"+str_name),0)+1,dimsize($(stringfromlist(var_index,str_list)+"_"+str_name),1)) $(stringfromlist(var_index,str_list)+"_"+str_name)
			$(stringfromlist(var_index,str_list)+"_"+str_name)[dimsize($(stringfromlist(var_index,str_list)+"_"+str_name),0)-1][] = $stringfromlist(var_index,str_list)[var_index1][q]
			setdimlabel 0,dimsize($(stringfromlist(var_index,str_list)+"_"+str_name),0)-1,$getdimlabel($stringfromlist(var_index,str_list),0,var_index1),$(stringfromlist(var_index,str_list)+"_"+str_name)
		endif
		var_index1+=1
	while(var_index1<dimsize($stringfromlist(var_index,str_list),0))
	var_index+=1
while(var_index<itemsinlist(str_list))
end