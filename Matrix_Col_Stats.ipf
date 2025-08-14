#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro Matrix_Col_Stats()

pMCS()
proc pMCS(str_input)
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
	if (var_index == 0)
		variable/g var_size = dimsize($inWave,1)
		variable/g var_count = 0
		make/o/n=(var_size) $(nameofwave($inWave)+"_avg")
		make/o/n=(var_size) $(nameofwave($inWave)+"_sem")
		make/o/n=(var_size) $(nameofwave($inWave)+"_SD")
		do
			if (var_count == 0)
				duplicate/o/r=[][var_count] $inWave tempwave
				wavestats/q tempwave
				$(nameofwave($inWave)+"_avg")[var_count] = V_avg
				$(nameofwave($inWave)+"_sem")[var_count] = V_sem
				$(nameofwave($inWave)+"_SD")[var_count] = V_sdev
			else
				duplicate/o/r=[][var_count] $inWave tempwave
				wavestats/q tempwave
				$(nameofwave($inWave)+"_avg")[var_count] = V_avg
				$(nameofwave($inWave)+"_sem")[var_count] = V_sem
				$(nameofwave($inWave)+"_SD")[var_count] = V_sdev
			endif
		var_count = var_count+1
		while (var_count < var_size)
	else
		variable/g var_size = dimsize($inWave,1)
		variable/g var_count = 0
		make/o/n=(var_size) $(nameofwave($inWave)+"_avg")
		make/o/n=(var_size) $(nameofwave($inWave)+"_sem")
		make/o/n=(var_size) $(nameofwave($inWave)+"_SD")
		do
			if (var_count == 0)
				duplicate/o/r=[][var_count] $inWave tempwave
				wavestats/q tempwave
				$(nameofwave($inWave)+"_avg")[var_count] = V_avg
				$(nameofwave($inWave)+"_sem")[var_count] = V_sem
				$(nameofwave($inWave)+"_SD")[var_count] = V_sdev
			else
				duplicate/o/r=[][var_count] $inWave tempwave
				wavestats/q tempwave
				$(nameofwave($inWave)+"_avg")[var_count] = V_avg
				$(nameofwave($inWave)+"_sem")[var_count] = V_sem
				$(nameofwave($inWave)+"_SD")[var_count] = V_sdev
			endif
		var_count = var_count+1
		while (var_count < var_size)
	endif
var_index += 1
while(var_index<var_total)
killwaves tempwave
beep
end