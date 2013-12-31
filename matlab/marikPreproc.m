function avg=marikPreproc(path2file,trig)
% path2file='/home/yuval/Data/marik/4fingers/1'

% cleaning HeartBeat, Power Line and Building Vibrations
cd (path2file)
fileName = 'c,rfhp0.1Hz';
if ~exist(['xc,hb,lf_',fileName])
    p=pdf4D(fileName);
    cleanCoefs = createCleanFile(p, fileName,...
        'byLF',256 ,'Method','Adaptive',...
        'xClean',[4,5,6],...
        'byFFT',0,...
        'HeartBeat',[],...
        'maskTrigBits', 512);
end

trg=readTrig_BIU('xc,hb,lf_c,rfhp0.1Hz');
tr=clearTrig(trg);
trialSamp=find(tr==trig);
blSamp=round(-1017.25*0.2);
endSamp=round(1017.25*0.4);
trl=trialSamp'+blSamp;
trl(:,2)=trialSamp'+endSamp;
trl(:,3)=blSamp;
cfg=[];
cfg.trl=trl;
cfg.dataset='xc,hb,lf_c,rfhp0.1Hz';
cfg.demean='yes';
cfg.channel='MEG';
cfg.blcwindow=[-0.2 0];
data=ft_preprocessing(cfg);


avg=ft_timelockanalysis([],data);

cfg=[];
cfg.xlim=[0.05 0.05];
cfg.layout='4D248.lay';
cfg.interactive='yes';
ft_topoplotER(cfg,avg);