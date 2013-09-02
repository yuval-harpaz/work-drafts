#!/bin/bash

# copy this to ~/bin for it to be in liux path
# cd to where your nudged ortho+orig is
# run something like "ortho2FS.sh Idan", Idan being subject directory to be created.
# the last stage takes a day!

# conversions
3dcopy ortho+orig ortho.nii
mri_convert -i ortho.nii -o ortho.mgz
mri_convert -c -oc 0 0 0 ortho.mgz 001.mgz
mksubjdirs /usr/local/freesurfer/subjects/$1
mv 001.mgz /usr/local/freesurfer/subjects/$1/mri/orig/

# freesurfing
recon-all -all -subject $1

# getting the dipoles
mne_setup_source_space --subject $1 --spacing 5

# to view 
tkmedit $1 brainmask.mgz -aux T1.mgz -surfs -aseg


