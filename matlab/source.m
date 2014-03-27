function fileName=source
!ls c,* > LS.txt
LS=importdata('LS.txt');
fileName=LS{1,1};
if length(LS)>1
    warning('more than one c,* files')
end