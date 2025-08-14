#pragma rtGlobals=1

Macro Error_Bars()

pEB()

proc pEB()
string/g str_list = TraceNameList("",";",1)
variable/g var_index
var_index = 0
string/g str_waves
//string newname
variable/g var_total = itemsinlist(str_list)
do
silent 1
pauseupdate
	str_waves = stringfromlist(var_index,str_list)
	if (strlen(str_waves) == 0)
		break
	endif
	if (var_index == 0)
		string/g str_name = nameofwave($str_waves)
		string/g str_end = "avg"
		string/g str_sem = removeending (str_name, str_end)
		str_sem = str_sem+"sem"
		if(exists(str_sem) == 1)
			ErrorBars $str_waves Y,wave=($str_sem,$str_sem)
		endif
	else
		string/g str_name = nameofwave($str_waves)
		string/g str_end = "avg"
		string/g str_sem = removeending (str_name, str_end)
		str_sem = str_sem+"sem"
		if(exists(str_sem) == 1)
			ErrorBars $str_waves Y,wave=($str_sem,$str_sem)
		endif
	endif
	var_index += 1
while(1)
resumeupdate
end