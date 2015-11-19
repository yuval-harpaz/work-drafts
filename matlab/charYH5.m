function charYH5(sub1)
if ~existAndFull('sub1')
    sub1=1;
end
% SAM
% chanMethod='max'; % 'mean' 'min'
% freqMethod = 'max'; % 'mean'
bands={'Delta','Theta','Alpha','Beta','Gamma'};
freqs=[1,4;4,8;8,13;13,25;25,40];
trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
conds={'closed','open','charisma','room','dull','silent'};
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
cfg=[];
cfg.torig=500; %beginning of VS in sec
cfg.TR=500; % time of requisition, time gap between samples
cfg.func='funcTemp+orig';
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];

scale=1e+11;
h = waitbar(0,['SUB ',num2str(sub1)]);
%% average power per condition per band    
for subi=sub1:40
    waitbar(subi/40-1/40,h,['SUB ',num2str(subi)]);
    cd (['Char_',num2str(subi)])
    load FrYH
    oddEven=subi-ceil(subi/2)*2+2;
    TRL=[];
    try
        load Fr TRL good
    catch
        load data TRL good
    end
    [~,~,wts]=readWeights('SAM/SPMall,1-40Hz,Alla.wts');
    ns=mean(abs(wts),2);
    for condi=1:6
        trli=TRL(:,4)==trigVal(oddEven,condi);
        tr=find(trli);
        for bandi=1:5
            data=Fr(:,trli,freqs(bandi,1):freqs(bandi,2));
            cfg.prefix=['YH/',conds{condi},'_',bands{bandi}];
            if ~exist(['./YH/',conds{condi},'_',bands{bandi},'+orig.BRIK'],'file')
                pow=zeros(63455,sum(trli));
                for tri=1:sum(trli)
                    for fri=1:size(data,3)
                        pow(:,tri)=pow(:,tri)+abs(wts*data(:,tri,fri));
                    end
                    prog(tri)
                end
                pow=pow./repmat(ns,1,size(pow,2)).*scale;
                VS2Brik(cfg,pow)
            end
            if ~exist(['./YH/',conds{condi},'_',bands{bandi},'+tlrc.BRIK'],'file')
                cd YH
                [~,w]=afnix(['@auto_tlrc -apar ../warped+tlrc -input ',cfg.prefix(4:end),'+orig -dxyz 5']);
                if ~strcmp(w(end-11:end-5),'Cleanup')
                    error('convert to tlrc failed?')
                    disp(w)
                end
                masktlrc([cfg.prefix(4:end),'+tlrc'],'MASKctx+tlrc')
                cd ../
            end
        end
    end
    cd ../
    
end

