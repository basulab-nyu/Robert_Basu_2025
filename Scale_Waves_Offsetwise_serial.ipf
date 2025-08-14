#pragma rtGlobals=1

macro Scale_Waves_Offsetwise_serial()

pScale_Waves_Offsetwise_serial()
proc pScale_Waves_Offsetwise_serial(str_input,str_scale)
string str_input
prompt str_input "input waves ?"
string str_scale
prompt str_scale "scale ?"
string str_list = sortlist(wavelist(str_input,";",""),";",16)
//print replacestring(";",str_list,"\r")
variable var_index = 0
do
	print stringfromlist(var_index,str_list)
	setscale/p x,dimoffset($stringfromlist(var_index,str_list),0)*str2num(str_scale),str2num(str_scale),$stringfromlist(var_index,str_list)
	var_index+=1
while(var_index<itemsinlist(str_list))
end
