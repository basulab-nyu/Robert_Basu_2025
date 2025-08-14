#pragma rtglobals=1
macro delta_topgraph()
pdelta_topgraph()
proc pdelta_topgraph(str_output)
string str_output
prompt str_output "output waves ?"
if(strlen(str_output) == 0)
	str_output = "delta"
endif
string str_list = sortlist(tracenamelist("",";",1),";",16)
print replacestring(";",str_list,"\r")
make/o/n=2 sortwave = nan
sortwave[0] = xcsr(A)
sortwave[1] = xcsr(B)
sort sortwave, sortwave
variable var_0 = sortwave[0]
variable var_1 = sortwave[1]
variable var_index = 0
make/o/n=(itemsinlist(str_list)) $str_output
pauseupdate
do	
	$str_output[var_index] = $stringfromlist(var_index,str_list)(var_1)-$stringfromlist(var_index,str_list)(var_0)
	setdimlabel 0,var_index,$stringfromlist(var_index,str_list),$str_output
	var_index+=1
while(var_index<itemsinlist(str_list))
resumeupdate
killwaves/z sortwave
end