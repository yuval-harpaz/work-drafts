function [list,labels]=tpReadData(chan,freq);

pat='/media/Elements/MEG/talResults'
cd(pat)
load squad01_pow94_1

%[~,A197i]=ismember('A197',cohLRv1post_D.label);
[~,chi]=ismember(chan,pow.label);

subsV1={'quad01';'quad02';'quad03';'quad04';'quad08';'quad11';'quad29';'quad31';'quad39';'quad40';'quad41';'quad42';'quad05';'quad06';'quad07';'quad09';'quad10';'quad14';'quad15';'quad16';'quad18';'quad37';'quad38';'quad12';'quad20';'quad24';'quad25';'quad26';'quad27';'quad30';'quad32';'quad33';'quad34';'quad35';'quad36'};
subsV2={'quad01b';'quad0202';'quad0302';'quad0402';'quad0802';'quad1102';'quad2902';'quad3102';'quad3902';'quad4002';'quad4102';'quad4202';'quad0502';'quad0602';'quad0702';'quad0902';'quad1002';'quad1402';'quad1502';'quad1602';'quad1802';'quad3702';'quad3802';'quad1202';'quad2002';'quad2402';'quad2502';'quad2602';'quad2702';'quad3002';'quad3202';'quad3302';'quad3402';'quad3502';'quad3602'};
labels={'rest_v1_pre','rest_v1_post','pre_v2_pre','rest_v1_post',...
    'tp_v1','tp_v2','W_v1','W_v2','NW_v1','NW_v2'};
dirs={'/media/Elements/MEG/talResults'};
%powList
%chan='A158';
%freq=[4,10];
cd ('/media/Elements/MEG/tal')

for subi=1:length(subsV1)
    for visiti=1:2
    cd ('/media/Elements/MEG/tal')
    eval(['sub=subsV',num2str(visiti),'{subi};'])
    display(['BEGGINING WITH ',sub]);
    cd ([sub,'/',sub,'/0.14d1']);
    conditions=textread('conditions','%s');
    tpcell=find(strcmp('timeProd',conditions));
    tpi=1;
    path2file=conditions{tpcell(tpi)+1};
    source= conditions{tpcell(tpi)+2};
    cd(path2file(end-16:end))
    if exist(['xc,hb,lf_',source],'file')
        clnsource=['xc,hb,lf_',source];
    elseif exist(['hb,xc,lf_',source],'file')
        clnsource=['hb,xc,lf_',source];
    elseif exist(['xc,lf_',source],'file')
        clnsource=['xc,lf_',source];
    else
        error('no cleaned source file found')
    end
    trig=readTrig_BIU(clnsource);
    trig=clearTrig(trig);
    close
    resp=readChan(clnsource,'RESPONSE');
    trval=112;
    time0=find(trig==trval,1);
    resp(1:time0)=0;
    RT(subi,visiti)=(find(resp,1)-time0)/1017.25;
%     cfg1=[];
%     cfg1.trl(1:size(epoched,2),1)=epoched';
%     cfg1.trl(1:size(epoched,2),2)=epoched'+1017;
%     cfg1.trl(1:size(epoched,2),3)=0;
%     cfg1.channel={'MEG','-A74','-A204'}
%     %% reading high frequencies to find muscle artifact
%     cfg1.hpfilter='yes';cfg1.hpfreq=20;
%     cfg1.blc='yes';
%     data=ft_preprocessing(cfg1);
%     trialAbs=[];
%     for triali=1:length(data.trial)
%         trialAbs(triali)=mean(mean(abs(data.trial{1,triali})));
%     end
%     sd=std(trialAbs);
%     good=find(trialAbs<median(trialAbs)+sd*3);
%     badn=num2str(length(trialAbs)-length(good));
%     display(['rejected ',badn,' trials']);
%     find(trialAbs>median(trialAbs)+sd*3)
%     trl=data.cfg.trl(good,:);
%     cfg1.trl=trl;
%     cfg1=rmfield(cfg1,'hpfilter');
%     cfg1=rmfield(cfg1,'hpfreq');
%     %%  reading data after artifact rejection and compute power spectrum
%     data=ft_preprocessing(cfg1);
%     cfg2            = [];
%     cfg2.output     = 'pow';
%     cfg2.method     = 'mtmfft';
%     cfg2.foilim     = [1 100];
%     cfg2.tapsmofrq  = 1;
%     cfg2.keeptrials = 'no';
%     pow=ft_freqanalysis(cfg2,data);
%     save(['/media/Elements/MEG/tal/s',sub,'_pow',num2str(trval),'_',num2str(tpi)],'pow');
    end
end
RT



%%
% for diri=1:length(dirs)
%     cd(dirs{diri})
%     for subi=1:length(subsV1)
%         try
%             load(['s',subsV1{subi},'_pow94_1'])
%             col(subi,1:length(freq))=mean(pow.powspctrm(chi,freq),1);
%         catch
%             display([subsV1{subi},' had an error. was there a s',subsV1{subi},'_pow94_1 file?']);
%         end
%     end
% end
% list(1:35,1)=col(:,1);
% for diri=1:length(dirs)
%     cd(dirs{diri})
%     for subi=1:length(subsV1)
%         try
%             load(['s',subsV1{subi},'_pow94_2'])
%             col(subi,1:length(freq))=mean(pow.powspctrm(chi,freq),1);
%         catch
%             display([subsV1{subi},' had an error. was there a s',subsV1{subi},'_pow94_1 file?']);
%         end
%     end
% end
% list(1:35,2)=col(:,1);
% 
% for diri=1:length(dirs)
%     cd(dirs{diri})
%     for subi=1:length(subsV2)
%         try
%             load(['s',subsV2{subi},'_pow94_1'])
%             col(subi,1:length(freq))=mean(pow.powspctrm(chi,freq),1);
%         catch
%             display([subsV2{subi},' had an error. was there a s',subsV2{subi},'_pow94_1 file?']);
%         end
%     end
% end
% list(1:35,3)=col(:,1);
% 
% for diri=1:length(dirs)
%     cd(dirs{diri})
%     for subi=1:length(subsV2)
%         try
%             load(['s',subsV2{subi},'_pow94_2'])
%             col(subi,1:length(freq))=mean(pow.powspctrm(chi,freq),1);
%         catch
%             display([subsV2{subi},' had an error. was there a s',subsV2{subi},'_pow94_1 file?']);
%         end
%     end
% end
% list(1:35,4)=col(:,1);
% 
% 
% % time production
% ;
% cd /media/Elements/MEG/tal
% for diri=1:length(dirs)
%     for subi=1:length(subsV1)
%         try
%             load(['s',subsV1{subi},'_pow112'])
%             col(subi,1:length(freq))=mean(pow.powspctrm(chi,freq),1);
%         catch
%             display([subsV1{subi},' had an error. was there a s',subsV1{subi},'_pow94_1 file?']);
%         end
%     end
% end
% list(1:35,5)=col(:,1);
% 
% for diri=1:length(dirs)
%     for subi=1:length(subsV2)
%         try
%             load(['s',subsV2{subi},'_pow112'])
%             col(subi,1:length(freq))=mean(pow.powspctrm(chi,freq),1);
%         catch
%             display([subsV2{subi},' had an error. was there a s',subsV2{subi},'_pow94_1 file?']);
%         end
%     end
% end
% list(1:35,6)=col(:,1);
% 
% %% oneBack
% subsV2=subsV2(1:end-1);
% % subsV1={'quad01';'quad02';'quad03';'quad04';'quad08';'quad11';'quad29';'quad31';'quad39';'quad40';'quad41';'quad42';'quad05';'quad06';'quad07';'quad09';'quad10';'quad14';'quad15';'quad16';'quad18';'quad37';'quad38';'quad12';'quad20';'quad24';'quad25';'quad26';'quad27';'quad30';'quad32';'quad33';'quad34';'quad35';'quad36'};
% % subsV2={'quad01b';'quad0202';'quad0302';'quad0402';'quad0802';'quad1102';'quad2902';'quad3102';'quad3902';'quad4002';'quad4102';'quad4202';'quad0502';'quad0602';'quad0702';'quad0902';'quad1002';'quad1402';'quad1502';'quad1602';'quad1802';'quad3702';'quad3802';'quad1202';'quad2002';'quad2402';'quad2502';'quad2602';'quad2702';'quad3002';'quad3202';'quad3302';'quad3402';'quad3502';'quad3602'};
% % talPower1bk(subsV1);
% % talPower1bk(subsV2); % error with sub 3602
% cd /media/Elements/MEG/talResults
% for subi=1:length(subsV1)
%     try
%         load(['s',subsV1{subi},'_pow_W'])
%         col(subi,1:length(freq))=mean(pow.powspctrm(chi,freq),1);
%     catch
%         display([subsV1{subi},' had an error']);
%     end
% end
% 
% list(1:35,7)=col(:,1);
% 
% for subi=1:length(subsV2)
%     try
%         load(['s',subsV2{subi},'_pow_W'])
%         col(subi,1:length(freq))=mean(pow.powspctrm(chi,freq),1);
%     catch
%         display([subsV2{subi},' had an error']);
%     end
% end
% list(1:35,8)=col(:,1);
% % nonwords
% for subi=1:length(subsV1)
%     try
%         load(['s',subsV1{subi},'_pow_NW'])
%         col(subi,1:length(freq))=mean(pow.powspctrm(chi,freq),1);
%     catch
%         display([subsV1{subi},' had an error']);
%     end
% end
% %v2
% list(1:35,9)=col(:,1);
% for subi=1:length(subsV2)
%     try
%         load(['s',subsV2{subi},'_pow_NW'])
%         col(subi,1:length(freq))=mean(pow.powspctrm(chi,freq),1);
%     catch
%         display([subsV2{subi},' had an error']);
%     end
% end
% list(1:35,10)=col(:,1);
% 
% 
