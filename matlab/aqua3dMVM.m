function str=aqua3dMVM


str=[];
str='3dMVM -prefix 3dANOVA_3gr -jobs 6 -model group -wsVars visit -num_glt 0 -dataTable Subj group visit InputFile ';
TalQuad={'quad06';'quad11';'quad14';'quad15';'quad16';'quad18';'quad37';'quad42';}
TalVerb={'quad24';'quad25';'quad26';'quad27';'quad30';'quad32';'quad35';'quad36';}
for subi=1:8
    str=[str,'tq',TalQuad{subi}(end-1:end),' TalQuad v1 /media/Elements/MEG/talResults/',TalQuad{subi},'/alpha1z+tlrc tq',TalQuad{subi}(end-1:end),' TalQuad v2 /media/Elements/MEG/talResults/',TalQuad{subi},'02/alpha1z+tlrc '];
    str=[str,'tv',TalVerb{subi}(end-1:end),' TalVerb v1 /media/Elements/MEG/talResults/',TalVerb{subi},'/alpha1z+tlrc tv',TalVerb{subi}(end-1:end),' TalVerb v2 /media/Elements/MEG/talResults/',TalVerb{subi},'02/alpha1z+tlrc '];
    str=[str,'aq0',num2str(subi),' aquaQuad v1 rest_az_',num2str(subi),'+tlrc aq0',num2str(subi),' aquaQuad v2 rest_az_',num2str(subi),'+tlrc '];
end
cd /media/Elements/quadaqua/SAM
eval(['!echo "',str,'" > 3dMVMaqua1'])