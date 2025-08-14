#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro Replace_Values()

pRVs()
proc pRVs(str_input,str_limit,str_NaN,str_comp)
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
string str_list_input = wavelist(str_input,";","")
string str_list_sort = sortlist (str_list_input,";",16)
string str_list_print = wavelist(str_input,"\r","")
string str_list_sort_print = sortlist (str_list_print,"\r",16)
print str_list_sort_print
variable/g var_total = itemsinlist(str_list_input)
variable/g var_index = 0
if(var_comp == 0)
	if(var_NaN == 0)
		do
		silent 1
		string/g inWave = stringfromlist(var_index,str_list_sort)
			if (strlen(inWave) == 0)
				break
			endif
			if (var_index == 0) // 1st wave
				variable/g var_C = 0
				wavestats/q $inWave
				variable/g var_N = V_endRow
				duplicate/o $inWave tempwave
				do
				silent 1
					if(var_C == 0)
						if (tempwave[var_C] < var_limit)
						tempwave[var_C] = 0
						endif
					else
						if (tempwave[var_C] < var_limit)
						tempwave[var_C] = 0
						endif
					endif
				var_C += 1
				while (var_C<=var_N)
			rename tempwave, $(inWave+"_inf_"+str_limit+"_0")
			else
				variable/g var_C = 0
				wavestats/q $inWave
				variable/g var_N = V_endRow
				duplicate/o $inWave tempwave
				do
				silent 1
					if(var_C == 0)
						if (tempwave[var_C] < var_limit)
						tempwave[var_C] = 0
						endif
					else
						if (tempwave[var_C] < var_limit)
						tempwave[var_C] = 0
						endif
					endif
				var_C += 1
				while (var_C<=var_N)
				rename tempwave, $(inWave+"_inf_"+str_limit+"_0")
			endif
		var_index += 1
		while(var_index<=var_total)	
	else
		do
		silent 1
		string/g inWave = stringfromlist(var_index,str_list_sort)
			if (strlen(inWave) == 0)
				break
			endif
			if (var_index == 0) // 1st wave
				variable/g var_C = 0
				wavestats/q $inWave
				variable/g var_N = V_endRow
				duplicate/o $inWave tempwave
				do
				silent 1
					if(var_C == 0)
						if (tempwave[var_C] < var_limit)
						tempwave[var_C] = NaN
						endif
					else
						if (tempwave[var_C] < var_limit)
						tempwave[var_C] = NaN
						endif
					endif
				var_C += 1
				while (var_C<=var_N)
			rename tempwave, $(inWave+"_inf_"+str_limit+"_NaN")
			else
				variable/g var_C = 0
				wavestats/q $inWave
				variable/g var_N = V_endRow
				duplicate/o $inWave tempwave
				do
				silent 1
					if(var_C == 0)
						if (tempwave[var_C] < var_limit)
						tempwave[var_C] = NaN
						endif
					else
						if (tempwave[var_C] < var_limit)
						tempwave[var_C] = NaN
						endif
					endif
				var_C += 1
				while (var_C<=var_N)
				rename tempwave, $(inWave+"_inf_"+str_limit+"_NaN")
			endif
		var_index += 1
		while(var_index<=var_total)	
	endif
else
	if(var_NaN == 0)
		do
		silent 1
		string/g inWave = stringfromlist(var_index,str_list_sort)
			if (strlen(inWave) == 0)
				break
			endif
			if (var_index == 0) // 1st wave
				variable/g var_C = 0
				wavestats/q $inWave
				variable/g var_N = V_endRow
				duplicate/o $inWave tempwave
				do
				silent 1
					if(var_C == 0)
						if (tempwave[var_C] > var_limit)
						tempwave[var_C] = 0
						endif
					else
						if (tempwave[var_C] > var_limit)
						tempwave[var_C] = 0
						endif
					endif
				var_C += 1
				while (var_C<=var_N)
			rename tempwave, $(inWave+"_sup_"+str_limit+"_0")
			else
				variable/g var_C = 0
				wavestats/q $inWave
				variable/g var_N = V_endRow
				duplicate/o $inWave tempwave
				do
				silent 1
					if(var_C == 0)
						if (tempwave[var_C] > var_limit)
						tempwave[var_C] = 0
						endif
					else
						if (tempwave[var_C] > var_limit)
						tempwave[var_C] = 0
						endif
					endif
				var_C += 1
				while (var_C<=var_N)
				rename tempwave, $(inWave+"_sup_"+str_limit+"_0")
			endif
		var_index += 1
		while(var_index<=var_total)	
	else
		do
		silent 1
		string/g inWave = stringfromlist(var_index,str_list_sort)
			if (strlen(inWave) == 0)
				break
			endif
			if (var_index == 0) // 1st wave
				variable/g var_C = 0
				wavestats/q $inWave
				variable/g var_N = V_endRow
				duplicate/o $inWave tempwave
				do
				silent 1
					if(var_C == 0)
						if (tempwave[var_C] > var_limit)
						tempwave[var_C] = NaN
						endif
					else
						if (tempwave[var_C] > var_limit)
						tempwave[var_C] = NaN
						endif
					endif
				var_C += 1
				while (var_C<=var_N)
			rename tempwave, $(inWave+"_sup_"+str_limit+"_NaN")
			else
				variable/g var_C = 0
				wavestats/q $inWave
				variable/g var_N = V_endRow
				duplicate/o $inWave tempwave
				do
				silent 1
					if(var_C == 0)
						if (tempwave[var_C] > var_limit)
						tempwave[var_C] = NaN
						endif
					else
						if (tempwave[var_C] > var_limit)
						tempwave[var_C] = NaN
						endif
					endif
				var_C += 1
				while (var_C<=var_N)
				rename tempwave, $(inWave+"_sup_"+str_limit+"_NaN")
			endif
		var_index += 1
		while(var_index<=var_total)	
	endif
endif
beep
end