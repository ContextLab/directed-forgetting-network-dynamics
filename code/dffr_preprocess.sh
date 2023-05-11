#!/bin/sh

FSLDIR=/usr/local/fsl
PATH=${FSLDIR}/bin:${PATH}
. ${FSLDIR}/etc/fslconf/fsl.sh
export FSLDIR PATH

mkdir reg

#skull strip mprage
for m in o*MPRAGE*.nii*
do
	#skull strip mprage
	echo "Skull stripping mprage"
	bet $m mprage_brain -R -f .4
	
	#register mprage to standard space
	echo "Registering mprage to standard"
	flirt -in mprage_brain -ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain -dof 12 -omat reg/highres2standard.mat	
	
	#segment the brain-extracted mprage image
	echo "Segmenting brain-extracted mprage"
	fast --nopve mprage_brain
	
	echo "Making gray matter mask"
	fslmaths mprage_brain_seg -thr 2 -uthr 2 -bin gray_matter_mask

	echo "Warping gray matter mask to standard brain"
	flirt -in gray_matter_mask -ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain -out gray_matter_mask_std -init reg/highres2standard.mat -applyxfm
	echo "Re-masking gray matter"
	fslmaths gray_matter_mask_std -thr 0.5 -uthr 2 -bin gray_matter_mask_std_bin
done

for f in *epi*.nii*
do
	#motion correction
	echo "Motion correction: $f"
	mcflirt -in $f -out mc_${f} -refvol 0 -plots -report
	
	#pull out first volume for reference
	fslroi mc_${f} example_func 0 1
	
	#skull strip example_func
	echo "Skull stripping example_func"
	bet example_func example_func_brain_${f} -f .3

	##make whole brain mask
	#echo "Making whole brain mask"
	#fslmaths example_func_brain_${f} -bin wholebrain_${f}	
		
	#register example_func to mprage
	echo "Registering example_func to mprage"
	flirt -in example_func_brain_${f} -ref mprage_brain -dof 6 -omat reg/example_func2highres_${f}.mat
	
	#concatenate matrices
	echo "Concatenating matrices..."
	convert_xfm -omat reg/example_func2standard_${f}.mat -concat reg/highres2standard.mat reg/example_func2highres_${f}.mat
	
	#apply xfm to get epi in standard space
	flirt -in mc_${f} -ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain -out std_mc_${f} -init reg/example_func2standard_${f}.mat -applyxfm
        #applyxfm4D example_func_brain_${f} /usr/local/fsl/data/standard/MNI152_T1_2mm_brain std_${f} std_${f} reg/example_func2standard_${f}.mat -singlematrix
	#mask standard space epi sequence
	echo "Masking epi sequence"
	fslmaths std_mc_${f} -mas gray_matter_mask_std_bin masked_std_mc_${f}
done

echo "Done."
