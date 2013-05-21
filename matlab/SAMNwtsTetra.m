function SAMNwtsTetra(foi)
cd /media/YuvalExtDrive/VM/Data
load somsens/dataShort

[SAMHeader, ~, ActWgts]=readWeights('somsens/SAM/Raw,1-70Hz,Global.wts');
cohlr=zeros(length(ActWgts),1);
if exist ('somsens/SAM/tetraWts.mat','file')
    load somsens/SAM/tetraWts.mat
else
    tetraWts=zeros(size(ActWgts));
    for Xi=-12:0.5:12
        for Yi=-9:0.5:9
            for Zi=-2:0.5:15
                [ind,~]=voxIndex([Xi,Yi,Zi],100.*[...
                    SAMHeader.XStart SAMHeader.XEnd ...
                    SAMHeader.YStart SAMHeader.YEnd ...
                    SAMHeader.ZStart SAMHeader.ZEnd],...
                    100.*SAMHeader.StepSize,0);
                if ~isempty(find(ActWgts(ind,:))) %FIXME check if other points are not empty too
                    !echo 8 > somsens/SAM/Tetra.txt
                    eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi),'" >> somsens/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi-1),' ',num2str(Yi),' ',num2str(Zi),'" >> somsens/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi+1),' ',num2str(Yi),' ',num2str(Zi),'" >> somsens/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi),' ',num2str(Yi-1),' ',num2str(Zi),'" >> somsens/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi),' ',num2str(Yi+1),' ',num2str(Zi),'" >> somsens/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi-1),'" >> somsens/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi+1),'" >> somsens/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi),' ',num2str(-Yi),' ',num2str(Zi),'" >> somsens/SAM/Tetra.txt'])
                    !SAMNwts -r somsens -d hb_c,rfhp0.1Hz -m RawN -c Global -t Tetra.txt
                    [~, ~, NWgts]=readWeights('somsens/SAM/RawN,Tetra.txt.wts');
                    tetraWts(ind,:)=NWgts(1,:);
                end
            end
        end
        display(['X = ',num2str(Xi)])
    end
    save somsens/SAM/tetraWts tetraWts
end
cd /media/YuvalExtDrive/VM/Data/somsens
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
                vsL=tetraWts(indL,:)*dataShort.trial{1,1};
                vsR=tetraWts(indR,:)*dataShort.trial{1,1};
                [Cxy,F] = mscohere(vsL,vsR,[],[],[],dataShort.fsample);
                fi=nearest(F,foi);
                cohlr(indR,1)=Cxy(fi);
                cohlr(indL,1)=cohlr(indR);
            end
        end
    end
    display(['X = ',num2str(Xi)])
end
Yi=0
for Xi=-12:0.5:12
    for Zi=-2:0.5:15
        [indM,~]=voxIndex([Xi,Yi,Zi],100.*[...
            SAMHeader.XStart SAMHeader.XEnd ...
            SAMHeader.YStart SAMHeader.YEnd ...
            SAMHeader.ZStart SAMHeader.ZEnd],...
            100.*SAMHeader.StepSize,0);
        cohlr(indM)=1;
    end
end
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=['CohLRtetra',num2str(foi),'Hz'];
VS2Brik(cfg,cohlr)