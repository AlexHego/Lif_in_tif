////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// This macro was written in february 2021 by Alexandre Hego for Novadip
////// This macro will convert automatically all the file in .lif in .tif
////// This macro will run in batch mode and need bio-format
////// If you need more informations please contact alexandre.hego@uliege.be
////// Please remove the space in the folder name and file name
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#@ File (label ="input folder with lif files ", style = "directory") input
#@ File (label="output folder to save ome.tif files", style = "directory") output


// Fresh startup
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
print("\\Clear");
// close all images
close("*");
// empty the ROI manager
roiManager("reset");
// empty the results table
run("Clear Results");
// configure that binary image are black in background, objects are white
setOption("BlackBackground", true);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
run("Bio-Formats Macro Extensions");
setBatchMode(true);

list = getFileList(input);   
for (i=0; i<list.length; i++) {
	if (endsWith(list[i],".lif")){
		inputPath= input +  File.separator + list[i];
		//how many series in this lif file?
		Ext.setId(inputPath);
		Ext.getSeriesCount(seriesCount); //-- Gets the number of image series in the active dataset.
		for (j=1; j<=seriesCount; j++) {
			run("Bio-Formats", "open=inputPath autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_"+j);
			name=getTitle();
			
		// save
			saveAs("TIFF", output +File.separator+name+ "_"+j);
			run("Close All");
			run("Collect Garbage");	
		}
	}
}
setBatchMode(false);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
print("Macro ends");