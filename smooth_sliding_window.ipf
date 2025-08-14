#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro smooth_sliding_window()

psmooth_sliding_window()
proc psmooth_sliding_window(str_input,str_box,str_output)
string str_input
prompt str_input "input waves ?"
string str_box
prompt str_box "window size (samples) ?"
string str_output
prompt str_output "output waves ?"
if(strlen(str_output) == 0)
	str_output = "s"
endif
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
silent 1
variable var_index = 0
do
	duplicate/o $stringfromlist(var_index,str_list) $(stringfromlist(var_index,str_list)+"_"+str_output)
	smooth/b str2num(str_box),$(stringfromlist(var_index,str_list)+"_"+str_output)
	var_index+=1
while(var_index<itemsinlist(str_list))	
end