#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro Replace_Values_Matrix()

pReplace_Values_Matrix()
proc pReplace_Values_Matrix(str_input,str_limit,str_NaN,str_comp)
string str_input
prompt str_input "input waves ?"
string str_limit
prompt str_limit "threshold ?"
string str_NaN
prompt str_NaN "zero (0) or NaN (1)"
string str_comp
prompt str_comp "< (0) or > (1)"
variable/g var_limit = str2num (str_limit)
variable/g var_NaN = str2num(str_NaN)
variable/g var_comp = str2num (str_comp)
string str_list_input = sortlist (wavelist(str_input,";",""),";",16)
string str_list_input_print = sortlist (wavelist(str_input,"\r",""),"\r",16)
print str_list_input_print
variable/g var_index = 0
do
silent 1
	string/g str_waves = stringfromlist(var_index,str_list_input)
	duplicate/o $str_waves tempwave
	variable/g var_scroll_x = 0
	do
		variable/g var_scroll_y = 0
		do
			if (var_comp == 0) //inf
				if (var_NaN == 0) //zero
					variable/g var_rename = 0
					if (tempwave[var_scroll_x][var_scroll_y] < var_limit)
						tempwave[var_scroll_x][var_scroll_y] = 0
					endif
				else //NaN
					variable/g var_rename = 1
					if (tempwave[var_scroll_x][var_scroll_y] < var_limit)
						tempwave[var_scroll_x][var_scroll_y] = NaN
					endif
				endif
			else //sup
				if (var_NaN == 0) //zero
					variable/g var_rename = 2
					if (tempwave[var_scroll_x][var_scroll_y] > var_limit)
						tempwave[var_scroll_x][var_scroll_y] = 0
					endif
				else //NaN
					variable/g var_rename = 3
					if (tempwave[var_scroll_x][var_scroll_y] > var_limit)
						tempwave[var_scroll_x][var_scroll_y] = NaN
					endif
				endif
			endif
		var_scroll_y+=1
		while(var_scroll_y < dimsize($str_waves,1))
	var_scroll_x+=1
	while (var_scroll_x < dimsize($str_waves,0))
	if (var_rename == 0)
		rename tempwave,  $(str_waves)+"_i_"+str_limit+"_0"
	endif
	if (var_rename == 1)
		rename tempwave,  $(str_waves)+"_i_"+str_limit+"_N"
	endif
	if (var_rename == 2)
		rename tempwave, $(str_waves)+"_s_"+str_limit+"_0"
	endif
	if (var_rename == 3)
		rename tempwave, $(str_waves)+"_s_"+str_limit+"_N"
	endif
var_index+=1
while (var_index < itemsinlist(str_list_input))
beep
end