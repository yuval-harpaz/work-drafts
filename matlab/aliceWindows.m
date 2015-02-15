function aliceWindows(width,opFolder)
if ~existAndFull('width')
    width=0.05;
end
if ~existAndFull('opFolder')
    opFolder='/home/yuval/Copy/MEGdata/alice/ga2015/func';
end

toi=0.075:width/2:0.225;
Xlim=[toi-width/2]'; %#ok<*NBRAK>
Xlim(:,2)=[toi+width/2]';
wts='general,3-35Hz,alla.wts';
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};

cd /home/yuval/Copy/MEGdata/alice/ga2015
load GavgEqTrl
conds={'avgMr','GavgM20'};
%!echo "cd /home/yuval/Copy/MEGdata/alice" > ~/alice2tlrc
prefix={'MaSW','MwSW'};
scale=1e-13;
for subi=1:8
    cd(['/home/yuval/Copy/MEGdata/alice/',sf{subi}])
    %load ('SAM/general,3-35Hz,alla.wts')
    cd SAM
    [~, ~, ActWgts]=readWeights(wts);
    cd ..
    %load SAM/noiseNormCov
    ns=mean(abs(ActWgts),2);
    cd MRI
    for condi=1:2
        Gavg=eval(conds{condi});
        for wini=1:length(toi)
            samples=[nearest(Gavg.time,Xlim(wini,1)),nearest(Gavg.time,Xlim(wini,2))];
            data=squeeze(Gavg.individual(subi,:,samples(1):samples(2)));
            vs=ActWgts*data;
            vs=vs./repmat(ns,1,size(vs,2))./scale;
            vs(isnan(vs))=0;
            VS(1:size(vs,1),wini)=abs(mean(vs,2));
            %make 3D image
        end
        [~,w]=unix(['rm ',prefix{condi},'+*']) %#ok<NOPRT>
        cfg=[];
        cfg.step=5;
        cfg.boxSize=[-120 120 -90 90 -20 150];
        cfg.prefix=prefix{condi};
        cfg.torig=toi(1)*1000;
        cfg.TR=width*1000;
        VS2Brik(cfg,VS);
        %eval(['!echo "cd ',pwd,'" >> ~/alice2tlrc'])
        eval(['!@auto_tlrc -apar ortho+tlrc -input ',prefix{condi},'+orig -dxyz 5'])
        %!mv ',prefix,'+tlrc.HEAD /home/yuval/Copy/MEGdata/alice/func/',prefix,'_',num2str(subi),'+tlrc.HEAD" >> ~/alice2tlrc']);
        eval(['!mv ',prefix{condi},'+tlrc.BRIK ',opFolder,'/',prefix{condi},'_',num2str(subi),'+tlrc.BRIK']);
        eval(['!mv ',prefix{condi},'+tlrc.HEAD ',opFolder,'/',prefix{condi},'_',num2str(subi),'+tlrc.HEAD']);
    end
end
cd (opFolder)
[~,w]=unix(['3dcalc -a ',prefix{1},'_1+tlrc -b ',prefix{1},'_2+tlrc -c ',prefix{1},'_3+tlrc -d ',prefix{1},'_4+tlrc -e ',prefix{1},'_5+tlrc -f ',prefix{1},'_6+tlrc -g ',prefix{1},'_7+tlrc -h ',prefix{1},'_8+tlrc -exp "(a+b+c+d+e+f+g+h)/8" -prefix Gavg',prefix{1}]) %#ok<NOPRT>
masktlrc(['Gavg',prefix{1},'+tlrc'],'MASKctx+tlrc');
[~,w]=unix(['3dcalc -a ',prefix{2},'_1+tlrc -b ',prefix{2},'_2+tlrc -c ',prefix{2},'_3+tlrc -d ',prefix{2},'_4+tlrc -e ',prefix{2},'_5+tlrc -f ',prefix{2},'_6+tlrc -g ',prefix{2},'_7+tlrc -h ',prefix{2},'_8+tlrc -exp "(a+b+c+d+e+f+g+h)/8" -prefix Gavg',prefix{2}]) %#ok<NOPRT>
masktlrc(['Gavg',prefix{2},'+tlrc'],'MASKctx+tlrc');
