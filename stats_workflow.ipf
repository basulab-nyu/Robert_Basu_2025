#pragma rtGlobals=1

Macro Comparative_Statistics_batch()

pComparative_Statistics_batch()

proc pComparative_Statistics_batch(str_input,str_pair,str_force,str_name,str_ccl)
string str_input
prompt str_input "input waves (textref) ?"
string str_pair
prompt str_pair "paired comparisons ? (0/1 = no/yes)"
string str_force
prompt str_force "force parametric comparisons ? (0/1 = no/yes)"
string str_name
prompt str_name "output waves (textref) ?"
string str_ccl
prompt str_ccl "summary wave ?"
variable/g var_pair = str2num(str_pair)
variable/g var_force = str2num(str_force)
make/o/n=(numpnts($str_input)*2,(itemsinlist(sortlist(wavelist($str_input[0],";",""),";",16))+1)*2) $str_ccl = nan
make/t/o/n=(numpnts($str_input)*2) $(str_ccl+"_xlbl") = ""
make/t/o/n=((itemsinlist(sortlist(wavelist($str_input[0],";",""),";",16))+1)*2) $(str_ccl+"_ylbl") = ""
make/o/n=(numpnts($str_input)*2) $(str_ccl+"_xloc") = x
make/o/n=((itemsinlist(sortlist(wavelist($str_input[0],";",""),";",16))+1)*2) $(str_ccl+"_yloc") = x
string/g str_catch = ""
variable/g var_catch = 0
do
	string/g str_pre = ($str_input[0])[0,strsearch($str_input[0],"*",0)-1]
	string/g str_post = ($str_input[0])[strsearch($str_input[0],"*",0)+1,inf]
	str_catch = addlistitem(stringfromlist(var_catch,sortlist(wavelist($str_input[0],";",""),";",16))[strsearch(stringfromlist(var_catch,sortlist(wavelist($str_input[0],";",""),";",16)),str_pre,inf,1)+strlen(str_pre),strsearch(stringfromlist(var_catch,sortlist(wavelist($str_input[0],";",""),";",16)),str_post,0)-1],str_catch)
	var_catch+=1
while(var_catch<itemsinlist(sortlist(wavelist($str_input[0],";",""),";",16)))
make/o/n=((itemsinlist(sortlist(wavelist($str_input[0],";",""),";",16))+1)*2) $(str_ccl+"_check") = 0
variable/g var_ref = 0
do
string/g str_list = sortlist(wavelist($str_input[var_ref],";",""),";",16)
string/g str_output = $str_name[var_ref]
variable/g var_num = itemsinlist(str_list)
variable/g var_norm = 1
silent 1
pauseupdate
variable/g var_ck = 0
do
	if (strlen(stringfromlist(var_ck+1,str_list)) == 0)
		break
	endif
	wavestats/q $stringfromlist(var_ck,str_list)
	if (v_numnans != 0)
		print stringfromlist(var_ck,str_list) + " excluded because contains NaNs"
		str_list = removefromlist(stringfromlist(var_ck,str_list),str_list,";")
	endif
	if (v_numinfs != 0)
		print stringfromlist(var_ck,str_list) + " excluded because contains INFs"
		str_list = removefromlist(stringfromlist(var_ck,str_list),str_list,";")
	endif
	var_ck+=1
while(var_ck < var_num)
variable/g var_num = itemsinlist(str_list)
if (var_num > 1)
if (var_num == 2)
	variable/g var_index = 0
	do
		string/g str_waves = stringfromlist(var_index,str_list)
		print "\rJarque-Bera test :"
		print str_waves
		if(numpnts($str_waves)>6)
				statsjbtest $str_waves
				if (w_jbresults[%JBStatistic] >= w_jbresults[%Critical])
					var_norm = 0
					print "no normality"
				endif
			else
				var_norm = 0
				print "insufficient data - assuming no normality"
			endif
		var_index = var_index + 1
	while (var_index < var_num)
	print "\rBarlett test :"
	print str_list
	statsvariancestest/wstr=str_list
	if (w_statsvariancestest[%Bartlett_T] >= w_statsvariancestest[%Critical])
		var_norm = 0
		print "no homoscedasticity"
	endif
	if (var_force == 1)
		var_norm = 1
		print "\rCAUTION : forced parametric comparisons"
	endif
	if (var_norm == 0)
		if (var_pair == 0)
			print "\rMann-Whitney U test :"
			print str_list
			statswilcoxonranktest/tail=4 $stringfromlist(0,str_list),$stringfromlist(1,str_list)
			print "p = " 
			print w_wilcoxontest[%P_two_tail]
			//make/o/n=1 $("wMWUTp_"+str_output) = w_wilcoxontest[%P_two_tail]
			//make/t/o/n=1 $("wMWUTw1_"+str_output) = stringfromlist(0,str_list)
			//make/t/o/n=1 $("wMWUTw2_"+str_output) = stringfromlist(1,str_list)
			$str_ccl[var_ref][0] = w_wilcoxontest[%P_two_tail]
			setdimlabel 0,var_ref,$(stringfromlist(0,str_list)+"_vs_"+stringfromlist(1,str_list)),$str_ccl
			setdimlabel 1,0,MWUTp,$str_ccl
			$(str_ccl+"_xlbl")[var_ref] = stringfromlist(0,str_list)+"_vs_"+stringfromlist(1,str_list)
			$(str_ccl+"_ylbl")[0] = "MWUTp"
			//edit $("wMWUTw1_"+str_output)
			//appendtotable $("wMWUTw2_"+str_output)
			//appendtotable $("wMWUTp_"+str_output)
		else
			print "\rWilcoxon signed-rank test :"
			print str_list
			statswilcoxonranktest/wsrt $stringfromlist(0,str_list),$stringfromlist(1,str_list)
			print "p = "
			print w_wilcoxontest[%P_two_tail]
			//make/o/n=1 $("wWSRTp_"+str_output) = w_wilcoxontest[%P_two_tail]
			//make/t/o/n=1 $("wWSRTw1_"+str_output) = stringfromlist(0,str_list)
			//make/t/o/n=1 $("wWSRTw2_"+str_output) = stringfromlist(1,str_list)
			$str_ccl[var_ref][0] = w_wilcoxontest[%P_two_tail]
			setdimlabel 0,var_ref,$(stringfromlist(0,str_list)+"_vs_"+stringfromlist(1,str_list)),$str_ccl
			setdimlabel 1,0,WSRTp,$str_ccl
			$(str_ccl+"_xlbl")[var_ref] = stringfromlist(0,str_list)+"_vs_"+stringfromlist(1,str_list)
			$(str_ccl+"_ylbl")[0] = "WSRTp"
			//edit $("wWSRTw1_"+str_output)
			//appendtotable $("wWSRTw2_"+str_output)
			//appendtotable $("wWSRTp_"+str_output)
		endif
	else
		if (var_pair == 0)
			print "\rT test :"
			print str_list
			statsttest/tail=4 $stringfromlist(0,str_list),$stringfromlist(1,str_list)
			print "p = "
			print w_statsttest[%P]
			//make/o/n=1 $("wTTp_"+str_output) = w_statsttest[%P]
			//make/t/o/n=1 $("wTTw1_"+str_output) = stringfromlist(0,str_list)
			//make/t/o/n=1 $("wTTw2_"+str_output) = stringfromlist(1,str_list)
			$str_ccl[var_ref][0] = w_statsttest[%P]
			setdimlabel 0,var_ref,$(stringfromlist(0,str_list)+"_vs_"+stringfromlist(1,str_list)),$str_ccl
			setdimlabel 1,0,TTp,$str_ccl
			$(str_ccl+"_xlbl")[var_ref] = stringfromlist(0,str_list)+"_vs_"+stringfromlist(1,str_list)
			$(str_ccl+"_ylbl")[0] = "TTp"
			//edit $("wTTw1_"+str_output)
			//appendtotable $("wTTw2_"+str_output)
			//appendtotable $("wTTp_"+str_output)
		else
			print "\rPaired-T test :"
			print str_list
			statsttest/pair $stringfromlist(0,str_list),$stringfromlist(1,str_list)
			print "p = "
			print w_statsttest[%P]
			//make/o/n=1 $("wPTTp_"+str_output) = w_statsttest[%P]
			//make/t/o/n=1 $("wPTTw1_"+str_output) = stringfromlist(0,str_list)
			//make/t/o/n=1 $("wPTTw2_"+str_output) = stringfromlist(1,str_list)
			$str_ccl[var_ref][0] = w_statsttest[%P]
			setdimlabel 0,var_ref,$(stringfromlist(0,str_list)+"_vs_"+stringfromlist(1,str_list)),$str_ccl
			setdimlabel 1,0,PTTp,$str_ccl
			$(str_ccl+"_xlbl")[var_ref] = stringfromlist(0,str_list)+"_vs_"+stringfromlist(1,str_list)
			$(str_ccl+"_ylbl")[0] = "PTTp"
			//edit $("wPTTw1_"+str_output)
			//appendtotable $("wPTTw2_"+str_output)
			//appendtotable $("wPTTp_"+str_output)
		endif
	endif
else
	variable/g var_index = 0
	if (var_pair == 0)
		do
			string/g str_waves = stringfromlist(var_index,str_list)
			print "\rJarque-Bera test :"
			print str_waves
			if(numpnts($str_waves)>6)
				statsjbtest $str_waves
				if (w_jbresults[%JBStatistic] >= w_jbresults[%Critical])
					var_norm = 0
					print "no normality"
				endif
			else
				var_norm = 0
				print "insufficient data - assuming no normality"
			endif
			var_index = var_index + 1
		while (var_index < var_num)
		print "\rBarlett test :"
		print str_list
		statsvariancestest/wstr=str_list
		if (w_statsvariancestest[%Bartlett_T] >= w_statsvariancestest[%Critical])
			var_norm = 0
			print "no homoscedasticity"
		endif
		if (var_force == 1)
			var_norm = 1
			print "\rCAUTION : forced parametric comparisons"
		endif
	//
	else
		variable/g var_temp = 0
		make/o/n=(numpnts($stringfromlist(var_temp,str_list)),itemsinlist(str_list)) $(str_output+"_m")
		do
			$(str_output+"_m")[][var_temp] = $stringfromlist(var_temp,str_list)[p]
			setdimlabel 1,var_temp,$stringfromlist(var_temp,str_list),$(str_output+"_m")
			var_temp+=1
		while (var_temp < itemsinlist(str_list))
		matrixtranspose $(str_output+"_m")
		variable/g var_temp2 = 0
		string/g str_list2
		string/g str_relabel
		do
			make/n=(dimsize($(str_output+"_m"),0)) $(str_output+"_m_"+num2str(var_temp2))
			$(str_output+"_m_"+num2str(var_temp2)) = $(str_output+"_m")[p][var_temp2]
			print "\rJarque-Bera test :"
			print str_output+"_m_"+num2str(var_temp2)
			//statsjbtest $(str_output+"_m_"+num2str(var_temp2))
			if(numpnts($(str_output+"_m_"+num2str(var_temp2)))>6)
				statsjbtest $(str_output+"_m_"+num2str(var_temp2))
				if (w_jbresults[%JBStatistic] >= w_jbresults[%Critical])
					var_norm = 0
					print "no normality"
				endif
			else
				var_norm = 0
				print "insufficient data - assuming no normality"
			endif
			if (var_temp2 == 0)
				str_list2 = str_output+"_m_"+num2str(var_temp2)
				str_relabel = str_output+"_m_"+num2str(var_temp2)
			else
				str_list2 = str_list2+";"+str_output+"_m_"+num2str(var_temp2)
				str_relabel = str_relabel+","+str_output+"_m_"+num2str(var_temp2)
			endif
			var_temp2+=1
		while (var_temp2 < (dimsize($(str_output+"_m"),1)))
		variable/g var_relabel = 0
		do
			setdimlabel 0,var_relabel,$(stringfromlist(var_relabel,str_relabel)),$stringfromlist(var_relabel,str_relabel)
			var_relabel+=1
		while (var_temp < itemsinlist(str_relabel))
		print "\rBarlett test :"
		print str_list2
		statsvariancestest/wstr=str_list2
		if (w_statsvariancestest[%Bartlett_T] >= w_statsvariancestest[%Critical])
			var_norm = 0
			print "no homoscedasticity"
		endif
		if (var_force == 1)
			var_norm = 1
			print "\rCAUTION : forced parametric comparisons"
		endif
	endif
	//
	if (var_norm == 0)
		if (var_pair == 0)
			print "\rKruskal-Wallis ANOVA :"
			print str_list
			statskwtest/wstr=str_list
			print "p = "
			print w_kwtestresults[%P_Chi_square_approx]
			print "p = "
			print w_kwtestresults[%P_Wallace_approx]
			print "\rnon-parametric post hoc"
			statsnpmctest/swn/tuk/dhw/wstr=str_list
			//make/o/n=2 $("wKWTp_"+str_output)
			//$("wKWTp_"+str_output)[0] = w_kwtestresults[%P_Chi_square_approx]
			//$("wKWTp_"+str_output)[1] = w_kwtestresults[%P_Wallace_approx]
			//edit $("wKWTp_"+str_output)
			duplicate/o W_KWTestResults $("wKWT_"+str_output)
			duplicate/o M_NPMCTukeyResults $("wNPMCtuk_"+str_output)
			duplicate/o M_NPMCDHWResults $("wNPMCdhw_"+str_output)
			$str_ccl[var_ref*2][0] = 0.5*(w_kwtestresults[%P_Chi_square_approx]+w_kwtestresults[%P_Wallace_approx])
			$str_ccl[(var_ref*2)+1][0] = 0.5*(w_kwtestresults[%P_Chi_square_approx]+w_kwtestresults[%P_Wallace_approx])
			setdimlabel 0,var_ref*2,$(str_output+"_tuk"),$str_ccl
			setdimlabel 0,(var_ref*2)+1,$(str_output+"_dhw"),$str_ccl
			setdimlabel 1,0,KWT,$str_ccl
			$(str_ccl+"_xlbl")[var_ref*2] = str_output+"_tuk"
			$(str_ccl+"_xlbl")[(var_ref*2)+1] = str_output+"_dhw"
			$(str_ccl+"_ylbl")[0] = "KWT"
			$(str_ccl+"_check")[0] = 1
			make/o/n=(dimsize(M_NPMCTukeyResults,0)) temptuk = M_NPMCTukeyResults[p][%Conclusion]
			make/o/n=(dimsize(M_NPMCTukeyResults,0)) tempdhw = M_NPMCDHWResults[p][%Conclusion]
			duplicate/o T_NPMCTukeyDescriptors temptukT
			duplicate/o T_NPMCDHWDescriptors tempdhwT
			sort temptukT,temptuk,temptukT
			sort tempdhwT,tempdhw,tempdhwT
			variable/g var_fill = 0
			do
				//$str_ccl[var_ref*2][var_fill+1] = M_NPMCTukeyResults[var_fill][%Conclusion]
				//$str_ccl[(var_ref*2)+1][var_fill+1] = M_NPMCDHWResults[var_fill][%Conclusion]
				$str_ccl[var_ref*2][var_fill+1] = temptuk[var_fill]
				$str_ccl[(var_ref*2)+1][var_fill+1] = tempdhw[var_fill]
				//setdimlabel 1,var_fill+1,$T_NPMCTukeyDescriptors[var_fill],$str_ccl
				variable/g var_catch = 0
				do
					if(strlen($(str_ccl+"_ylbl")[var_fill+1]) == 0 && stringmatch(temptukT[var_fill],"*"+stringfromlist(var_catch,str_catch)+"*") == 1 && $(str_ccl+"_check")[var_fill+1] == 0)
						$(str_ccl+"_ylbl")[var_fill+1] = (temptukT[var_fill])[strsearch(temptukT[var_fill],stringfromlist(var_catch,str_catch),0),strsearch(temptukT[var_fill],stringfromlist(var_catch,str_catch),0)+strlen(stringfromlist(var_catch,str_catch))-1]
						var_catch+=1
					else
						if(strlen($(str_ccl+"_ylbl")[var_fill+1]) > 0 && stringmatch(temptukT[var_fill],"*"+stringfromlist(var_catch,str_catch)+"*") == 1 && $(str_ccl+"_check")[var_fill+1] == 0)
							$(str_ccl+"_ylbl")[var_fill+1] = $(str_ccl+"_ylbl")[var_fill+1] + "_vs_" + (temptukT[var_fill])[strsearch(temptukT[var_fill],stringfromlist(var_catch,str_catch),0),strsearch(temptukT[var_fill],stringfromlist(var_catch,str_catch),0)+strlen(stringfromlist(var_catch,str_catch))-1]
						endif
						var_catch+=1
					endif
				while(var_catch<itemsinlist(str_catch))
				$(str_ccl+"_check")[var_fill+1] = 1
				var_fill+=1
			while(var_fill<itemsinlist(str_list))
			variable/g var_lbl = 0
			do
				setdimlabel 0,var_lbl,$T_NPMCTukeyDescriptors[var_lbl],$("wNPMCtuk_"+str_output)
				setdimlabel 0,var_lbl,$T_NPMCDHWDescriptors[var_lbl],$("wNPMCdhw_"+str_output)
				var_lbl+=1
			while(var_lbl<dimsize($("wNPMCtuk_"+str_output),0))
		else
			print "\rFriedman ANOVA :"
			print str_list2
			statsfriedmantest/wstr=str_list2
			print "p = "
			print 1-statsfriedmancdf(m_friedmantestresults[0][%Statistic],m_friedmantestresults[0][%Columns],m_friedmantestresults[0][%Rows],0,1)
			make/o/n=1 $("wFAp_"+str_output) = 1-statsfriedmancdf(m_friedmantestresults[0][%Statistic],m_friedmantestresults[0][%Columns],m_friedmantestresults[0][%Rows],0,1)
			edit $("wFAp_"+str_output)
			variable/g var_index = 0
			make/o/n=(var_num) tempwave=x
			variable/g var_tot = sum(tempwave)
			make/o/n=(var_tot) $("wWSRTp_"+str_output) = NaN
			make/t/o/n=(var_tot) $("wWSRTw1_"+str_output)
			make/t/o/n=(var_tot) $("wWSRTw2_"+str_output)
			killwaves tempwave
			do
				variable/g var_scroll = var_index
				do
					if (var_scroll == var_index)
						variable/g var_label = var_index + var_scroll
						if (strlen(stringfromlist(var_scroll+1,str_list2)) == 0)
							break
						endif
						print "\rWilcoxon signed-rank test :"
						print stringfromlist(var_index,str_list2)+"_vs_"+stringfromlist(var_scroll+1,str_list2)
						statswilcoxonranktest/wsrt $stringfromlist(var_index,str_list2),$stringfromlist(var_scroll+1,str_list2)
						$("wWSRTw1_"+str_output)[var_label] = stringfromlist(var_index,str_list2)
						$("wWSRTw2_"+str_output)[var_label] = stringfromlist(var_scroll+1,str_list2)
						$("wWSRTp_"+str_output)[var_label] = w_wilcoxontest[%P_two_tail]
						//wPTTpT[var_label] = $stringfromlist(var_index,str_list)+"_vs_"+$stringfromlist(var_scroll,str_list)
						//setdimlabel 0,var_label, $(stringfromlist(var_index,str_list)+"_vs_"+stringfromlist(var_scroll,str_list)),wPTTp
					else
						variable/g var_label = var_index + var_scroll
						if (strlen(stringfromlist(var_scroll+1,str_list2)) == 0)
							break
						endif
						print "\rWilcoxon signed-rank test :"
						print stringfromlist(var_index,str_list2)+"_vs_"+stringfromlist(var_scroll+1,str_list2)
						statswilcoxonranktest/wsrt $stringfromlist(var_index,str_list2),$stringfromlist(var_scroll+1,str_list2)
						$("wWSRTw1_"+str_output)[var_label] = stringfromlist(var_index,str_list2)
						$("wWSRTw2_"+str_output)[var_label] = stringfromlist(var_scroll+1,str_list2)
						$("wWSRTp_"+str_output)[var_label] = w_wilcoxontest[%P_two_tail]
						//wPTTpT[var_label] = $stringfromlist(var_index,str_list)+"_vs_"+$stringfromlist(var_scroll,str_list)
						//setdimlabel 0,var_label, $(stringfromlist(var_index,str_list)+"_vs_"+stringfromlist(var_scroll,str_list)),wPTTp
					endif
					var_scroll = var_scroll + 1
				while (var_scroll < var_num-1)
				var_index = var_index + 1
			while (var_index < var_num)
			appendtotable $("wWSRTw1_"+str_output)
			appendtotable $("wWSRTw2_"+str_output)
			appendtotable $("wWSRTp_"+str_output)
		endif
	else
		if (var_pair == 0)
			print "\rOne-way ANOVA :"
			statsanova1test/wstr=str_list
			print "p = "
			print m_anova1[%total][%P]
			print "\rTukey post hoc"
			statstukeytest/swn/wstr=str_list
			//make/o/n=1 $("w1Ap_"+str_output) = m_anova1[%total][%P]
			//edit $("w1Ap_"+str_output)
			duplicate/o M_ANOVA1 $("w1Ap_"+str_output)
			duplicate/o M_TukeyTestResults $("w1Atuk_"+str_output)
			$str_ccl[var_ref*2][0] = M_ANOVA1[inf][%p]
			setdimlabel 0,var_ref*2,$(str_output+"_tuk"),$str_ccl
			setdimlabel 1,0,ANOVA1,$str_ccl
			$(str_ccl+"_xlbl")[var_ref*2] = str_output+"_tuk"
			$(str_ccl+"_ylbl")[0] = "ANOVA1"
			$(str_ccl+"_check")[0] = 1
			make/o/n=(dimsize(M_TukeyTestResults,0)) temptuk = M_TukeyTestResults[p][%p]
			duplicate/o T_TukeyDescriptors temptukT
			sort temptukT,temptuk,temptukT
			variable/g var_fill = 0
			do
				//$str_ccl[var_ref*2][var_fill+1] = M_NPMCTukeyResults[var_fill][%Conclusion]
				//$str_ccl[(var_ref*2)+1][var_fill+1] = M_NPMCDHWResults[var_fill][%Conclusion]
				$str_ccl[var_ref*2][var_fill+1] = temptuk[var_fill]
				//setdimlabel 1,var_fill+1,$T_NPMCTukeyDescriptors[var_fill],$str_ccl
				variable/g var_catch = 0
				do
					if(strlen($(str_ccl+"_ylbl")[var_fill+1]) == 0 && stringmatch(temptukT[var_fill],"*"+stringfromlist(var_catch,str_catch)+"*") == 1 && $(str_ccl+"_check")[var_fill+1] == 0)
						$(str_ccl+"_ylbl")[var_fill+1] = (temptukT[var_fill])[strsearch(temptukT[var_fill],stringfromlist(var_catch,str_catch),0),strsearch(temptukT[var_fill],stringfromlist(var_catch,str_catch),0)+strlen(stringfromlist(var_catch,str_catch))-1]
						var_catch+=1
					else
						if(strlen($(str_ccl+"_ylbl")[var_fill+1]) > 0 && stringmatch(temptukT[var_fill],"*"+stringfromlist(var_catch,str_catch)+"*") == 1 && $(str_ccl+"_check")[var_fill+1] == 0)
							$(str_ccl+"_ylbl")[var_fill+1] = $(str_ccl+"_ylbl")[var_fill+1] + "_vs_" + (temptukT[var_fill])[strsearch(temptukT[var_fill],stringfromlist(var_catch,str_catch),0),strsearch(temptukT[var_fill],stringfromlist(var_catch,str_catch),0)+strlen(stringfromlist(var_catch,str_catch))-1]
						endif
						var_catch+=1
					endif
				while(var_catch<itemsinlist(str_catch))
				$(str_ccl+"_check")[var_fill+1] = 1
				var_fill+=1
			while(var_fill<itemsinlist(str_list))
			variable/g var_lbl = 0
			do
				setdimlabel 0,var_lbl,$T_TukeyDescriptors[var_lbl],$("w1Atuk_"+str_output)
				var_lbl+=1
			while(var_lbl<dimsize($("w1Atuk_"+str_output),0))
		else
			//make/o/n=(numpnts($str_waves),var_num) w_matrix
			//variable/g var_index = 0
			//do
			//	string/g str_waves = stringfromlist(var_index,str_list)
			//	if (var_index == 0)
			//		w_matrix[][var_index] = $str_waves[p]
			//	else
			//		w_matrix[][var_index] = $str_waves[p]
			//	endif
			//	var_index = var_index + 1
			//while (var_index < var_num)
			print "\rRepeated-measures ANOVA :"
			print str_list2
			statsanova2rmtest $(str_output+"_m")
			print "p = "
			print 1-statsfcdf(m_anova2rmresults[%test_h0][%F],m_anova2rmresults[%groups][%DF],m_anova2rmresults[%remainder][%DF])
			make/o/n=1 $("wRmAp_"+str_output) = 1-statsfcdf(m_anova2rmresults[%test_h0][%F],m_anova2rmresults[%groups][%DF],m_anova2rmresults[%remainder][%DF])
			edit  $("wRmAp_"+str_output)
			variable/g var_index = 0
			make/o/n=(var_num) tempwave=x
			variable/g var_tot = sum(tempwave)
			make/o/n=(var_tot) $("wPTTp_"+str_output) = NaN
			make/t/o/n=(var_tot) $("wPTTw1_"+str_output)
			make/t/o/n=(var_tot) $("wPTTw2_"+str_output)
			//make/t/o/n=(var_tot) wPTTpT
			killwaves tempwave
			do
				variable/g var_scroll = var_index
				do
					if (var_scroll == var_index)
						variable/g var_label = var_index + var_scroll
						if (strlen(stringfromlist(var_scroll+1,str_list2)) == 0)
							break
						endif
					print "\rPaired-T test :"
					print stringfromlist(var_index,str_list2)+"_vs_"+stringfromlist(var_scroll+1,str_list2)
					statsttest/pair $stringfromlist(var_index,str_list2),$stringfromlist(var_scroll+1,str_list2)
					$("wPTTw1_"+str_output)[var_label] = stringfromlist(var_index,str_list2)
					$("wPTTw2_"+str_output)[var_label] = stringfromlist(var_scroll+1,str_list2)
					$("wPTTp_"+str_output)[var_label] = w_statsttest[%P]
					//wPTTpT[var_label] = $stringfromlist(var_index,str_list)+"_vs_"+$stringfromlist(var_scroll,str_list)
					//setdimlabel 0,var_label, $(stringfromlist(var_index,str_list)+"_vs_"+stringfromlist(var_scroll,str_list)),wPTTp
					else
						variable/g var_label = var_index + var_scroll
						if (strlen(stringfromlist(var_scroll+1,str_list2)) == 0)
							break
						endif
						print "\rPaired-T test :"
						print stringfromlist(var_index,str_list2)+"_vs_"+stringfromlist(var_scroll+1,str_list2)
						statsttest/pair $stringfromlist(var_index,str_list2),$stringfromlist(var_scroll+1,str_list2)
						$("wPTTw1_"+str_output)[var_label] = stringfromlist(var_index,str_list2)
						$("wPTTw2_"+str_output)[var_label] = stringfromlist(var_scroll+1,str_list2)
						$("wPTTp_"+str_output)[var_label] = w_statsttest[%P]
						//wPTTpT[var_label] = $stringfromlist(var_index,str_list)+"_vs_"+$stringfromlist(var_scroll,str_list)
						//setdimlabel 0,var_label, $(stringfromlist(var_index,str_list)+"_vs_"+stringfromlist(var_scroll,str_list)),wPTTp
					endif
					var_scroll = var_scroll + 1
				while (var_scroll < var_num-1)
				var_index = var_index + 1
			while (var_index < var_num)
			appendtotable $("wPTTw1_"+str_output)
			appendtotable $("wPTTw2_"+str_output)
			appendtotable $("wPTTp_"+str_output)
		endif
	endif
endif
endif
var_ref+=1
while(var_ref<numpnts($str_input))
display
$str_ccl[][ceil(0.5*dimsize($str_ccl,1))] = 0
appendtograph $str_ccl[][ceil(0.5*dimsize($str_ccl,1))]
modifygraph mode($str_ccl)=3,marker($str_ccl)=9,mrkThick($str_ccl)=5,msize($str_ccl)=10,zColor($str_ccl)={$str_ccl[*][0],0,0.05,Rainbow,0},zColorMax($str_ccl)=(0,0,0)
variable/g var_plot = 0
do
	$str_ccl[][ceil(0.5*dimsize($str_ccl,1))+var_plot+1] = var_plot+1
	appendtograph $str_ccl[][ceil(0.5*dimsize($str_ccl,1))+var_plot+1]
	modifygraph mode($(str_ccl+"#"+num2str(var_plot+1)))=3,marker($(str_ccl+"#"+num2str(var_plot+1)))=9,mrkThick($(str_ccl+"#"+num2str(var_plot+1)))=5,msize($(str_ccl+"#"+num2str(var_plot+1)))=10,zColor($(str_ccl+"#"+num2str(var_plot+1)))={$str_ccl[*][var_plot+1],0,0.05,Rainbow,0},zColorMax($(str_ccl+"#"+num2str(var_plot+1)))=(0,0,0)
	var_plot+=1
while(var_plot+1<ceil(0.5*dimsize($str_ccl,1)))
modifygraph userticks(bottom)={$(str_ccl+"_xloc"),$(str_ccl+"_xlbl")}
modifygraph userticks(left)={$(str_ccl+"_yloc"),$(str_ccl+"_ylbl")}
modifygraph fSize(bottom)=8
modifygraph swapxy = 1
modifygraph grid(left)=1
colorscale/c/n=pval/f=0/a=mb/b=1/x=-90/y=-15 vert=0,trace=$str_ccl,axisRange={0,0.06},lowTrip=0.01, "p value"
movewindow 200,40,800,475
resumeupdate
end