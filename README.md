# KraftLab.github.io
MATLAB SOURCE CODE FOR THE ARTICLE ENTITLED:

Depth correction of 3D NanoSIMS images show intracellular lipid and cholesterol distributions while capturing the effects of differential sputter rate

Authored by:
   1. Melanie A. Brunet, Department of Chemical and Biomolecular Engineering, University of Illinois Urbana-Champaign, Urbana, Illinois 61801, USA
   2. Brittney L. Gorman, Center for Biophysics and Quantitative Biology, University of Illinois Urbana-Champaign, Urbana, Illinois 61801, USA
   3. Mary L. Kraft, Department of Chemical and Biomolecular Engineering, Center for Biophysics and Quantitative Biology, and Department of Chemistry,             University of Illinois Urbana-Champaign, Urbana, Illinois 61801, USA
Melanie A. Brunet and Brittney L. Gorman contributed equally to this work.

Citation for article: Melanie A. Brunet, Brittney L. Gorman and Mary L. Kraft. "Depth Correction of 3D NanoSIMS Images Shows Intracellular Lipid and Cholesterol Distributions while Capturing the Effects of Differential Sputter Rate," ACS Nano 2022, 16 (10), 16221-16233. DOI: 10.1021/acsnano.2c05148.

Correspondence should be addressed to M.L.K. at mlkraft@illinois.edu 

These codes were authored by Melanie A. Brunet and Brittney L. Gorman under the supervision of Mary L. Kraft.
Questions regarding the code should be directed to Brittney Gorman (gormanb9@gmail.com) and Melanie Brunet (mab15@illinois.edu).

PACKAGE 1: Image preprocessing

	This package is used to preprocess the NanoSIMS depth profiling image data.
	MATLAB file: Preprocessing_Crop_Masking_IlluminationCorrection_LowerBaseline.m 
	Cropping is applied to the secondary electron matrix and all secondary ion matices.
	Masking, illumination correction, and baseline lowering are applied to the secondary electron matrix. 

PACKAGE 2: Alignment functions

	This package is used to align the secondary electron image planes in the depth profile acquired with a NanoSIMS instrument.
	MATLAB files: ROI_align.m
		      Drift_correcting.m
		      Course_align.m
		      Fine_align.m
	ROI_align.m, Course_align.m, and Fine_align.m are functions that are called in Drift_correcting.m.
	
PACKAGE 3: Morphology reconstruction
	
	This package is used to reconstruct the sample's morphology and visualize the results.
	MATLAB files: 	Morphology_reconstruction_DSR.m
			Surface_plots.m
		        Relative_height_difference.m
	Morphology_reconstruction_DSR.m is used to reconstruct the sample's morphology from the secondary electron pixel intensities.
	Surface_plots.m generates a 3D rendering for each morphology reconstructions.
	Relative_height_difference.m calculates the relative height difference between the morphology reconstruction and the sample topography measured with AFM     and creates an image that shows these differences.
	
PACKAGE 4: Preprocessing secondary ion images
	
	This package is used to preprocess the secondary ion images in the depth profile acquired with a NanoSIMS instrument.
	MATLAB files: Secondary_ion_image_preprocessing.m
		      Ratio_matrices.m
		      Masking_pixels.m
		      Secondary_ion_image_alignment.m 
	Ratio_matrices.m, Masking_pixels.m, and Secondary_ion_image_alignment.m are functions that are called in Secondary_ion_image_preprocessing.m.
	Ratio_matrices.m is used to generate iosotope enrichment images.
	Secondary_ion_image_alignment.m is used to align the secondary ion image planes using the translations defined by the codes in PACKAGE 2. 
	Masking_pixels.m smoothes the secondary ion images for noise reduction. 

PACKAGE 5: Depth correction

	This package is used depth correct the isotope enrichment images using the heights derived from the morphology reconstruction and to generate 3D renderings   of the depth corrected data.
	MATLAB files: Enrichment_images.m
		      Z_translate.m
		      Colocalize_cholesterol_and_sphingolipids-Figure.m
	Enrichment_images.m generates 3D renderings of the iosotope enrichment images generated with the codes in PACKAGE 4.  
	Z_translate.m depth corrects the isotope enrichment images using the heights derived from the morphology reconstruction.
	Colocalize_cholesterol_and_sphingolipids-Figure.m generates an overlay of the two component-specific isotope enrichment images.

If you use these codes to generate images for publications or presentations, please cite this repository.
