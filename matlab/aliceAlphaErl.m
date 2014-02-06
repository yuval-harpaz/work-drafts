
fileName = 'c,rfhp0.1Hz';
% cd /home/yuval/Data/Erlangen
% load subs
% for subi=1:length(subs)
%     try
%         cd /home/yuval/Data/Erlangen
%         cd(subs{subi})
%         cd 1
hdr=ft_read_header(fileName);
sRate=hdr.Fs;
samp1=round(sRate*3);
samp1Last=samp1+60*sRate;

% cleanData=LFcleanNoCue(fileName,sRate,'time','ADAPTIVE',50);
cleanData=LFcleanNoCue([],[],[],'ADAPTIVE',50);
%cleanData=LFcleanNoCue([],[],[],'GLOBAL',50);

rewrite_pdf(cleanData,[],[],'lf')
clear cleanData
cleanData=correctHB(['lf_',fileName]);

rewrite_pdf(cleanData,[],[],'lf,hb')
clear cleanData
cfn=['lf,hb_',fileName];



epoched=samp1+round(sRate):round(sRate):samp1Last;

cfg=[];
cfg.dataset=cfn;
cfg.trl=epoched';
cfg.trl(:,2)=cfg.trl+1017;
cfg.trl(:,3)=0;
cfg.channel='MEG';
cfg.blc='yes';
cfg.feedback='no';
meg=ft_preprocessing(cfg);
cfg=[];
cfg.method='var';
cfg.criterion='sd';
cfg.critval=3;
good=badTrials(cfg,meg,0);
cfg=[];
cfg.trials=good;
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = [3 6 9 10 11 12 15 20 25 30 40 50 60 70 80 90 100];
cfg.feedback='no';
%cfg.keeptrials='yes';
megFr = ft_freqanalysis(cfg, meg);
[~,maxch]=max(mean(megFr.powspctrm(:,:),2));
maxchans=megFr.label(maxch);
save meg meg
save good good
save megFr megFr
% 
%     end
%     
% end
% 
% strCl='cfg';
% strOp='cfg';
% for subi=1:length(subs)
%     cd /media/YuvalExtDrive/alpha/AviBP
%     cd(subs{subi})
%     load open
%     eval(['open_',num2str(subi),'=megFr']);
%     strOp=[strOp,',open_',num2str(subi)];
%     load closed
%     eval(['cl_',num2str(subi),'=megFr']);
%     strCl=[strCl,',cl_',num2str(subi)];
%     
% end
% cfg=[];
% cfg.keepindividual = 'yes';
% cfg.channel={'MEG','-A74','-A204'};
% eval(['Open=ft_freqgrandaverage(',strOp,');'])
% eval(['Closed=ft_freqgrandaverage(',strCl,');'])
% save /home/yuval/Copy/MEGdata/AviBP/Open Open
% save /home/yuval/Copy/MEGdata/AviBP/Closed Closed
% save /home/yuval/Copy/MEGdata/AviBP/subs subs
% 
% % AviMa
% cd /media/YuvalExtDrive/alpha/AviMa
% load subs
% load startSec
% 
% for subi=[1 4:17]%1:length(subs)
%     try
%         cd /media/YuvalExtDrive/alpha/AviMa
%         cd(subs{subi})
%         if exist('1','dir')
%             cd 1
%         else
%             cd 2
%         end
%         
%         fileName = 'c,rfhp0.1Hz';
%         trig=readTrig_BIU(fileName);
%         trig=clearTrig(trig);
%         close;
%         samp1=round(startSec(subi)*1017.25);
%         startTrigs=find(trig,1);
%         if isempty(startTrigs)
%             warning(['no trigs for ',subs{subi}])
%         elseif startTrigs<(samp1+60*1017.25)
%             error('early triggers');
%         end
%         p=pdf4D(fileName);
%         cleanCoefs = createCleanFile(p, fileName,...
%             'byLF',256 ,'Method','Adaptive',...
%             'xClean',[4,5,6],...
%             'byFFT',0,...
%             'HeartBeat',[],... % use [] for automatic HB cleaning, use 0 to avoid HB cleaning
%             'maskTrigBits', 512);
%         cfn=ls ('*lf*');
%         cfn=cfn(1:end-1);
%         
%         epoched=samp1+1017:1017:samp1+60*1017.25;
%         cfg=[];
%         cfg.dataset=cfn;
%         cfg.trl=epoched';
%         cfg.trl(:,2)=cfg.trl+1017;
%         cfg.trl(:,3)=0;
%         cfg.channel='MEG';
%         cfg.blc='yes';
%         cfg.feedback='no';
%         meg=ft_preprocessing(cfg);
%         cfg=[];
%         cfg.method='var';
%         cfg.criterion='sd';
%         cfg.critval=3;
%         good=badTrials(cfg,meg,0);
%         cfg=[];
%         cfg.trials=good;
%         cfg.output       = 'pow';
%         cfg.method       = 'mtmfft';
%         cfg.taper        = 'hanning';
%         cfg.foi          = [3 6 9 10 11 12 15 20 25 30 40 50 60 70 80 90 100];
%         cfg.feedback='no';
%         %cfg.keeptrials='yes';
%         megFr = ft_freqanalysis(cfg, meg);
%         [~,maxch]=max(mean(megFr.powspctrm(:,:),2));
%         maxchans=megFr.label(maxch);
%         cd ..
%         save open megFr meg maxchans
%     end
% end
% 
% 
% strOp='cfg';
% for subi=1:length(subs)
%     cd /media/YuvalExtDrive/alpha/AviMa
%     cd(subs{subi})
%     load open
%     eval(['open_',num2str(subi),'=megFr']);
%     strOp=[strOp,',open_',num2str(subi)];
% end
% cfg=[];
% cfg.keepindividual = 'yes';
% % cfg.channel={'MEG','-A74','-A204'};
% eval(['Open=ft_freqgrandaverage(',strOp,');'])
% save /home/yuval/Copy/MEGdata/AviMa/Open Open
% save /home/yuval/Copy/MEGdata/AviMa/subs subs
% 
% 
% % Hyp
% cd /media/YuvalExtDrive/alpha/Hyp
% load subs
% 
% 
% for subi=3:7
%     try
%         cd /media/YuvalExtDrive/alpha/Hyp
%         cd(subs{subi})
%         fileName = 'c,rfhp0.1Hz';
%         trig=readTrig_BIU(fileName);
%         trig=clearTrig(trig);
%         close;
%         samp1=2*1017+1;
%         p=pdf4D(fileName);
%         cleanCoefs = createCleanFile(p, fileName,...
%             'byLF',[] ,'Method','Adaptive',...
%             'xClean',[4,5,6],...
%             'byFFT',0,...
%             'HeartBeat',[],... % use [] for automatic HB cleaning, use 0 to avoid HB cleaning
%             'maskTrigBits', 512);
%         cfn=ls ('*lf*');
%         cfn=cfn(1:end-1);
%         
%         epoched=samp1+1017:1017:samp1+60*1017.25;
%         cfg=[];
%         cfg.dataset=cfn;
%         cfg.trl=epoched';
%         cfg.trl(:,2)=cfg.trl+1017;
%         cfg.trl(:,3)=0;
%         cfg.channel='MEG';
%         cfg.blc='yes';
%         cfg.feedback='no';
%         meg=ft_preprocessing(cfg);
%         cfg=[];
%         cfg.method='var';
%         cfg.criterion='sd';
%         cfg.critval=3;
%         good=badTrials(cfg,meg,0);
%         cfg=[];
%         cfg.trials=good;
%         cfg.output       = 'pow';
%         cfg.method       = 'mtmfft';
%         cfg.taper        = 'hanning';
%         cfg.foi          = [3 6 9 10 11 12 15 20 25 30 40 50 60 70 80 90 100];
%         cfg.feedback='no';
%         %cfg.keeptrials='yes';
%         megFr = ft_freqanalysis(cfg, meg);
%         [~,maxch]=max(mean(megFr.powspctrm(:,:),2));
%         maxchans=megFr.label(maxch);
%         
%         save close megFr meg maxchans
%     end
% end
% 
% 
% str='cfg';
% for subi=1:length(subs)
%     cd /media/YuvalExtDrive/alpha/Hyp
%     cd(subs{subi})
%     load close
%     eval(['close_',num2str(subi),'=megFr']);
%     str=[str,',close_',num2str(subi)];
% end
% cfg=[];
% cfg.keepindividual = 'yes';
% % cfg.channel={'MEG','-A74','-A204'};
% mkdir /home/yuval/Copy/MEGdata/Hyp
% eval(['Close=ft_freqgrandaverage(',str,');'])
% save /home/yuval/Copy/MEGdata/Hyp/Close Close
% save /home/yuval/Copy/MEGdata/Hyp/subs subs
% 
