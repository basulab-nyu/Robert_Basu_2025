run("OVMacro");
setBatchMode(true);
input = "//research-cifs.nyumc.org/Research/basulab/basulabspace/VR/VR_histology/2P/DREADD_PSAM_LEC/Black_928_2/vsi_files/";
list = getFileList(input);
for (i = 0; i < list.length; i++)
{
	if (list[i].contains(".vsi"))
	{
		path = input + list[i];
		output = list[i].substring(0, list[i].indexOf(".vsi"));
		Ext.getGroupCount(path, groups);
		Ext.getLevelCount(path, groups-1, levels);
		for (j = 0; j < groups; j++)
		{
			
/////	 saving all image resolution series 	/////
			for (k = 0; k < levels; k++)
			{
				if(File.exists(input+output+"_"+j+"_"+k+".tif"))
				{
					print(path+" group #"+j+" level #"+k+" already processed !!!");
				}
				else
				{
					print("reading "+path+" group #"+j+" level #"+k+"...");
					Ext.openFile(path, j, k);
					print("saving tiff as "+input+output+"_"+j+"_"+k+".tif...");
					saveAs("Tiff", input+output+"_"+j+"_"+k+".tif");
					print("done !!!");
				}				
			}
/////////////////////////////////////////////////////

/////	 saving only ~2250x1500px image only 	/////
//			if (File.exists(input+output+"_"+j+"_"+"3"+".tif"))
//			{
//				print(path+" group #"+j+" level #"+"3"+" already processed !!!");
//			}
//			else
//			{
//				print("reading "+path+" group #"+j+" level #"+"3"+"...");
//				Ext.openFile(path, j, 3);
//				print("saving tiff as "+input+output+"_"+j+"_"+"3"+".tif...");
//				saveAs("Tiff", input+output+"_"+j+"_"+"3"+".tif");
//				print("done !!!");
//			}
/////////////////////////////////////////////////////

		}		
	}
}