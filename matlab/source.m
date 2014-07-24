function fileName=source
!ls c,* > LS.txt
LS=importdata('LS.txt');
!rm LS.txt
if isempty(LS);
    disp('looking for *_c,*')
    !ls *_c,* > LS.txt
    LS=importdata('LS.txt');
    !rm LS.txt
end
if isempty(LS);
    fileName='';
elseif length(LS)>1
    warning('more than one c,* files present, took the first one')
else
    fileName=LS{1,1};
end
