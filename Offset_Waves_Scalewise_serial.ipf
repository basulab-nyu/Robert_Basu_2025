#pragma rtGlobals=1

macro Offset_Waves_Scalewise_serial()

pOWSws()
proc pOWSws(str_input,str_offset)
string str_input
prompt str_input "input waves ?"
string str_offset
prompt str_offset "offset (s) ?"
string str_index
string str_input_list = sortlist(wavelist(str_input,";",""),";",16)
string str_input_list_print = sortlist(wavelist(str_input,"\r",""),"\r",16)
print str_input_list_print
variable/g var_count = 0
variable/g var_offset = str2num(str_offset)
do
silent 1
	string/g str_waves = stringfromlist(var_count,str_input_list)
	variable/g var_rate = dimdelta($stringfromlist(var_count,str_input_list),0)
	setscale/P x -var_offset,var_rate,"", $str_waves
	var_count += 1
while (var_count < itemsinlist(str_input_list))
end
