#pragma rtGlobals=1
#include <Waves Average>

macro array_group_concat_scale_interp_avg()

parray_group_concat_scale_interp_avg()
proc parray_group_concat_scale_interp_avg(str_input)
string str_input
prompt str_input "input waves ? (string or textwave)"
//setting up groups
if(exists(str_input) == 1 && wavetype($str_input,1) == 2)
	killstrings/z str_groups
	string/g str_groups
	killstrings/z str_list
	string/g str_list
	variable/g var_ref = 0
	do
		if(strlen(str_list) == 0)
			str_list = sortlist(wavelist($str_input[var_ref],";",""),";",16)
		else
			str_list = str_list+";"+sortlist(wavelist($str_input[var_ref],";",""),";",16)
		endif
		if(strlen(sortlist(wavelist($str_input[var_ref],";",""),";",16))>0)
			if(strlen(str_groups) == 0)
				str_groups = $str_input[var_ref]
			else
				str_groups = str_groups+";"+$str_input[var_ref]
			endif
		endif
		var_ref+=1
	while(var_ref<numpnts($str_input))
	str_list = removefromlist("",str_list)
	print "input waves:"
	print replacestring(";",str_list,"\r")
else
	string/g str_list = sortlist(wavelist(str_input,";",""),";",16)
	string/g str_rm
	variable/g var_rmtxt = 0
	do
		if(wavetype($stringfromlist(var_rmtxt,str_list),1) == 2)
			if (strlen(str_rm) == 0)
				str_rm = stringfromlist(var_rmtxt,str_list)
			else
				str_rm = str_rm+";"+stringfromlist(var_rmtxt,str_list)
			endif
		endif
		var_rmtxt+=1
	while(var_rmtxt<itemsinlist(str_list))
	str_list = removefromlist(str_rm,str_list)
	print "input waves:"
	print replacestring(";",str_list,"\r")
	string/g str_core = str_input[1,strlen(str_input)-2]
	killstrings/z str_groups
	string/g str_groups
	variable/g var_index = 0
	do
		variable/g var_cut = strsearch(stringfromlist(var_index,str_list),str_core,0)
		string/g str_sub = stringfromlist(var_index,str_list)[0,var_cut-1]+str_core+"_*"
		if (itemsinlist(listmatch(str_groups,str_sub)) == 0)
			if (strlen(str_groups) == 0)
				str_groups = str_sub
			else
				str_groups = str_groups+";"+str_sub
			endif
		endif
		var_index+=1
	while (var_index<itemsinlist(str_list))
endif
print "group names:"
print replacestring(";",str_groups,"\r")
variable/g var_groups = 0
do
//grabbing scales
	string/g str_sublist = sortlist(wavelist(stringfromlist(var_groups,str_groups),";",""),";",16)
	make/o/n=(itemsinlist(str_sublist)) w_x_range = nan
	make/o/n=(itemsinlist(str_sublist)) w_x_offset = nan
	make/o/n=(itemsinlist(str_sublist)) w_x_delta = nan
	make/o/n=(itemsinlist(str_sublist)) w_y_range = nan
	make/o/n=(itemsinlist(str_sublist)) w_y_offset = nan
	make/o/n=(itemsinlist(str_sublist)) w_y_delta = nan
	variable/g var_scroll = 0
	do
		string/g str_waves = stringfromlist(var_scroll,str_sublist)
		w_x_range[var_scroll] = dimsize($str_waves,0)
		w_x_offset[var_scroll] = dimoffset($str_waves,0)
		w_x_delta[var_scroll] = dimdelta($str_waves,0)
		w_y_range[var_scroll] = dimsize($str_waves,1)
		w_y_offset[var_scroll] = dimoffset($str_waves,1)
		w_y_delta[var_scroll] = dimdelta($str_waves,1)
		var_scroll+=1
	while(var_scroll<itemsinlist(str_sublist))
//checking scales
	if(w_x_delta[0]>0)
		variable/g var_x_offset = wavemin(w_x_offset)
		variable/g var_x_delta = wavemin(w_x_delta)
		variable/g var_mod_ck = 0
		do
			if(mod(w_x_delta[var_mod_ck],var_x_delta) != 0)
				var_x_delta = min(var_x_delta,gcd(var_x_delta,w_x_delta[var_mod_ck]))
			endif
			var_mod_ck += 1
		while (var_mod_ck<numpnts(w_x_delta))
		duplicate/o w_x_range tempW
		tempW = w_x_range*w_x_delta/var_x_delta
		variable/g var_x_range = wavemax(tempW)
	else
		variable/g var_x_offset = wavemax(w_x_offset)
		variable/g var_x_delta = wavemax(w_x_delta)
		variable/g var_mod_ck = 0
		do
			if(mod(w_x_delta[var_mod_ck],var_x_delta) != 0)
				var_x_delta = max(var_x_delta,0-gcd(var_x_delta,w_x_delta[var_mod_ck]))
			endif
			var_mod_ck += 1
		while (var_mod_ck<numpnts(w_x_delta))
		duplicate/o w_x_range tempW
		tempW = w_x_range*w_x_delta/var_x_delta
		variable/g var_x_range = wavemax(tempW)
	endif
	if(w_y_delta[0]>0)
		variable/g var_y_offset = wavemin(w_y_offset)
		variable/g var_y_delta = wavemin(w_y_delta)
		variable/g var_mod_ck = 0
		do
			if(mod(w_y_delta[var_mod_ck],var_y_delta) != 0)
				var_y_delta = min(var_y_delta,gcd(var_y_delta,w_y_delta[var_mod_ck]))
			endif
			var_mod_ck += 1
		while (var_mod_ck<numpnts(w_y_delta))
		duplicate/o w_y_range tempW
		tempW = w_y_range*w_y_delta/var_y_delta
		variable/g var_y_range = wavemax(tempW)
	else
		variable/g var_y_offset = wavemax(w_y_offset)
		variable/g var_y_delta = wavemax(w_y_delta)
		variable/g var_mod_ck = 0
		do
			if(mod(w_y_delta[var_mod_ck],var_y_delta) != 0)
				var_y_delta = max(var_y_delta,0-gcd(var_y_delta,w_y_delta[var_mod_ck]))
			endif
			var_mod_ck += 1
		while (var_mod_ck<numpnts(w_y_delta))
		duplicate/o w_y_range tempW
		tempW = w_y_range*w_y_delta/var_y_delta
		variable/g var_y_range = wavemax(tempW)
	endif
//implementing scales
	string/g str_name = stringfromlist(var_groups,str_groups)[0,strlen(stringfromlist(var_groups,str_groups))-3]
	variable/g var_x_caution = 0
	variable/g var_y_caution = 0
	if(dimsize($stringfromlist(0,str_sublist),1) == 0)
		make/o/n=(var_x_range,itemsinlist(str_sublist)) $(str_name+"_2D") = nan
		variable/g var_scroll = 0
		do
			make/o/n=(var_x_range) tempM = nan
			setscale/p x var_x_offset,var_x_delta,"", tempM
			str_waves = stringfromlist(var_scroll,str_sublist)
			if(var_x_delta != dimdelta($str_waves,0))
				if(var_x_caution == 0)
					print "CAUTION: non-uniform x scaling in "+str_name+" group"
					print "---> interpolating x scales to match smallest modulus in data"
					var_x_caution = 1
				endif
			endif
			variable/g var_x_asgn = dimoffset($str_waves,0)
			variable/g var_x_cnt = 0
			do
				tempM(var_x_asgn) = $str_waves(var_x_asgn)
				var_x_asgn+=dimdelta($str_waves,0)
				var_x_cnt+=1
			while(var_x_cnt<dimsize($str_waves,0))
			duplicate/o tempM $(nameofwave($str_waves)+"_sc")
			$(str_name+"_2D")[][var_scroll] = tempM[p]
			setdimlabel 1,var_scroll,$(nameofwave($str_waves)+"_sc"),$(str_name+"_2D")
			var_scroll += 1
		while(var_scroll<itemsinlist(str_sublist))
	else
		make/o/n=(var_x_range,var_y_range,itemsinlist(str_sublist)) $(str_name+"_3D") = nan
		variable/g var_scroll = 0
		do
			make/o/n=(var_x_range,var_y_range) tempM = nan
			setscale/p x var_x_offset,var_x_delta,"", tempM
			setscale/p y var_y_offset,var_y_delta,"", tempM
			str_waves = stringfromlist(var_scroll,str_sublist)
			if(var_x_delta != dimdelta($str_waves,0))
				if(var_x_caution == 0)
					print "CAUTION: non-uniform x scaling in "+str_name+" group"
					print "---> interpolating x scales to match smallest modulus in data"
					var_x_caution = 1
				endif
			endif
			if(var_y_delta != dimdelta($str_waves,1))
				if(var_y_caution == 0)
					print "CAUTION: non-uniform y scaling in "+str_name+" group"
					print "---> interpolating y scales to match smallest modulus in data"
					var_y_caution = 1
				endif
			endif
			variable/g var_x_asgn = dimoffset($str_waves,0)
			variable/g var_x_cnt = 0
			do
				variable/g var_y_asgn = dimoffset($str_waves,1)
				variable/g var_y_cnt = 0
				do
					tempM(var_x_asgn)(var_y_asgn) = $str_waves(var_x_asgn)(var_y_asgn)
					var_y_asgn+=dimdelta($str_waves,1)
					var_y_cnt+=1
				while(var_y_cnt<dimsize($str_waves,1))
				var_x_asgn+=dimdelta($str_waves,0)
				var_x_cnt+=1
			while(var_x_cnt<dimsize($str_waves,0))
			duplicate/o tempM $(nameofwave($str_waves)+"_sc")
			$(str_name+"_3D")[][][var_scroll] = tempM[p][q]
			setdimlabel 2,var_scroll,$(nameofwave($str_waves)+"_sc"),$(str_name+"_3D")
			var_scroll += 1
		while(var_scroll<itemsinlist(str_sublist))
	endif
//generating groups average vectors
	if(dimsize($stringfromlist(0,str_sublist),1) == 0)
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
	else
		make/o/n=(dimsize(tempM,0),dimsize(tempM,1)) $(str_name+"_avg") = nan
		make/o/n=(dimsize(tempM,0),dimsize(tempM,1)) $(str_name+"_sem") = nan
		variable/g var_scroll_x = 0
		do
			variable/g var_scroll_y = 0
				do
					duplicate/o $(str_name+"_3D") tempL
					matrixop/o tempB=beam(tempL,var_scroll_x,var_scroll_y)
					wavestats/q tempB
					$(str_name+"_avg")[var_scroll_x][var_scroll_y] = v_avg
					$(str_name+"_sem")[var_scroll_x][var_scroll_y] = v_sem
					var_scroll_y += 1
				while (var_scroll_y < dimsize(tempL,1))
			var_scroll_x += 1
		while (var_scroll_x < dimsize(tempL,0))
		setscale/p x var_x_offset,dimdelta(tempM,0),"", $(str_name+"_avg")
		setscale/p x var_x_offset,dimdelta(tempM,0),"", $(str_name+"_sem")
		setscale/p y var_y_offset,dimdelta(tempM,1),"", $(str_name+"_avg")
		setscale/p y var_y_offset,dimdelta(tempM,1),"", $(str_name+"_sem")
		setscale/p x var_x_offset,dimdelta(tempM,0),"", $(str_name+"_3D")
		setscale/p y var_y_offset,dimdelta(tempM,1),"", $(str_name+"_3D")
	endif
	var_groups+=1
while(var_groups<itemsinlist(str_groups))
killwaves/z tempwave, transwave, tempL, tempM, tempW, w_y_delta, w_y_offset, w_y_range, w_x_delta, w_x_offset, w_x_range, tempB
beep
end