#pragma rtGlobals=1

macro Offset_Waves_serial()

pOWs()
proc pOWs(str_input,str_offset)
string str_input
prompt str_input "input waves ?"
string str_offset
prompt str_offset "offset (s) ?"
string str_index
string str_list = wavelist(str_input,";","")
string str_list_sort = sortlist (str_list,";",16)
string str_list_print = wavelist(str_input,"\r","")
string str_list_sort_print = sortlist (str_list_print,"\r",16)
print str_list_sort_print
variable/g var_count
variable/g var_offset = str2num(str_offset)
var_count = 0
string str_waves
do
silent 1
	str_waves = stringfromlist(var_count,str_list_sort)
	if (strlen(str_waves) == 0)
		break
	endif
	if (var_count == 0)
		variable/g var_rate = deltax($str_waves)
		SetScale/P x -var_offset,var_rate,"", $str_waves
	else
		variable/g var_rate = deltax($str_waves)
		SetScale/P x -var_offset,var_rate,"", $str_waves
	endif
	var_count += 1
while (1)
end
