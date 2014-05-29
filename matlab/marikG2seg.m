function marikG2seg(time,fold,fn,pat)
% SEGMENTS
if ~exist('pat','var')
    pat='/home/yuval/Data/epilepsy/b162b';
end
cd(pat);
% time=[130 133];
if ~exist('fold','var')
    fold='';
end
if isempty(fold)
    fold='1';
end
if ~exist('fn','var')
    fn='';
end
if isempty(fn)
    fn='c,rfhp1.0Hz';
end
cd(fold)


% time=[130 133];
covWinLength=1;
t1=time(1)-covWinLength+0.5;
t2=time(2)-0.5;
t=t1:t2;
tt=t+0.5;
%fn='segments/c,rfhp1.0Hz';
hdr=ft_read_header(fn);
%s1=round(hdr.Fs*t(segi));
trl=round([time(1)-0.5:time(2)-0.5]*hdr.Fs)';
trl(:,2)=trl+round(hdr.Fs);
trl(:,3)=trl(:,1);
ntrl=size(trl,1);
%trl=[s1,round(hdr.Fs*t(segi)+hdr.Fs*5),s1];
cfg=[];
cfg.trl=trl;
cfg.dataset=fn;
cfg.channel='MEG';
cfg.bpfilter='yes';
cfg.bpfreq=[40 130];
raw=ft_preprocessing(cfg);

%counters=zeros(1,ntrl);
for segi=1:length(t)
    %     start=max([segi-covWinLength+1,1]); % which trials (segments) are included in this window
    %     stop=min([segi,ntrl]);
    %     segments=start:stop;
    %     counters(segments)=counters(segments)+1;
    cd(pat)
    cd (fold)
    Trig2mark('seg',t(segi));
    cd ..
    eval(['!SAMcov64 -d ',fn,' -r ',fold,' -m seg1 -v'])
    eval(['!SAMwts64 -d ',fn,' -r ',fold,' -m seg1 -c sega -v'])
    cd (fold)
    cd SAM
%     !SAMcov64 -d hp20_c,rfhp1.0Hz -r segments -m seg1 -v
%     !SAMwts64 -d hp20_c,rfhp1.0Hz -r segments -m seg1 -c sega -v
%     cd segments/SAM
    [~,~, ActWgts]=readWeights('seg1,40-130Hz,sega.wts');
    cd ..
%     ns=mean(abs(ActWgts),2);
    if exist('seg1+orig.BRIK')
        !rm seg1+*
    end
%     pow=mean(abs(ActWgts*raw.trial{1,segi}),2)./ns;
%     pow=pow.*(10^13);
    g2seg=G2(ActWgts*raw.trial{1,segi});
    cfg=[];
    cfg.step=5;
    cfg.boxSize=[-120 120 -90 90 -20 150];
    cfg.prefix='seg1';
    VS2Brik(cfg,g2seg);
    eval(['!3dcalc -a ../maskRS+orig -b seg1+orig -exp ''','b*ispositive(a)''',' -prefix ',num2str(tt(segi)),'g2seg']);
    !rm seg1+*
    
end

str=['!3dTcat -prefix g2seg',fold,' '];
for triali=time(1):time(2)
    str=[str,num2str(triali),'g2seg+orig '];
end
eval(str);
%eval(['!3dTcat -prefix adapt5s',fold,' *all+orig.BRIK'])
eval(['!3drefit -Torg ',num2str(time(1)),' g2seg',fold,'+orig'])
% 
% 
%  !3dTcat -prefix seg1sec 1*.BRIK
%  !3drefit -Torg 100 seg1sec+orig   

%!rm seg1+*


