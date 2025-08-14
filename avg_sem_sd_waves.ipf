#pragma rtGlobals=1

Macro avg_sem_sd_waves()

pavg_sem_sd_waves()

proc pavg_sem_sd_waves(str_input)
string str_input
prompt str_input "input waves ?"
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
variable var_index = 0
make/o/n=(itemsinlist(str_list)) $(replacestring("*",str_input,"_avg")) = nan
make/o/n=(itemsinlist(str_list)) $(replacestring("*",str_input,"_sem")) = nan
make/o/n=(itemsinlist(str_list)) $(replacestring("*",str_input,"_sd")) = nan
do
	wavestats/q $stringfromlist(var_index,str_list)
	$(replacestring("*",str_input,"_avg"))[var_index] = v_avg
	$(replacestring("*",str_input,"_sem"))[var_index] = v_sem
	$(replacestring("*",str_input,"_sd"))[var_index] = v_sdev
	setdimlabel 0,var_index,$stringfromlist(var_index,str_list),$(replacestring("*",str_input,"_avg"))
	setdimlabel 0,var_index,$stringfromlist(var_index,str_list),$(replacestring("*",str_input,"_sem"))
	setdimlabel 0,var_index,$stringfromlist(var_index,str_list),$(replacestring("*",str_input,"_sd"))
	var_index+=1
while(var_index<itemsinlist(str_list))
end