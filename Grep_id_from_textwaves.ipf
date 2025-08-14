#pragma rtGlobals=1

Macro Grep_id_from_textwaves()

pGrep_id_from_textwaves()

proc pGrep_id_from_textwaves(str_input,str_output)
string str_input
prompt str_input "input waves ?"
string str_output
prompt str_output "output waves ?"
string/g str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
variable/g var_index = 0
do
	duplicate/o $stringfromlist(var_index,str_list) $(stringfromlist(var_index,str_list)+"_"+str_output)
	variable/g var_labels = 0
	do
		string/g str_temp = $(stringfromlist(var_index,str_list)+"_"+str_output)[var_labels]
		if(exists("str_new") == 2)
			killstrings/z str_new
		endif
		string/g str_new
		if(grepstring(str_temp,"((?i)[0-9]{6}+[c]{1}+[0-9]{1,2})") == 1)
			splitstring/e=("((?i)[0-9]{6}+[c]{1}+[0-9]{1,2})") str_temp,str_new 
			$(stringfromlist(var_index,str_list)+"_"+str_output)[var_labels] = str_new
			killstrings/z str_temp,str_new
		endif
		var_labels+=1
	while(var_labels<numpnts($(stringfromlist(var_index,str_list)+"_"+str_output)))
	var_index+=1
while(var_index<itemsinlist(str_list))
end
