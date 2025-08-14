#pragma rtGlobals=1
macro matrix_3D_average_regex()
pmatrix_3D_average_regex()
proc pmatrix_3D_average_regex(str_input,str_regex,str_output)
string str_input
prompt str_input "input?"
string str_regex
prompt str_regex "regex?"
string str_output
prompt str_output "output?"
if(strlen(str_input) == 0)
	str_input = "spike_binRheo_*"
endif
if(strlen(str_regex) == 0)
	str_regex = "(w+[[:digit:]]{6}+c+[[:digit:]]{1,2}+_+[[:alpha:]]{2})"
endif
if(strlen(str_output) == 0)
	str_output = "spike_binRheo"
endif
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
make/o/t/n=(itemsinlist(str_list)) temp = stringfromlist(p,str_list)
string str_split
variable var_index
variable var_index1
variable var_index2
variable var_index3
variable var_x
variable var_y
variable var_z
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
	extract/indx temp,temp2,stringmatch(temp,temp1[var_index]) == 1 //temp2 = pool indices
	var_x = 0
	var_y = 0
	var_z = 0
	var_index1 = 0
	do
		var_x = max(var_x,dimsize($stringfromlist(temp2[var_index1],str_list),0))
		var_y = max(var_y,dimsize($stringfromlist(temp2[var_index1],str_list),1))
		var_z = max(var_z,dimsize($stringfromlist(temp2[var_index1],str_list),2))
		var_index1+=1
	while(var_index1<dimsize(temp2,0))
	make/o/n=(var_x,var_y,var_z,dimsize(temp2,0)) temp3 = nan
	var_index1 = 0
	do
		temp3[0,dimsize($stringfromlist(temp2[var_index1],str_list),0)-1][0,dimsize($stringfromlist(temp2[var_index1],str_list),1)-1][0,dimsize($stringfromlist(temp2[var_index1],str_list),2)-1][var_index1] = $stringfromlist(temp2[var_index1],str_list)[p][q][r]
		setdimlabel 3,var_index1,$stringfromlist(temp2[var_index1],str_list),temp3
		var_index1+=1
	while(var_index1<dimsize(temp2,0))
	make/o/n=(dimsize(temp3,0),dimsize(temp3,1),dimsize(temp3,2)) $(temp1[var_index]+"_"+str_output+"_pool") = nan
	var_index1 = 0
	do
		var_index2 = 0
		do
			var_index3 = 0
			do
				wavestats/q/rmd=[var_index1][var_index2][var_index3][] temp3
				$(temp1[var_index]+"_"+str_output+"_pool")[var_index1][var_index2][var_index3] = v_avg
				var_index3+=1
			while(var_index3<dimsize($(temp1[var_index]+"_"+str_output+"_pool"),2))
			var_index2+=1
		while(var_index2<dimsize($(temp1[var_index]+"_"+str_output+"_pool"),1))
		var_index1+=1
	while(var_index1<dimsize($(temp1[var_index]+"_"+str_output+"_pool"),0))
	duplicate/o temp3,$(temp1[var_index]+"_"+str_output+"_4D")
	copydimlabels/cols=1 $stringfromlist(temp2[0],str_list),$(temp1[var_index]+"_"+str_output+"_pool")
	copydimlabels/layr=2 $stringfromlist(temp2[0],str_list),$(temp1[var_index]+"_"+str_output+"_pool")
	copydimlabels/cols=1 $stringfromlist(temp2[0],str_list),$(temp1[var_index]+"_"+str_output+"_4D")
	copydimlabels/layr=2 $stringfromlist(temp2[0],str_list),$(temp1[var_index]+"_"+str_output+"_4D")
	var_index1 = 0
	do
		setdimlabel 0,var_index1,$("sweep#"+num2str(var_index1+1)),$(temp1[var_index]+"_"+str_output+"_pool")
		setdimlabel 0,var_index1,$("sweep#"+num2str(var_index1+1)),$(temp1[var_index]+"_"+str_output+"_4D")
		var_index1+=1
	while(var_index1<dimsize($(temp1[var_index]+"_"+str_output+"_pool"),0))
	copyscales/p $stringfromlist(temp2[0],str_list),$(temp1[var_index]+"_"+str_output+"_pool")
	copyscales/p $stringfromlist(temp2[0],str_list),$(temp1[var_index]+"_"+str_output+"_4D")
	var_index+=1
while(var_index<dimsize(temp1,0))
killwaves/z temp,temp1,temp2,temp3
resumeupdate
end