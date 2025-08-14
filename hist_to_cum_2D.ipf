#pragma rtGlobals=1

Macro hist_to_cum_2D()

phist_to_cum_2D()

proc phist_to_cum_2D(str_input,str_dim)
string str_input
prompt str_input "input waves ?"
string str_dim
prompt str_dim "dimension ?"
if(strlen(str_dim) == 0)
	str_dim = "1"
endif
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
variable var_index = 0
variable var_index1
variable var_length
variable var_plot
variable V_FitError
if(str2num(str_dim) == 1)
	var_length = 0
else
	var_length = 1
endif
pauseupdate
do
	display
	movewindow 400,45,750,350
	var_plot = 0
	integrate/dim=(str2num(str_dim)) $stringfromlist(var_index,str_list)/d=$(stringfromlist(var_index,str_list)+"_cum")
	duplicate/o $(stringfromlist(var_index,str_list)+"_cum") $(stringfromlist(var_index,str_list)+"_cum_fit")
	$(stringfromlist(var_index,str_list)+"_cum_fit") = nan
	make/o/n=(dimsize($stringfromlist(var_index,str_list),var_length)) $(stringfromlist(var_index,str_list)+"_K") = nan
	var_index1 = 0
	do
		duplicate/o/r=[var_index1][] $(stringfromlist(var_index,str_list)+"_cum"),temp
		matrixtranspose temp
		redimension/n=-1 temp
		wavestats/q temp
		if(v_npnts>v_numnans)
			V_FitError = 0
			curvefit/q/n/w=2 sigmoid,$(stringfromlist(var_index,str_list)+"_cum")[var_index1][]/d=temp
			if(V_FitError == 0)
				//curvefit/q sigmoid,$(stringfromlist(var_index,str_list)+"_cum")[var_index1][]/d=temp
				$(stringfromlist(var_index,str_list)+"_cum_fit")[var_index1][] = temp[q]
				$(stringfromlist(var_index,str_list)+"_K")[var_index1] = w_coef[2]
				appendtograph $(stringfromlist(var_index,str_list)+"_cum")[var_index1][]
				appendtograph $(stringfromlist(var_index,str_list)+"_cum_fit")[var_index1][]
				if(var_plot == 0)
					modifygraph rgb($(stringfromlist(var_index,str_list)+"_cum")) = (0,0,0)
					modifygraph rgb($(stringfromlist(var_index,str_list)+"_cum_fit")) = (65535,0,0)
				else
					modifygraph rgb($(stringfromlist(var_index,str_list)+"_cum#"+num2str(var_plot))) = (0,0,0)
					modifygraph rgb($(stringfromlist(var_index,str_list)+"_cum_fit#"+num2str(var_plot))) = (65535,0,0)
				endif
				var_plot+=1
			endif
		endif
		var_index1+=1
	while(var_index1<dimsize($stringfromlist(var_index,str_list),var_length))
	var_index+=1
while(var_index<itemsinlist(str_list))
resumeupdate
killwaves/z temp,tempfit,w_coef,w_sigma
end
