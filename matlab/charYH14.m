function charYH14(smFac)
chanMethod='max'; % 'mean' 'min'
freqMethod = 'max'; % 'mean'
bands={'Delta','Theta','Alpha','Beta','Gamma'};
freqs=[1,4;4,8;8,13;13,25;25,40];
trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
conds={'closed','open','charisma','room','dull','silent'};
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
if ~exist('smFac','var')
    smFac=300;
end
%% average power per condition per band    
R=zeros(40,5);
for bandi=1:5
    for condi=1:6
    
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
%             figure;
%             plot(Pow')
%             hold on
%             plot(PowNan','k')
%             line([1,243],[median(Pow(:))*4,median(Pow(:))*4],'color','m')
        end
        if condi==2
            PowAll=Pow;
        elseif condi>2
            PowAll=[PowAll,Pow];
        end
    end
    Rsm=zeros(40,1431);
    for smi=1:40
        sm=smooth(PowAll(smi,:),smFac)';
        Rsm(smi,1:length(PowAll))=sm;
    end
    rr=corr(Rsm','rows','pairwise');
    rr(logical(eye(40)))=nan;
    R(1:40,bandi)=nanmean(rr);
    %PSD(1:40,condi,bandi)=nanmean(Pow,2);
    disp(['done ',bands{bandi},' mean R = ',num2str(mean(R(:,bandi)))]);
    
end
%save (['R_',freqMethod,'_',chanMethod], 'R')
%save (['PSD_',freqMethod,'_',chanMethod], 'PSD')
% for bi=1:5
%     [~,p(bi)]=ttest(R(:,bi));
% end
disp('done')
