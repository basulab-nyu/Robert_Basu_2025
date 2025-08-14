#pragma rtGlobals=1

Macro m2D_hist_from_1D_vectors()

pm2D_hist_from_1D_vectors()

proc pm2D_hist_from_1D_vectors(str_input,str_bin_start,str_bin_size,str_bin_n,str_output)
string str_input
prompt str_input "input waves ?"
string str_bin_start
prompt str_bin_start "bin start ?"
string str_bin_size
prompt str_bin_size "bin size ?"
string str_bin_n
prompt str_bin_n "bin number ?"
string str_output
prompt str_output "output wave ?"
if(strlen(str_bin_start) == 0)
	str_bin_start = "0"
endif
if(strlen(str_bin_size) == 0)
	str_bin_size = "5"
endif
if(strlen(str_bin_n) == 0)
	str_bin_n = "40"
endif
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
variable var_index
make/o/n=(str2num(str_bin_n),itemsinlist(str_list)) $str_output = nan
var_index = 0
do
	make/o/n=(str2num(str_bin_n)) temp = nan
	histogram/b={str2num(str_bin_start),str2num(str_bin_size),str2num(str_bin_n)}/c/dest=temp $stringfromlist(var_index,str_list)
	$str_output[][var_index] = temp[p]
	setdimlabel 1,var_index,$stringfromlist(var_index,str_list),$str_output
	var_index+=1
while(var_index<itemsinlist(str_list))
setscale/p x,str2num(str_bin_start),str2num(str_bin_size),$str_output
killwaves/z temp
end