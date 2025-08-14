#pragma rtGlobals=1

macro extract_matrix_n_txt_rows_from_label()
pextract_matrix_n_txt_rows_from_label()
proc pextract_matrix_n_txt_rows_from_label(str_input,str_txt,str_lbl)
string str_input
prompt str_input "input waves ?"
string str_txt
prompt str_txt "input texts ?"
string str_lbl
prompt str_lbl "label ?"
string str_list
string str_txtlist
string str_name = str_lbl
if(strlen(str_input) == 0)
	str_input = "*data"
endif
if(strlen(str_txt) == 0)
	str_txt = "*lbl_sort"
endif
//do
//	if(strlen(str_name[strsearch(str_name,"*",0)+1,inf])>0)
//		str_name = str_name[strsearch(str_name,"*",0)+1,inf]
//	else
//		str_name = str_name[0,strsearch(str_name,"*",0)-1]
//	endif
//while(strsearch(str_name,"*",0)!=-1)
str_name = replacestring("*",str_name,"")
str_name = replacestring("__",str_name,"_")
variable var_index
variable var_index1
str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
str_txtlist = sortlist(wavelist(str_txt,";",""),";",16)
print replacestring(";",str_txtlist,"\r")
var_index = 0
do
	make/o/n=(0,dimsize($stringfromlist(var_index,str_list),1)) $(stringfromlist(var_index,str_list)+"_"+str_name)
	make/t/o/n=(0,dimsize($stringfromlist(var_index,str_txtlist),1)) $(stringfromlist(var_index,str_txtlist)+"_"+str_name)
	var_index1 = 0
	do
		if(stringmatch(getdimlabel($stringfromlist(var_index,str_list),0,var_index1),str_lbl) == 1)
			redimension/n=(dimsize($(stringfromlist(var_index,str_list)+"_"+str_name),0)+1,dimsize($(stringfromlist(var_index,str_list)+"_"+str_name),1)) $(stringfromlist(var_index,str_list)+"_"+str_name)
			redimension/n=(dimsize($(stringfromlist(var_index,str_txtlist)+"_"+str_name),0)+1,dimsize($(stringfromlist(var_index,str_txtlist)+"_"+str_name),1)) $(stringfromlist(var_index,str_txtlist)+"_"+str_name)
			$(stringfromlist(var_index,str_list)+"_"+str_name)[dimsize($(stringfromlist(var_index,str_list)+"_"+str_name),0)-1][] = $stringfromlist(var_index,str_list)[var_index1][q]
			$(stringfromlist(var_index,str_txtlist)+"_"+str_name)[dimsize($(stringfromlist(var_index,str_txtlist)+"_"+str_name),0)-1][] = $stringfromlist(var_index,str_txtlist)[var_index1][q]
			setdimlabel 0,dimsize($(stringfromlist(var_index,str_list)+"_"+str_name),0)-1,$getdimlabel($stringfromlist(var_index,str_list),0,var_index1),$(stringfromlist(var_index,str_list)+"_"+str_name)
			setdimlabel 0,dimsize($(stringfromlist(var_index,str_txtlist)+"_"+str_name),0)-1,$getdimlabel($stringfromlist(var_index,str_list),0,var_index1),$(stringfromlist(var_index,str_txtlist)+"_"+str_name)
		endif
		var_index1+=1
	while(var_index1<dimsize($stringfromlist(var_index,str_list),0))
	var_index+=1
while(var_index<itemsinlist(str_list))
end