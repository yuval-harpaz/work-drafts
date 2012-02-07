% first step - open: home>meg>ducoments>MATLAB>MatlabTools>C50Hz2msi.m
% or open "cleanFilemaor.m" from home\meg\Documents\MATLAB folder (for this you need to use MATLAB 10)
% Replace the path or the name to your file and run it.

subnum = 14; %change

orig = ['save ','ma',num2str(subnum),'orig', ' dataorig'];
clean = ['save ','ma',num2str(subnum),'cln', ' datacln'];
ica = ['save ','ma',num2str(subnum),'ica', ' dataica'];

%% defining trials in all the data.
cfg=[];
cfg.dataset='xc,hb,lf_c,rfhp1.0Hz'; % change file name or path+name
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.eventvalue=[10,20,30,40]; % all conditions. 10 -CM; 20 -LIT; 30 -NM; 40 -UR.
cfg.trialdef.prestim=0.2;
cfg.trialdef.poststim=0.8;
cfg.trialdef.offset=-0.2;
cfg.trialdef.rspwin = 2.5;
cfg.trialdef.visualtrig='visafter'; 
cfg.trialdef.visualtrigwin=0.3;
cfg.trialdef.powerline='yes'; % takes into account triggers that contain the electricity in the wall (+256).
cfg.trialfun='BIUtrialfun';
cfg=definetrial(cfg);

% creating colume 7 with correct code
for i=1:length(cfg.trl)
	if ((cfg.trl(i,4)==10) && (cfg.trl(i,6)==256)) cfg.trl(i,7)=1; end;
	if ((cfg.trl(i,4)==20) && (cfg.trl(i,6)==256)) cfg.trl(i,7)=1; end;
	if ((cfg.trl(i,4)==30) && (cfg.trl(i,6)==256)) cfg.trl(i,7)=1; end;
	if ((cfg.trl(i,4)==40) && (cfg.trl(i,6)==512)) cfg.trl(i,7)=1; end;
end; %for					

findBadChans('c,rfhp1.0Hz');
cfg.channel={'MEG','-A74','-A204'}; % change to bad channels' names

%% reading high frequencies to find muscle artifact
cfg.continuous='yes';
cfg.hpfilter='yes';
cfg.hpfreq=20;
cfg.blc='yes';
data=ft_preprocessing(cfg);
trialAbs=[];
for triali=1:length(data.trial)
     trialAbs(triali)=mean(mean(abs(data.trial{1,triali})));
end

%finding trials with sd > 3
sd=std(trialAbs);
good=find(trialAbs<median(trialAbs)+sd*3);
badn=num2str(length(trialAbs)-length(good));
display(['rejected ',badn,' trials']);
find(trialAbs>median(trialAbs)+sd*3)
trl=data.cfg.trl(good,:); % ans = which trials were rejected

cfg.trl=trl;
cfg=rmfield(cfg,'hpfilter');
cfg=rmfield(cfg,'hpfreq');
cfg.blcwindow=[-0.2,0];
cfg.bpfilter='yes'; % or cfg.lpfilter='yes';
cfg.bpfreq=[1 50]; % or cfg.lpfreq=50;

%%  reading data after artifact rejection and compute power spectrum
dataorig=ft_preprocessing(cfg);
eval(orig); 

%% ICA to correct data

%resampling data to speed the ica
cfg            = [];
cfg.resamplefs = 300;
cfg.detrend    = 'no';
dummy           = resampledata(cfg, dataorig);

%run ica (This stage takes half an hour or more!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)
cfg            = [];
cfg.channel    = {'MEG'};
comp           = ft_componentanalysis(cfg, dummy);


%see the components and find the artifact
cfg=[];
cfg.comp=[1:5];
cfg.layout='4D248.lay';
comppic=componentbrowser(cfg,comp);
saveas(gcf, ['comppicsub',num2str(subnum)], 'fig');
close all

% find bad component and trials
figure;
cmp=findBlinkComp(comp); % change to eye blink's component number
title(['comp' ,num2str(cmp),' - sub',num2str(subnum)]);
saveas(gcf, ['blinkcompSub',num2str(subnum)], 'fig');
close all

trlScore=[];
for triali=1:length(comp.trial)
    trlScore(triali,1)=max(comp.trial{1,triali}(cmp,:));
end

bad=find(trlScore>3*min(trlScore));

%run the ICA in the original data
cfg = [];
cfg.topo      = comp.topo;
cfg.topolabel = comp.topolabel;
comp_orig     = ft_componentanalysis(cfg, dataorig);
%comp_bad=comp_orig;
%comp_bad.trial=comp_orig.trial(1,bad);
%remove the artifact component
cfg = [];
cfg.component = cmp; 
dataica_bad = ft_rejectcomponent(cfg, comp_orig);
dataica_bad=correctBL(dataica_bad,[-0.2,0]);
dataica=dataorig;
dataica.trial(1,bad)=dataica_bad.trial(1,bad);

eval(ica);
%--------------------------
%trialAbs=[];
%for triali=1:length(dataica.trial)
%     trial=dataica.trial{1,triali};
%     m=mean(trial');m=m';
%     mmat=ones(size(trial));
%	for i=1:length(trial)
%		mmat(:,i)=m;
%	end;
%     trial=trial-mmat;
%     trialAbs(triali)=mean(mean(abs(trial)));
%end;

%finding trials with sd > 3
%sd=std(trialAbs);
%good=find(trialAbs<median(trialAbs)+sd*3);
%badn=num2str(length(trialAbs)-length(good));
%display(['rejected ',badn,' trials']);
%find(trialAbs>median(trialAbs)+sd*3)


%-----------------------------------------
%rejectvisual summary
%cfg=[];
%cfg.method='summary';
%cfg.channel='MEG';
%cfg.alim=1e-12;
%datacln=rejectvisual(cfg, dataica); % reject all bad trials/channels manually

%rejectvisual trial
%cfg=[];
%cfg.method='trial';
%cfg.channel='MEG';
%cfg.alim=1e-12;
%datacln=rejectvisual(cfg, datacln); % reject all bad trials/channels manually. Don't forget to reject channel 204

% save only after choosing the trials/channels manually
%eval(clean);
 

%% base line correction
%dataica=correctBL(dataica,[-0.2 0]);
%% retrive the trls
%dataica.cfg.trl=reindex(dataica.cfg.previous.previous.previous.previous.trl,dataica.cfg.previous.previous.trl) % change number of previous if necessary.

%% defining trials (for correct answers only)
% define
cfg=[];
cfg.cond=10;
cond10=splitcondscrt(cfg,dataica);
cfg=[];
cfg.cond=20;
cond20=splitcondscrt(cfg,dataica);
cfg=[];
cfg.cond=30;
cond30=splitcondscrt(cfg,dataica);
cfg=[];
cfg.cond=40;
cond40=splitcondscrt(cfg,dataica);
% for the NM mistakes
cfg=[];                          
cfg.cond=30;
cond30mstk=splitcondmstk(cfg,dataica);
% average
cfg=[]            
eval(['sub',num2str(subnum),'avg=ft_timelockanalysis(cfg,dataica)']);
eval(['sub',num2str(subnum),'avcond10=ft_timelockanalysis(cfg,cond10)']);
eval(['sub',num2str(subnum),'avcond20=ft_timelockanalysis(cfg,cond20)']);
eval(['sub',num2str(subnum),'avcond30=ft_timelockanalysis(cfg,cond30)']);
eval(['sub',num2str(subnum),'avcond40=ft_timelockanalysis(cfg,cond40)']);
eval(['sub',num2str(subnum),'avcond30mstk=ft_timelockanalysis(cfg,cond30mstk)']);

save(['sub',num2str(subnum),'avconds'], ['sub',num2str(subnum),'avg'], ['sub',num2str(subnum),'avcond10'], ['sub',num2str(subnum),'avcond20'], ['sub',num2str(subnum),'avcond30'], ['sub',num2str(subnum),'avcond40'], ['sub',num2str(subnum),'avcond30mstk'])
--------------------------------------------------------------------------------------------------
% butterfly
cfg=[];
cfg.showlabels='yes';
cfg.fontsize=10;
cfg.layout='butterfly';
eval(['ft_multiplotER(cfg, sub',num2str(subnum),'avg)']);

figure;
eval(['ft_multiplotER(cfg, sub',num2str(subnum),'avcond10, sub',num2str(subnum),'avcond20, sub',num2str(subnum),'avcond30, sub',num2str(subnum),'avcond40)']);

% interactive plot multi conditions
-----------------------------------
cfg=[];
cfg.interactive='yes';
cfg.showlabels='yes';
cfg.fontsize=10;
cfg.layout='4D248.lay';
multiplotER(cfg,sub3avcond10,sub3avcond20,sub3avcond30,sub3avcond40);

% interactive plot single condition
multiplotER(cfg,sub3avcond10);
% interactive plot single condition
multiplotER(cfg,sub3avcond20);
% interactive plot single condition
multiplotER(cfg,sub3avcond30);
% interactive plot single condition
multiplotER(cfg,sub3avcond40);

% topoplot
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[0.3:0.05:0.5]; % from 600ms to 800ms in 50ms interval
cfg.colorbar='yes';
% cfg.electrodes='numbers'; % Shows channel's numbers
topoplotER(cfg,sub3avcond10); % avcond10/20/30/40 or avallcond

---------------------------------------------------------------------------------------------------
% creating planar grad for one subject
sub3avcond10.grad=dataorig.grad;
sub3avcond20.grad=dataorig.grad;
sub3avcond30.grad=dataorig.grad;
sub3avcond40.grad=dataorig.grad;
cfg=[];
cfg.neighbourdist=0.04;
cfg.planarmethod='sincos';
sub3avcond10p=megplanar(cfg, sub3avcond10);
sub3avcond20p=megplanar(cfg, sub3avcond20);
sub3avcond30p=megplanar(cfg, sub3avcond30);
sub3avcond40p=megplanar(cfg, sub3avcond40);
sub3avcond10p=timelockanalysis(cfg, sub3avcond10p);
sub3avcond20p=timelockanalysis(cfg, sub3avcond20p);
sub3avcond30p=timelockanalysis(cfg, sub3avcond30p);
sub3avcond40p=timelockanalysis(cfg, sub3avcond40p);
sub3avcond10cp=combineplanar(cfg, sub3avcond10p);
sub3avcond20cp=combineplanar(cfg, sub3avcond20p);
sub3avcond30cp=combineplanar(cfg, sub3avcond30p);
sub3avcond40cp=combineplanar(cfg, sub3avcond40p);

save sub3planarGrad sub3avcond10cp sub3avcond20cp sub3avcond30cp sub3avcond40cp

% butterfly
cfg=[];
cfg.showlabels='yes';
cfg.fontsize=10;
cfg.layout='butterfly';
ft_multiplotER(cfg, sub3avcond10cp, sub3avcond20cp, sub3avcond30cp, sub3avcond40cp);

%% Planar grad for grand average
% grcond10.grad=dataorig.grad;
% grcond10.trial(1,:,:)=grcond10.avg;
% cfg=[];
% cfg.planarmethod ='sincos';
% grcond10.dimord='chan_time';
% grcond10p=megplanar(cfg, grcond10);
% grcond10p=timelockanalysis(cfg, grcond10p);
% grcond10cp=combineplanar(cfg, grcond10p);
------------------------------------------------------------------------------------------------------------------------------------------------
% Preparation for statistics
----------------------------
cfg = [];
cfg.keepindividual = 'yes';
[grcond10] =  timelockgrandaverage(cfg, sub3avcond10, sub14avcond10, sub15avcond10, sub16avcond10, sub17avcond10, sub18avcond10, sub19avcond10, sub30avcond10, sub31avcond10, sub33avcond10, sub34avcond10, sub35avcond10, sub36avcond10, sub37avcond10, sub38avcond10, sub39avcond10);
[grcond20] =  timelockgrandaverage(cfg, sub3avcond20, sub14avcond20, sub15avcond20, sub16avcond20, sub17avcond20, sub18avcond20, sub19avcond20, sub30avcond20, sub31avcond20, sub33avcond20, sub34avcond20, sub35avcond20, sub36avcond20, sub37avcond20, sub38avcond20, sub39avcond20);
[grcond30] =  timelockgrandaverage(cfg, sub3avcond30, sub14avcond30, sub15avcond30, sub16avcond30, sub17avcond30, sub18avcond30, sub19avcond30, sub30avcond30, sub31avcond30, sub33avcond30, sub34avcond30, sub35avcond30, sub36avcond30, sub37avcond30, sub38avcond30, sub39avcond30);
[grcond40] =  timelockgrandaverage(cfg, sub3avcond40, sub14avcond40, sub15avcond40, sub16avcond40, sub17avcond40, sub18avcond40, sub19avcond40, sub30avcond40, sub31avcond40, sub33avcond40, sub34avcond40, sub35avcond40, sub36avcond40, sub37avcond40, sub38avcond40, sub39avcond40);

% interactive plot multi conditions for all subjects
cfg=[];
cfg.interactive='yes';
cfg.showlabels='yes';
cfg.fontsize=10;
cfg.layout='4D248.lay';
multiplotER(cfg,grcond10,grcond20,grcond30,grcond40);

% interactive plot single condition for all subjects
cfg=[];
cfg.interactive='yes';
cfg.showlabels='yes';
cfg.fontsize=10;
cfg.colorbar='yes';
cfg.layout='4D248.lay';
multiplotER(cfg,grcond30);

% Butterfly plot
cfg=[];
cfg.layout='butterfly';
multiplotER(cfg,grcond10,grcond20,grcond30,grcond40);

% Topoplot
cfg=[];
min=0.350; max=0.450;
cfg.layout='4D248.lay';
cfg.xlim=[min max];
%cfg.colorbar='yes';
%cfg.electrodes='labels';% or 'numbers';
subplot(1,2,1);
title(['NM ' ,num2str(min),'-',num2str(max)]);
topoplotER(cfg,grcond30);
subplot(1,2,2);
title(['LIT ' ,num2str(min),'-',num2str(max)]);
topoplotER(cfg,grcond20);

% Preparation for statistics: Planar grad
%----------------------------
cfg = [];
cfg.keepindividual = 'yes';
[grcond10cp] =  timelockgrandaverage(cfg, sub3avcond10cp, sub14avcond10cp, sub15avcond10cp, sub16avcond10cp, sub17avcond10cp, sub18avcond10cp, sub19avcond10cp, sub30avcond10cp, sub31avcond10cp, sub33avcond10cp, sub34avcond10cp, sub35avcond10cp, sub36avcond10cp, sub37avcond10cp, sub38avcond10cp, sub39avcond10cp);
[grcond20cp] =  timelockgrandaverage(cfg, sub3avcond20cp, sub14avcond20cp, sub15avcond20cp, sub16avcond20cp, sub17avcond20cp, sub18avcond20cp, sub19avcond20cp, sub30avcond20cp, sub31avcond20cp, sub33avcond20cp, sub34avcond20cp, sub35avcond20cp, sub36avcond20cp, sub37avcond20cp, sub38avcond20cp, sub39avcond20cp);
[grcond30cp] =  timelockgrandaverage(cfg, sub3avcond30cp, sub14avcond30cp, sub15avcond30cp, sub16avcond30cp, sub17avcond30cp, sub18avcond30cp, sub19avcond30cp, sub30avcond30cp, sub31avcond30cp, sub33avcond30cp, sub34avcond30cp, sub35avcond30cp, sub36avcond30cp, sub37avcond30cp, sub38avcond30cp, sub39avcond30cp);
[grcond40cp] =  timelockgrandaverage(cfg, sub3avcond40cp, sub14avcond40cp, sub15avcond40cp, sub16avcond40cp, sub17avcond40cp, sub18avcond40cp, sub19avcond40cp, sub30avcond40cp, sub31avcond40cp, sub33avcond40cp, sub34avcond40cp, sub35avcond40cp, sub36avcond40cp, sub37avcond40cp, sub38avcond40cp, sub39avcond40cp);

% interactive plot multi conditions for all subjects
cfg=[];
cfg.interactive='yes';
cfg.showlabels='yes';
cfg.fontsize=10;
cfg.layout='4D248.lay';
multiplotER(cfg,grcond10cp,grcond20cp,grcond30cp,grcond40cp);

% interactive plot single condition for all subjects
cfg=[];
cfg.interactive='yes';
cfg.showlabels='yes';
cfg.fontsize=10;
cfg.colorbar='yes';
cfg.layout='4D248.lay';
multiplotER(cfg,grcond30cp);

% Butterfly plot
cfg=[];
cfg.layout='butterfly';
multiplotER(cfg,grcond10cp,grcond20cp,grcond30cp,grcond40cp);

% Topoplot planar grad
cfg=[];
min=0.370; max=0.470;
cfg.layout='4D248.lay';
cfg.xlim=[min max];
cfg.colorbar='yes';
%cfg.electrodes='labels';% or 'numbers';
figure;
title(['UR' , num2str(min),'-',num2str(max), ' planar gradiometer']);
topoplotER(cfg,grcond40cp);


% Topoplot planar grad with significant channels - compar conditions
cfg=[];
min=0.45; max=0.65;
cfg.layout='4D248.lay';
cfg.xlim=[min max];
cfg.highlight=find(sig(:,1));%for highlighting the channels that were significent in the statistics
subplot(2,2,1);
title(['LIT ', num2str(min),'-',num2str(max), ' planar gradiometer']);
topoplotER(cfg,grcond10cp);
subplot(2,2,2);
title(['CM ', num2str(min),'-',num2str(max), ' planar gradiometer']);
topoplotER(cfg,grcond20cp);
subplot(2,2,3);
title(['NM ', num2str(min),'-',num2str(max), ' planar gradiometer']);
topoplotER(cfg,grcond30cp);
subplot(2,2,4);
title(['UR ', num2str(min),'-',num2str(max), ' planar gradiometer']);
topoplotER(cfg,grcond40cp);
--------------------------------------
% making a movie for component no.4 (all conditions)
--------------------------------------
cfg=[];
gr10=grcond10cp;
gr20=grcond20cp;
gr30=grcond30cp;
gr40=grcond40cp;
cfg.layout='4D248.lay';
cfg.zparam='avg';
gr10.dimord='chan_time';
gr20.dimord='chan_time';
gr30.dimord='chan_time';
gr40.dimord='chan_time';
cfg.xlim = [0 0];
cfg.zlim = [0 10*10^(-11)]
figure;

for j = 1:140; % acording to the time window of the statistics
    gr10.avg=(grcond10cp.avg(:,j+489));
    gr20.avg=(grcond20cp.avg(:,j+489));
    gr30.avg=(grcond30cp.avg(:,j+489));
    gr40.avg=(grcond40cp.avg(:,j+489));
    subplot(2,2,1);
    title('LIT');
    topoplotER(cfg,gr10);
    subplot(2,2,2);
    title('CM');
    topoplotER(cfg,gr20);
    subplot(2,2,3);
    title('NM');
    topoplotER(cfg,gr30);
    subplot(2,2,4);
    title('UR');
    topoplotER(cfg,gr40);
    comp4(j) = getframe(gcf);
end
% showing the movie
implay(comp4)

% comparisons movie
-------------------------------------------------------------------------------
grcond20_10cp=grcond20cp;
grcond20_10cp.avg=grcond20cp.avg-grcond10cp.avg;
grcond30_10cp=grcond30cp;
grcond30_10cp.avg=grcond30cp.avg-grcond10cp.avg;
grcond40_10cp=grcond40cp;
grcond40_10cp.avg=grcond40cp.avg-grcond10cp.avg;
grcond30_20cp=grcond30cp;
grcond30_20cp.avg=grcond30cp.avg-grcond20cp.avg;
grcond30_40cp=grcond30cp;
grcond30_40cp.avg=grcond30cp.avg-grcond40cp.avg;
grcond40_20cp=grcond40cp;
grcond40_20cp.avg=grcond40cp.avg-grcond20cp.avg;

cfg=[];
gr20_10=grcond20_10cp;
gr30_10=grcond30_10cp;
gr40_10=grcond40_10cp;
gr30_20=grcond30_10cp;
gr30_40=grcond30_40cp;
gr40_20=grcond40_20cp;
cfg.layout='4D248.lay';
cfg.zparam='avg';
gr20_10.dimord='chan_time';
gr30_10.dimord='chan_time';
gr40_10.dimord='chan_time';
gr30_20.dimord='chan_time';
gr30_40.dimord='chan_time';
gr40_20.dimord='chan_time';
cfg.xlim = [0 0];
figure;
for j = 1:200; % acording to the time window of the statistics
gr20_10.avg=(grcond20_10cp.avg(:,j+300));
gr30_10.avg=(grcond30_10cp.avg(:,j+300));
gr40_10.avg=(grcond40_10cp.avg(:,j+300));
gr30_20.avg=(grcond30_20cp.avg(:,j+300));
gr30_40.avg=(grcond30_40cp.avg(:,j+300));
gr40_20.avg=(grcond40_20cp.avg(:,j+300));
subplot(2,3,1);
title('CM-LIT');
cfg.colorbar='yes';
topoplotER(cfg,gr20_10);
subplot(2,3,2);
title('NM-LIT');
cfg.colorbar='yes';
topoplotER(cfg,gr30_10);
subplot(2,3,3);
title('UR-LIT');
cfg.colorbar='yes';
topoplotER(cfg,gr40_10);
subplot(2,3,4);
title('NM-CM');
cfg.colorbar='yes';
topoplotER(cfg,gr30_20);
subplot(2,3,5);
title('NM-UR');
cfg.colorbar='yes';
topoplotER(cfg,gr30_40);
subplot(2,3,6);
title('UR-CM');
cfg.colorbar='yes';
topoplotER(cfg,gr40_20);
comp100_300(j) = getframe(gcf);
end

implay(comp100_300);
-------------------------------------------------------------------------------------------------
% Clusters Analysis for one subject
-----------------------------------
cfg=[];
cfg.keeptrials = 'yes';
avcond10=timelockanalysis(cfg,cond10);
avcond10=rmfield(avcond10, 'dof');
avcond20=timelockanalysis(cfg,cond20);
avcond20=rmfield(avcond20, 'dof');
avcond30=timelockanalysis(cfg,cond30);
avcond30=rmfield(avcond30, 'dof');
avcond40=timelockanalysis(cfg,cond40);
avcond40=rmfield(avcond40, 'dof');

cfg = [];
cfg.channel = {'MEG'};
cfg.latency = [0.4 1]; % [0 1];
cfg.grad=dataorig.grad
cfg.method = 'montecarlo';
cfg.statistic = 'indepsamplesT';
cfg.correctm = 'cluster';
cfg.clusteralpha = 0.1;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan = 2;
cfg.tail = 0;
cfg.clustertail = 0;
cfg.alpha = 0.1;
cfg.numrandomization = 500;

design = zeros(1,size(avcond30.trial,1)+size(avcond10.trial,1));%change second avcond
design(1,1:size(avcond30.trial,1)) = 1;
design(1,(size(avcond30.trial,1)+1):(size(avcond30.trial,1)+size(avcond10.trial,1)))=2;%change last avcond
cfg.design   = design;
cfg.ivar  = 1;

[stat] = timelockstatistics(cfg, avcond30, avcond10);%change second avcond


% Plotting the results
cfg=[];
cfg.layout='4D248.lay';
clusterplot(cfg, stat);

% Time windows of significant channels
[I,J]=find(stat.negclusterslabelmat==1);
A=sort(I);
B=[];
b=1;
for i=2:length(A)-1
    B(b)=A(i);
    if A(i+1)~=A(i)
        b=b+1;
    end;
end;

Sig=B';
a=1;
for i=1:length(Sig)
    d=Sig(i);
    D=find(stat.negclusterslabelmat(d,:)==1);
    Sig(a,2)=min(D);
    Sig(a,3)=max(D);
    a=a+1;
end; 

%---------------------------------------------------------------------
% Statistics: Repeated Measurs ANOVA for a specifie time window
%---------------------------------------------------------------------
design=[];
s=16; % change to the number of subjects
design=[1:4*s; 1:s 1:s 1:s 1:s];
design(1,1:s)=1;
design(1,s+1:2*s)=2;
design(1,2*s+1:3*s)=3;
design(1,3*s+1:4*s)=4;

min=0.112; max=0.183; % no need to correct the time line!!!!!!!!!

cfg = [];
cfg.channel = 'MEG';
cfg.parameter   = 'individual';
cfg.method = 'analytic';
cfg.statistic = 'depsamplesF';
cfg.latency     = [min max]; % change!!
cfg.avgovertime = 'yes';
cfg.alpha = 0.05;
cfg.design = design;
cfg.tail = 1;
cfg.ivar = 1;
cfg.uvar = 2;

ftest=timelockstatistics(cfg,grcond10,grcond20,grcond30,grcond40);% or with "cp"
sigF=ftest.label(ftest.mask,1);

% topoplot F-test
cfg=[];
gr=grg; % load the file grg
for i=1:1017
  grg.avg(:,i)=ftest.stat(:);
end;
cfg.layout='4D248.lay';
cfg.zparam='avg';
gr.dimord='chan_time';
cfg.xlim = [0 0];
cfg.highlight=find((ftest.mask(:,1)));
figure;
title (['Repeated Measures ANOVA (LIT, CM, NM, UR), n=16, ' ,num2str(min),'-', num2str(max),'ms'])
ft_topoplotER(cfg,grg);

%----------------------------------------------------------------------------------------------------
% statistics: T-test for specific time window
%---------------------------------------------
cfg = [];
min=0.112; max=0.183; % no need to correct the time line!!!!
% cfg.channel = 'MEG'; % for all channels
cfg.channel = sigF; % for analyzing only the significant channels from the ANOVA 
cfg.avgovertime='yes';
cfg.latency=[min max];
cfg.parameter = 'individual';
cfg.method = 'analytic';
cfg.statistic = 'depsamplesT';
cfg.avgovertime = 'yes';
cfg.alpha = 0.05; % for 3 T-tests (NM-LIT, NM-CM, NM-UR)
s=16; %change the number of subjects
design=[1:2*s; 1:s 1:s];
design(1,1:s)=1;
design(1,s+1:2*s)=2;
cfg.design = design;
cfg.ivar = 1;
cfg.uvar = 2;
ttest = timelockstatistics(cfg,grcond30,grcond20); % for tow conditions
sigT=ttest.label(ttest.mask,1);

cfg.channel = 'MEG'
ttest4plot = timelockstatistics(cfg,grcond30,grcond20);

cfg=[];
gr=grg; % load the filr grg
for i=1:1017
  grg.avg(:,i)=ttest4plot.stat(:);
end;
cfg.layout='4D248.lay';
cfg.zparam='avg';
cfg.colorbar='yes';
gr.dimord='chan_time';
cfg.xlim = [0 0];
% cfg.highlight=find(ttest.mask(:,1)); % for all channels
sigTindex=ismember(grcond30.label,sigT);  % for only the significant channels from the ANOVA
cfg.highlight=find(sigTindex(:,1));
figure;
title(['NM-LIT: T-test, ',num2str(min),'-', num2str(max),'ms']);
ft_topoplotER(cfg,grg);

%---------------------------------------------------------------------------------------------------
% statistics: T-test
%--------------------
cfg = [];
cfg.channel = 'MEG'; % for all channels
cfg.parameter   = 'individual'; % for 1 subject, type "trial"
cfg.method = 'analytic';
cfg.statistic = 'depsamplesT';
cfg.avgovertime = 'yes';
cfg.alpha = 0.05; % for 3 T-tests (NM-LIT, NM-CM, NM-UR)?
s=16; %change the number of subjects
design=[1:2*s; 1:s 1:s];
for i=1:s
    design(1,i)=1;
    design(1,i+s)=2;
end;
cfg.design = design;
cfg.ivar = 1;
cfg.uvar = 2;

ttest = timelockstatistics(cfg,grcond30,grcond10); % for tow conditions: cond10 and cond30

cfg=[];
gr=grcond30;
gr.avg=ttest.stat;
cfg.layout='4D248.lay';
cfg.zparam='avg';
gr.dimord='chan_time';
cfg.xlim = [0 0];
cfg.highlight=find(ttest.mask(:,1)); % for all channels
figure;
title ('NM-LIT')
topoplotER(cfg,gr);


-------------------------------------------------
% making movie for statistics without avgovertime
-------------------------------------------------
% Record the movie
gr=grcond30cp;
cfg.layout='4D248.lay';
cfg.zparam='avg';
gr.dimord='chan_time';
cfg.xlim = [0 0];
cfg.zlim= [-3 3];
figure;

for j = 1:58 % acording to the time window of the statistics
    gr.avg=(stat.stat(:,j));
    cfg.highlight=find(stat.mask(:,j)==1)
    topoplotER(cfg,gr);
    F(j) = getframe;
end

% Play the movie; note that it does not fit the figure properly:
h2 = figure;
movie(h2,F)

%-------------------------------------------------
% making movie for statistics without avgovertime
%-------------------------------------------------
% Record the movie
gr=grcond30cp;
cfg.layout='4D248.lay';
cfg.zparam='avg';
gr.dimord='chan_time'; % maybe need 'subj_chan_time'
cfg.xlim = [0 0];
cfg.zlim= [0 8];
figure;

for j = 1:77 % acording to the time window of the statistics
    gr.avg=(ftest.stat(:,j));
    cfg.highlight=find(ftest.mask(:,j)==1)
    topoplotER(cfg,gr);
    F(j) = getframe;
end

% Play the movie; note that it does not fit the figure properly:
h2 = figure;
movie(h2,F)
%-----------------------------------------------------------------------------------------------------------
% rms-root mean squer for the all head for all subjects P300 component (195-295 samples)
%-------------------------------------------------------------------------
for i=13:21
  for l=1:4
    eval(['sub',num2str(i),'rmsCond',num2str(l*10),'P300=sub',num2str(i),'avcond',num2str(l*10),'.avg(:,(195+200)*1.017:(295+200)*1.107);']);
    eval(['sub',num2str(i),'rmsCond',num2str(l*10),'P300=sqrt(mean(mean(sub',num2str(i),'rmsCond',num2str(l*10),'P300.^2,1),2));']);
  end;
end;
	
for i=23:29
  for l=1:4
    eval(['sub',num2str(i),'rmsCond',num2str(l*10),'P300=sub',num2str(i),'avcond',num2str(l*10),'.avg(:,(195+200)*1.017:(295+200)*1.107);']);
    eval(['sub',num2str(i),'rmsCond',num2str(l*10),'P300=sqrt(mean(mean(sub',num2str(i),'rmsCond',num2str(l*10),'P300.^2,1),2));']);
  end;
end;

for m=1:9
  for a=1:4
    eval(['rms(m,a)=sub',num2str(m+12),'rmsCond',num2str(a*10),'P300;']);
  end;
end;

for m=10:16
  for a=1:4
    eval(['rms(m,a)=sub',num2str(m+13),'rmsCond',num2str(a*10),'P300;']);
  end;
end;

rms=rms.*10^14;
%------------------------------------------
% rms for left and right for all subjects
%------------------------------------------
left={'A6','A7','A8','A9','A10','A11','A16','A238','A237','A236','A235','A234','A233','A231','A230','A229','A219','A218','217','A216','A215','A214','A213','A212','A203','A202','A201','A200','A199','A198','A197','A196','A185','A184','A183','A182','A181','A180','A179','A178','A177','A136','A135','A134','A133','A132','A131','A130','A129','A128','A127','A126','A125','A124','A123','A122','A104','A103','A102','A101','A100','A99','A98','A97','A96','A95','A94','A93','A92','A91','A90','A74','A73','A72','A71','A70','A69','A68','A67','A66','A65','A64','A63','A62','A163','A162','A161','A160','A159','A158','A156','A155','A154','A153','A48','A47','A46','A45','A44','A43','A42','A41','A40','A39','A38','A27','A26','A25','A24','A23','A22','A21','A20'};
right={'A248','A247','A246','A245','A244','A243','A242','A241','A240','A239','A227','A226','A225','A224','A223','A221','A211','A210','A209','A208','A207','A206','A205','A194','A193','A192','A191','A190','A189','A188','A187','A176','A175','A173','A172','A171','A170','A169','A168','A167','A166','A165','A152','A151','A150','A149','A148','A144','A143','A142','A141','A140','A139','A138','A120','A119','A118','A117','A116','A112','A111','A110','A109','A108','A107','A106','A88','A87','A86','A85','A84','A81','A80','A79','A78','A77','A76','A60','A59','A58','A57','A56','A54','A53','A52','A51','A50','A36','A35','A34','A33','A32','A31','A30','A29','A18','A17','A16','A15','A14','A13'};

for i=13:21
  for j=1:4
    eval(['chans=ISMEMBER(sub',num2str(i),'avcond',num2str(j*10),'.label,left);']);
    eval(['sub',num2str(i),'cond',num2str(j*10),'left=sub',num2str(i),'avcond',num2str(j*10),'.avg(find(chans==1),:);']);
  end;
end;

for i=23:29
  for j=1:4
    eval(['chans=ISMEMBER(sub',num2str(i),'avcond',num2str(j*10),'.label,left);']);
    eval(['sub',num2str(i),'cond',num2str(j*10),'left=sub',num2str(i),'avcond',num2str(j*10),'.avg(find(chans==1),:);']);
  end;
end;

for i=13:21
  for j=1:4
    eval(['chans=ISMEMBER(sub',num2str(i),'avcond',num2str(j*10),'.label,right);']);
    eval(['sub',num2str(i),'cond',num2str(j*10),'right=sub',num2str(i),'avcond',num2str(j*10),'.avg(find(chans==1),:);']);
  end;
end;

for i=23:29
  for j=1:4
    eval(['chans=ISMEMBER(sub',num2str(i),'avcond',num2str(j*10),'.label,right);']);
    eval(['sub',num2str(i),'cond',num2str(j*10),'right=sub',num2str(i),'avcond',num2str(j*10),'.avg(find(chans==1),:);']);
  end;
end;

% create rms table to left
for i=13:21
  for l=1:4
    eval(['sub',num2str(i),'cond',num2str(l*10),'P300left=sub',num2str(i),'cond',num2str(l*10),'left(:,(195+200)*1.017:(295+200)*1.107);']);
    eval(['sub',num2str(i),'cond',num2str(l*10),'P300rmsleft=sqrt(mean(mean(sub',num2str(i),'cond',num2str(l*10),'P300left.^2,1),2));']);
  end;
end;
	
for i=23:29
  for l=1:4
    eval(['sub',num2str(i),'cond',num2str(l*10),'P300left=sub',num2str(i),'cond',num2str(l*10),'left(:,(195+200)*1.017:(295+200)*1.107);']);
    eval(['sub',num2str(i),'cond',num2str(l*10),'P300rmsleft=sqrt(mean(mean(sub',num2str(i),'cond',num2str(l*10),'P300left.^2,1),2));']);
  end;
end;

for m=1:9
  for a=1:4
    eval(['P300rmsleft(m,a)=sub',num2str(m+12),'cond',num2str(a*10),'P300rmsleft;']);
  end;
end;

for m=10:16
  for a=1:4
    eval(['P300rmsleft(m,a)=sub',num2str(m+13),'cond',num2str(a*10),'P300rmsleft;']);
  end;
end;

P300rmsleft=P300rmsleft.*10^14;

% create rms table to right
for i=13:21
  for l=1:4
    eval(['sub',num2str(i),'cond',num2str(l*10),'P300right=sub',num2str(i),'cond',num2str(l*10),'right(:,(195+200)*1.017:(295+200)*1.107);']);
    eval(['sub',num2str(i),'cond',num2str(l*10),'P300rmsright=sqrt(mean(mean(sub',num2str(i),'cond',num2str(l*10),'P300right.^2,1),2));']);
  end;
end;
	
for i=23:29
  for l=1:4
    eval(['sub',num2str(i),'cond',num2str(l*10),'P300right=sub',num2str(i),'cond',num2str(l*10),'right(:,(195+200)*1.017:(295+200)*1.107);']);
    eval(['sub',num2str(i),'cond',num2str(l*10),'P300rmsright=sqrt(mean(mean(sub',num2str(i),'cond',num2str(l*10),'P300right.^2,1),2));']);
  end;
end;

for m=1:9
  for a=1:4
    eval(['P300rmsright(m,a)=sub',num2str(m+12),'cond',num2str(a*10),'P300rmsright;']);
  end;
end;

for m=10:16
  for a=1:4
    eval(['P300rmsright(m,a)=sub',num2str(m+13),'cond',num2str(a*10),'P300rmsright;']);
  end;
end;

P300rmsright=P300rmsright.*10^14;

%____________________________________________________
% planarSum function (a backup)                      |
function [av]=planarSum(sub,comp,a,varargin)%        |
chans=ISMEMBER(sub.label,varargin);%                 |
av=sub.avg(find(chans==1),:);%                       |
comp=(comp+0.2)*1000*1.017;%  maybe doesn't need the |
mincomp=comp-(a/2);%          "+0.2" any more        |
maxcomp=comp+(a/2);%                                 |
av=av(:,mincomp:maxcomp);%                           |
av=mean(mean(av,1),2);%                              |
%____________________________________________________|
% Left vs. Right
%-------------------
%-------------------
left={'A6','A7','A8','A9','A10','A11','A16','A238','A237','A236','A235','A234','A233','A231','A230','A229','A219','A218','217','A216','A215','A214','A213','A212','A203','A202','A201','A200','A199','A198','A197','A196','A185','A184','A183','A182','A181','A180','A179','A178','A177','A136','A135','A134','A133','A132','A131','A130','A129','A128','A127','A126','A125','A124','A123','A122','A104','A103','A102','A101','A100','A99','A98','A97','A96','A95','A94','A93','A92','A91','A90','A74','A73','A72','A71','A70','A69','A68','A67','A66','A65','A64','A63','A62','A163','A162','A161','A160','A159','A158','A156','A155','A154','A153','A48','A47','A46','A45','A44','A43','A42','A41','A40','A39','A38','A27','A26','A25','A24','A23','A22','A21','A20'};
right={'A248','A247','A246','A245','A244','A243','A242','A241','A240','A239','A227','A226','A225','A224','A223','A221','A211','A210','A209','A208','A207','A206','A205','A194','A193','A192','A191','A190','A189','A188','A187','A176','A175','A173','A172','A171','A170','A169','A168','A167','A166','A165','A152','A151','A150','A149','A148','A144','A143','A142','A141','A140','A139','A138','A120','A119','A118','A117','A116','A112','A111','A110','A109','A108','A107','A106','A88','A87','A86','A85','A84','A81','A80','A79','A78','A77','A76','A60','A59','A58','A57','A56','A54','A53','A52','A51','A50','A36','A35','A34','A33','A32','A31','A30','A29','A18','A17','A16','A15','A14','A13'};

% significant channels 0.05
%--------------------------
left={'A10','A238','A233','217','A201','A136','A129','A127','A122','A104','A103','A97','A74','A155'};
right={'A243','A226','A225','A208','A194','A193','A192','A187','A173','A171','A165','A138','A117','A116','A107','A106','A88','A87','A86','A80','A76','A60','A59','A58','A57','A56','A54','A51','A50','A36','A35','A34','A29','A18','A17','A14'};

% significant channels 0.1
%--------------------------
left={'A10','A238','A233','217','A201','A136','A129','A127','A122','A104','A103','A97','A74','A155','A134','A158','A48','A90','A237','A73','A101','A97','A236','A229','A183','A132','A102','A200','A135','A27','A38','A235','A219','A11'};
right={'A243','A226','A225','A208','A194','A193','A192','A187','A173','A171','A165','A138','A117','A116','A107','A106','A88','A87','A86','A80','A205','A76','A60','A59','A58','A57','A56','A54','A51','A50','A36','A35','A34','A29','A18','A17','A14','A111','A140','A52','A81','A30','A227','A85','A189','A151','A242','A247','A13','A224','A207'};

% significant channels 0.05 - symetric 
%-------------------------------------
left={'A62','A38','A20','A6','A7','A22','A41','A21','A40','A94','A39','A64','A93','A63','A178','A179','A42','A44','A156','A158','A70','A27','A47','A48','A214','A180','A215','A199','A234','A185','A164','A10','A238','A233','217','A201','A136','A129','A127','A122','A104','A103','A97','A74','A155'};
right={'A152','A147','A174','A82','A113','A244','A206','A223','A243','A226','A225','A208','A194','A193','A192','A187','A173','A171','A165','A138','A117','A116','A107','A106','A88','A87','A86','A80','A76','A60','A59','A58','A57','A56','A54','A51','A50','A36','A35','A34','A29','A18','A17','A14'};

% significant channels 0.05 - symetric without the center
%--------------------------------------------------------
left={'A7','A22','A41','A94','A93','A178','A179','A42','A44','A156','A158','A70','A214','A180','A215','A199','A234','A185','A164','A238','A233','217','A201','A136','A129','A127','A104','A103','A97','A155'};
right={'A147','A174','A82','A113','A244','A206','A223','A243','A226','A225','A208','A194','A193','A192','A187','A173','A171','A165','A138','A117','A116','A107','A106','A80','A57','A56','A54','A34','A17'};

sub3cond10left=planarSum(sub3avcond10cp,490,630,left{:});
sub3cond20left=planarSum(sub3avcond20cp,490,630,left{:});
sub3cond30left=planarSum(sub3avcond30cp,490,630,left{:});
sub3cond40left=planarSum(sub3avcond40cp,490,630,left{:});
sub14cond10left=planarSum(sub14avcond10cp,490,630,left{:});
sub14cond20left=planarSum(sub14avcond20cp,490,630,left{:});
sub14cond30left=planarSum(sub14avcond30cp,490,630,left{:});
sub14cond40left=planarSum(sub14avcond40cp,490,630,left{:});
sub15cond10left=planarSum(sub15avcond10cp,490,630,left{:});
sub15cond20left=planarSum(sub15avcond20cp,490,630,left{:});
sub15cond30left=planarSum(sub15avcond30cp,490,630,left{:});
sub15cond40left=planarSum(sub15avcond40cp,490,630,left{:});
sub16cond10left=planarSum(sub16avcond10cp,490,630,left{:});
sub16cond20left=planarSum(sub16avcond20cp,490,630,left{:});
sub16cond30left=planarSum(sub16avcond30cp,490,630,left{:});
sub16cond40left=planarSum(sub16avcond40cp,490,630,left{:});
sub17cond10left=planarSum(sub17avcond10cp,490,630,left{:});
sub17cond20left=planarSum(sub17avcond20cp,490,630,left{:});
sub17cond30left=planarSum(sub17avcond30cp,490,630,left{:});
sub17cond40left=planarSum(sub17avcond40cp,490,630,left{:});
sub18cond10left=planarSum(sub18avcond10cp,490,630,left{:});
sub18cond20left=planarSum(sub18avcond20cp,490,630,left{:});
sub18cond30left=planarSum(sub18avcond30cp,490,630,left{:});
sub18cond40left=planarSum(sub18avcond40cp,490,630,left{:});
sub19cond10left=planarSum(sub19avcond10cp,490,630,left{:});
sub19cond20left=planarSum(sub19avcond20cp,490,630,left{:});
sub19cond30left=planarSum(sub19avcond30cp,490,630,left{:});
sub19cond40left=planarSum(sub19avcond40cp,490,630,left{:});
sub30cond10left=planarSum(sub30avcond10cp,490,630,left{:});
sub30cond20left=planarSum(sub30avcond20cp,490,630,left{:});
sub30cond30left=planarSum(sub30avcond30cp,490,630,left{:});
sub30cond40left=planarSum(sub30avcond40cp,490,630,left{:});
sub31cond10left=planarSum(sub31avcond10cp,490,630,left{:});
sub31cond20left=planarSum(sub31avcond20cp,490,630,left{:});
sub31cond30left=planarSum(sub31avcond30cp,490,630,left{:});
sub31cond40left=planarSum(sub31avcond40cp,490,630,left{:});
sub33cond10left=planarSum(sub33avcond10cp,490,630,left{:});
sub33cond20left=planarSum(sub33avcond20cp,490,630,left{:});
sub33cond30left=planarSum(sub33avcond30cp,490,630,left{:});
sub33cond40left=planarSum(sub33avcond40cp,490,630,left{:});
sub34cond10left=planarSum(sub34avcond10cp,490,630,left{:});
sub34cond20left=planarSum(sub34avcond20cp,490,630,left{:});
sub34cond30left=planarSum(sub34avcond30cp,490,630,left{:});
sub34cond40left=planarSum(sub34avcond40cp,490,630,left{:});
sub35cond10left=planarSum(sub35avcond10cp,490,630,left{:});
sub35cond20left=planarSum(sub35avcond20cp,490,630,left{:});
sub35cond30left=planarSum(sub35avcond30cp,490,630,left{:});
sub35cond40left=planarSum(sub35avcond40cp,490,630,left{:});
sub36cond10left=planarSum(sub36avcond10cp,490,630,left{:});
sub36cond20left=planarSum(sub36avcond20cp,490,630,left{:});
sub36cond30left=planarSum(sub36avcond30cp,490,630,left{:});
sub36cond40left=planarSum(sub36avcond40cp,490,630,left{:});
sub37cond10left=planarSum(sub37avcond10cp,490,630,left{:});
sub37cond20left=planarSum(sub37avcond20cp,490,630,left{:});
sub37cond30left=planarSum(sub37avcond30cp,490,630,left{:});
sub37cond40left=planarSum(sub37avcond40cp,490,630,left{:});
sub38cond10left=planarSum(sub38avcond10cp,490,630,left{:});
sub38cond20left=planarSum(sub38avcond20cp,490,630,left{:});
sub38cond30left=planarSum(sub38avcond30cp,490,630,left{:});
sub38cond40left=planarSum(sub38avcond40cp,490,630,left{:});
sub39cond10left=planarSum(sub39avcond10cp,490,630,left{:});
sub39cond20left=planarSum(sub39avcond20cp,490,630,left{:});
sub39cond30left=planarSum(sub39avcond30cp,490,630,left{:});
sub39cond40left=planarSum(sub39avcond40cp,490,630,left{:});

sub3cond10right=planarSum(sub3avcond10cp,490,630,right{:});
sub3cond20right=planarSum(sub3avcond20cp,490,630,right{:});
sub3cond30right=planarSum(sub3avcond30cp,490,630,right{:});
sub3cond40right=planarSum(sub3avcond40cp,490,630,right{:});
sub14cond10right=planarSum(sub14avcond10cp,490,630,right{:});
sub14cond20right=planarSum(sub14avcond20cp,490,630,right{:});
sub14cond30right=planarSum(sub14avcond30cp,490,630,right{:});
sub14cond40right=planarSum(sub14avcond40cp,490,630,right{:});
sub15cond10right=planarSum(sub15avcond10cp,490,630,right{:});
sub15cond20right=planarSum(sub15avcond20cp,490,630,right{:});
sub15cond30right=planarSum(sub15avcond30cp,490,630,right{:});
sub15cond40right=planarSum(sub15avcond40cp,490,630,right{:});
sub16cond10right=planarSum(sub16avcond10cp,490,630,right{:});
sub16cond20right=planarSum(sub16avcond20cp,490,630,right{:});
sub16cond30right=planarSum(sub16avcond30cp,490,630,right{:});
sub16cond40right=planarSum(sub16avcond40cp,490,630,right{:});
sub17cond10right=planarSum(sub17avcond10cp,490,630,right{:});
sub17cond20right=planarSum(sub17avcond20cp,490,630,right{:});
sub17cond30right=planarSum(sub17avcond30cp,490,630,right{:});
sub17cond40right=planarSum(sub17avcond40cp,490,630,right{:});
sub18cond10right=planarSum(sub18avcond10cp,490,630,right{:});
sub18cond20right=planarSum(sub18avcond20cp,490,630,right{:});
sub18cond30right=planarSum(sub18avcond30cp,490,630,right{:});
sub18cond40right=planarSum(sub18avcond40cp,490,630,right{:});
sub19cond10right=planarSum(sub19avcond10cp,490,630,right{:});
sub19cond20right=planarSum(sub19avcond20cp,490,630,right{:});
sub19cond30right=planarSum(sub19avcond30cp,490,630,right{:});
sub19cond40right=planarSum(sub19avcond40cp,490,630,right{:});
sub30cond10right=planarSum(sub30avcond10cp,490,630,right{:});
sub30cond20right=planarSum(sub30avcond20cp,490,630,right{:});
sub30cond30right=planarSum(sub30avcond30cp,490,630,right{:});
sub30cond40right=planarSum(sub30avcond40cp,490,630,right{:});
sub31cond10right=planarSum(sub31avcond10cp,490,630,right{:});
sub31cond20right=planarSum(sub31avcond20cp,490,630,right{:});
sub31cond30right=planarSum(sub31avcond30cp,490,630,right{:});
sub31cond40right=planarSum(sub31avcond40cp,490,630,right{:});
sub33cond10right=planarSum(sub33avcond10cp,490,630,right{:});
sub33cond20right=planarSum(sub33avcond20cp,490,630,right{:});
sub33cond30right=planarSum(sub33avcond30cp,490,630,right{:});
sub33cond40right=planarSum(sub33avcond40cp,490,630,right{:});
sub34cond10right=planarSum(sub34avcond10cp,490,630,right{:});
sub34cond20right=planarSum(sub34avcond20cp,490,630,right{:});
sub34cond30right=planarSum(sub34avcond30cp,490,630,right{:});
sub34cond40right=planarSum(sub34avcond40cp,490,630,right{:});
sub35cond10right=planarSum(sub35avcond10cp,490,630,right{:});
sub35cond20right=planarSum(sub35avcond20cp,490,630,right{:});
sub35cond30right=planarSum(sub35avcond30cp,490,630,right{:});
sub35cond40right=planarSum(sub35avcond40cp,490,630,right{:});
sub36cond10right=planarSum(sub36avcond10cp,490,630,right{:});
sub36cond20right=planarSum(sub36avcond20cp,490,630,right{:});
sub36cond30right=planarSum(sub36avcond30cp,490,630,right{:});
sub36cond40right=planarSum(sub36avcond40cp,490,630,right{:});
sub37cond10right=planarSum(sub37avcond10cp,490,630,right{:});
sub37cond20right=planarSum(sub37avcond20cp,490,630,right{:});
sub37cond30right=planarSum(sub37avcond30cp,490,630,right{:});
sub37cond40right=planarSum(sub37avcond40cp,490,630,right{:});
sub38cond10right=planarSum(sub38avcond10cp,490,630,right{:});
sub38cond20right=planarSum(sub38avcond10cp,490,630,right{:});
sub38cond30right=planarSum(sub38avcond20cp,490,630,right{:});
sub38cond40right=planarSum(sub38avcond20cp,490,630,right{:});
sub39cond10right=planarSum(sub39avcond30cp,490,630,right{:});
sub39cond20right=planarSum(sub39avcond30cp,490,630,right{:});
sub39cond30right=planarSum(sub39avcond40cp,490,630,right{:});
sub39cond40right=planarSum(sub39avcond40cp,490,630,right{:});

allleft(1,:)=[sub3cond10left,sub3cond20left,sub3cond30left,sub3cond40left];
allleft(2,:)=[sub14cond10left,sub14cond20left,sub14cond30left,sub14cond40left];
allleft(3,:)=[sub15cond10left,sub15cond20left,sub15cond30left,sub15cond40left];
allleft(4,:)=[sub16cond10left,sub16cond20left,sub16cond30left,sub16cond40left];
allleft(5,:)=[sub17cond10left,sub17cond20left,sub17cond30left,sub17cond40left];
allleft(6,:)=[sub18cond10left,sub18cond20left,sub18cond30left,sub18cond40left];
allleft(7,:)=[sub19cond10left,sub19cond20left,sub19cond30left,sub19cond40left]; 
allleft(8,:)=[sub30cond10left,sub30cond20left,sub30cond30left,sub30cond40left];
allleft(9,:)=[sub31cond10left,sub31cond20left,sub31cond30left,sub31cond40left]; 
allleft(10,:)=[sub33cond10left,sub33cond20left,sub33cond30left,sub33cond40left];
allleft(11,:)=[sub34cond10left,sub34cond20left,sub34cond30left,sub34cond40left];
allleft(12,:)=[sub35cond10left,sub35cond20left,sub35cond30left,sub35cond40left];
allleft(13,:)=[sub36cond10left,sub36cond20left,sub36cond30left,sub36cond40left];
allleft(14,:)=[sub37cond10left,sub37cond20left,sub37cond30left,sub37cond40left];
allleft(15,:)=[sub38cond10left,sub38cond20left,sub38cond30left,sub38cond40left];
allleft(16,:)=[sub39cond10left,sub39cond20left,sub39cond30left,sub39cond40left];

allright(1,:)=[sub3cond10right,sub3cond20right,sub3cond30right,sub3cond40right];
allright(2,:)=[sub14cond10right,sub14cond20right,sub14cond30right,sub14cond40right];
allright(3,:)=[sub15cond10right,sub15cond20right,sub15cond30right,sub15cond40right];
allright(4,:)=[sub16cond10right,sub16cond20right,sub16cond30right,sub16cond40right];
allright(5,:)=[sub17cond10right,sub17cond20right,sub17cond30right,sub17cond40right];
allright(6,:)=[sub18cond10right,sub18cond20right,sub18cond30right,sub18cond40right];
allright(7,:)=[sub19cond10right,sub19cond20right,sub19cond30right,sub19cond40right]; 
allright(8,:)=[sub30cond10right,sub30cond20right,sub30cond30right,sub30cond40right];
allright(9,:)=[sub31cond10right,sub31cond20right,sub31cond30right,sub31cond40right]; 
allright(10,:)=[sub33cond10right,sub33cond20right,sub33cond30right,sub33cond40right];
allright(11,:)=[sub34cond10right,sub34cond20right,sub34cond30right,sub34cond40right];
allright(12,:)=[sub35cond10right,sub35cond20right,sub35cond30right,sub35cond40right];
allright(13,:)=[sub36cond10right,sub36cond20right,sub36cond30right,sub36cond40right];
allright(14,:)=[sub37cond10right,sub37cond20right,sub37cond30right,sub37cond40right];
allright(15,:)=[sub38cond10right,sub38cond20right,sub38cond30right,sub38cond40right];
allright(16,:)=[sub39cond10right,sub39cond20right,sub39cond30right,sub39cond40right];

allleft=allleft.*10^12;
allright=allright.*10^12;
save planarGrad_rightVSleft_Clean_290-430 allleft allright;

%-----------------------------------
%Isolating Component for one subject
%-----------------------------------

A=650; B=720; % the begining and end of the component according to the time line in the butterfly plot
if B-A==B.*(1017/1000)-A.*(1017/1000);
	C=B;
   else
	C=B+1;
end;
% cond10:
sub3n400cond10=sub3avcond10;
sub3n400cond10.avg=[];
sub3n400cond10.avg=sub3avcond10.avg(:,A.*(1017/1000):B.*(1017/1000));
sub3n400cond10.var=[];
sub3n400cond10.var=sub3avcond10.var(:,A.*(1017/1000):B.*(1017/1000));
sub3n400cond10.dof=[];
sub3n400cond10.dof=sub3avcond10.dof(:,A.*(1017/1000):B.*(1017/1000));
sub3n400cond10.time=[];
sub3n400cond10.time=[(A-200)/1000:0.001:(C-200)/1000];
% cond20:
sub3n400cond20=sub3avcond20;
sub3n400cond20.avg=[];
sub3n400cond20.avg=sub3avcond20.avg(:,A.*(1017/1000):B.*(1017/1000));
sub3n400cond20.var=[];
sub3n400cond20.var=sub3avcond20.var(:,A.*(1017/1000):B.*(1017/1000));
sub3n400cond20.dof=[];
sub3n400cond20.dof=sub3avcond20.dof(:,A.*(1017/1000):B.*(1017/1000));
sub3n400cond20.time=[];
sub3n400cond20.time=[(A-200)/1000:0.001:(C-200)/1000];
% cond 30:
sub3n400cond30=sub3avcond30;
sub3n400cond30.avg=[];
sub3n400cond30.avg=sub3avcond30.avg(:,A.*(1017/1000):B.*(1017/1000));
sub3n400cond30.var=[];
sub3n400cond30.var=sub3avcond30.var(:,A.*(1017/1000):B.*(1017/1000));
sub3n400cond30.dof=[];
sub3n400cond30.dof=sub3avcond30.dof(:,A.*(1017/1000):B.*(1017/1000));
sub3n400cond30.time=[];
sub3n400cond30.time=[(A-200)/1000:0.001:(C-200)/1000];
% cond 40
sub3n400cond40=sub3avcond40;
sub3n400cond40.avg=[];
sub3n400cond40.avg=sub3avcond40.avg(:,A.*(1017/1000):B.*(1017/1000));
sub3n400cond40.var=[];
sub3n400cond40.var=sub3avcond40.var(:,A.*(1017/1000):B.*(1017/1000));
sub3n400cond40.dof=[];
sub3n400cond40.dof=sub3avcond40.dof(:,A.*(1017/1000):B.*(1017/1000));
sub3n400cond40.time=[];
sub3n400cond40.time=[(A-200)/1000:0.001:(C-200)/1000];

save sub3n400 sub3n400cond10 sub3n400cond20 sub3n400cond30 sub3n400cond40

% butterfly
cfg=[];
cfg.showlabels='yes';
cfg.fontsize=10;
cfg.layout='butterfly';
ft_multiplotER(cfg, sub3n400cond10, sub3n400cond20, sub3n400cond30, sub3n400cond40);
%-------------------------------
% Grand Averages for Statistics for isolated comp
%-------------------------------

% N400
%-----
cfg = [];
cfg.keepindividual = 'yes';
[grN400cond10] =  timelockgrandaverage(cfg, sub3n400cond10, sub14n400cond10, sub15n400cond10, sub16n400cond10, sub17n400cond10, sub18n400cond10, sub19n400cond10, sub30n400cond10, sub31n400cond10, sub33n400cond10, sub34n400cond10, sub35n400cond10, sub36n400cond10, sub37n400cond10, sub38n400cond10, sub39n400cond10);
[grN400cond20] =  timelockgrandaverage(cfg, sub3n400cond20, sub14n400cond20, sub15n400cond20, sub16n400cond20, sub17n400cond20, sub18n400cond20, sub19n400cond20, sub30n400cond20, sub31n400cond20, sub33n400cond20, sub34n400cond20, sub35n400cond20, sub36n400cond20, sub37n400cond20, sub38n400cond20, sub39n400cond20);
[grN400cond30] =  timelockgrandaverage(cfg, sub3n400cond30, sub14n400cond30, sub15n400cond30, sub16n400cond30, sub17n400cond30, sub18n400cond30, sub19n400cond30, sub30n400cond30, sub31n400cond30, sub33n400cond30, sub34n400cond30, sub35n400cond30, sub36n400cond30, sub37n400cond30, sub38n400cond30, sub39n400cond30);
[grN400cond40] =  timelockgrandaverage(cfg, sub3n400cond40, sub14n400cond40, sub15n400cond40, sub16n400cond40, sub17n400cond40, sub18n400cond40, sub19n400cond40, sub30n400cond40, sub31n400cond40, sub33n400cond40, sub34n400cond40, sub35n400cond40, sub36n400cond40, sub37n400cond40, sub38n400cond40, sub39n400cond40);

% Late Comp
%----------
cfg = [];
cfg.keepindividual = 'yes';
[grLateCompCond10] =  timelockgrandaverage(cfg, sub3latecond10, sub14latecond10, sub17latecond10, sub18latecond10, sub19latecond10, sub31latecond10, sub33latecond10, sub34latecond10, sub35latecond10, sub36latecond10, sub37latecond10, sub38latecond10);
[grLateCompCond20] =  timelockgrandaverage(cfg, sub3latecond20, sub14latecond20, sub17latecond20, sub18latecond20, sub19latecond20, sub31latecond20, sub33latecond20, sub34latecond20, sub35latecond20, sub36latecond20, sub37latecond20, sub38latecond20);
[grLateCompCond30] =  timelockgrandaverage(cfg, sub3latecond30, sub14latecond30, sub17latecond30, sub18latecond30, sub19latecond30, sub31latecond30, sub33latecond30, sub34latecond30, sub35latecond30, sub36latecond30, sub37latecond30, sub38latecond30);
[grLateCompCond40] =  timelockgrandaverage(cfg, sub3latecond40, sub14latecond40, sub17latecond40, sub18latecond40, sub19latecond40, sub31latecond40, sub33latecond40, sub34latecond40, sub35latecond40, sub36latecond40, sub37latecond40, sub38latecond40);

% P300
%-----
cfg = [];
cfg.keepindividual = 'yes';
[grP300cond10] =  timelockgrandaverage(cfg, sub3earlycond10, sub14earlycond10, sub15earlycond10, sub16earlycond10, sub17earlycond10, sub18earlycond10, sub19earlycond10, sub30earlycond10, sub31earlycond10, sub33earlycond10, sub34earlycond10, sub35earlycond10, sub36earlycond10, sub37earlycond10, sub38earlycond10, sub39earlycond10);
[grP300cond20] =  timelockgrandaverage(cfg, sub3earlycond20, sub14earlycond20, sub15earlycond20, sub16earlycond20, sub17earlycond20, sub18earlycond20, sub19earlycond20, sub30earlycond20, sub31earlycond20, sub33earlycond20, sub34earlycond20, sub35earlycond20, sub36earlycond20, sub37earlycond20, sub38earlycond20, sub39earlycond20);
[grP300cond30] =  timelockgrandaverage(cfg, sub3earlycond30, sub14earlycond30, sub15earlycond30, sub16earlycond30, sub17earlycond30, sub18earlycond30, sub19earlycond30, sub30earlycond30, sub31earlycond30, sub33earlycond30, sub34earlycond30, sub35earlycond30, sub36earlycond30, sub37earlycond30, sub38earlycond30, sub39earlycond30);
[grP300cond40] =  timelockgrandaverage(cfg, sub3earlycond40, sub14earlycond40, sub15earlycond40, sub16earlycond40, sub17earlycond40, sub18earlycond40, sub19earlycond40, sub30earlycond40, sub31earlycond40, sub33earlycond40, sub34earlycond40, sub35earlycond40, sub36earlycond40, sub37earlycond40, sub38earlycond40, sub39earlycond40);
%--------------------------------
% ANOVA
%--------------------------------
design=[];
s=16; % change to the number of subjects
design=[1:4*s; 1:s 1:s 1:s 1:s];
design(1,1:s)=1;
design(1,s+1:2*s)=2;
design(1,2*s+1:3*s)=3;
design(1,3*s+1:4*s)=4;

cfg = [];
cfg.channel = 'MEG';
cfg.parameter   = 'individual';
cfg.method = 'analytic';
% cfg.latency=[min max]; % put min and max
cfg.statistic = 'depsamplesF';
cfg.avgovertime = 'yes';
cfg.alpha = 0.05;
cfg.design = design;
cfg.tail = 1;
cfg.ivar = 1;
cfg.uvar = 2;

ftest=timelockstatistics(cfg,grN400cond10,grN400cond20,grN400cond30,grN400cond40);

% topoplot F-test
cfg=[];
gr=grN400cond30; % or with "cp"
gr.avg=ftest.stat;
cfg.layout='4D248.lay';
cfg.zparam='avg';
gr.dimord='subj_chan_time';
cfg.xlim = [0 0];
cfg.highlight=find((ftest.mask(:,1)));
figure;
title ('Repeated Measures ANOVA (LIT, CM, NM, UR), n=16')
ft_topoplotER(cfg,gr);
%--------------------
% statistics: T-test
%--------------------
cfg = [];
cfg.channel = 'MEG';
cfg.parameter   = 'individual'; % for 1 subject, type "trial"
cfg.method = 'analytic';
% cfg.latency=[min max]; % put min and max
cfg.statistic = 'depsamplesT';
cfg.avgovertime = 'yes';
cfg.alpha = 0.05; % for 3 T-tests (NM-LIT, NM-CM, NM-UR)?
s=16; %change the number of subjects
design=[1:2*s; 1:s 1:s];
for i=1:s
    design(1,i)=1;
    design(1,i+s)=2;
end;
cfg.design = design;
cfg.ivar = 1;
cfg.uvar = 2;

ttest = timelockstatistics(cfg,grN400cond30,grN400cond20); % for tow conditions: cond10 and cond30

cfg=[];
gr=grN400cond30;
gr.avg=ttest.stat;
cfg.layout='4D248.lay';
cfg.zparam='avg';
gr.dimord='subj_chan_time'; %some times work without "subj_"
cfg.xlim = [0 0];
cfg.highlight=find((ttest.mask(:,1)));
figure;
title ('NM-LIT')
topoplotER(cfg,gr);

% create planar grade mean for back/front-left/right channels using planarSum function for symetric sig channels
%---------------------------------------------------------------------------------------------------------------
FL={'A122','A62','A38','A20','A6','A7','A10','A63','A39','A21','A22','A64','A40','A41','A42','A44','A93','A94','A97','A178','A155','A127','A129','A158','A233','A179','A156'};
FR={'A152','A88','A87','A60','A36','A59','A86','A117','A18','A35','A58','A116','A17','A34','A57','A56','A147','A174','A193','A194','A173','A82','A113','A14','A54','A171','A244'};
BL={'A214','A180','A70','A27','A47','A48','A215','A199','A234','A74','A103','A104','A136','A164','A185','A217','A201'};
BR={'A29','A50','A51','A76','A106','A107','A138','A80','A165','A187','A206','A223','A208','A243','A225','A192','A226'};


sub3cond10FL=planarSum(sub3avcond10cp,450,650,FL{:});
sub3cond20FL=planarSum(sub3avcond20cp,450,650,FL{:});
sub3cond30FL=planarSum(sub3avcond30cp,450,650,FL{:});
sub3cond40FL=planarSum(sub3avcond40cp,450,650,FL{:});
sub14cond10FL=planarSum(sub14avcond10cp,450,650,FL{:});
sub14cond20FL=planarSum(sub14avcond20cp,450,650,FL{:});
sub14cond30FL=planarSum(sub14avcond30cp,450,650,FL{:});
sub14cond40FL=planarSum(sub14avcond40cp,450,650,FL{:});
sub15cond10FL=planarSum(sub15avcond10cp,450,650,FL{:});
sub15cond20FL=planarSum(sub15avcond20cp,450,650,FL{:});
sub15cond30FL=planarSum(sub15avcond30cp,450,650,FL{:});
sub15cond40FL=planarSum(sub15avcond40cp,450,650,FL{:});
sub16cond10FL=planarSum(sub16avcond10cp,450,650,FL{:});
sub16cond20FL=planarSum(sub16avcond20cp,450,650,FL{:});
sub16cond30FL=planarSum(sub16avcond30cp,450,650,FL{:});
sub16cond40FL=planarSum(sub16avcond40cp,450,650,FL{:});
sub17cond10FL=planarSum(sub17avcond10cp,450,650,FL{:});
sub17cond20FL=planarSum(sub17avcond20cp,450,650,FL{:});
sub17cond30FL=planarSum(sub17avcond30cp,450,650,FL{:});
sub17cond40FL=planarSum(sub17avcond40cp,450,650,FL{:});
sub18cond10FL=planarSum(sub18avcond10cp,450,650,FL{:});
sub18cond20FL=planarSum(sub18avcond20cp,450,650,FL{:});
sub18cond30FL=planarSum(sub18avcond30cp,450,650,FL{:});
sub18cond40FL=planarSum(sub18avcond40cp,450,650,FL{:});
sub19cond10FL=planarSum(sub19avcond10cp,450,650,FL{:});
sub19cond20FL=planarSum(sub19avcond20cp,450,650,FL{:});
sub19cond30FL=planarSum(sub19avcond30cp,450,650,FL{:});
sub19cond40FL=planarSum(sub19avcond40cp,450,650,FL{:});
sub30cond10FL=planarSum(sub30avcond10cp,450,650,FL{:});
sub30cond20FL=planarSum(sub30avcond20cp,450,650,FL{:});
sub30cond30FL=planarSum(sub30avcond30cp,450,650,FL{:});
sub30cond40FL=planarSum(sub30avcond40cp,450,650,FL{:});
sub31cond10FL=planarSum(sub31avcond10cp,450,650,FL{:});
sub31cond20FL=planarSum(sub31avcond20cp,450,650,FL{:});
sub31cond30FL=planarSum(sub31avcond30cp,450,650,FL{:});
sub31cond40FL=planarSum(sub31avcond40cp,450,650,FL{:});
sub33cond10FL=planarSum(sub33avcond10cp,450,650,FL{:});
sub33cond20FL=planarSum(sub33avcond20cp,450,650,FL{:});
sub33cond30FL=planarSum(sub33avcond30cp,450,650,FL{:});
sub33cond40FL=planarSum(sub33avcond40cp,450,650,FL{:});
sub34cond10FL=planarSum(sub34avcond10cp,450,650,FL{:});
sub34cond20FL=planarSum(sub34avcond20cp,450,650,FL{:});
sub34cond30FL=planarSum(sub34avcond30cp,450,650,FL{:});
sub34cond40FL=planarSum(sub34avcond40cp,450,650,FL{:});
sub35cond10FL=planarSum(sub35avcond10cp,450,650,FL{:});
sub35cond20FL=planarSum(sub35avcond20cp,450,650,FL{:});
sub35cond30FL=planarSum(sub35avcond30cp,450,650,FL{:});
sub35cond40FL=planarSum(sub35avcond40cp,450,650,FL{:});
sub36cond10FL=planarSum(sub36avcond10cp,450,650,FL{:});
sub36cond20FL=planarSum(sub36avcond20cp,450,650,FL{:});
sub36cond30FL=planarSum(sub36avcond30cp,450,650,FL{:});
sub36cond40FL=planarSum(sub36avcond40cp,450,650,FL{:});
sub37cond10FL=planarSum(sub37avcond10cp,450,650,FL{:});
sub37cond20FL=planarSum(sub37avcond20cp,450,650,FL{:});
sub37cond30FL=planarSum(sub37avcond30cp,450,650,FL{:});
sub37cond40FL=planarSum(sub37avcond40cp,450,650,FL{:});
sub38cond10FL=planarSum(sub38avcond10cp,450,650,FL{:});
sub38cond20FL=planarSum(sub38avcond20cp,450,650,FL{:});
sub38cond30FL=planarSum(sub38avcond30cp,450,650,FL{:});
sub38cond40FL=planarSum(sub38avcond40cp,450,650,FL{:});
sub39cond10FL=planarSum(sub39avcond10cp,450,650,FL{:});
sub39cond20FL=planarSum(sub39avcond20cp,450,650,FL{:});
sub39cond30FL=planarSum(sub39avcond30cp,450,650,FL{:});
sub39cond40FL=planarSum(sub39avcond40cp,450,650,FL{:});

sub3cond10FR=planarSum(sub3avcond10cp,450,650,FR{:});
sub3cond20FR=planarSum(sub3avcond20cp,450,650,FR{:});
sub3cond30FR=planarSum(sub3avcond30cp,450,650,FR{:});
sub3cond40FR=planarSum(sub3avcond40cp,450,650,FR{:});
sub14cond10FR=planarSum(sub14avcond10cp,450,650,FR{:});
sub14cond20FR=planarSum(sub14avcond20cp,450,650,FR{:});
sub14cond30FR=planarSum(sub14avcond30cp,450,650,FR{:});
sub14cond40FR=planarSum(sub14avcond40cp,450,650,FR{:});
sub15cond10FR=planarSum(sub15avcond10cp,450,650,FR{:});
sub15cond20FR=planarSum(sub15avcond20cp,450,650,FR{:});
sub15cond30FR=planarSum(sub15avcond30cp,450,650,FR{:});
sub15cond40FR=planarSum(sub15avcond40cp,450,650,FR{:});
sub16cond10FR=planarSum(sub16avcond10cp,450,650,FR{:});
sub16cond20FR=planarSum(sub16avcond20cp,450,650,FR{:});
sub16cond30FR=planarSum(sub16avcond30cp,450,650,FR{:});
sub16cond40FR=planarSum(sub16avcond40cp,450,650,FR{:});
sub17cond10FR=planarSum(sub17avcond10cp,450,650,FR{:});
sub17cond20FR=planarSum(sub17avcond20cp,450,650,FR{:});
sub17cond30FR=planarSum(sub17avcond30cp,450,650,FR{:});
sub17cond40FR=planarSum(sub17avcond40cp,450,650,FR{:});
sub18cond10FL=planarSum(sub18avcond10cp,450,650,FR{:});
sub18cond20FL=planarSum(sub18avcond20cp,450,650,FR{:});
sub18cond30FL=planarSum(sub18avcond30cp,450,650,FR{:});
sub18cond40FL=planarSum(sub18avcond40cp,450,650,FR{:});
sub19cond10FR=planarSum(sub19avcond10cp,450,650,FR{:});
sub19cond20FR=planarSum(sub19avcond20cp,450,650,FR{:});
sub19cond30FR=planarSum(sub19avcond30cp,450,650,FR{:});
sub19cond40FR=planarSum(sub19avcond40cp,450,650,FR{:});
sub30cond10FR=planarSum(sub30avcond10cp,450,650,FR{:});
sub30cond20FR=planarSum(sub30avcond20cp,450,650,FR{:});
sub30cond30FR=planarSum(sub30avcond30cp,450,650,FR{:});
sub30cond40FR=planarSum(sub30avcond40cp,450,650,FR{:});
sub31cond10FR=planarSum(sub31avcond10cp,450,650,FR{:});
sub31cond20FR=planarSum(sub31avcond20cp,450,650,FR{:});
sub31cond30FR=planarSum(sub31avcond30cp,450,650,FR{:});
sub31cond40FR=planarSum(sub31avcond40cp,450,650,FR{:});
sub33cond10FR=planarSum(sub33avcond10cp,450,650,FR{:});
sub33cond20FR=planarSum(sub33avcond20cp,450,650,FR{:});
sub33cond30FR=planarSum(sub33avcond30cp,450,650,FR{:});
sub33cond40FR=planarSum(sub33avcond40cp,450,650,FR{:});
sub34cond10FR=planarSum(sub34avcond10cp,450,650,FR{:});
sub34cond20FR=planarSum(sub34avcond20cp,450,650,FR{:});
sub34cond30FR=planarSum(sub34avcond30cp,450,650,FR{:});
sub34cond40FR=planarSum(sub34avcond40cp,450,650,FR{:});
sub35cond10FR=planarSum(sub35avcond10cp,450,650,FR{:});
sub35cond20FR=planarSum(sub35avcond20cp,450,650,FR{:});
sub35cond30FR=planarSum(sub35avcond30cp,450,650,FR{:});
sub35cond40FR=planarSum(sub35avcond40cp,450,650,FR{:});
sub36cond10FR=planarSum(sub36avcond10cp,450,650,FR{:});
sub36cond20FR=planarSum(sub36avcond20cp,450,650,FR{:});
sub36cond30FR=planarSum(sub36avcond30cp,450,650,FR{:});
sub36cond40FR=planarSum(sub36avcond40cp,450,650,FR{:});
sub37cond10FR=planarSum(sub37avcond10cp,450,650,FR{:});
sub37cond20FR=planarSum(sub37avcond20cp,450,650,FR{:});
sub37cond30FR=planarSum(sub37avcond30cp,450,650,FR{:});
sub37cond40FR=planarSum(sub37avcond40cp,450,650,FR{:});
sub38cond10FR=planarSum(sub38avcond10cp,450,650,FR{:});
sub38cond20FR=planarSum(sub38avcond10cp,450,650,FR{:});
sub38cond30FR=planarSum(sub38avcond20cp,450,650,FR{:});
sub38cond40FR=planarSum(sub38avcond20cp,450,650,FR{:});
sub39cond10FR=planarSum(sub39avcond30cp,450,650,FR{:});
sub39cond20FR=planarSum(sub39avcond30cp,450,650,FR{:});
sub39cond30FR=planarSum(sub39avcond40cp,450,650,FR{:});
sub39cond40FR=planarSum(sub39avcond40cp,450,650,FR{:});

sub3cond10BL=planarSum(sub3avcond10cp,450,650,BL{:});
sub3cond20BL=planarSum(sub3avcond20cp,450,650,BL{:});
sub3cond30BL=planarSum(sub3avcond30cp,450,650,BL{:});
sub3cond40BL=planarSum(sub3avcond40cp,450,650,BL{:});
sub14cond10BL=planarSum(sub14avcond10cp,450,650,BL{:});
sub14cond20BL=planarSum(sub14avcond20cp,450,650,BL{:});
sub14cond30BL=planarSum(sub14avcond30cp,450,650,BL{:});
sub14cond40BL=planarSum(sub14avcond40cp,450,650,BL{:});
sub15cond10BL=planarSum(sub15avcond10cp,450,650,BL{:});
sub15cond20BL=planarSum(sub15avcond20cp,450,650,BL{:});
sub15cond30BL=planarSum(sub15avcond30cp,450,650,BL{:});
sub15cond40BL=planarSum(sub15avcond40cp,450,650,BL{:});
sub16cond10BL=planarSum(sub16avcond10cp,450,650,BL{:});
sub16cond20BL=planarSum(sub16avcond20cp,450,650,BL{:});
sub16cond30BL=planarSum(sub16avcond30cp,450,650,BL{:});
sub16cond40BL=planarSum(sub16avcond40cp,450,650,BL{:});
sub17cond10BL=planarSum(sub17avcond10cp,450,650,BL{:});
sub17cond20BL=planarSum(sub17avcond20cp,450,650,BL{:});
sub17cond30BL=planarSum(sub17avcond30cp,450,650,BL{:});
sub17cond40BL=planarSum(sub17avcond40cp,450,650,BL{:});
sub18cond10FL=planarSum(sub18avcond10cp,450,650,BL{:});
sub18cond20FL=planarSum(sub18avcond20cp,450,650,BL{:});
sub18cond30FL=planarSum(sub18avcond30cp,450,650,BL{:});
sub18cond40FL=planarSum(sub18avcond40cp,450,650,BL{:});
sub19cond10BL=planarSum(sub19avcond10cp,450,650,BL{:});
sub19cond20BL=planarSum(sub19avcond20cp,450,650,BL{:});
sub19cond30BL=planarSum(sub19avcond30cp,450,650,BL{:});
sub19cond40BL=planarSum(sub19avcond40cp,450,650,BL{:});
sub30cond10BL=planarSum(sub30avcond10cp,450,650,BL{:});
sub30cond20BL=planarSum(sub30avcond20cp,450,650,BL{:});
sub30cond30BL=planarSum(sub30avcond30cp,450,650,BL{:});
sub30cond40BL=planarSum(sub30avcond40cp,450,650,BL{:});
sub31cond10BL=planarSum(sub31avcond10cp,450,650,BL{:});
sub31cond20BL=planarSum(sub31avcond20cp,450,650,BL{:});
sub31cond30BL=planarSum(sub31avcond30cp,450,650,BL{:});
sub31cond40BL=planarSum(sub31avcond40cp,450,650,BL{:});
sub33cond10BL=planarSum(sub33avcond10cp,450,650,BL{:});
sub33cond20BL=planarSum(sub33avcond20cp,450,650,BL{:});
sub33cond30BL=planarSum(sub33avcond30cp,450,650,BL{:});
sub33cond40BL=planarSum(sub33avcond40cp,450,650,BL{:});
sub34cond10BL=planarSum(sub34avcond10cp,450,650,BL{:});
sub34cond20BL=planarSum(sub34avcond20cp,450,650,BL{:});
sub34cond30BL=planarSum(sub34avcond30cp,450,650,BL{:});
sub34cond40BL=planarSum(sub34avcond40cp,450,650,BL{:});
sub35cond10BL=planarSum(sub35avcond10cp,450,650,BL{:});
sub35cond20BL=planarSum(sub35avcond20cp,450,650,BL{:});
sub35cond30BL=planarSum(sub35avcond30cp,450,650,BL{:});
sub35cond40BL=planarSum(sub35avcond40cp,450,650,BL{:});
sub36cond10BL=planarSum(sub36avcond10cp,450,650,BL{:});
sub36cond20BL=planarSum(sub36avcond20cp,450,650,BL{:});
sub36cond30BL=planarSum(sub36avcond30cp,450,650,BL{:});
sub36cond40BL=planarSum(sub36avcond40cp,450,650,BL{:});
sub37cond10BL=planarSum(sub37avcond10cp,450,650,BL{:});
sub37cond20BL=planarSum(sub37avcond20cp,450,650,BL{:});
sub37cond30BL=planarSum(sub37avcond30cp,450,650,BL{:});
sub37cond40BL=planarSum(sub37avcond40cp,450,650,BL{:});
sub38cond10BL=planarSum(sub38avcond10cp,450,650,BL{:});
sub38cond20BL=planarSum(sub38avcond20cp,450,650,BL{:});
sub38cond30BL=planarSum(sub38avcond30cp,450,650,BL{:});
sub38cond40BL=planarSum(sub38avcond40cp,450,650,BL{:});
sub39cond10BL=planarSum(sub39avcond10cp,450,650,BL{:});
sub39cond20BL=planarSum(sub39avcond20cp,450,650,BL{:});
sub39cond30BL=planarSum(sub39avcond30cp,450,650,BL{:});
sub39cond40BL=planarSum(sub39avcond40cp,450,650,BL{:});

sub3cond10BR=planarSum(sub3avcond10cp,450,650,BR{:});
sub3cond20BR=planarSum(sub3avcond20cp,450,650,BR{:});
sub3cond30BR=planarSum(sub3avcond30cp,450,650,BR{:});
sub3cond40BR=planarSum(sub3avcond40cp,450,650,BR{:});
sub14cond10BR=planarSum(sub14avcond10cp,450,650,BR{:});
sub14cond20BR=planarSum(sub14avcond20cp,450,650,BR{:});
sub14cond30BR=planarSum(sub14avcond30cp,450,650,BR{:});
sub14cond40BR=planarSum(sub14avcond40cp,450,650,BR{:});
sub15cond10BR=planarSum(sub15avcond10cp,450,650,BR{:});
sub15cond20BR=planarSum(sub15avcond20cp,450,650,BR{:});
sub15cond30BR=planarSum(sub15avcond30cp,450,650,BR{:});
sub15cond40BR=planarSum(sub15avcond40cp,450,650,BR{:});
sub16cond10BR=planarSum(sub16avcond10cp,450,650,BR{:});
sub16cond20BR=planarSum(sub16avcond20cp,450,650,BR{:});
sub16cond30BR=planarSum(sub16avcond30cp,450,650,BR{:});
sub16cond40BR=planarSum(sub16avcond40cp,450,650,BR{:});
sub17cond10BR=planarSum(sub17avcond10cp,450,650,BR{:});
sub17cond20BR=planarSum(sub17avcond20cp,450,650,BR{:});
sub17cond30BR=planarSum(sub17avcond30cp,450,650,BR{:});
sub17cond40BR=planarSum(sub17avcond40cp,450,650,BR{:});
sub18cond10BR=planarSum(sub18avcond10cp,450,650,BR{:});
sub18cond20BR=planarSum(sub18avcond20cp,450,650,BR{:});
sub18cond30BR=planarSum(sub18avcond30cp,450,650,BR{:});
sub18cond40BR=planarSum(sub18avcond40cp,450,650,BR{:});
sub19cond10BR=planarSum(sub19avcond10cp,450,650,BR{:});
sub19cond20BR=planarSum(sub19avcond20cp,450,650,BR{:});
sub19cond30BR=planarSum(sub19avcond30cp,450,650,BR{:});
sub19cond40BR=planarSum(sub19avcond40cp,450,650,BR{:});
sub30cond10BR=planarSum(sub30avcond10cp,450,650,BR{:});
sub30cond20BR=planarSum(sub30avcond20cp,450,650,BR{:});
sub30cond30BR=planarSum(sub30avcond30cp,450,650,BR{:});
sub30cond40BR=planarSum(sub30avcond40cp,450,650,BR{:});
sub31cond10BR=planarSum(sub31avcond10cp,450,650,BR{:});
sub31cond20BR=planarSum(sub31avcond20cp,450,650,BR{:});
sub31cond30BR=planarSum(sub31avcond30cp,450,650,BR{:});
sub31cond40BR=planarSum(sub31avcond40cp,450,650,BR{:});
sub33cond10BR=planarSum(sub33avcond10cp,450,650,BR{:});
sub33cond20BR=planarSum(sub33avcond20cp,450,650,BR{:});
sub33cond30BR=planarSum(sub33avcond30cp,450,650,BR{:});
sub33cond40BR=planarSum(sub33avcond40cp,450,650,BR{:});
sub34cond10BR=planarSum(sub34avcond10cp,450,650,BR{:});
sub34cond20BR=planarSum(sub34avcond20cp,450,650,BR{:});
sub34cond30BR=planarSum(sub34avcond30cp,450,650,BR{:});
sub34cond40BR=planarSum(sub34avcond40cp,450,650,BR{:});
sub35cond10BR=planarSum(sub35avcond10cp,450,650,BR{:});
sub35cond20BR=planarSum(sub35avcond20cp,450,650,BR{:});
sub35cond30BR=planarSum(sub35avcond30cp,450,650,BR{:});
sub35cond40BR=planarSum(sub35avcond40cp,450,650,BR{:});
sub36cond10BR=planarSum(sub36avcond10cp,450,650,BR{:});
sub36cond20BR=planarSum(sub36avcond20cp,450,650,BR{:});
sub36cond30BR=planarSum(sub36avcond30cp,450,650,BR{:});
sub36cond40BR=planarSum(sub36avcond40cp,450,650,BR{:});
sub37cond10BR=planarSum(sub37avcond10cp,450,650,BR{:});
sub37cond20BR=planarSum(sub37avcond20cp,450,650,BR{:});
sub37cond30BR=planarSum(sub37avcond30cp,450,650,BR{:});
sub37cond40BR=planarSum(sub37avcond40cp,450,650,BR{:});
sub38cond10BR=planarSum(sub38avcond10cp,450,650,BR{:});
sub38cond20BR=planarSum(sub38avcond10cp,450,650,BR{:});
sub38cond30BR=planarSum(sub38avcond20cp,450,650,BR{:});
sub38cond40BR=planarSum(sub38avcond20cp,450,650,BR{:});
sub39cond10BR=planarSum(sub39avcond30cp,450,650,BR{:});
sub39cond20BR=planarSum(sub39avcond30cp,450,650,BR{:});
sub39cond30BR=planarSum(sub39avcond40cp,450,650,BR{:});
sub39cond40BR=planarSum(sub39avcond40cp,450,650,BR{:});

allFL(1,:)=[sub3cond10FL,sub3cond20FL,sub3cond30FL,sub3cond40FL];
allFL(2,:)=[sub14cond10FL,sub14cond20FL,sub14cond30FL,sub14cond40FL];
allFL(3,:)=[sub15cond10FL,sub15cond20FL,sub15cond30FL,sub15cond40FL];
allFL(4,:)=[sub16cond10FL,sub16cond20FL,sub16cond30FL,sub16cond40FL];
allFL(5,:)=[sub17cond10FL,sub17cond20FL,sub17cond30FL,sub17cond40FL];
allFL(6,:)=[sub18cond10FL,sub18cond20FL,sub18cond30FL,sub18cond40FL];
allFL(7,:)=[sub19cond10FL,sub19cond20FL,sub19cond30FL,sub19cond40FL]; 
allFL(8,:)=[sub30cond10FL,sub30cond20FL,sub30cond30FL,sub30cond40FL];
allFL(9,:)=[sub31cond10FL,sub31cond20FL,sub31cond30FL,sub31cond40FL]; 
allFL(10,:)=[sub33cond10FL,sub33cond20FL,sub33cond30FL,sub33cond40FL];
allFL(11,:)=[sub34cond10FL,sub34cond20FL,sub34cond30FL,sub34cond40FL];
allFL(12,:)=[sub35cond10FL,sub35cond20FL,sub35cond30FL,sub35cond40FL];
allFL(13,:)=[sub36cond10FL,sub36cond20FL,sub36cond30FL,sub36cond40FL];
allFL(14,:)=[sub37cond10FL,sub37cond20FL,sub37cond30FL,sub37cond40FL];
allFL(15,:)=[sub38cond10FL,sub38cond20FL,sub38cond30FL,sub38cond40FL];
allFL(16,:)=[sub39cond10FL,sub39cond20FL,sub39cond30FL,sub39cond40FL];

allFR(1,:)=[sub3cond10FR,sub3cond20FR,sub3cond30FR,sub3cond40FR];
allFR(2,:)=[sub14cond10FR,sub14cond20FR,sub14cond30FR,sub14cond40FR];
allFR(3,:)=[sub15cond10FR,sub15cond20FR,sub15cond30FR,sub15cond40FR];
allFR(4,:)=[sub16cond10FR,sub16cond20FR,sub16cond30FR,sub16cond40FR];
allFR(5,:)=[sub17cond10FR,sub17cond20FR,sub17cond30FR,sub17cond40FR];
allFR(6,:)=[sub18cond10FR,sub18cond20FR,sub18cond30FR,sub18cond40FR];
allFR(7,:)=[sub19cond10FR,sub19cond20FR,sub19cond30FR,sub19cond40FR]; 
allFR(8,:)=[sub30cond10FR,sub30cond20FR,sub30cond30FR,sub30cond40FR];
allFR(9,:)=[sub31cond10FR,sub31cond20FR,sub31cond30FR,sub31cond40FR]; 
allFR(10,:)=[sub33cond10FR,sub33cond20FR,sub33cond30FR,sub33cond40FR];
allFR(11,:)=[sub34cond10FR,sub34cond20FR,sub34cond30FR,sub34cond40FR];
allFR(12,:)=[sub35cond10FR,sub35cond20FR,sub35cond30FR,sub35cond40FR];
allFR(13,:)=[sub36cond10FR,sub36cond20FR,sub36cond30FR,sub36cond40FR];
allFR(14,:)=[sub37cond10FR,sub37cond20FR,sub37cond30FR,sub37cond40FR];
allFR(15,:)=[sub38cond10FR,sub38cond20FR,sub38cond30FR,sub38cond40FR];
allFR(16,:)=[sub39cond10FR,sub39cond20FR,sub39cond30FR,sub39cond40FR];

allBL(1,:)=[sub3cond10BL,sub3cond20BL,sub3cond30BL,sub3cond40BL];
allBL(2,:)=[sub14cond10BL,sub14cond20BL,sub14cond30BL,sub14cond40BL];
allBL(3,:)=[sub15cond10BL,sub15cond20BL,sub15cond30BL,sub15cond40BL];
allBL(4,:)=[sub16cond10BL,sub16cond20BL,sub16cond30BL,sub16cond40BL];
allBL(5,:)=[sub17cond10BL,sub17cond20BL,sub17cond30BL,sub17cond40BL];
allBL(6,:)=[sub18cond10BL,sub18cond20BL,sub18cond30BL,sub18cond40BL];
allBL(7,:)=[sub19cond10BL,sub19cond20BL,sub19cond30BL,sub19cond40BL]; 
allBL(8,:)=[sub30cond10BL,sub30cond20BL,sub30cond30BL,sub30cond40BL];
allBL(9,:)=[sub31cond10BL,sub31cond20BL,sub31cond30BL,sub31cond40BL]; 
allBL(10,:)=[sub33cond10BL,sub33cond20BL,sub33cond30BL,sub33cond40BL];
allBL(11,:)=[sub34cond10BL,sub34cond20BL,sub34cond30BL,sub34cond40BL];
allBL(12,:)=[sub35cond10BL,sub35cond20BL,sub35cond30BL,sub35cond40BL];
allBL(13,:)=[sub36cond10BL,sub36cond20BL,sub36cond30BL,sub36cond40BL];
allBL(14,:)=[sub37cond10BL,sub37cond20BL,sub37cond30BL,sub37cond40BL];
allBL(15,:)=[sub38cond10BL,sub38cond20BL,sub38cond30BL,sub38cond40BL];
allBL(16,:)=[sub39cond10BL,sub39cond20BL,sub39cond30BL,sub39cond40BL];

allBR(1,:)=[sub3cond10BR,sub3cond20BR,sub3cond30BR,sub3cond40BR];
allBR(2,:)=[sub14cond10BR,sub14cond20BR,sub14cond30BR,sub14cond40BR];
allBR(3,:)=[sub15cond10BR,sub15cond20BR,sub15cond30BR,sub15cond40BR];
allBR(4,:)=[sub16cond10BR,sub16cond20BR,sub16cond30BR,sub16cond40BR];
allBR(5,:)=[sub17cond10BR,sub17cond20BR,sub17cond30BR,sub17cond40BR];
allBR(6,:)=[sub18cond10BR,sub18cond20BR,sub18cond30BR,sub18cond40BR];
allBR(7,:)=[sub19cond10BR,sub19cond20BR,sub19cond30BR,sub19cond40BR]; 
allBR(8,:)=[sub30cond10BR,sub30cond20BR,sub30cond30BR,sub30cond40BR];
allBR(9,:)=[sub31cond10BR,sub31cond20BR,sub31cond30BR,sub31cond40BR]; 
allBR(10,:)=[sub33cond10BR,sub33cond20BR,sub33cond30BR,sub33cond40BR];
allBR(11,:)=[sub34cond10BR,sub34cond20BR,sub34cond30BR,sub34cond40BR];
allBR(12,:)=[sub35cond10BR,sub35cond20BR,sub35cond30BR,sub35cond40BR];
allBR(13,:)=[sub36cond10BR,sub36cond20BR,sub36cond30BR,sub36cond40BR];
allBR(14,:)=[sub37cond10BR,sub37cond20BR,sub37cond30BR,sub37cond40BR];
allBR(15,:)=[sub38cond10BR,sub38cond20BR,sub38cond30BR,sub38cond40BR];
allBR(16,:)=[sub39cond10BR,sub39cond20BR,sub39cond30BR,sub39cond40BR];

allFL=allFL.*10^12;
allFR=allFR.*10^12;
allBL=allBL.*10^12;
allBR=allBR.*10^12;
save planarGrad_frontVSback_rightVSleft_Clean_250-450 allFL allFR allBL allBR
%-------------------------------------------------------------------------------------------------------------------
% Beamforming!!!!!!!
=========================
% see file BeamForming_9.10

