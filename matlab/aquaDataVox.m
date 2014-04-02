function table=aquaDataVox(LPIxyz)
% give it talairach coordinates in mm (LPI) and it makes a table for this
% voxel, subject by subject
if exist('voxValues.txt','file')
    !rm voxValues.txt
end
if ~exist('LPIxyz','var')
    LPIxyz=[];
end
if isempty(LPIxyz);
    LPIxyz=[12 -37 -22];
end
RAIxyz=[num2str(-LPIxyz(1)),'  ', num2str(-LPIxyz(2)),' ', num2str(LPIxyz(3))];
subs={'quad05';  'quad06';  'quad07';  'quad09';  'quad10';  'quad14';  'quad15';  'quad16';  'quad18';  'quad38'};
cd /media/Elements/MEG/talResults
for subi=1:length(subs)
    eval(['!3dmaskdump -xbox ',RAIxyz,' ',subs{subi},'/alpha1z+tlrc >> voxValues.txt'])
    eval(['!3dmaskdump -xbox ',RAIxyz,' ',subs{subi},'02/alpha1z+tlrc >> voxValues.txt'])
end
for subi=1:8 %aqua
    eval(['!3dmaskdump -xbox ',RAIxyz,' /media/Elements/quadaqua/SAM/rest_az_',num2str(subi),'+tlrc >> voxValues.txt'])
    eval(['!3dmaskdump -xbox ',RAIxyz,' /media/Elements/quadaqua/SAM/rest_bz_',num2str(subi),'+tlrc >> voxValues.txt'])
end
list=importdata('voxValues.txt');
list=list(:,4);
Tal=list(1:10);
Tal(:,2)=list(11:20);
aqua=list(21:28);
aqua(:,2)=list(29:end);
bars=[mean(aqua) mean(Tal)];
err=[std(aqua)./sqrt(size(aqua,1)) std(Tal)./sqrt(size(Tal,1))];
bar(bars,'k')
hold on
errorbar(bars,err,'k.')
title ('aqua 1             aqua 2              Tal 1              Tal 2')
data=[Tal;aqua];
table={'subject';'quad05';  'quad06';  'quad07';  'quad09';  'quad10';  'quad14';  'quad15';  'quad16';  'quad18';  'quad38';'Nissim003';'Nissim004';'Nissim005';'Nissim006';'Nissim008';'Nissim009';'Nissim011';'Nissim012';}
table{1,2}='visit 1';
table{1,3}='visit 2';

for i=1:10
    table{i+1,2}=num2str(Tal(i,1));
    table{i+1,3}=num2str(Tal(i,2));
end
for i=11:18
    table{i+1,2}=num2str(aqua(i-10,1));
    table{i+1,3}=num2str(aqua(i-10,2));
end
!rm voxValues.txt
