#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro Target_Cell_to_NaN_Matrix()

pTarget_Cell_to_NaN_Matrix()
proc pTarget_Cell_to_NaN_Matrix(str_input,str_x,str_y)
string str_input
prompt str_input "input waves ?"
string str_x
prompt str_x "x location ?"
string str_y
prompt str_y "y location ?"
variable/g var_x = str2num (str_x)
variable/g var_y = str2num(str_y)
string str_list_input = sortlist (wavelist(str_input,";",""),";",16)
string str_list_input_print = sortlist (wavelist(str_input,"\r",""),"\r",16)
print str_list_input_print
variable/g var_index = 0
do
silent 1
	string/g str_waves = stringfromlist(var_index,str_list_input)
	$str_waves[var_x][var_y] = nan
var_index+=1
while (var_index < itemsinlist(str_list_input))
beep
end