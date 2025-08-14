#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro Matrix_Col_Concat_ZapNaNs()

pMatrix_Col_Concat_ZapNaNs()
proc pMatrix_Col_Concat_ZapNaNs(str_input)
string str_input
prompt str_input "input waves ?"
string str_list = sortlist(wavelist(str_input,";",""),";",16)
print replacestring(";",str_list,"\r")
variable var_index
variable var_Nrows
variable var_Ncols
silent 1
pauseupdate
var_index = 0
do
	duplicate/o $stringfromlist(var_index,str_list) tempinwave
	var_Nrows = dimsize(tempinwave,0)
	var_Ncols = dimsize(tempinwave,1)
	matrixop/o tempoutwave = redimension(tempinwave,var_Nrows*var_Ncols,1)
	wavetransform zapnans tempoutwave
	duplicate/o tempoutwave $(stringfromlist(var_index,str_list)+"_1D")
	killwaves/z tempinwave,tempoutwave
	var_index+=1
while(var_index<itemsinlist(str_list))
resumeupdate
end