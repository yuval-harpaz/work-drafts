function rewriteDicom(pathToDicom)

cd(pathToDicom);
!ls > ls.txt
A=importdata('ls.txt');

for ii=1:length(A)
    currentFile = A{ii};
    info = dicominfo(currentFile);
    infNT=rmfield(info,'TransferSyntaxUID');
    X = dicomread(info);
    dicomwrite(X,[num2str(ii),'.dicom'],infNT);
end