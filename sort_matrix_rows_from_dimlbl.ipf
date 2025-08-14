#pragma rtGlobals=1

macro sort_matrix_rows_from_dimlbl()

psort_matrix_rows_from_dimlbl()
proc psort_matrix_rows_from_dimlbl(str_input)
string str_input
prompt str_input "input waves ?"
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
variable var_index
variable var_index1
silent 1
pauseupdate
var_index = 0
do
	duplicate/o $stringfromlist(var_index,str_list),$(stringfromlist(var_index,str_list)+"_sort")
	$(stringfromlist(var_index,str_list)+"_sort") = nan
	make/o/t/n=(dimsize($stringfromlist(var_index,str_list),0)) templbl
	templbl = getdimlabel($stringfromlist(var_index,str_list),0,p)
	make/o/n=(dimsize(templbl,0)) tempidx = p
	sort templbl,tempidx
	var_index1 = 0
	do
		$(stringfromlist(var_index,str_list)+"_sort")[var_index1][] = $stringfromlist(var_index,str_list)[tempidx[var_index1]][q]
		setdimlabel 0,var_index1,$getdimlabel($stringfromlist(var_index,str_list),0,tempidx[var_index1]),$(stringfromlist(var_index,str_list)+"_sort")
		var_index1+=1
	while(var_index1<dimsize(templbl,0))
	var_index+=1
while(var_index<itemsinlist(str_list))
resumeupdate
killwaves/z templbl,tempidx
end