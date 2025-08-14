#pragma rtglobals=1
macro display_data_regex()
pdisplay_data_regex()
proc pdisplay_data_regex(str_input,str_regex)
string str_input
prompt str_input "input?"
string str_regex
prompt str_regex "regex?"
if(strlen(str_regex) == 0)
	str_regex = "(w+[[:digit:]]{6}+c+[[:digit:]]{1,2}+_+[[:alpha:]]{2}+_+[[:digit:]]{3})"
endif
variable var_left_g
variable var_top_g
variable var_right_g
variable var_bottom_g
variable var_left_t
variable var_top_t
variable var_right_t
variable var_bottom_t
variable var_graph_last
variable var_table_last
string str_graph_last
string str_table_last
string str_graph_list = sortlist(winlist("*",";","WIN:1"),";",16)
if(strlen(str_graph_list) == 0)
	var_left_g = 405
	var_top_g = 38
	var_right_g = 755.25
	var_bottom_g = 353.25
else
	var_graph_last = itemsinlist(str_graph_list)-1
	str_graph_last = winname(0,1)
	getwindow $str_graph_last, wsize
	var_left_g = v_left + 5.25
	var_top_g = v_top + 22.5
	var_right_g = v_right + 5.25
	var_bottom_g = v_bottom + 22.5
endif
string str_table_list = sortlist(winlist("*",";","WIN:2"),";",16)
if(strlen(str_table_list) == 0)
	var_left_t = 452.25
	var_top_t = 256.25
	var_right_t = 957
	var_bottom_t = 454.25
else
	var_table_last = itemsinlist(str_table_list)-1
	str_table_last = winname(0,2)
	getwindow $str_table_last, wsize
	var_left_t = v_left + 5.25
	var_top_t = v_top + 22.5
	var_right_t = v_right + 5.25
	var_bottom_t = v_bottom + 22.5
endif
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
make/o/t/n=(itemsinlist(str_list)) temp = stringfromlist(p,str_list)
string str_split
variable var_index
variable var_index1
var_index = 0
pauseupdate
do
	splitstring/e=str_regex temp[var_index],str_split
	temp[var_index] = str_split //temp = common id
	var_index+=1
while(var_index<dimsize(temp,0))
findduplicates/rt=temp1 temp //temp1 = unique id
var_index = 0
do
	str_list = sortlist(wavelist(temp1[var_index]+"*",";",""),";",16)
	var_index1 = 0
	display
	movewindow var_left_g+var_index*5.25,var_top_g+var_index*22.5,var_right_g+var_index*5.25,var_bottom_g+var_index*22.5
	do
		appendtograph $stringfromlist(var_index1,str_list)
		if(var_index1 == 0)
			modifygraph rgb($stringfromlist(var_index1,str_list))=(0,0,0)
		else
			modifygraph rgb($stringfromlist(var_index1,str_list))=(0,0,0,65535/(var_index1+1))
		endif
		var_index1+=1
	while(var_index1<itemsinlist(str_list))
	modifygraph gfrelsize=4
	modifygraph lsize=1.2
	setaxis bottom 100,1300
	setaxis left -80,60
	label bottom "time (ms)"
	label left "Vm (mV)"
	var_index+=1
while(var_index<dimsize(temp1,0))
resumeupdate
killwaves/z temp,temp1
end