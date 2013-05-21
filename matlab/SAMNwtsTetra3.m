function SAMNwtsTetra3(boxSize,stepSize,outside,distance,SAMcfg)
% boxSize=[SAMHeader.XStart SAMHeader.XEnd SAMHeader.YStart SAMHeader.YEnd SAMHeader.ZStart SAMHeader.ZEnd];
% outside=ActWgts(:,1)==0;
% distance in voxels, how many steps apart you want to put the vs. distance=2 means 1cm for
% stepSize = 0.005
% you need SAMcfg
% SAMcfg.d='xc,hb,lf_c,rfhp0.1Hz';
% SAMcfg.r='oddball';
% SAMcfg.m='allTrials';
% SAMcfg.c='Alla';
%[SAMHeader, ~, ActWgts]=readWeights('somsens/SAM/Raw,1-70Hz,Global.wts');
if isempty(boxSize)
    boxSize=[-0.12 0.12 -0.09 0.09 -0.02 0.15];
end
if isempty(stepSize)
    stepSize=0.005;
end
if isempty(distance)
    distance=2;
end
dist=100*stepSize*distance;
%cohlr=zeros(length(outside),1);
% if exist ('SAM/tetraWts.mat','file')
%     load somsens/SAM/tetraWts.mat
% else
dataBand=[];
fid1 = fopen('allTrials1S.param','r'); %# open csv file for reading
while ~feof(fid1)
    line = fgets(fid1); %# read line by line
    if strcmp(line(1:8),'DataBand')
        dataBand=str2num(line(9:end));
    end
end
fclose(fid1);

if ~exist([SAMcfg.r,'/SAM/',SAMcfg.m,',',num2str(dataBand(1)),'-',num2str(dataBand(2)),'Hz/',SAMcfg.c,'.cov'],'file')
    % !SAMcov64 -r oddball -d xc,hb,lf_c,rfhp0.1Hz -m allTrials1S
    eval(['!SAMNcov64 -r ',SAMcfg.r,' -d ',SAMcfg.d,' -m ',SAMcfg.m]);
end
tetraWts=zeros(length(outside),248);
midlineLim=distance*stepSize*100/2; % when the homolog vs overlaps with tetrahedron vs
for Xi=dist-12:0.5:12-dist
    for Yi=dist-9:0.5:9-dist
        for Zi=dist-2:0.5:15-dist
            [ind,~]=voxIndex([Xi,Yi,Zi],100.*boxSize,100.*stepSize,0);
            [ind1,~]=voxIndex([Xi+dist,Yi,Zi],100.*boxSize,100.*stepSize,0);
            [ind2,~]=voxIndex([Xi-dist,Yi,Zi],100.*boxSize,100.*stepSize,0);
            [ind3,~]=voxIndex([Xi,Yi+dist,Zi],100.*boxSize,100.*stepSize,0);
            [ind4,~]=voxIndex([Xi,Yi-dist,Zi],100.*boxSize,100.*stepSize,0);
            [ind5,~]=voxIndex([Xi,Yi,Zi+dist],100.*boxSize,100.*stepSize,0);
            [ind6,~]=voxIndex([Xi,Yi,Zi-dist],100.*boxSize,100.*stepSize,0);
            if ~outside(ind1) && ~outside(ind2) && ~outside(ind3) && ~outside(ind4) && ~outside(ind5) && ~outside(ind6)
                % no points are outside the headshape
                if abs(Yi)>midlineLim % FIXME, only good for 0.5cm stepSize and 1cm distance (2 voxels)
                    % voxels are not in the midline
                    eval(['!echo 8 > ',SAMcfg.r,'/SAM/Tetra.txt']);
                    eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi),'" >> ',SAMcfg.r,'/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi-dist),' ',num2str(Yi),' ',num2str(Zi),'" >> ',SAMcfg.r,'/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi+dist),' ',num2str(Yi),' ',num2str(Zi),'" >> ',SAMcfg.r,'/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi),' ',num2str(Yi-dist),' ',num2str(Zi),'" >> ',SAMcfg.r,'/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi),' ',num2str(Yi+dist),' ',num2str(Zi),'" >> ',SAMcfg.r,'/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi-dist),'" >> ',SAMcfg.r,'/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi+dist),'" >> ',SAMcfg.r,'/SAM/Tetra.txt'])
                    eval(['!echo "',num2str(Xi),' ',num2str(-Yi),' ',num2str(Zi),'" >> ',SAMcfg.r,'/SAM/Tetra.txt'])
                    if exist([SAMcfg.r,'/SAM/',SAMcfg.m,',Tetra.txt.wts'],'file')
                        eval(['!rm ',SAMcfg.r,'/SAM/',SAMcfg.m,',Tetra.txt.wts']);
                    end
                    eval(['!SAMNwts -r ',SAMcfg.r,' -d ',SAMcfg.d,' -m ',SAMcfg.m,' -c ',SAMcfg.c,' -t Tetra.txt']);
                    NWgts=zeros(8,248);
                    if exist([SAMcfg.r,'/SAM/',SAMcfg.m,',Tetra.txt.wts'],'file')
                        [~, ~, NWgts]=readWeights([SAMcfg.r,'/SAM/',SAMcfg.m,',Tetra.txt.wts']);
                        % display('ok')
                    else
                        display('???')
                    end
                    tetraWts(ind,:)=NWgts(1,:);
                end
            end
        end
    end
    display(['X = ',num2str(Xi)])
end
save ([SAMcfg.r,'/SAM/tetraWts'],'tetraWts')
end
% cd /media/YuvalExtDrive/VM/Data/somsens
% cohlr=zeros(length(ActWgts),1);
% for Xi=-12:0.5:12
%     for Yi=-9:0.5:-0.5
%         for Zi=-2:0.5:15
%             [indR,~]=voxIndex([Xi,Yi,Zi],100.*boxSize,100.*stepSize,0);
%             [indL,~]=voxIndex([Xi,-Yi,Zi],100.*boxSize,100.*stepSize,0);
%             if ~isempty(find(ActWgts(indR,:))) && ~isempty(find(ActWgts(indL,:)))
%                 vsL=tetraWts(indL,:)*dataShort.trial{1,1};
%                 vsR=tetraWts(indR,:)*dataShort.trial{1,1};
%                 [Cxy,F] = mscohere(vsL,vsR,[],[],[],dataShort.fsample);
%                 fi=nearest(F,foi);
%                 cohlr(indR,1)=Cxy(fi);
%                 cohlr(indL,1)=cohlr(indR);
%             end
%         end
%     end
%     display(['X = ',num2str(Xi)])
% end
% Yi=0
% for Xi=-12:0.5:12
%     for Zi=-2:0.5:15
%         [indM,~]=voxIndex([Xi,Yi,Zi],100.*boxSize,100.*stepSize,0);
%         cohlr(indM)=1;
%     end
% end
% cfg=[];
% cfg.step=5;
% cfg.boxSize=[-120 120 -90 90 -20 150];
% cfg.prefix=['CohLRtetra',num2str(foi),'Hz'];
% VS2Brik(cfg,cohlr)