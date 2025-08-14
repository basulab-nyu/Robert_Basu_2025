#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro vector_to_matrix_groups()

pvector_to_matrix_groups()
proc pvector_to_matrix_groups(str_input,str_dim_in,str_dim_out,str_sort)
string str_input
prompt str_input "input waves (textwave) ?"
string str_dim_in
prompt str_dim_in "input dimension ?"
string str_dim_out
prompt str_dim_out "output dimension ?"
string str_sort
prompt str_sort "alphanumerical sorting (byte) ?"
if(strlen(str_input) == 0)
	str_input = "wref"
endif
if(strlen(str_dim_in) == 0)
	str_dim_in = "0"
endif
if(strlen(str_dim_out) == 0)
	str_dim_out = "0"
endif
string str_list
string str_output
string str_outtxt
variable var_index
variable var_index1
var_index = 0
do
	str_list = ""
	if(strlen(str_sort) == 0)
		str_list = wavelist($str_input[var_index],";","")
	else
		str_list = sortlist(wavelist($str_input[var_index],";",""),";",str2num(str_sort))
	endif
	str_output = ""
	str_output = $str_input[var_index]
	do
		str_output = str_output[0,strsearch(str_output,"*",0)-1]+str_output[strsearch(str_output,"*",0)+1,inf]
	while(grepstring(str_output,"\*") == 1)
	str_output = str_output+"_2d"
	str_output = replacestring("__",str_output,"_")
	str_outtxt = replacestring("_2d",str_output,"_2t")
	print str_output
	print str_outtxt
	print replacestring(";",str_list,"\r")
	if(str2num(str_dim_in) == 0 && str2num(str_dim_out) == 0)//cols to cols
		make/o/n=(dimsize($stringfromlist(0,str_list),0),0) $str_output
		make/t/o/n=(dimsize($stringfromlist(0,str_list),0),0) $str_outtxt
	endif
	if(str2num(str_dim_in) == 1 && str2num(str_dim_out) == 0)//rows to cols
		make/o/n=(dimsize($stringfromlist(0,str_list),1),0) $str_output
		make/t/o/n=(dimsize($stringfromlist(0,str_list),1),0) $str_outtxt
	endif
	if(str2num(str_dim_in) == 0 && str2num(str_dim_out) == 1)//cols to rows
		make/o/n=(0,dimsize($stringfromlist(0,str_list),0)) $str_output
		make/t/o/n=(0,dimsize($stringfromlist(0,str_list),0)) $str_outtxt
	endif
	if(str2num(str_dim_in) == 1 && str2num(str_dim_out) == 1)//rows to rows
		make/o/n=(0,dimsize($stringfromlist(0,str_list),1)) $str_output
		make/t/o/n=(0,dimsize($stringfromlist(0,str_list),1)) $str_outtxt
	endif
	var_index1 = 0
	do
		if(str2num(str_dim_in) == 0 && str2num(str_dim_out) == 0)//cols to cols
			redimension/n=(dimsize($str_output,0),dimsize($str_output,1)+1) $str_output
			$str_output[][var_index1] = $stringfromlist(var_index1,str_list)[p]
			setdimlabel 1,var_index1,$stringfromlist(var_index1,str_list),$str_output
			redimension/n=(dimsize($str_outtxt,0),dimsize($str_outtxt,1)+1) $str_outtxt
			$str_outtxt[][var_index1] = getdimlabel($stringfromlist(var_index1,str_list),0,p)
			//copydimlabels/rows=0 $stringfromlist(var_index1,str_list),$str_output
		endif
		if(str2num(str_dim_in) == 1 && str2num(str_dim_out) == 0)//rows to cols
			redimension/n=(dimsize($str_output,0),dimsize($str_output,1)+1) $str_output
			$str_output[][var_index1] = $stringfromlist(var_index1,str_list)[0][p]
			setdimlabel 1,var_index1,$stringfromlist(var_index1,str_list),$str_output
			redimension/n=(dimsize($str_output,0),dimsize($str_output,1)+1) $str_outtxt
			$str_outtxt[][var_index1] = getdimlabel($stringfromlist(var_index1,str_list),1,p)
			//copydimlabels/rows=1 $stringfromlist(var_index1,str_list),$str_output
		endif
		if(str2num(str_dim_in) == 0 && str2num(str_dim_out) == 1)//cols to rows
			redimension/n=(dimsize($str_output,0)+1,dimsize($str_output,1)) $str_output
			$str_output[var_index1][] = $stringfromlist(var_index1,str_list)[q]
			setdimlabel 0,var_index1,$stringfromlist(var_index1,str_list),$str_output
			redimension/n=(dimsize($str_output,0)+1,dimsize($str_output,1)) $str_outtxt
			$str_outtxt[var_index1][] = getdimlabel($stringfromlist(var_index1,str_list),1,p)
			//copydimlabels/cols=1 $stringfromlist(var_index1,str_list),$str_output
		endif
		if(str2num(str_dim_in) == 1 && str2num(str_dim_out) == 1)//rows to rows
			redimension/n=(dimsize($str_output,0)+1,dimsize($str_output,1)) $str_output
			$str_output[var_index1][] = $stringfromlist(var_index1,str_list)[0][q]
			setdimlabel 0,var_index1,$stringfromlist(var_index1,str_list),$str_output
			redimension/n=(dimsize($str_output,0)+1,dimsize($str_output,1)) $str_outtxt
			$str_outtxt[var_index1][] = getdimlabel($stringfromlist(var_index1,str_list),0,p)
			//copydimlabels/cols=0 $stringfromlist(var_index1,str_list),$str_output
		endif
		var_index1+=1
	while(var_index1<itemsinlist(str_list))
	var_index+=1
while(var_index<numpnts($str_input))
end