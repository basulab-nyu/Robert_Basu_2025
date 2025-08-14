#pragma rtGlobals=1

Macro Baseline_Cursor_TopGraph()

pBaseline_Cursor_TopGraph()

proc pBaseline_Cursor_TopGraph(str_output)
string str_output
prompt str_output "output waves ?"
string str_list = sortlist(tracenamelist("",";",1),";",16)
print replacestring(";",str_list,"\r")
getaxis/q bottom
variable/g var_left = v_min
variable/g var_right = v_max
string/g str_graph_list = sortlist(winlist("*",";","WIN:1"),";",16)
string/g str_table_list = sortlist(winlist("*",";","WIN:2"),";",16)
variable/g var_graph_last = itemsinlist(str_graph_list)-1
string/g str_graph_last = winname(0,1)
variable/g var_table_last = itemsinlist(str_table_list)-1
string/g str_table_last = winname(0,2)
getwindow $str_graph_last, wsize
variable/g var_left_g = v_left + 5.25
variable/g var_top_g = v_top + 22.5
variable/g var_right_g = v_right + 5.25
variable/g var_bottom_g = v_bottom + 22.5
getwindow $str_table_last, wsize
variable/g var_left_t = v_left + 5.25
variable/g var_top_t = v_top + 22.5
variable/g var_right_t = v_right + 5.25
variable/g var_bottom_t = v_bottom + 22.5
make/o/n=2 sortwave = NaN
sortwave[0] = xcsr(A)
sortwave[1] = xcsr(B)
sort sortwave, sortwave
killstrings/z str_list_d
string/g str_list_d
variable/g var_index = 0
do
silent 1
pauseupdate
	if(strlen(str_output) == 0)
		wavestats/q/r=(sortwave[0],sortwave[1]) $stringfromlist(var_index,str_list)
		variable/g var_baseline_avg = v_avg
		$stringfromlist(var_index,str_list) = $stringfromlist(var_index,str_list) - var_baseline_avg
	else
		wavestats/q/r=(sortwave[0],sortwave[1]) $stringfromlist(var_index,str_list)
		variable/g var_baseline_avg = v_avg
		duplicate/o $stringfromlist(var_index,str_list) $(stringfromlist(var_index,str_list)+"_"+str_output)
		$(stringfromlist(var_index,str_list)+"_"+str_output) = $(stringfromlist(var_index,str_list)+"_"+str_output) - var_baseline_avg
		if(var_index == 0)
			str_list_d = stringfromlist(var_index,str_list)+"_"+str_output
		else
			str_list_d = str_list_d+";"+stringfromlist(var_index,str_list)+"_"+str_output
		endif
	endif
	var_index += 1
while(var_index<itemsinlist(str_list))
if(itemsinlist(str_list_d)>0)
	display
	variable/g var_index = 0
	do
		appendtograph $stringfromlist(var_index,str_list_d)
		var_index+=1
	while(var_index<itemsinlist(str_list_d))
	movewindow var_left_g,var_top_g,var_right_g,var_bottom_g
endif
resumeupdate
setaxis/a=2 left
setaxis bottom var_left,var_right
modifygraph rgb=(0,0,0)
showinfo
showtools/a
killwaves/z sortwave
end