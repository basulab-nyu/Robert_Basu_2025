#pragma rtGlobals=1
macro matrix_3D_average()
pmatrix_3D_average()
proc pmatrix_3D_average(str_input,str_output)
string str_input
prompt str_input "input?"
string str_output
prompt str_output "output?"
if(strlen(str_input) == 0)
	str_input = "w*_RS_spike_binRheo"
endif
if(strlen(str_output) == 0)
	str_output = "RS_spike_binRheo_pool"
endif
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
variable var_index
variable var_index1
variable var_index2
variable var_x = 0
variable var_y = 0
variable var_z = 0
var_index = 0
pauseupdate
do
	var_x = max(var_x,dimsize($stringfromlist(var_index,str_list),0))
	var_y = max(var_y,dimsize($stringfromlist(var_index,str_list),1))
	var_z = max(var_z,dimsize($stringfromlist(var_index,str_list),2))
	var_index+=1
while(var_index<itemsinlist(str_list))
make/o/n=(var_x,var_y,var_z,itemsinlist(str_list)) $(str_output+"_4D") = nan
var_index = 0
do
	$(str_output+"_4D")[0,dimsize($stringfromlist(var_index,str_list),0)-1][0,dimsize($stringfromlist(var_index,str_list),1)-1][0,dimsize($stringfromlist(var_index,str_list),2)-1][var_index] = $stringfromlist(var_index,str_list)[p][q][r]
	setdimlabel 3,var_index,$stringfromlist(var_index,str_list),$(str_output+"_4D")
	var_index+=1
while(var_index<itemsinlist(str_list))
make/o/n=(var_x,var_y,var_z) $(str_output+"_avg") = nan
var_index = 0
do
	var_index1 = 0
	do
		var_index2 = 0
		do
			wavestats/q/rmd=[var_index][var_index1][var_index2][] $(str_output+"_4D")
			$(str_output+"_avg")[var_index][var_index1][var_index2] = v_avg
			var_index2+=1
		while(var_index2<var_z)
		var_index1+=1
	while(var_index1<var_y)
	var_index+=1
while(var_index<var_x)
copydimlabels/cols=1 $stringfromlist(0,str_list),$(str_output+"_avg")
copydimlabels/layr=2 $stringfromlist(0,str_list),$(str_output+"_avg")
copydimlabels/cols=1 $stringfromlist(0,str_list),$(str_output+"_4D")
copydimlabels/layr=2 $stringfromlist(0,str_list),$(str_output+"_4D")
var_index = 0
do
	setdimlabel 0,var_index,$("sweep#"+num2str(var_index+1)),$(str_output+"_avg")
	setdimlabel 0,var_index,$("sweep#"+num2str(var_index+1)),$(str_output+"_4D")
	var_index+=1
while(var_index<dimsize($(str_output+"_avg"),0))
copyscales/p $stringfromlist(0,str_list),$(str_output+"_avg")
copyscales/p $stringfromlist(0,str_list),$(str_output+"_4D")
resumeupdate
end