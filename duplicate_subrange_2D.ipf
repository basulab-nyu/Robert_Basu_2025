#pragma rtGlobals=1

Macro duplicate_subrange_2D()

pduplicate_subrange_2D()

proc pduplicate_subrange_2D(str_input,str_startrow,str_endrow,str_output)
string str_input
prompt str_input "input waves ?"
string str_startrow
prompt str_startrow "start row ?"
string str_endrow
prompt str_endrow "end row ?"
string str_output
prompt str_output "output waves ?"
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
variable var_index = 0
do
	duplicate/o/r=[str2num(str_startrow),str2num(str_endrow)][] $stringfromlist(var_index,str_list) $(stringfromlist(var_index,str_list)+"_"+str_output)
	var_index+=1
while(var_index<itemsinlist(str_list))
end