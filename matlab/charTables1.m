function powMed=charTables1(chanMethod, freqMethod)

if ~exist('org.apache.poi.ss.usermodel.WorkbookFactory', 'class')
    cd ~/Documents/MATLAB/20130227_xlwrite/20130227_xlwrite
    javaaddpath('poi_library/poi-3.8-20120326.jar');
    javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
    javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
    javaaddpath('poi_library/xmlbeans-2.3.0.jar');
    javaaddpath('poi_library/dom4j-1.6.1.jar');
end
if ~existAndFull('chanMethod')
    chanMethod='max'; % 'mean' 'min'
end
if ~existAndFull('freqMethod')
    freqMethod = 'max'; % 'mean'
end
bands={'Delta','Theta','Alpha','Beta','Gamma'};
freqs=[1,4;4,8;8,13;13,25;25,40];
trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
conds={'closed','open','charisma','room','dull','silent'};
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
load /media/yuval/YuvalExtDrive/Data/Hilla_Rotem/Sub40
%% average power per condition per band    
R=zeros(40,6,5);
for condi=1:6
    for bandi=1:5
        for subi=1:40
            load(['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_',freqMethod,'_',chanMethod])
            if subi==1
                Pow=nan(40,size(pow,2));
                segs=1:10:size(Pow,2)-19;
                segs(2,:)=segs+19;
            end
            PowNan=pow;
            PowNan(pow>(median(pow)*4))=nan;
            Pow(subi,:)=PowNan;
        end
        rr=corr(Pow','rows','pairwise');
        rr(logical(eye(40)))=nan;
        R(1:40,condi,bandi)=nanmean(rr);
        PSD(1:40,condi,bandi)=nanmean(Pow,2);
        disp(['done ',conds{condi},' ',bands{bandi},' mean R = ',num2str(mean(R(:,condi,bandi)))]);
    end
    
end

bandi=1:5;
for bi=1:length(bandi)
    table={};
    table{1,1}='subjects\condition';
    for coli=1:6
        table{1,coli+1}=conds{coli};
        for rowi=1:40
            if coli==1
                table{rowi+1,1}=Sub{rowi,1};
            end
            table{rowi+1,coli+1}=R(rowi,coli,bi);
        end
    end
    xlwrite(['ISC_',bands{bi}],table);
end
disp('done')

