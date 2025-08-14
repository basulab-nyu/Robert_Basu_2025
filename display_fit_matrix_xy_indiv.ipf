#pragma rtGlobals=1

macro display_fit_matrix_xy_indiv()

pdisplay_fit_matrix_xy_indiv()
proc pdisplay_fit_matrix_xy_indiv(str_input1,str_input2)
string str_input1
prompt str_input1 "input waves #1 ?"
string str_input2
prompt str_input2 "input waves #2 ?"
string str_list1 = sortlist(wavelist(str_input1,";",""),";",16)
string str_list2 = sortlist(wavelist(str_input2,";",""),";",16)
print replacestring(";",str_list1,"\r")
print replacestring(";",str_list2,"\r")
variable var_index
variable var_index1
variable var_size
variable var_NaN1
variable var_NaN2
variable var_max = 0
do
	var_max = max(var_max,dimsize($stringfromlist(var_index,str_list1),1))
	var_index+=1
while(var_index<itemsinlist(str_list1))
make/o/n=(itemsinlist(str_list1)*var_max,2) stats_linreg_indiv = nan
setdimlabel 1,0,coeff,stats_linreg_indiv
setdimlabel 1,1,r2,stats_linreg_indiv
pauseupdate
display
movewindow 400,45,750,350
var_index = 0
do
	var_index1 = 0
	do
		duplicate/o/r=[][var_index1] $stringfromlist(var_index,str_list1),$(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1))
		duplicate/o/r=[][var_index1] $stringfromlist(var_index,str_list2),$(stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1))
		redimension/n=-1 $(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1))
		redimension/n=-1 $(stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1))
		wavestats/q $(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1))
		var_NaN1 = v_numnans
		wavestats/q $(stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1))
		var_NaN2 = v_numnans
		if(numpnts($(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1))) > var_NaN1 && numpnts($(stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1))) > var_NaN2)		
			appendtograph $(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)) vs $(stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1))
			modifygraph mode($(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)))=3,marker($(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)))=19,msize($(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)))=1.5
			if(stringmatch(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1),"*control*") == 1)
				modifygraph rgb($(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)))=(0,0,0,32768)
			endif
			if(stringmatch(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1),"*LECglu*") == 1)
				modifygraph rgb($(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)))=(2,39321,1,32768)
			endif
			if(stringmatch(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1),"*LECgaba*") == 1)
				modifygraph rgb($(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)))=(65535,0,0,32768)
			endif
			curvefit/q line,$(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1))/x=$(stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1))/d
			duplicate/o $("fit_"+stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)),$("fit_"+stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)+"_vs_"+stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1))
			removefromgraph $("fit_"+stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1))
			killwaves/z $("fit_"+stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1))
			appendtograph $("fit_"+stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)+"_vs_"+stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1))
			if(stringmatch(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1),"*control*") == 1)
				modifygraph rgb($("fit_"+stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)+"_vs_"+stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1)))=(0,0,0)
			endif
			if(stringmatch(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1),"*LECglu*") == 1)
				modifygraph rgb($("fit_"+stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)+"_vs_"+stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1)))=(2,39321,1)
			endif
			if(stringmatch(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1),"*LECgaba*") == 1)
				modifygraph rgb($("fit_"+stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)+"_vs_"+stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1)))=(65535,0,0)
			endif
			statslinearregression/pair/q $(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)),$(stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1))
			stats_linreg_indiv[var_index*dimsize($stringfromlist(var_index,str_list1),1)+var_index1][0] = W_StatsLinearRegression[0][%b]
			stats_linreg_indiv[var_index*dimsize($stringfromlist(var_index,str_list1),1)+var_index1][1] = W_StatsLinearRegression[0][%r2]
			setdimlabel 0,var_index*dimsize($stringfromlist(var_index,str_list1),1)+var_index1,$(stringfromlist(var_index,str_list1)+"_v"+num2str(var_index1)+"_vs_"+stringfromlist(var_index,str_list2)+"_v"+num2str(var_index1)),stats_linreg_indiv
		endif
		var_index1+=1
	while(var_index1<dimsize($stringfromlist(var_index,str_list1),1))
	var_index+=1
while(var_index<itemsinlist(str_list1))
resumeupdate 
getaxis/q left
setaxis left max(-1,1.1*v_min),min(1,1.1*v_max)
setdrawenv xcoord= bottom,ycoord= left,linefgc= (0,0,0,32768),dash= 3
drawline 0,max(-1,1.1*v_min),0,min(1,1.1*v_max)
getaxis/q bottom
setaxis bottom max(-1,1.1*v_min),min(1,1.1*v_max)
setdrawenv xcoord= bottom,ycoord= left,linefgc= (0,0,0,32768),dash= 3
drawline max(-1,1.1*v_min),0,min(1,1.1*v_max),0
pauseupdate
if(stringmatch(stringfromlist(0,str_list1)+"_v0","*_PV_*") == 1)
	label left "PV correlation"
endif
if(stringmatch(stringfromlist(0,str_list1)+"_v0","*_TC_*") == 1)
	label left "TC correlation"
endif
if(stringmatch(stringfromlist(0,str_list2)+"_v0","*_DI_*") == 1)
	label bottom "discrimination index"
endif
if(stringmatch(stringfromlist(0,str_list2)+"_v0","*_PV_*") == 1)
	label bottom "PV correlation"
endif
if(stringmatch(stringfromlist(0,str_list2)+"_v0","*_TC_*") == 1)
	label bottom "TC correlation"
endif
if(stringmatch(stringfromlist(0,str_list1)+"_v0","*_DI_*") == 1)
	label left "discrimination index"
endif
modifygraph gfrelsize = 4
killwaves/z temp1,temp2,base1,base2,w_coef,w_statslinearregression,w_sigma
resumeupdate
end