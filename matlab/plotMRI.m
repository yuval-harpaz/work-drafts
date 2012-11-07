function plotMRI(dicom)
% dicom is a string, e.g. 'something.dcm'
info = dicominfo(dicom);
Y = dicomread(info);
imshow(Y);
imcontrast