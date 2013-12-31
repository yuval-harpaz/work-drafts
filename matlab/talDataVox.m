function [Dys,Cont]=talDataVox(LPIxyz)
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
subs={'quad01'; 'quad02';  'quad03';  'quad04';  'quad08';  'quad11';  'quad29';  'quad31';  'quad39';  'quad40';  'quad41';  'quad42'  ;'quad05';  'quad06';  'quad07';  'quad09';  'quad10';  'quad14';  'quad15';  'quad16';  'quad18';  'quad38';'quad01b';'quad0202';'quad0302';'quad0402';'quad0802';'quad1102';'quad2902';'quad3102';'quad3902';'quad4002';'quad4102';'quad4202';'quad0502';'quad0602';'quad0702';'quad0902';'quad1002';'quad1402';'quad1502';'quad1602';'quad1802';'quad3802'};
for subi=1:length(subs)
    cd /media/Elements/MEG/talResults
    eval(['!3dmaskdump -xbox ',RAIxyz,' ',subs{subi},'/alpha1z+tlrc >> voxValues.txt'])
end
list=importdata('voxValues.txt');
list=list(:,4);
Dys=list(1:12);
Dys(:,2)=list(23:34);
Cont=list(13:22);
Cont(:,2)=list(35:end);
bars=[mean(Cont) mean(Dys)];
err=[std(Cont)./sqrt(size(Cont,1)) std(Dys)./sqrt(size(Dys,1))];
bar(bars,'k')
hold on
errorbar(bars,err,'k.')
