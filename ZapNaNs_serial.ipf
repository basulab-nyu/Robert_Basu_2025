#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro ZapNaNserial()

pZpNs()
proc pZpNs(str_input)
string str_input
prompt str_input "input waves ?"
string str_list_input = wavelist(str_input,";","")
string str_list_sort = sortlist (str_list_input,";",16)
string str_list_print = wavelist(str_input,"\r","")
string str_list_sort_print = sortlist (str_list_print,"\r",16)
print str_list_sort_print
variable/g var_total = itemsinlist(str_list_input)
variable/g var_index = 0
do
silent 1
	string/g inWave = stringfromlist(var_index,str_list_sort)
	if (strlen(inWave) == 0)
		break
	endif
	if (var_index == 0) // 1st wave
		wavetransform/o zapnans $inWave
	else
		wavetransform/o zapnans $inWave
	endif
var_index += 1
while(var_index<=var_total)	
beep
end