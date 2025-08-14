#pragma rtGlobals=1		// Use modern global access method.
#include <Waves Average>

macro Avg_Subrange_from_Scale()

pAvg_Subrange_from_Scale()
proc pAvg_Subrange_from_Scale(str_input,str_scales,str_factor,str_span,str_output)
string str_input
prompt str_input "input waves ?"
string str_scales
prompt str_scales "scaling wave ?"
string str_factor
prompt str_factor "scale multiplier ?"
string str_span
prompt str_span "window length (x) ?"
string str_output
prompt str_output "output wave ?"
string/g str_list = sortlist(wavelist(str_input,";",""),";",16)
print sortlist(wavelist(str_input,"\r",""),"\r",16)
//make/o/t/n=(itemsinlist(str_list)) w_input_check_txt
//make/o/t/n=(itemsinlist(str_list)) w_scaling_check_txt
make/o/n=(itemsinlist(str_list)) w_x_check
variable/g var_span = str2num(str_span)
variable/g var_factor = str2num(str_factor)
make/o/n=(itemsinlist(str_list)) $str_output
if (itemsinlist(str_list) == numpnts($str_scales))
	variable/g var_index = 0
	do
		string/g str_waves = stringfromlist(var_index,str_list)
		variable/g var_start = $str_scales[var_index]*var_factor - 0.5*var_span*($str_scales[var_index]*var_factor)
		variable/g var_end = $str_scales[var_index]*var_factor + 0.5*var_span*($str_scales[var_index]*var_factor)
		wavestats/q/r=(var_start,var_end) $str_waves
		$str_output[var_index] = v_avg
		setdimlabel 0,var_index,$str_waves,$str_output
		//w_input_check_txt[var_index] = nameofwave($str_waves)
		//w_scaling_check_txt[var_index] = getdimlabel($str_scales,0,var_index)
		w_x_check[var_index] = $str_scales[var_index]*var_factor
		setdimlabel 0,var_index,$getdimlabel($str_scales,0,var_index),w_x_check
		var_index += 1
	while (var_index < itemsinlist(str_list))
else
	print "input waves vs scaling wave mismatch"
endif
//edit w_input_check_txt,w_scaling_check_txt,w_x_check,$str_output.ld
edit w_x_check.ld,$str_output.ld
end