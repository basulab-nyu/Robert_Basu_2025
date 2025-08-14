#pragma rtglobals=1
macro label_to_text()
plabel_to_text()
proc plabel_to_text(str_input,str_dim,str_output)
string str_input
prompt str_input "input?"
string str_dim
prompt str_dim "dimension?"
string str_output
prompt str_output "output?"
if(strlen(str_dim) == 0)
	str_dim = "0"
endif
if(strlen(str_output) == 0)
	str_output = "lbls"
endif
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
make/o/t/n=0 $str_output
variable var_index = 0
pauseupdate
do
	make/o/t/n=(dimsize($stringfromlist(var_index,str_list),str2num(str_dim))) temp = getdimlabel($stringfromlist(var_index,str_list),str2num(str_dim),p)
	concatenate/dl/np {temp},$str_output
	setdimlabel 0,var_index*dimsize($stringfromlist(var_index,str_list),0),$stringfromlist(var_index,str_list),$str_output
	var_index+=1
while(var_index<itemsinlist(str_list))
resumeupdate
edit $str_output.ld
killwaves/z temp
end