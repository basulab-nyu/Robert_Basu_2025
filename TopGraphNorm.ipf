#pragma rtGlobals=1

Macro normalize_from_top_graph()

pnormalize_from_top_graph()

proc pnormalize_from_top_graph()
string str_list = sortlist(tracenamelist("",";",1),";",16)
variable var_index
silent 1
pauseupdate
var_index = 0
do
	duplicate/o $stringfromlist(var_index,str_list), $(stringfromlist(var_index,str_list)+"_n")
	wavestats/q/r=(xcsr(A),xcsr(B)) $stringfromlist(var_index,str_list)
	$(stringfromlist(var_index,str_list)+"_n") = $stringfromlist(var_index,str_list)-v_avg
	var_index+=1
while(var_index<itemsinlist(str_list))
resumeupdate
end