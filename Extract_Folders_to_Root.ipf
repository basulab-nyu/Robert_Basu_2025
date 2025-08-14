#pragma rtGlobals=1

Macro Extract_Folders_to_Root()

pExtract_Folders_to_Root()

proc pExtract_Folders_to_Root()
setdatafolder root:
string str_list
string str_sublist
variable var_index
variable var_subindex
silent 1
pauseupdate
str_list = ""
var_index = 0
do
	str_list = addlistitem(getindexedobjname("",4,var_index),str_list,";",var_index)
	var_index+=1
while(var_index<countobjects("",4))
str_list = removefromlist("Packages",str_list)
var_index = 0
do
	setdatafolder root:$stringfromlist(var_index,str_list)
	str_sublist = ""
	var_subindex = 0
	do
		str_sublist = addlistitem(getindexedobjname("",4,var_subindex),str_sublist,";",var_subindex)
		var_subindex+=1
	while(var_subindex<countobjects("",4))
	str_sublist = removefromlist("Packages",str_sublist)
	var_subindex = 0
	do
		movedatafolder root:$stringfromlist(var_index,str_list):$stringfromlist(var_subindex,str_sublist):, root:
		var_subindex+=1
	while(var_subindex<itemsinlist(str_sublist))
	setdatafolder root:
	var_index+=1
while(var_index<itemsinlist(str_list))
setdatafolder root:
end