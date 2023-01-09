masterdir = "E:\\test"


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
		
// Shading Correction for all four channels
File.openSequence(currentdir, " filter=w1405");
run("BaSiC ", "processing_stack=" + batch + 
" flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Image Sequence... ", "dir=[" + currentdir + "] format=TIFF use");
run("Close All");
File.openSequence(currentdir, " filter=w2488");
run("BaSiC ", "processing_stack=" + batch + 
" flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Image Sequence... ", "dir=[" + currentdir + "] format=TIFF use");
run("Close All");
File.openSequence(currentdir, " filter=w3561");
run("BaSiC ", "processing_stack=" + batch + 
" flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Image Sequence... ", "dir=[" + currentdir + "] format=TIFF use");
run("Close All");
File.openSequence(currentdir, " filter=w4640");
run("BaSiC ", "processing_stack=" + batch + 
" flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Image Sequence... ", "dir=[" + currentdir + "] format=TIFF use");
run("Close All");

// DAPI image at 405, channel 1
run("MIST",
"gridwidth=" + width + 
" gridheight=" + height + 
" starttile=1 imagedir=[" + currentdir + 
"] filenamepattern=" + batch + 
"_w1405_s{ppp}.tif filenamepatterntype=SEQUENTIAL gridorigin=LR assemblefrommetadata=false assemblenooverlap=false globalpositionsfile=[] numberingpattern=VERTICALCOMBING startrow=0 startcol=0 extentwidth=" + width + 
" extentheight=" + height + 
" timeslices=0 istimeslicesenabled=false outputpath=[" + masterdir + File.separator +
"stitched] displaystitching=false outputfullimage=true outputmeta=true outputimgpyramid=false blendingmode=LINEAR blendingalpha=1.0 outfileprefix=" + batch + 
"_w1405 programtype=AUTO numcputhreads=16 loadfftwplan=false savefftwplan=flase stagerepeatability=0 horizontaloverlap=40 verticaloverlap=40 numfftpeaks=0 overlapuncertainty=20.0 isusedoubleprecision=false isusebioformats=false issuppressmodelwarningdialog=false isenablecudaexceptions=false translationrefinementmethod=SINGLE_HILL_CLIMB numtranslationrefinementstartpoints=16 headless=false loglevel=MANDATORY debuglevel=NONE");
       

// Additional images

// channel 2
channel = "2"; // channel values have to be string for concatenation 
wavelength = 488;
run("MIST", "gridwidth=" + width + 
" gridheight=" + height + 
" starttile=1 imagedir=[" + currentdir + 
"] filenamepattern=" + batch + 
"_w" + channel + wavelength + 
"_s{ppp}.tif filenamepatterntype=SEQUENTIAL gridorigin=LR assemblefrommetadata=true assemblenooverlap=false globalpositionsfile=[" + masterdir + File.separator + 
"stitched" + File.separator + batch + 
"_w1405global-positions-0.txt] numberingpattern=VERTICALCOMBING startrow=0 startcol=0 extentwidth=" + width + 
" extentheight=" + height + 
" timeslices=0 istimeslicesenabled=false outputpath=[" + masterdir + File.separator +
"stitched] displaystitching=false outputfullimage=true outputmeta=true outputimgpyramid=false blendingmode=LINEAR blendingalpha=1.0 outfileprefix=" + batch + 
"_w" + channel + wavelength + 
" programtype=AUTO numcputhreads=16 loadfftwplan=false savefftwplan=false stagerepeatability=0 horizontaloverlap=NaN verticaloverlap=NaN numfftpeaks=0 overlapuncertainty=20.0 isusedoubleprecision=false isusebioformats=false issuppressmodelwarningdialog=false isenablecudaexceptions=false translationrefinementmethod=SINGLE_HILL_CLIMB numtranslationrefinementstartpoints=16 headless=false cudadevice0id=0 loglevel=MANDATORY debuglevel=NONE");

// channel 3
channel = "3";
wavelength = 561;
run("MIST", "gridwidth=" + width + 
" gridheight=" + height + 
" starttile=1 imagedir=[" + currentdir + 
"] filenamepattern=" + batch + 
"_w" + channel + wavelength + 
"_s{ppp}.tif filenamepatterntype=SEQUENTIAL gridorigin=LR assemblefrommetadata=true assemblenooverlap=false globalpositionsfile=[" + masterdir + File.separator +
"stitched" + File.separator + batch + 
"_w1405global-positions-0.txt] numberingpattern=VERTICALCOMBING startrow=0 startcol=0 extentwidth=" + width + 
" extentheight=" + height + 
" timeslices=0 istimeslicesenabled=false outputpath=[" + masterdir + File.separator +
"stitched] displaystitching=false outputfullimage=true outputmeta=true outputimgpyramid=false blendingmode=LINEAR blendingalpha=1.0 outfileprefix=" + batch + 
"_w" + channel + wavelength + 
" programtype=AUTO numcputhreads=16 loadfftwplan=false savefftwplan=false stagerepeatability=0 horizontaloverlap=NaN verticaloverlap=NaN numfftpeaks=0 overlapuncertainty=20.0 isusedoubleprecision=false isusebioformats=false issuppressmodelwarningdialog=false isenablecudaexceptions=false translationrefinementmethod=SINGLE_HILL_CLIMB numtranslationrefinementstartpoints=16 headless=false cudadevice0id=0 loglevel=MANDATORY debuglevel=NONE");

// channel 4
channel = "4";
wavelength = 640;
run("MIST", "gridwidth=" + width + 
" gridheight=" + height + 
" starttile=1 imagedir=[" + currentdir + 
"] filenamepattern=" + batch + 
"_w" + channel + wavelength + 
"_s{ppp}.tif filenamepatterntype=SEQUENTIAL gridorigin=LR assemblefrommetadata=true assemblenooverlap=false globalpositionsfile=[" + masterdir + File.separator +
"stitched" + File.separator + batch + 
"_w1405global-positions-0.txt] numberingpattern=VERTICALCOMBING startrow=0 startcol=0 extentwidth=" + width + 
" extentheight=" + height + 
" timeslices=0 istimeslicesenabled=false outputpath=[" + masterdir + File.separator +
"stitched] displaystitching=false outputfullimage=true outputmeta=true outputimgpyramid=false blendingmode=LINEAR blendingalpha=1.0 outfileprefix=" + batch + 
"_w" + channel + wavelength + 
" programtype=AUTO numcputhreads=16 loadfftwplan=false savefftwplan=false stagerepeatability=0 horizontaloverlap=NaN verticaloverlap=NaN numfftpeaks=0 overlapuncertainty=20.0 isusedoubleprecision=false isusebioformats=false issuppressmodelwarningdialog=false isenablecudaexceptions=false translationrefinementmethod=SINGLE_HILL_CLIMB numtranslationrefinementstartpoints=16 headless=false cudadevice0id=0 loglevel=MANDATORY debuglevel=NONE");

// merge multiple channels into one tiff file and perform standard processing
open(masterdir + File.separator + "Stitched" + File.separator + batch + "_w1405stitched-0.ome.tif");
run("Enhance Contrast", "saturated=0.35");
open(masterdir + File.separator + "Stitched" + File.separator + batch + "_w2488stitched-0.ome.tif");
run("Enhance Contrast", "saturated=0.35");
open(masterdir + File.separator + "Stitched" + File.separator + batch + "_w3561stitched-0.ome.tif");
run("Enhance Contrast", "saturated=0.35");
open(masterdir + File.separator + "Stitched" + File.separator + batch + "_w4640stitched-0.ome.tif");
run("Enhance Contrast", "saturated=0.35");
run("Merge Channels...",
"c1="+
batch + "_w3561stitched-0.ome.tif"+" c2="+
batch + "_w2488stitched-0.ome.tif"+" c3="+
batch + "_w1405stitched-0.ome.tif"+" c6="+
batch + "_w4640stitched-0.ome.tif"+" create");
Stack.setDisplayMode("color");
run("Arrange Channels...", "new=3214"); // rearrange channel to conventional order
run("Set Scale...", "distance=15 known=10 unit=um"); // set scale for Olympus spinning disk confocal 20X objective Andor camera
run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack"); // rotate image by 180 to correct orientation
saveAs("tiff", masterdir + File.separator + "Stitched" + File.separator + batch + ".tif");

run("Close All");

	}
}

