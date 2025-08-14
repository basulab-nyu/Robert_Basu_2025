#pragma rtGlobals=1

macro Replace_String_Serial()

pRSS()
proc pRSS(str_input,str_target,str_output)
string str_input
prompt str_input "input waves ?"
string str_target
prompt str_target "target string ?"
string str_output
prompt str_output "output string ?"
string str_index
string str_list = wavelist(str_input,";","")
string str_list_sort = sortlist (str_list,";",16)
string str_list_print = wavelist(str_input,"\r","")
string str_list_sort_print = sortlist (str_list_print,"\r",16)
print str_list_sort_print
variable/g var_count
var_count = 0
string str_waves
string str_newname
do
silent 1
	str_waves = stringfromlist(var_count,str_list_sort)
	if (strlen(str_waves) == 0)
		break
	endif
	if (var_count == 0)
		rename $str_waves,$replacestring(str_target,nameofwave($str_waves),str_output)
	else
		rename $str_waves,$replacestring(str_target,nameofwave($str_waves),str_output)
	endif
	var_count += 1
while (1)
end
