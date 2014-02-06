function marikSAMloopA20(time,fold,fn,pat)
% ADAPTIVE
if ~exist('pat','var')
    pat='/home/yuval/Data/epilepsy/b162b';
end
cd(pat);
% time=[130 133];
if ~exist('fold','var')
    fold='';
end
if isempty(fold)
    fold='adapt';
end
if ~exist('fn','var')
    fn='';
end
if isempty(fn)
    fn='c,rfhp1.0Hz';
end
cd(fold)
covWinLength=6;
t1=time(1)-covWinLength+0.5;
t2=time(2)-0.5;
t=t1:t2;
hdr=ft_read_header(fn);
%s1=round(hdr.Fs*t(slidei));
trl=round([time(1)-0.5:time(2)-0.5]*hdr.Fs)';
trl(:,2)=trl+round(hdr.Fs);
trl(:,3)=trl(:,1);
ntrl=size(trl,1);
%trl=[s1,round(hdr.Fs*t(slidei)+hdr.Fs*5),s1];
cfg=[];
cfg.trl=trl;
cfg.dataset=fn;
cfg.channel='MEG';
cfg.bpfilter='yes';
cfg.bpfreq=[20 70];
raw=ft_preprocessing(cfg);
% nOP=5*ones(size(t)); % 5s is the length of the sliding window
% nOP(1:4)=[1:4];
% nOP(end-3:end)=[4:-1:1];
% segments={};

% set counters
counters=zeros(1,ntrl);
!rm slide*_*
!rm *s+*
%segments={1,[1,2],[1,2,3],[1,2,3,4],[1,2,3,4],[2,3,4],[3,4],4}
for slidei=1:length(t)
    start=max([slidei-covWinLength+1,1]); % which trials (segments) are included in this window
    stop=min([slidei,ntrl]);
    segments=start:stop;
    counters(segments)=counters(segments)+1; 
    cd(pat)
    cd (fold)
    Trig2mark('slide',t(slidei));
    cd ..
    eval(['!SAMcov64 -d ',fn,' -r ',fold,' -m adapt20 -v'])
    eval(['!SAMwts64 -d ',fn,' -r ',fold,' -m adapt20 -c slidea -v'])
    cd (fold)
    cd SAM
    [~,~, ActWgts]=readWeights('adapt20,20-70Hz,slidea.wts');
    cd ..
	ns=mean(abs(ActWgts),2);
    for segi=segments
%         if counters(segi)==5
%             disp('at your service')
%         end
        if exist('./slide1+orig.BRIK','file')
            !rm slide1+*
        end
        pow=mean(abs(ActWgts*raw.trial{1,segi}),2)./ns;
        pow=pow.*(10^13);
        cfg=[];
        cfg.step=5;
        cfg.boxSize=[-120 120 -90 90 -20 150];
        cfg.prefix='slide1';
        VS2Brik(cfg,pow);
        eval(['!3dcalc -a ../maskRS+orig -b slide1+orig -exp ''','b*ispositive(a)''',' -prefix slide',num2str(segi),'_',num2str(counters(segi))]);
        !rm slide1+*
    end
end
% read the images
disp('averaging');    
for triali=1:ntrl
    % here I only average repetitions 1 to 5, the 6th is always corrupt,
    % might be something to do with left edge of filtered data in SAMcov
    TI=num2str(triali);
    eval(['!3dcalc -a slide',TI,'_1+orig -b slide',TI,'_2+orig -c slide',TI,'_3+orig -d slide',TI,'_4+orig -e slide',TI,'_5+orig -exp ''','(a+b+c+d+e)/5''',' -prefix ',num2str(time(1)+triali-1),'s']);
end
str=['!3dTcat -prefix adapt',fold,' '];
for triali=time(1):time(2)
    str=[str,num2str(triali),'s+orig '];
end
eval(str);
%eval(['!3dTcat -prefix adapt5s',fold,' *all+orig.BRIK'])
eval(['!3drefit -Torg ',num2str(time(1)),' adapt',fold,'+orig'])

% !3dTcat -prefix adapt5 *s+orig.BRIK
% !3drefit -Torg 100 adapt5+orig   
%!rm slide*_*+*        
        
    
