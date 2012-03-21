function talSourceCoh(subs,tlrc);
%subs={'quad01'}
% tlrc=[ -40 -18 -8;40 -18 -8;... %   LR hippo, Wink 2006
% -49 17 17;49 17 17;... %        Broca
% -39 29 -6;39 29 -6;... %        IFG 47
% -48 -5 -21;48 -5 -21;... %      ITG
% -57 -12 -2;57 -12 -2;... %      STG
% -14 -20 12;14 -20 12;... %      thalamus
% -34 18 2;34 18 2;...    %       insula
% -30 -61 -36;30 -61 -36;... %    cerebellum
% -35 -25 60;35 -25 60]; %
PWD=pwd;
cd ('/home/yuval/Desktop/tal')
for subi=1:length(subs)
    sub=subs{subi};
    if exist(['~/Desktop/talResults/CohSource/',sub],'file')
        error(['file ~/Desktop/talResults/CohSource/',sub,' exists'])
    else
        display(['BEGGINING WITH ',sub]);
        indiv=indivPathTal(sub,'rest');
        for i=1:2 % two eyes closed per subject
            eval(['cd (indiv.path',num2str(i),')']);
            eval(['source=indiv.source',num2str(i),';'])
            % converting MarkerFile to trl
            trg=textread('restMarkerFile.mrk','%s');
            startTrg=find(strcmp('eyesClosed',trg))+14;
            numTrg=trg(startTrg-10);
            numTrg=str2num(numTrg{1,1});
            endTrg=startTrg+numTrg*2-2;
            trl=[];
            trli=1;
            load ~/Desktop/tal/cohTempData.mat
            vox=round(0.2*tlrc2orig(tlrc))/2;
            for trgi=startTrg:2:endTrg
                trOnset=str2num(trg{trgi});
                strOnset=num2str(trOnset);
                trl(trli,1)=round(trOnset*1017.25);
                data.trial{1,trli}=VSbyVox(source,'SAM/alpha,7-13Hz,eyesCloseda',1,[trOnset (trOnset+1)],[],vox);
                if trli>1
                    data.time{1,trli}=data.time{1,1};
                end
                display (['Really trial ',num2str(trli),' of about ',num2str(round((endTrg-startTrg)/2))])
                trli=trli+1;
            end
            data.label={'Lhip';'Rhip';'Lbr';'Rbr';'L47';'R47';'Litg';'Ritg';'Lstg';'Rstg';'Ltha';'Rtha';'Lins';'Rins';'Lcereb';'Rcereb';'Lmu';'Rmu'}
            data=correctBL(data);
            trl(:,2)=trl(:,1)+1017;
            trl(:,3)=0;
            %         cfg=[];
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
            % fft
            cfg3           = [];
            cfg3.method    = 'mtmfft';
            cfg3.output    = 'fourier';
            cfg3.tapsmofrq = 1;
            cfg3.foilim=[1 100];
            freq          = ft_freqanalysis(cfg3, data);
            % Coherence
            %chansL={'A229' 'A232' 'A215' 'A236' 'A123' 'A126' 'A129' 'A132' 'A135' 'A39' 'A43' 'A47'};
            %chansR={'A248' 'A245' 'A225' 'A241' 'A151' 'A148' 'A145' 'A142' 'A139' 'A59' 'A55' 'A51'};
            %chanCmbLR=chansL';
            %chanCmbLR(:,2)=chansR';
            %load ~/ft_BIU/matlab/files/LRpairs
            cfg4           = [];
            cfg4.method    = 'coh';
            %cfg4.channelcmb=LRpairs;
            
            coh          = ft_connectivityanalysis(cfg4, freq);
            eval(['coh',num2str(i),'=coh;'])
        end
        save(['~/Desktop/talResults/CohSource/',sub],'coh1','coh2')
    end
end
cd(PWD);
end
