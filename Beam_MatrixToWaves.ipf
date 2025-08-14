#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro Beam_MatrixToWaves()

pBeam_MatrixToWaves()
proc pBeam_MatrixToWaves(str_input,str_x,str_y)
string str_input
prompt str_input "input waves (3D) ?"
string str_x
prompt str_x "x target ?"
string str_y
prompt str_y "y target ?"
string/g str_list = sortlist (wavelist(str_input,";",""),";",16)
print sortlist (wavelist(str_input,"\r",""),"\r",16)
variable/g var_x = str2num(str_x)
variable/g var_y = str2num(str_y)
silent 1
pauseupdate
variable/g var_index = 0
do
	duplicate/o $stringfromlist(var_index,str_list) temp3D
	matrixop/o tempB=beam(temp3D,var_x,var_y)
	duplicate/o tempB $(nameofwave($stringfromlist(var_index,str_list))+"_bm")
	variable/g var_label = 0
	do
		setdimlabel 0,var_label,$getdimlabel(temp3D,2,var_label),$(nameofwave($stringfromlist(var_index,str_list))+"_bm")
		var_label += 1
	while (var_label < numpnts($(nameofwave($stringfromlist(var_index,str_list))+"_bm")))
	var_index += 1
while (var_index < itemsinlist(str_list))
resumeupdate
killwaves/z tempB, temp3D
end