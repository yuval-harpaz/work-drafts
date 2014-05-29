function [cohLR,coh,freq,data]=aquaCoh(cond)
% chCmb can be 'LR' or 'AntPost'
% [cohLR,freq,data]=cohTal({'quad01'},[1:50]);
subs={'Nissim003';'Nissim004';'Nissim005';'Nissim006';'Nissim008';'Nissim009';'Nissim011';'Nissim012';}
pat='/media/Elements/quadaqua/';
foi=1:50;
if ~exist('cond','var')
    cond=[];
end
if isempty(cond)
    cond='rest';
end

for subi=1:length(subs)
    
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    run={'a','b'};
    for runi=1:2 % two eyes closed per subject
        cd (pat)
        cd (sub)
        cd(run{runi})
        trg=textread([cond,'MarkerFile.mrk'],'%s');
        if strcmp('rest',cond)
            startTrg=find(strcmp('eyesClosed',trg))+14;
        elseif strcmp('timeProd',cond)
            startTrg=find(strcmp([cond,'32'],trg))+14;
        end
        numTrg=trg(startTrg-10);
        numTrg=str2num(numTrg{1,1});
        endTrg=startTrg+numTrg*2-2;
        trl=[];
        trli=1;
        for trgi=startTrg:2:endTrg
            trl(trli,1)=round(str2num(trg{trgi})*1017.25);
            trli=trli+1;
        end
        trl(:,2)=trl(:,1)+1017;
        trl(:,3)=0;
        cfg=[];
        cfg.dataset=source;
        cfg.trialdef.poststim=0.2;
        cfg.trialfun='trialfun_beg';
        cfg1=[];
        cfg1=ft_definetrial(cfg);
        cfg1.trl=trl
        cfg1.channel={'MEG','-A74','-A204'}
        cfg1.blc='yes';
        cfg1.export='';
        data=ft_preprocessing(cfg1);
        % fft
        cfg3           = [];
        cfg3.method    = 'mtmfft';
        cfg3.output    = 'fourier';
        cfg3.tapsmofrq = 1;
        cfg3.foi=foi;
        freq          = ft_freqanalysis(cfg3, data);
        % Coherence
        cfg4           = [];
        cfg4.method    = 'coh';
        load ~/ft_BIU/matlab/files/LRpairs
        cfg4.channelcmb=LRpairs;
        cohLR          = ft_connectivityanalysis(cfg4, freq);
        load ('/media/Elements/MEG/talResults/tempCoh');
        cohspctrm=ones(246,50);
        for cmbi=1:113
            chi=find(strcmp(cohLR.labelcmb{cmbi,1},data.label));
            cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,1:50);
            chi=find(strcmp(cohLR.labelcmb{cmbi,2},data.label));
            cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,1:50);
        end
        coh=tempCoh;
        coh.powspctrm=cohspctrm;
        coh.freq=1:50;
        sufix='';
        eval(['cohV',num2str(runi),'=coh;'])
    end
        save([pat,'Coh/',num2str(subi)],'cohV1','cohV2')
end
