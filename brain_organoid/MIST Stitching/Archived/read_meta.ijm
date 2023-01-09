masterdir = "/Volumes/Jan Mayen/test"

list = getFileList(masterdir);
for (i=0; i<list.length; i++) {
	if (indexOf(list[i], "Raw") >= 0) {} 
	else if (indexOf(list[i], "Stitched") >= 0) {}
	else if (endsWith(list[i], "/")) {
		batch = File.getNameWithoutExtension(list[i]);
		print("Processing batch: " + batch);
		
		currentdir = masterdir + File.separator + batch;

		// Use Bio-formats to query metadata to calculate grid size
		run("Bio-Formats Macro Extensions");
		// Open fisrt image
		id = masterdir + File.separator + "Raw" + File.separator + batch + "_w1405_s1.tif";
		Ext.setId(id);
		// Get y step size (by going to second image in series)
		Ext.setSeries(1);
		Ext.getSeriesMetadataValue("Prior Stage Y", y_stepsize);
		y_stepsize = parseInt(y_stepsize);
		// Get y end point (by going to last image in series)
		Ext.getSeriesCount(seriesCount);
		Ext.setSeries(seriesCount-1);
		Ext.getSeriesMetadataValue("Prior Stage Y", y_end);
		y_end = parseInt(y_end);
		// Calculate y size
		height = y_end / y_stepsize + 1;
		print("Batch grid height is " + height);
		// Calculate x size
		width = seriesCount / height;
		print("Batch grid width is " + width);
		Ext.close();
	}
}


		
		
		
//masterdir = "/Volumes/Jan Mayen/test"
//batch = "condition_1_hoxb4_otx2_hoxb1_1";
//		print("Processing batch: " + batch);
//		
//		currentdir = masterdir + File.separator + batch;
//
//		// Use Bio-formats to query metadata to calculate grid size
//		run("Bio-Formats Macro Extensions");
//		// Open fisrt image
//		id = masterdir + File.separator + "Raw" + File.separator + batch + "_w1405_s1.tif";
//		Ext.setId(id);
//		// Get y step size (by going to second image in series)
//		Ext.setSeries(1);
//		Ext.getSeriesMetadataValue("Prior Stage Y", y_stepsize);
//		y_stepsize = parseInt(y_stepsize);
//		print(y_stepsize);
//		// Get y end point (by going to last image in series)
//		Ext.getSeriesCount(seriesCount);
//		print(seriesCount);
//		
//		Ext.setSeries(seriesCount-1);
//		Ext.getSeriesMetadataValue("Prior Stage Y", y_end);
//		y_end = parseInt(y_end);
////		print(y_end);
//		// Calculate y size
//		height = y_end / y_stepsize + 1;
////		print("Batch grid height is " + height);
//		// Calculate x size
//		width = seriesCount / height;
////		print("Batch grid width is " + width);
//		Ext.close();
		
		
		
		
		