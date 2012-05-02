function talOneBackH(subs)
cd ('/media/Elements/MEG/tal')
for subi=1:length(subs)
    cd ('/media/Elements/MEG/tal')
    sub=subs{subi};
    if ~exist(['/media/Elements/MEG/talResults/s',sub,'_1bk.mat'],'file')
        display(['BEGGINING WITH ',sub]);
        cd ([sub,'/',sub,'/0.14d1']);
        conditions=textread('conditions','%s');
        oneBackCell=find(strcmp('oneBack',conditions));
        
        path2file=conditions{oneBackCell+1};
        source= conditions{oneBackCell+2};
        cd(path2file)
        if exist(['xc,hb,lf_',source],'file')
            clnsource=['xc,hb,lf_',source];
        elseif exist(['hb,xc,lf_',source],'file')
            clnsource=['hb,xc,lf_',source];
        elseif exist(['xc,lf_',source],'file')
            clnsource=['xc,lf_',source];
        elseif exist(['hb,lf_',source],'file')
            clnsource=['hb,lf_',source];
        else
            error('no cleaned source file found')
        end
        trig=readTrig_BIU(source);
        trig=clearTrig(trig);
        cfg=[];
        cfg.dataset=source;
        cfg.trialfun='trialfun_beg';
        cfg1=ft_definetrial(cfg);
        cfg1.channel='X3';
        cfg1.hpfilter='yes';
        cfg1.hpfreq=110;
        Aud=ft_preprocessing(cfg1);
        trigFixed=fixAudTrig(trig,Aud.trial{1,1},[],0.005);
        trigon=find(trigFixed);
        trl=trigon'-203;
        trl(:,2)=trl+1017;
        trl(:,3)=(-203);
        trl(:,4)=trigFixed(trigon)
        validCond=trl(:,4)==100;
        validCond=validCond+(trl(:,4)==102);
        validCond=validCond+(trl(:,4)==200);
        validCond=validCond+(trl(:,4)==202);
        trl=trl(find(validCond),:);
        cfg.dataset=clnsource;
        cfg2=ft_definetrial(cfg);
        cfg2.trl=trl;
        cfg2.channel={'MEG' '-A74' '-A204'};
        % reading high frequencies to find muscle artifact
        cfg2.hpfilter='yes';cfg2.hpfreq=20;
        cfg2.blc='yes';
        data=ft_preprocessing(cfg2);
        trialAbs=[];
        for triali=1:length(data.trial)
            trialAbs(triali)=mean(mean(abs(data.trial{1,triali})));
        end
        %finding trials with sd > 2
        sd=std(trialAbs);
        good=find(trialAbs<median(trialAbs)+sd*3);
        badn=num2str(length(trialAbs)-length(good));
        display(['rejected ',badn,' trials']);
        find(trialAbs>median(trialAbs)+sd*3)
        trl=data.cfg.trl(good,:);
        %save trl92 trl
        cfg3=rmfield(cfg2,'hpfilter');
        cfg3=rmfield(cfg3,'hpfreq')
        cfg3.trl=trl;
        %%  reading data after artifact rejection and compute power spectrum
        cfg3.bpfilter='yes';
        cfg3.bpfreq=[3 30];
        data=ft_preprocessing(cfg3);
        cfg4.cond=100;
        word=splitconds(cfg4,data);
        wordAv=ft_timelockanalysis([],word);
        cfg4.cond=200;
        nonword=splitconds(cfg4,data);
        nonwordAv=ft_timelockanalysis([],nonword);
        save(['/media/Elements/MEG/talResults/s',sub,'_1bk'],'word','wordAv','nonword','nonwordAv');
        save trl trl
        close all
    end
end
end

% pdf=pdf4D(source);
% X3=read_data_block(pdf,[1 length(trig)],channel_index(pdf,'X3','name'));
% trigFixed=fixAudTrig(trig,Aud.trial{1,1});
% BandPassSpecObj=fdesign.bandpass(...
%     'Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',...
%     2,4,50,100,60,1,60,1017.25);
% BandPassSpecObj=fdesign.highpass(...
%     'Fst1,Fp1,Ast1,Ap',...
%     50,60,20,1),1017);
%
%
% HighPassSpecObj=fdesign.highpass;
% HighPassSpecObj.Fstop=60;
% HighPassFilt=design(HighPassSpecObj  ,'butter');
% X3filt = myFilt(X3,HighPassFilt);
%
%
%
% BandPassFilt=design(BandPassSpecObj  ,'butter');
% X3filt = myFilt(mMEG,BandPassFilt);