#pragma rtglobals=1
macro relabel()
prelabel()
proc prelabel(str_input,str_target,str_output)
string str_input
prompt str_input "input?"
string str_target
prompt str_target "target?"
string str_output
prompt str_output "output?"
string str_index
if(strlen(str_input) == 0)
	str_input = "*"
endif
string str_list = sortlist(wavelist(str_input,";",""),";",16)
variable var_index = 0
pauseupdate
do
	rename $stringfromlist(var_index,str_list) $replacestring(str_target,stringfromlist(var_index,str_list),str_output)
	print stringfromlist(var_index,str_list)
	print replacestring(str_target,stringfromlist(var_index,str_list),str_output)
	var_index+=1
while(var_index<itemsinlist(str_list))
resumeupdate
end
