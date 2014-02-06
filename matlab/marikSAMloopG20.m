function marikSAMloopG20(time,fold,fn,pat)
% GLOBAL 
if ~exist('fn','var')
    fn='';
end
if isempty(fn)
    fn='c,rfhp1.0Hz';
end
if ~exist('pat','var')
    pat='/home/yuval/Data/epilepsy/b162b';
end
cd (pat)
cd (fold)
% time=[130 133];
covWinLength=1;
t1=time(1)-covWinLength+0.5;
t2=time(2)-0.5;
t=t1:t2;
tt=t+0.5;
hdr=ft_read_header(fn);
%s1=round(hdr.Fs*t(segi));
trl=round([time(1)-0.5:time(2)-0.5]*hdr.Fs)';
trl(:,2)=trl+round(hdr.Fs);
trl(:,3)=trl(:,1);
%ntrl=size(trl,1);
%trl=[s1,round(hdr.Fs*t(segi)+hdr.Fs*5),s1];
cfg=[];
cfg.trl=trl;
cfg.dataset=fn;
cfg.channel='MEG';
cfg.bpfilter='yes';
cfg.bpfreq=[20 70];
raw=ft_preprocessing(cfg);
cd (pat)
cd (fold)
Trig2mark('all',time(1));
cd ..
eval(['!SAMcov64 -d ',fn,' -r ',fold,' -m adapt -v'])
eval(['!SAMwts64 -d ',fn,' -r ',fold,' -m adapt -c alla -v'])
cd (fold)
cd SAM
[~,~, ActWgts]=readWeights('adapt,20-70Hz,alla.wts');
cd ..
ns=mean(abs(ActWgts),2);
%counters=zeros(1,ntrl);
 !rm all+*
for segi=1:length(t)
    pow=mean(abs(ActWgts*raw.trial{1,segi}),2)./ns;
    pow=pow.*(10^13);
    cfg=[];
    cfg.step=5;
    cfg.boxSize=[-120 120 -90 90 -20 150];
    cfg.prefix='all';
    VS2Brik(cfg,pow);
    eval(['!3dcalc -a ../maskRS+orig -b all+orig -exp ''','b*ispositive(a)''',' -prefix ',num2str(tt(segi)),'all']);
    !rm all+*
end
str=['!3dTcat -prefix all20',fold,' '];
for triali=time(1):time(2)
    str=[str,num2str(triali),'all+orig '];
end
eval(str);
%eval(['!3dTcat -prefix all1s',fold,' *all+orig.BRIK'])
eval(['!3drefit -Torg ',num2str(time(1)),' all20',fold,'+orig'])

%!rm *all+*


