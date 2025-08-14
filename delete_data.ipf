#pragma rtglobals=1
macro delete_data()
pdelete_data()
proc pdelete_data(str_input)
string str_input
prompt str_input "input?"
if(strlen(str_input) == 0)
	str_input = "*"
endif
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
variable var_index = 0
pauseupdate
do
	killwaves/z $stringfromlist(var_index,str_list)
	var_index+=1
while(var_index<itemsinlist(str_list))
resumeupdate
end