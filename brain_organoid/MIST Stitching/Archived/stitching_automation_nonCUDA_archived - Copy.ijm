masterdir = "D:\\BO Exp 15"
batch = "800_map2_tuj1_pax6_2"
height = 7
width = 21

currentdir = masterdir + "\\" + batch
// DAPI image at 405, channel 1
run("MIST",
"gridwidth=" + width + 
" gridheight=" + height + 
" starttile=1 imagedir=[" + currentdir + 
"] filenamepattern=" + batch + 
"_w1405_s{ppp}.tif filenamepatterntype=SEQUENTIAL gridorigin=LR assemblefrommetadata=false assemblenooverlap=false globalpositionsfile=[] numberingpattern=VERTICALCOMBING startrow=0 startcol=0 extentwidth=" + width + 
" extentheight=" + height + 
" timeslices=0 istimeslicesenabled=false outputpath=[" + masterdir + 
"\\stitched] displaystitching=false outputfullimage=true outputmeta=true outputimgpyramid=false blendingmode=LINEAR blendingalpha=1.0 outfileprefix=" + batch + 
"_w1405 programtype=AUTO numcputhreads=16 loadfftwplan=true savefftwplan=true fftwplantype=MEASURE fftwlibraryname=libfftw3 fftwlibraryfilename=libfftw3.dll planpath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw\\fftPlans fftwlibrarypath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw stagerepeatability=0 horizontaloverlap=NaN verticaloverlap=NaN numfftpeaks=0 overlapuncertainty=20.0 isusedoubleprecision=false isusebioformats=false issuppressmodelwarningdialog=false isenablecudaexceptions=false translationrefinementmethod=SINGLE_HILL_CLIMB numtranslationrefinementstartpoints=16 headless=false cudadevice0id=0 cudadevice0name=[NVIDIA GeForce RTX 3080] cudadevice0major=8 cudadevice0minor=6 loglevel=MANDATORY debuglevel=NONE");
       

// Additional images

// channel 2
channel = "2" // channel values have to be string for concatenation 
wavelength = 488
run("MIST", "gridwidth=" + width + 
" gridheight=" + height + 
" starttile=1 imagedir=[" + currentdir + 
"] filenamepattern=" + batch + 
"_w" + channel + wavelength + 
"_s{ppp}.tif filenamepatterntype=SEQUENTIAL gridorigin=LR assemblefrommetadata=true assemblenooverlap=false globalpositionsfile=[" + masterdir + 
"\\stitched\\" + batch + 
"_w1405global-positions-0.txt] numberingpattern=VERTICALCOMBING startrow=0 startcol=0 extentwidth=" + width + 
" extentheight=" + height + 
" timeslices=0 istimeslicesenabled=false outputpath=[" + masterdir + 
"\\stitched] displaystitching=false outputfullimage=true outputmeta=true outputimgpyramid=false blendingmode=LINEAR blendingalpha=1.0 outfileprefix=" + batch + 
"_w" + channel + wavelength + 
" programtype=AUTO numcputhreads=16 loadfftwplan=true savefftwplan=true fftwplantype=MEASURE fftwlibraryname=libfftw3 fftwlibraryfilename=libfftw3.dll planpath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw\\fftPlans fftwlibrarypath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw stagerepeatability=0 horizontaloverlap=NaN verticaloverlap=NaN numfftpeaks=0 overlapuncertainty=20.0 isusedoubleprecision=false isusebioformats=false issuppressmodelwarningdialog=false isenablecudaexceptions=false translationrefinementmethod=SINGLE_HILL_CLIMB numtranslationrefinementstartpoints=16 headless=false cudadevice0id=0 cudadevice0name=[NVIDIA GeForce RTX 3080] cudadevice0major=8 cudadevice0minor=6 loglevel=MANDATORY debuglevel=NONE");

// channel 3
channel = "3"
wavelength = 561
run("MIST", "gridwidth=" + width + 
" gridheight=" + height + 
" starttile=1 imagedir=[" + currentdir + 
"] filenamepattern=" + batch + 
"_w" + channel + wavelength + 
"_s{ppp}.tif filenamepatterntype=SEQUENTIAL gridorigin=LR assemblefrommetadata=true assemblenooverlap=false globalpositionsfile=[" + masterdir + 
"\\stitched\\" + batch + 
"_w1405global-positions-0.txt] numberingpattern=VERTICALCOMBING startrow=0 startcol=0 extentwidth=" + width + 
" extentheight=" + height + 
" timeslices=0 istimeslicesenabled=false outputpath=[" + masterdir + 
"\\stitched] displaystitching=false outputfullimage=true outputmeta=true outputimgpyramid=false blendingmode=LINEAR blendingalpha=1.0 outfileprefix=" + batch + 
"_w" + channel + wavelength + 
" programtype=AUTO numcputhreads=16 loadfftwplan=true savefftwplan=true fftwplantype=MEASURE fftwlibraryname=libfftw3 fftwlibraryfilename=libfftw3.dll planpath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw\\fftPlans fftwlibrarypath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw stagerepeatability=0 horizontaloverlap=NaN verticaloverlap=NaN numfftpeaks=0 overlapuncertainty=20.0 isusedoubleprecision=false isusebioformats=false issuppressmodelwarningdialog=false isenablecudaexceptions=false translationrefinementmethod=SINGLE_HILL_CLIMB numtranslationrefinementstartpoints=16 headless=false cudadevice0id=0 cudadevice0name=[NVIDIA GeForce RTX 3080] cudadevice0major=8 cudadevice0minor=6 loglevel=MANDATORY debuglevel=NONE");

// channel 4 (currently idle)
channel = "4"
wavelength = 640
run("MIST", "gridwidth=" + width + 
" gridheight=" + height + 
" starttile=1 imagedir=[" + currentdir + 
"] filenamepattern=" + batch + 
"_w" + channel + wavelength + 
"_s{ppp}.tif filenamepatterntype=SEQUENTIAL gridorigin=LR assemblefrommetadata=true assemblenooverlap=false globalpositionsfile=[" + masterdir + 
"\\stitched\\" + batch + 
"_w1405global-positions-0.txt] numberingpattern=VERTICALCOMBING startrow=0 startcol=0 extentwidth=" + width + 
" extentheight=" + height + 
" timeslices=0 istimeslicesenabled=false outputpath=[" + masterdir + 
"\\stitched] displaystitching=false outputfullimage=true outputmeta=true outputimgpyramid=false blendingmode=LINEAR blendingalpha=1.0 outfileprefix=" + batch + 
"_w" + channel + wavelength + 
" programtype=AUTO numcputhreads=16 loadfftwplan=true savefftwplan=true fftwplantype=MEASURE fftwlibraryname=libfftw3 fftwlibraryfilename=libfftw3.dll planpath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw\\fftPlans fftwlibrarypath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw stagerepeatability=0 horizontaloverlap=NaN verticaloverlap=NaN numfftpeaks=0 overlapuncertainty=20.0 isusedoubleprecision=false isusebioformats=false issuppressmodelwarningdialog=false isenablecudaexceptions=false translationrefinementmethod=SINGLE_HILL_CLIMB numtranslationrefinementstartpoints=16 headless=false cudadevice0id=0 cudadevice0name=[NVIDIA GeForce RTX 3080] cudadevice0major=8 cudadevice0minor=6 loglevel=MANDATORY debuglevel=NONE");

// merge multiple channels into one tiff file and perform standard processing
open(masterdir + File.separator + "Stitched" + File.separator + batch + "_w1405stitched-0.tif");
run("Enhance Contrast", "saturated=0.35");
open(masterdir + File.separator + "Stitched" + File.separator + batch + "_w2488stitched-0.tif");
run("Enhance Contrast", "saturated=0.35");
open(masterdir + File.separator + "Stitched" + File.separator + batch + "_w3561stitched-0.tif");
run("Enhance Contrast", "saturated=0.35");
open(masterdir + File.separator + "Stitched" + File.separator + batch + "_w4640stitched-0.tif");
run("Enhance Contrast", "saturated=0.35");
run("Merge Channels...",
"c1="+
batch + "_w3561stitched-0.tif"+" c2="+
batch + "_w2488stitched-0.tif"+" c3="+
batch + "_w1405stitched-0.tif"+" c6="+
batch + "_w4640stitched-0.tif"+" create");
Stack.setDisplayMode("color");
run("Arrange Channels...", "new=3214"); // rearrange channel to conventional order
run("Set Scale...", "distance=15 known=10 unit=um"); // set scale for Olympus spinning disk confocal 20X objective
run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack"); // rotate image by 180 to correct orientation
saveAs("tiff", masterdir + File.separator + "Stitched" + File.separator + batch + ".tif");

run("Close All");




