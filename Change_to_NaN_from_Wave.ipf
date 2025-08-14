#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro Change_to_NaN_from_Wave()

pCtNfW()
proc pCtNfW(str_input,str_ref,str_comp,str_limit)
string str_input
prompt str_input "input waves ?"
string str_ref
prompt str_ref "reference wave ?"
string str_comp
prompt str_comp "< (0) or > (1)"
string str_limit
prompt str_limit "threshold ?"
variable/g var_limit = str2num (str_limit)
variable/g var_comp = str2num (str_comp)
string/g str_list = sortlist(wavelist(str_input,";",""),";",16)
string/g str_print = sortlist(wavelist(str_input,"\r",""),"\r",16)
print str_print
variable/g var_total = itemsinlist(str_list)
//string/g str_waves
variable/g var_index = 0
//variable/g var_pos = findlistitem(str_ref, str_list)
str_list = removefromlist(str_ref, str_list)
str_list = addlistitem(str_ref, str_list,";",inf)
do
silent 1
string/g str_waves = stringfromlist(var_index,str_list)
	if (var_index == 0)
		wavestats/q $str_ref
		variable/g var_end = V_endrow
		variable/g var_C = 0
		do
			if (var_C == 0)
				if (var_comp == 0)
					if ($str_ref[var_C] < var_limit)
						$str_waves[var_C] = NaN
						//$str_ref[var_C] = NaN
					endif
				else
					if ($str_ref[var_C] > var_limit)
						$str_waves[var_C] = NaN
						//$str_ref[var_C] = NaN
					endif
				endif
			else
				if (var_comp == 0)
					if ($str_ref[var_C] < var_limit)
						$str_waves[var_C] = NaN
						//$str_ref[var_C] = NaN
					endif
				else
					if ($str_ref[var_C] > var_limit)
						$str_waves[var_C] = NaN
						//$str_ref[var_C] = NaN
					endif
				endif
			endif
		var_C += 1
		while(var_C <= var_end)
	else
		wavestats/q $str_ref
		variable/g var_end = V_endrow
		variable/g var_C = 0
		do
			if (var_C == 0)
				if (var_comp == 0)
					if ($str_ref[var_C] < var_limit)
						$str_waves[var_C] = NaN
						//$str_ref[var_C] = NaN
					endif
				else
					if ($str_ref[var_C] > var_limit)
						$str_waves[var_C] = NaN
						//$str_ref[var_C] = NaN
					endif
				endif
			else
				if (var_comp == 0)
					if ($str_ref[var_C] < var_limit)
						$str_waves[var_C] = NaN
						//$str_ref[var_C] = NaN
					endif
				else
					if ($str_ref[var_C] > var_limit)
						$str_waves[var_C] = NaN
						//$str_ref[var_C] = NaN
					endif
				endif
			endif
		var_C += 1
		while(var_C <= var_end)
	endif
var_index += 1
while (var_index <= var_total)
end