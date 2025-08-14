#pragma rtGlobals=1

macro add_index()

pAI()
proc pAI(str_input)
string str_input
prompt str_input "input waves ?"
string str_index
string str_list = wavelist(str_input,";","")
string str_list_sort = sortlist (str_list,";",16)
string str_list_print = wavelist(str_input,"\r","")
string str_list_sort_print = sortlist (str_list_print,"\r",16)
print str_list_sort_print
variable/g var_count
var_count = 0
string str_waves
do
silent 1
	str_waves = stringfromlist(var_count,str_list_sort)
	if (strlen(str_waves) == 0)
		break
	endif
	if (var_count == 0)
		variable/g var_index = var_count+1
		rename $str_waves, $(nameofwave($str_waves)+"_"+num2str(var_index))
	else
		variable/g var_index = var_count+1
		rename $str_waves, $(nameofwave($str_waves)+"_"+num2str(var_index))
	endif
	var_count += 1
while (1)
end
