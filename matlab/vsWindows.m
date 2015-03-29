function vsWindows(Subs,GA,wts,width,t,prefix)
% parameters
if ~existAndFull('Subs')
    Subs=cellstr(num2str([1:12]')); % folders of subjects
end
if ~existAndFull('t')
    t=[0.05 0.5];
end
if ~existAndFull('width')
    width=0.05;
end
folder=pwd;
if ~existAndFull('wts')
    cd (strrep(Subs{1},' ',''))
    cd SAM
    wts=dir('*.wts')
    if length(wts)==1
        wts=wts(1).name;
    else
        error('cannot find which .wts to use')
    end
    cd ../../
end
if ~existAndFull('prefix')
    prefix='func';
end
toi=t(1):width/2:t(2);
Xlim=[toi-width/2]'; %#ok<*NBRAK>
Xlim(:,2)=[toi+width/2]';

if ~exist('briks','dir')
    mkdir('briks');
end
if ischar(GA)
    ga=load (GA)
    gaName=fieldnames(ga);
    eval(['GA=ga.',gaName{1}])
end
str='';
scale=1e-13;
for subi=1:length(Subs)
    cd(folder)
    cd (strrep(Subs{subi},' ',''))
    %load ('SAM/general,3-35Hz,alla.wts')
    cd SAM
    [~, ~, ActWgts]=readWeights(wts);
    cd ..
    %load SAM/noiseNormCov
    ns=mean(abs(ActWgts),2);
%     cd folder
%     GA=eval(conds{condi});
    for wini=1:length(toi)
        samples=[nearest(GA.time,Xlim(wini,1)),nearest(GA.time,Xlim(wini,2))];
        data=squeeze(GA.individual(subi,:,samples(1):samples(2)));
        vs=ActWgts*data;
        vs=vs./repmat(ns,1,size(vs,2))./scale;
        vs(isnan(vs))=0;
        VS(1:size(vs,1),wini)=abs(mean(vs,2));
        %make 3D image
    end
    %[~,w]=unix(['rm ',prefix,'+*']) %#ok<NOPRT>
    if exist([prefix,'+orig.HEAD'],'file')
        unix(['rm ',prefix,'+orig.HEAD'])
        unix(['rm ',prefix,'+orig.BRIK'])
    end
    cfg=[];
    cfg.step=5;
    cfg.boxSize=[-120 120 -90 90 -20 150];
    cfg.prefix=prefix;
    cfg.torig=toi(1)*1000;
    cfg.TR=width*1000;
    VS2Brik(cfg,VS);
    %eval(['!echo "cd ',pwd,'" >> ~/alice2tlrc'])
    if exist('ortho+orig.HEAD','file')
        [~,w]=unix(['@auto_tlrc -apar ortho+tlrc -input ',prefix,'+orig -dxyz 5'])
    else
        [~,w]=unix(['@auto_tlrc -apar warped+tlrc -input ',prefix,'+orig -dxyz 5'])
    end
    masktlrc([prefix,'+tlrc'],'MASKctx+tlrc');
    %!mv ',prefix,'+tlrc.HEAD /home/yuval/Copy/MEGdata/alice/func/',prefix,'_',num2str(subi),'+tlrc.HEAD" >> ~/alice2tlrc']);
    [~,w]=unix(['mv ',prefix,'+tlrc.BRIK ',folder,'/briks/',prefix,'_',num2str(subi),'+tlrc.BRIK']);
    [~,w]=unix(['mv ',prefix,'+tlrc.HEAD ',folder,'/briks/',prefix,'_',num2str(subi),'+tlrc.HEAD']);
    str=[str,prefix,'_',num2str(subi),'+tlrc '];
end
cd ..
cd briks
[~,w]=unix(['3dMean -prefix GA_',prefix,' ',str])
