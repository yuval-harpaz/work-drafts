function aquaDataVox
% give it talairach coordinates in mm (LPI) and it makes a table for this
% voxel, subject by subject

% java path
if ~exist('org.apache.poi.ss.usermodel.WorkbookFactory', 'class')
    cd ~/Documents/MATLAB/20130227_xlwrite/20130227_xlwrite
    javaaddpath('poi_library/poi-3.8-20120326.jar');
    javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
    javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
    javaaddpath('poi_library/xmlbeans-2.3.0.jar');
    javaaddpath('poi_library/dom4j-1.6.1.jar');
end
vox=[-17 -72 -18;3 -72 -3; 33 -62 62; 51 -77 7;-52 -32 -23; -17 -67 27;-62 -47 7;21 -27 57;42 6 3];
xlsName={'cerebellum.xls','inferior occipital.xls','parietal.xls','mid occipital.xls','fusiform.xls','precuneus.xls','MTG.xls','somatosensory.xls','insula.xls'};
for voxi=1:size(vox,1)
    LPIxyz=vox(voxi,:);
    if ~exist('LPIxyz','var')
        LPIxyz=[];
    end
    if isempty(LPIxyz);
        LPIxyz=[12 -37 -22];
    end
    RAIxyz=[num2str(-LPIxyz(1)),'  ', num2str(-LPIxyz(2)),' ', num2str(LPIxyz(3))];
    cd /media/Elements/quadaqua/SAM
    load subsTal
    subs=subs(:,1);
    cd /media/Elements/MEG/talResults
    if exist('voxValues.txt','file')
        !rm voxValues.txt
    end
    for subi=1:length(subs)
        eval(['!3dmaskdump -xbox ',RAIxyz,' ',subs{subi},'/alpha1z+tlrc >> voxValues.txt'])
    end
    for subi=1:8 %aqua
        eval(['!3dmaskdump -xbox ',RAIxyz,' /media/Elements/quadaqua/SAM/rest_az_',num2str(subi),'+tlrc >> voxValues.txt'])
        eval(['!3dmaskdump -xbox ',RAIxyz,' /media/Elements/quadaqua/SAM/rest_bz_',num2str(subi),'+tlrc >> voxValues.txt'])
    end
    list=importdata('voxValues.txt');
    list=list(:,4);
    TalQuad=list(1:2:15);
    TalQuad(:,2)=list(2:2:16);
    TalVerb=list(17:2:31);
    TalVerb(:,2)=list(18:2:32);
    aqua=list(33:40);
    aqua(:,2)=list(41:end);
    bars=[mean(aqua) mean(TalQuad) mean(TalVerb)];
    err=[std(aqua)./sqrt(size(aqua,1)) std(TalQuad)./sqrt(size(TalQuad,1)) std(TalVerb)./sqrt(size(TalVerb,1))];
%     figure;
%     bar(bars,'k')
%     hold on
%     errorbar(bars,err,'k.')
%     title ('aqua 1    aqua 2    TalQuad 1  TalQuad 2 TalVerb 1 TalVerb 2')
    table={'subject';'quad06';'quad11';'quad14';'quad15';'quad16';'quad18';'quad37';'quad42';'quad24';'quad25';'quad26';'quad27';'quad30';'quad32';'quad35';'quad36';'Nissim003';'Nissim004';'Nissim005';'Nissim006';'Nissim008';'Nissim009';'Nissim011';'Nissim012';};
    table{1,2}='visit 1';
    table{1,3}='visit 2';
    
    for i=1:8
        table{i+1,2}=num2str(TalQuad(i,1));
        table{i+1,3}=num2str(TalQuad(i,2));
    end
    for i=9:16
        table{i+1,2}=num2str(TalVerb(i-8,1));
        table{i+1,3}=num2str(TalVerb(i-8,2));
    end
    for i=17:24
        table{i+1,2}=num2str(aqua(i-16,1));
        table{i+1,3}=num2str(aqua(i-16,2));
    end
    !rm voxValues.txt
    cd /media/Elements/quadaqua/SAM
    xlwrite(xlsName{voxi},table);
end

