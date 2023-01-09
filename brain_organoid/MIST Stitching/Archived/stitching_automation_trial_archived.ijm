masterdir = "G:\\My Drive\\Projects\\Brain Organoid\\stitching_automation_trial"
batch = "batch_1_otx2(488)_pax6(561)_1"
height = 3
width = 4

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
"_w1405 programtype=CUDA numcputhreads=16 loadfftwplan=true savefftwplan=true fftwplantype=MEASURE fftwlibraryname=libfftw3 fftwlibraryfilename=libfftw3.dll planpath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw\\fftPlans fftwlibrarypath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw stagerepeatability=0 horizontaloverlap=NaN verticaloverlap=NaN numfftpeaks=0 overlapuncertainty=20.0 isusedoubleprecision=false isusebioformats=false issuppressmodelwarningdialog=false isenablecudaexceptions=false translationrefinementmethod=SINGLE_HILL_CLIMB numtranslationrefinementstartpoints=16 headless=false cudadevice0id=0 cudadevice0name=[NVIDIA GeForce RTX 3080] cudadevice0major=8 cudadevice0minor=6 loglevel=MANDATORY debuglevel=NONE");


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
" programtype=CUDA numcputhreads=16 loadfftwplan=true savefftwplan=true fftwplantype=MEASURE fftwlibraryname=libfftw3 fftwlibraryfilename=libfftw3.dll planpath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw\\fftPlans fftwlibrarypath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw stagerepeatability=0 horizontaloverlap=NaN verticaloverlap=NaN numfftpeaks=0 overlapuncertainty=20.0 isusedoubleprecision=false isusebioformats=false issuppressmodelwarningdialog=false isenablecudaexceptions=false translationrefinementmethod=SINGLE_HILL_CLIMB numtranslationrefinementstartpoints=16 headless=false cudadevice0id=0 cudadevice0name=[NVIDIA GeForce RTX 3080] cudadevice0major=8 cudadevice0minor=6 loglevel=MANDATORY debuglevel=NONE");

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
" programtype=CUDA numcputhreads=16 loadfftwplan=true savefftwplan=true fftwplantype=MEASURE fftwlibraryname=libfftw3 fftwlibraryfilename=libfftw3.dll planpath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw\\fftPlans fftwlibrarypath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw stagerepeatability=0 horizontaloverlap=NaN verticaloverlap=NaN numfftpeaks=0 overlapuncertainty=20.0 isusedoubleprecision=false isusebioformats=false issuppressmodelwarningdialog=false isenablecudaexceptions=false translationrefinementmethod=SINGLE_HILL_CLIMB numtranslationrefinementstartpoints=16 headless=false cudadevice0id=0 cudadevice0name=[NVIDIA GeForce RTX 3080] cudadevice0major=8 cudadevice0minor=6 loglevel=MANDATORY debuglevel=NONE");

// channel 4 (currently idle)
//channel = "4"
//run("MIST", "gridwidth=" + width + 
//" gridheight=" + height + 
//" starttile=1 imagedir=[" + currentdir + 
//"] filenamepattern=" + batch + 
//"_w" + channel + wavelength + 
//"_s{ppp}.tif filenamepatterntype=SEQUENTIAL gridorigin=LR assemblefrommetadata=true assemblenooverlap=false globalpositionsfile=[" + masterdir + 
//"\\stitched\\" + batch + 
//"_w1405global-positions-0.txt] numberingpattern=VERTICALCOMBING startrow=0 startcol=0 extentwidth=" + width + 
//" extentheight=" + height + 
//" timeslices=0 istimeslicesenabled=false outputpath=[" + masterdir + 
//"\\stitched] displaystitching=false outputfullimage=true outputmeta=true outputimgpyramid=false blendingmode=LINEAR blendingalpha=1.0 outfileprefix=" + batch + 
//"_w" + channel + wavelength + 
//" programtype=CUDA numcputhreads=16 loadfftwplan=true savefftwplan=true fftwplantype=MEASURE fftwlibraryname=libfftw3 fftwlibraryfilename=libfftw3.dll planpath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw\\fftPlans fftwlibrarypath=C:\\Users\\yzx17\\OneDrive\\Documents\\fiji-win64\\Fiji.app\\lib\\fftw stagerepeatability=0 horizontaloverlap=NaN verticaloverlap=NaN numfftpeaks=0 overlapuncertainty=20.0 isusedoubleprecision=false isusebioformats=false issuppressmodelwarningdialog=false isenablecudaexceptions=false translationrefinementmethod=SINGLE_HILL_CLIMB numtranslationrefinementstartpoints=16 headless=false cudadevice0id=0 cudadevice0name=[NVIDIA GeForce RTX 3080] cudadevice0major=8 cudadevice0minor=6 loglevel=MANDATORY debuglevel=NONE");
