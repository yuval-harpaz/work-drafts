function [cohLR,coh,freq,data]=talCohLR(subs,foi,pat,cond)
% [cohLR,freq,data]=cohTal({'quad01'},[1:50]);
if strcmp('rest',cond)
    error('please use talCohH for rest')
end
if ~exist('pat','var')
    pat=[];
end
if isempty(pat)
    pat='/media/Elements/MEG/tal';
end
patR=[pat(1:(end-3)),'talResults'];
PWD=pwd;
cd (pat)
for subi=1:length(subs)
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    indiv=talIndivPathH(sub,cond,pat);
    i=1;
    cd (indiv.path1);
    source=indiv.source1;
    % converting MarkerFile to trl
    trg=textread([cond,'MarkerFile.mrk'],'%s');
    %
    %     startTrg=find(strcmp('eyesClosed',trg))+14;
    %     doCohLR(trg,startTrgW,i,source,cond,patR,sub,'')
    if strcmp('timeProd',cond)
        startTrg=find(strcmp([cond,'32'],trg))+14;
        doCohLR(trg,startTrgW,i,source,cond,patR,sub,'TP')
    elseif strcmp('oneBack',cond)
        startTrgW=find(strcmp('words',trg))+14;
        doCohLR(trg,startTrgW,i,source,cond,patR,sub,'W')
        startTrgNW=find(strcmp('nonwords',trg))+14;
        doCohLR(trg,startTrgNW,i,source,cond,patR,sub,'NW')
    end
    
    cd(PWD);
end
    function doCohLR(trg,startTrig,i,src,cond,patR,sub,sufix)
        numTrg=trg(startTrig-10);
        numTrg=str2num(numTrg{1,1});
        endTrg=startTrig+numTrg*2-2;
        trl=[];
        trli=1;
        for trgi=startTrig:2:endTrg
            trl(trli,1)=round(str2num(trg{trgi})*1017.25);
            trli=trli+1;
        end
        trl(:,2)=trl(:,1)+1017;
        trl(:,3)=0;
        cfg=[];
        cfg.dataset=src;
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
        cfg4           = [];
        cfg4.method    = 'coh';
        LRpairs=load('~/ft_BIU/matlab/files/LRpairs');
        cfg4.channelcmb=LRpairs.LRpairs;
        cohLR          = ft_connectivityanalysis(cfg4, freq);
        tempCoh=load ([patR,'/tempCoh']);
        tempCoh=tempCoh.tempCoh;
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
        eval(['coh',num2str(i),'=coh;'])
        if ~exist([patR,'/',cond,'Coh'],'dir')
            mkdir([patR,'/',cond,'Coh']);
        end
        save([patR,'/',cond,'Coh/',sub,sufix],'coh1')
    end
end

