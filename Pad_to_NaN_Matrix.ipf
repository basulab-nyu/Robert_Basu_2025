#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro Pad_to_NaN_Matrix()

pPad_to_NaN_Matrix()
proc pPad_to_NaN_Matrix(str_input,str_ref)
string str_input
prompt str_input "input waves ?"
string str_ref
prompt str_ref "reference wave ?"
string str_list = sortlist (wavelist(str_input,";",""),";",16)
string str_print = sortlist (wavelist(str_input,"\r",""),"\r",16)
str_list = removefromlist(str_ref, str_list)
//str_list = addlistitem(str_ref, str_list,";",inf)
print str_print
silent 1
variable/g var_index = 0
do
	string/g str_waves = stringfromlist(var_index,str_list)
	duplicate/o $str_waves $(nameOfWave($str_waves)+"_pad")
	var_index+=1
while (var_index < itemsinlist(str_list))
variable/g var_scroll_x = 0
do
	variable/g var_scroll_y = 1
	do
		if ($str_ref[var_scroll_y][var_scroll_x] == $str_ref[var_scroll_y-1][var_scroll_x])
			variable/g var_index = 0
			do
				string/g str_waves = stringfromlist(var_index,str_list)
				$(nameOfWave($str_waves)+"_pad")[var_scroll_y][var_scroll_x] = NaN
				var_index+=1
			while (var_index < itemsinlist(str_list))
		endif
		var_scroll_y+=1
	while(var_scroll_y < dimsize($str_ref,0))
	var_scroll_x+=1
while (var_scroll_x < dimsize($str_ref,1))
beep
end