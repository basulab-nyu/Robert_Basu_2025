#pragma rtGlobals=1
#include <Waves Average>

macro vector_average_groups()

pVxA_g()
proc pVxA_g(str_input,str_sweep_N)
string str_input
prompt str_input "input waves ?"
string str_sweep_N
prompt str_sweep_N "group start position ?"
variable/g var_sweep_N = str2num(str_sweep_N)
string str_list_input = sortlist (wavelist(str_input,";",""),";",16)
string str_list_print = sortlist (wavelist(str_input,"\r",""),"\r",16)
print "input waves:"
print str_list_print
print "group names:"
variable/g var_str = 0
variable/g var_txt = 0
make/o/t/n=(0,0) m_grp_names
silent 1
do
//setting up groups
	string/g str_extract = stringfromlist(var_str,str_list_input)[var_sweep_N,strlen(stringfromlist(var_str,str_list_input))-1]
	string/g str_swap = stringfromlist(var_str,str_list_input)
	str_swap[var_sweep_N,strlen(stringfromlist(var_str,str_list_input))-1] = "*"
	string/g str_name = str_swap
	str_name = replacestring("*",str_name,"")
	print str_name
	string/g str_group = sortlist(wavelist(str_swap,";",""),";",16)
	if (dimsize(m_grp_names,0) < itemsinlist(str_group))
		redimension/n=(itemsinlist(str_group),dimsize(m_grp_names,1)) m_grp_names
	endif
	redimension/n=(dimsize(m_grp_names,0),dimsize(m_grp_names,1)+1) m_grp_names
	setdimLabel 1,var_txt,$str_name,m_grp_names
//grabbing scales
	make/o/n=(itemsinlist(str_group)) w_x_range = nan
	make/o/n=(itemsinlist(str_group)) w_x_offset = nan
	make/o/n=(itemsinlist(str_group)) w_x_delta = nan
	make/o/n=(itemsinlist(str_group)) w_x_Grange = nan
	variable/g var_subscroll = 0
	do
		string/g str_waves = stringfromlist(var_subscroll,str_group)
		m_grp_names[var_subscroll][var_txt] = str_waves
		w_x_range[var_subscroll] = dimsize($str_waves,0)+dimoffset($str_waves,0)/dimdelta($str_waves,0)
		w_x_offset[var_subscroll] = dimoffset($str_waves,0)
		w_x_delta[var_subscroll] = dimdelta($str_waves,0)
		var_subscroll += 1
	while(var_subscroll<itemsinlist(str_group))
	if (w_x_delta[0] > 0)
		variable/g var_x_offset = wavemin(w_x_offset)
		variable/g var_x_delta = wavemin(w_x_delta)
		make/o/n=(numpnts(w_x_delta)) w_x_delta_mod = nan
		variable/g var_mod_ck = 0
		do
			if (mod(w_x_delta[var_mod_ck],var_x_delta) == 0)
				w_x_delta_mod[var_mod_ck] = nan
			else
				w_x_delta_mod[var_mod_ck] = mod(w_x_delta[var_mod_ck],var_x_delta)
			endif
			var_mod_ck += 1
		while (var_mod_ck < numpnts(w_x_delta))
		if (numtype(wavemin(w_x_delta_mod)) == 0)
			var_x_delta = wavemin(w_x_delta_mod)
			var_x_offset = var_x_offset - var_x_delta
		endif
		variable/g var_x_range = wavemax(w_x_range)*wavemax(w_x_delta)/var_x_delta
	else
		variable/g var_x_offset = wavemax(w_x_offset)
		variable/g var_x_delta = wavemax(w_x_delta)
		make/o/n=(numpnts(w_x_delta)) w_x_delta_mod = nan
		variable/g var_mod_ck = 0
		do
			if (mod(w_x_delta[var_mod_ck],var_x_delta) == 0)
				w_x_delta_mod[var_mod_ck] = nan
			else
				w_x_delta_mod[var_mod_ck] = mod(w_x_delta[var_mod_ck],var_x_delta)
			endif
			var_mod_ck += 1
		while (var_mod_ck < numpnts(w_x_delta))
		if (numtype(wavemax(w_x_delta_mod)) == 0)
			var_x_delta = wavemax(w_x_delta_mod)
			var_x_offset = var_x_offset - var_x_delta
		endif
		variable/g var_x_range = wavemax(w_x_range)*wavemin(w_x_delta)/var_x_delta
	endif
//implementing scales
	variable/g var_nb = itemsinlist(str_group)
	make/o/n=(var_x_range,var_nb) $(str_name+"_2D") = nan
	variable/g var_index = 0
	do
		str_waves = stringfromlist(var_index,str_group)
		duplicate/o $str_waves tempM
		variable/g var_off = 0
		if (var_x_offset != dimoffset(tempM,0))
			var_off = 1
			variable/g var_x_add = dimoffset(tempM,0)/dimdelta(tempM,0) - var_x_offset/dimdelta(tempM,0)
			insertpoints/m=0/v=nan 0,var_x_add,tempM
			setscale/p x var_x_offset,dimdelta(tempM,0),"", tempM
		endif
		if (var_x_delta != dimdelta(tempM,0))
			variable/g var_x_inc = dimdelta(tempM,0)/var_x_delta
			variable/g var_Dscroll = 0
			variable/g var_Dend = dimsize(tempM,0)
			do
				if (var_off == 1)
					insertpoints/m=0/v=nan (var_Dscroll*var_x_inc),(var_x_inc-1),tempM
				else
					insertpoints/m=0/v=nan (var_Dscroll*var_x_inc)+1,(var_x_inc-1),tempM
				endif
				var_Dscroll += 1
			while (var_Dscroll < var_Dend)
			setscale/p x var_x_offset,var_x_delta,"", tempM
		endif
		if (var_x_range != dimsize(tempM,0))
			variable/g var_x_add = var_x_range - dimsize(tempM,0)
			insertpoints/m=0/v=nan dimsize(tempM,0),var_x_add,tempM
		endif
		duplicate/o tempM $(nameofwave($str_waves)+"_sc")
		$(str_name+"_2D")[][var_index] = tempM[p]
		setdimlabel 1,var_index,,$(nameofwave($str_waves)+"_sc"),$(str_name+"_2D")
		var_index += 1
	while(var_index<itemsinlist(str_group))
//generating groups average vectors
	make/o/n=(dimsize(tempM,0)) $(str_name+"_avg") = nan
	make/o/n=(dimsize(tempM,0)) $(str_name+"_sem") = nan
	duplicate/o $(str_name+"_2D") transwave
	matrixtranspose transwave
	variable/g var_size = dimsize(transwave,1)
	variable/g var_scroll_x = 0
	do
		duplicate/o/r=[][var_scroll_x] transwave tempwave
		wavestats/q tempwave
		$(str_name+"_avg")[var_scroll_x] = v_avg
		$(str_name+"_sem")[var_scroll_x] = v_sem
		var_scroll_x += 1
	while (var_scroll_x < var_size)
	setscale/p x var_x_offset,dimdelta(tempM,0),"", $(str_name+"_avg")
	setscale/p x var_x_offset,dimdelta(tempM,0),"", $(str_name+"_sem")
	setscale/p x var_x_offset,dimdelta(tempM,0),"", $(str_name+"_2D")
	var_txt += 1
	var_str += itemsinlist(str_group)
while(var_str<itemsinlist(str_list_input))
edit m_grp_names.ld
beep
end