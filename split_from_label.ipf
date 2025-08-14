#pragma rtglobals=1
macro split_from_label()
psplit_from_label()
proc psplit_from_label(str_input,str_regex)
string str_input
prompt str_input "input ?"
string str_regex
prompt str_regex "regex ?"
if(strlen(str_input) == 0)
	str_input = "*"
endif
if(strlen(str_regex) == 0)
	str_regex = "(w+[[:digit:]]{6}+c+[[:digit:]]{1,2}+_+[[:alpha:]]{2}+_+[[:digit:]]{3})"
endif
string str_list = sortlist(wavelist(str_input,";",""),";",16)
string str_split
string str_output
variable var_index = 0
variable var_index1
variable var_index2
pauseupdate
do
	make/o/t/n=(dimsize($stringfromlist(var_index,str_list),0)) temp = getdimlabel($stringfromlist(var_index,str_list),0,p)
	var_index1 = 0
	do
		splitstring/e=str_regex temp[var_index1],str_split
		temp[var_index1] = str_split //temp = common id
		var_index1+=1
	while(var_index1<dimsize(temp,0))
	findduplicates/rt=temp1 temp //temp1 = unique id
	var_index1 = 0
	do
		extract/indx temp,temp2,stringmatch(temp,temp1[var_index1]) == 1 //temp2 = pool indices
		make/o/n=(dimsize(temp2,0),dimsize($stringfromlist(var_index,str_list),1)) $(stringfromlist(var_index,str_list)+"_"+temp1[var_index1]) = nan
		var_index2 = 0
		do
			$(stringfromlist(var_index,str_list)+"_"+temp1[var_index1])[var_index2][] = $stringfromlist(var_index,str_list)[temp2[var_index2]][q]
			setdimlabel 0,var_index2,$getdimlabel($stringfromlist(var_index,str_list),0,temp2[var_index2]),$(stringfromlist(var_index,str_list)+"_"+temp1[var_index1])
			var_index2+=1
		while(var_index2<dimsize(temp2,0))
		copydimlabels/cols=1 $stringfromlist(var_index,str_list),$(stringfromlist(var_index,str_list)+"_"+temp1[var_index1])
		var_index1+=1
	while(var_index1<dimsize(temp1,0))
	var_index+=1
while(var_index<itemsinlist(str_list))
resumeupdate
killwaves/z temp,temp1,temp2,temp3,temp4
end