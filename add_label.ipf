#pragma rtglobals=1
macro add_label()
padd_label()
proc padd_label(str_input,str_output)
string str_input
prompt str_input "input?"
string str_output
prompt str_output "label?"
if(strlen(str_input) == 0)
	str_input = "*"
endif
string str_list = sortlist(wavelist(str_input,";",""),";",16)
variable var_index = 0
pauseupdate
do
	rename $stringfromlist(var_index,str_list),$(stringfromlist(var_index,str_list)+"_"+str_output)
	print stringfromlist(var_index,str_list)
	print stringfromlist(var_index,str_list)+"_"+str_output
	var_index+=1
while(var_index<itemsinlist(str_list))
resumeupdate
end