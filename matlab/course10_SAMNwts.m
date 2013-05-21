function course10_SAMNwts(foi)
cd /media/YuvalExtDrive/VM/Data
load somsens/dataShort

[SAMHeader, ~, ActWgts]=readWeights('somsens/SAM/Raw,1-70Hz,Global.wts');
cohlr=zeros(length(ActWgts),1);
for Xi=-12:0.5:12
    for Yi=-9:0.5:-0.5
        for Zi=-2:0.5:15
            [indR,~]=voxIndex([Xi,Yi,Zi],100.*[...
                SAMHeader.XStart SAMHeader.XEnd ...
                SAMHeader.YStart SAMHeader.YEnd ...
                SAMHeader.ZStart SAMHeader.ZEnd],...
                100.*SAMHeader.StepSize,0);
            [indL,~]=voxIndex([Xi,-Yi,Zi],100.*[...
                SAMHeader.XStart SAMHeader.XEnd ...
                SAMHeader.YStart SAMHeader.YEnd ...
                SAMHeader.ZStart SAMHeader.ZEnd],...
                100.*SAMHeader.StepSize,0);
            if ~isempty(find(ActWgts(indR,:))) && ~isempty(find(ActWgts(indL,:)))
                !echo 5 > somsens/SAM/LR.txt
                !echo "-0.5 0 5.5" >> somsens/SAM/LR.txt
                !echo "7 -2.5 0" >> somsens/SAM/LR.txt 
                !echo "7 3.0 0" >> somsens/SAM/LR.txt
                eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi),'" >> somsens/SAM/LR.txt'])
                eval(['!echo "',num2str(Xi),' ',num2str(-Yi),' ',num2str(Zi),'" >> somsens/SAM/LR.txt'])
                !SAMNwts -r somsens -d hb_c,rfhp0.1Hz -m RawN -c Global -t LR.txt
                [~, ~, NWgts]=readWeights('somsens/SAM/RawN,LR.txt.wts');
                vsL=NWgts(2,:)*dataShort.trial{1,1};
                vsR=NWgts(1,:)*dataShort.trial{1,1};
                [Cxy,F] = mscohere(vsL,vsR,[],[],[],dataShort.fsample);
                fi=nearest(F,foi);
                cohlr(indR,1)=Cxy(fi);
                cohlr(indL,1)=cohlr(indR,1);
                
            end
        end
    end
    display(['X = ',num2str(Xi)])
end
% plant ones in the midline
Yi=0
for Xi=-12:0.5:12
    for Zi=-2:0.5:15
        [indM,~]=voxIndex([Xi,Yi,Zi],100.*[...
            SAMHeader.XStart SAMHeader.XEnd ...
            SAMHeader.YStart SAMHeader.YEnd ...
            SAMHeader.ZStart SAMHeader.ZEnd],...
            100.*SAMHeader.StepSize,0);
        cohlr(indM,1)=1;
    end
end
% eval(['coh',conds{i},'=cohlr;'])
cd somsens
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=['CohN5LR',num2str(foi),'Hz'];
VS2Brik(cfg,cohlr)
