cd /media/Elements/MEG/tal/quad01/quad01/0.14d1/05.06.11@_11:46
wtsNoSuf='1/SAM/theta,3-7Hz,eyesCloseda';
if exist ([wtsNoSuf,'.mat'],'file')
    load ([wtsNoSuf,'.mat'])
else
    [SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
    save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts')
end
conds={'W','NW'};
W=zeros(size(ActWgts,1),1);
NW=zeros(size(ActWgts,1),1);
for Xi=-12:0.5:12
    for Yi=-9:0.5:-0.5
        for Zi=-2:0.5:15
            [indR,~]=voxIndex([Xi,Yi,Zi],100.*[...
                SAMHeader.XStart SAMHeader.XEnd ...
                SAMHeader.YStart SAMHeader.YEnd ...
                SAMHeader.ZStart SAMHeader.ZEnd],...
                100.*SAMHeader.StepSize,0);
            [indL,~]=voxIndex([Xi,-Yi,Zi],100.*[...
                SAMHeader.XStart SAMHeader.XEnd ...
                SAMHeader.YStart SAMHeader.YEnd ...
                SAMHeader.ZStart SAMHeader.ZEnd],...
                100.*SAMHeader.StepSize,0);
            if ~isempty(find(ActWgts(indR,:)))
                
                for condi=1:2
                    eval(['lng=length(',conds{condi},'.trial);'])
                    nspm=[0;0];
                    
                    
%                     cfg=[];
%         cfg.dataset=source;
%         cfg.trialdef.poststim=0.2;
%         cfg.trialfun='trialfun_beg';
%         cfg1=[];
%         cfg1=ft_definetrial(cfg);
%         cfg1.trl=trl
%         cfg1.channel={'MEG','-A74','-A204'}
%         cfg1.blc='yes';
%         cfg1.export='';
%         data=ft_preprocessing(cfg1);
%         % fft
%         cfg3           = [];
%         cfg3.method    = 'mtmfft';
%         cfg3.output    = 'fourier';
%         cfg3.tapsmofrq = 1;
%         cfg3.foi=foi;
%         freq          = ft_freqanalysis(cfg3, data);
%         % Coherence
%         %chansL={'A229' 'A232' 'A215' 'A236' 'A123' 'A126' 'A129' 'A132' 'A135' 'A39' 'A43' 'A47'};
%         %chansR={'A248' 'A245' 'A225' 'A241' 'A151' 'A148' 'A145' 'A142' 'A139' 'A59' 'A55' 'A51'};
%         %chanCmbLR=chansL';
%         %chanCmbLR(:,2)=chansR';
%         
%         cfg4           = [];
%         cfg4.method    = 'coh';
%         if strcmp(chCmb,'LR')
%             load ~/ft_BIU/matlab/files/LRpairs
%             cfg4.channelcmb=LRpairs;
%             cohLR          = ft_connectivityanalysis(cfg4, freq);
%             load ([patR,'/tempCoh']);
%             cohspctrm=ones(246,50);
%             
%             for cmbi=1:113
%                 chi=find(strcmp(cohLR.labelcmb{cmbi,1},data.label));
%                 cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,1:50);
%                 chi=find(strcmp(cohLR.labelcmb{cmbi,2},data.label));
%                 cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,1:50);
%             end
%             coh=tempCoh;
%             coh.powspctrm=cohspctrm;
%             coh.freq=1:50;
%             sufix='';
%         else
                    
                    for triali=1:lng;
                        
%                         if triali==1
%                             display(['going through ',num2str(lng),' trials'])
%                         end
                        eval(['vs=actWgts*',conds{condi},'.trial{1,triali};']);
                        vs=vs-repmat(mean(vs,2),1,size(vs,2));
                        pow=vs.*vs;
                        pow=mean(pow,2);
                        pow=pow./ns;
                        nspm=nspm+pow;
                        %display(['trial ',num2str(triali)])
                    end
                    eval(['Nspm',conds{condi}(1:2),'([indR indL],1)=nspm./triali;'])
                end
            end
        end
    end
end