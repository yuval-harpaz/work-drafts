cd /home/yuval/Data/VSnorm/somsens
load somsensCln

% 104 = right index finger
s0=nearest(somsensCln.time{1,1},0);


Trig2mark('All',(somsensCln.sampleinfo(:,1)+s0)/1017.25,...
    'Right',(somsensCln.sampleinfo(find(somsensCln.trialinfo==104),1)+s0)/1017.25,...
    'Left',(somsensCln.sampleinfo(find(somsensCln.trialinfo==102),1)+s0)/1017.25)
cd ..
createPARAM('somsens','SPM','All',[0.03 0.07],[],[],[3 40],[-0.1 0.5],'Pseudo-Z',0.5,'MultiSphere','Power',[40 110]);
!SAMcov64 -d xc,lf,hb_c,rfhp0.1Hz -r somsens -m somsens -v
!SAMwts64 -d xc,lf,hb_c,rfhp0.1Hz -r somsens -m somsens -c Alla -v   
!SAMwts64 -d xc,lf,hb_c,rfhp0.1Hz -r somsens -m somsens -c Noise -v
%% load data
cd /home/yuval/Data/VSnorm/somsens
load somsensCln
[SAMHeader, ~, ActWgts]=readWeights('SAM/somsens,3-40Hz,Alla.wts');
%% 1 norm by weights MS
[vs , factor, prefix] = inbal_VS_normalization(1, ActWgts, somsensCln, [-0.1 0],'/home/yuval/Data/VSnorm/somsens/SAM/somsens,3-40Hz');
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=prefix(1:end-1);
cfg.torig=-100;
cfg.TR=1/1.017;
VS2Brik(cfg,vs);
%% 2 divide by baseline 
[vs , factor, prefix] = inbal_VS_normalization1(2, ActWgts, somsensCln, [-0.1 0],'/home/yuval/Data/VSnorm/somsens/SAM/somsens,3-40Hz');
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=prefix(1:end-1);
cfg.torig=-100;
cfg.TR=1/1.017;
VS2Brik(cfg,vs);

%% 3 divide by z score of raw data
[vs , factor, prefix] = inbal_VS_normalization1(3, ActWgts, somsensCln, [-0.1 0],'/home/yuval/Data/VSnorm/somsens/SAM/somsens,3-40Hz');
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=prefix(1:end-1);
cfg.torig=-100;
cfg.TR=1/1.017;
VS2Brik(cfg,vs);

%% 4 SNR : signal based on data cov / signal based on Noise cov
[vs , factor, prefix] = inbal_VS_normalization1(4, ActWgts, somsensCln, [-0.1 0],'/home/yuval/Data/VSnorm/somsens/SAM/somsens,3-40Hz');
vsMax=max(max(abs(vs)));
vs=vs./vsMax;
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=prefix(1:end-1);
cfg.torig=-100;
cfg.TR=1/1.017;
VS2Brik(cfg,vs);

%% 5 norm by weights Abs
[vs , factor, prefix] = inbal_VS_normalization1(5, ActWgts, somsensCln, [-0.1 0],'/home/yuval/Data/VSnorm/somsens/SAM/somsens,3-40Hz');
vsMax=max(max(abs(vs)));
vs=vs./vsMax;
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=prefix(1:end-1);
cfg.torig=-100;
cfg.TR=1/1.017;
VS2Brik(cfg,vs);

%% 6 SAMerf SNR

[vs , factor, prefix] = inbal_VS_normalization1(6, ActWgts, somsensCln, [-0.1 0],'/home/yuval/Data/VSnorm/somsens/SAM/somsens,3-40Hz');
vsMax=max(max(abs(vs)));
vs=vs./vsMax;
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=prefix(1:end-1);
cfg.torig=-100;
cfg.TR=1/1.017;
VS2Brik(cfg,vs);



%% 7 Z + SAMerf

[vs , factor, prefix] = inbal_VS_normalization1(7, ActWgts, somsensCln, [-0.1 0],'/home/yuval/Data/VSnorm/somsens/SAM/somsens,3-40Hz');
% vsMax=max(max(abs(vs)));
% vs=vs./vsMax;
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=prefix(1:end-1);
cfg.torig=-100;
cfg.TR=1/1.017;
VS2Brik(cfg,vs);

%% 8 SAMspm

[vs , factor, prefix] = inbal_VS_normalization1(8, ActWgts, somsensCln, [-0.1 0],'/home/yuval/Data/VSnorm/somsens/SAM/somsens,3-40Hz');
% vsMax=max(max(abs(vs)));
% vs=vs./vsMax;
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=prefix(1:end-1);
cfg.torig=-100;
cfg.TR=1/1.017;
VS2Brik(cfg,vs);

%% 9 Weights based on noise cov

[vs , factor, prefix] = inbal_VS_normalization1(9, ActWgts, somsensCln, [-0.1 0],'/home/yuval/Data/VSnorm/somsens/SAM/somsens,3-40Hz');
% vsMax=max(max(abs(vs)));
% vs=vs./vsMax;
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=prefix(1:end-1);
cfg.torig=-100;
cfg.TR=1/1.017;
VS2Brik(cfg,vs);