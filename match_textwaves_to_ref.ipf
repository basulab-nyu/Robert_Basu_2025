#pragma rtGlobals=1

Macro match_textwaves_to_ref()

pmatch_textwaves_to_ref()

proc pmatch_textwaves_to_ref(str_input,str_ref,str_output)
string str_input
prompt str_input "input waves ?"
string str_ref
prompt str_ref "reference wave ?"
string str_output
prompt str_output "output waves ?"
string/g str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
variable/g var_index = 0
do
	duplicate/o $stringfromlist(var_index,str_list) $(stringfromlist(var_index,str_list)+"_"+str_output)
	make/o/n=(numpnts($stringfromlist(var_index,str_list))) tempref = 0
	make/o/n=(numpnts($str_ref)) tempadd = 0
	variable/g var_labels = 0
	do
		string/g str_match = $str_ref[var_labels]
		variable/g var_missing = 1
		variable/g var_match = 0
		do
			string/g str_check = $(stringfromlist(var_index,str_list)+"_"+str_output)[var_match]
			if(stringmatch(str_match,str_check) == 1)
				tempref[var_match] = 1
				var_missing = 0
			endif
			killstrings/z str_check
			var_match+=1
		while(var_match<numpnts($(stringfromlist(var_index,str_list)+"_"+str_output)))
		if(var_missing == 1)
			tempadd[var_labels] = 1
		endif
		killstrings/z str_match
		var_labels+=1
	while(var_labels<numpnts($str_ref))
	variable/g var_asgn = 0
	do
		if(tempref[var_asgn] == 0)
			$(stringfromlist(var_index,str_list)+"_"+str_output)[var_asgn] = ""
		endif
		var_asgn+=1
	while(var_asgn<numpnts($(stringfromlist(var_index,str_list)+"_"+str_output)))
	variable/g var_rm = 0
	do
		if(strlen($(stringfromlist(var_index,str_list)+"_"+str_output)[var_rm]) == 0)
			deletepoints var_rm,1,$(stringfromlist(var_index,str_list)+"_"+str_output)
			var_rm = var_rm-1
		endif
		var_rm+=1
	while(var_rm<numpnts($(stringfromlist(var_index,str_list)+"_"+str_output)))
	variable/g var_add = 0
	do
		if(tempadd[var_add] == 1)
			insertpoints var_add,1,$(stringfromlist(var_index,str_list)+"_"+str_output)
			$(stringfromlist(var_index,str_list)+"_"+str_output)[var_add] = ""
		endif
		var_add+=1
	while(var_add<numpnts($str_ref))
	killwaves/z tempref,tempadd
	var_index+=1
while(var_index<itemsinlist(str_list))
end