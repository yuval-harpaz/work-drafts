function talWNW(subs,foi,pat)
% talWNW({'quad01'},4,[])
% chCmb can be 'LR' or 'AntPost'
% [cohLR,freq,data]=cohTal({'quad01'},[1:50]);
cond='oneBack';

if ~exist('pat','var')
    pat=[];
end
if isempty(pat)
    pat='/media/Elements/MEG/tal';
end
%patR=[pat(1:(end-3)),'talResults'];
conds={'W','NW'};
PWD=pwd;
cd (pat)
for subi=1:length(subs)
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    indiv=talIndivPathH(sub,cond,pat); %#ok<NASGU>
    numRep=2;
    for i=1:numRep % two eyes closed per subject
        eval(['cd (indiv.path',num2str(i),')']);
        eval(['source=indiv.source',num2str(i),';'])
        load(['/media/Elements/MEG/talResults/oneBackCoh/',sub,conds{1,numRep}])
        trl=coh1.cfg.previous.trl;
        % converting MarkerFile to trl
        cfg=[];
        cfg.dataset=source;
        cfg.trialdef.poststim=0.2;
        cfg.trialfun='trialfun_beg';
        cfg1=[]; %#ok<NASGU>
        cfg1=ft_definetrial(cfg);
        cfg1.trl=trl;
        cfg1.channel='MEG';
        cfg1.blc='yes';
        cfg1.export='';
        cfg1.feedback='no';
        data=ft_preprocessing(cfg1);
        
        wtsNoSuf='SAM/theta,3-7Hz,eyesCloseda';
        if exist ([wtsNoSuf,'.mat'],'file')
            load ([wtsNoSuf,'.mat'])
        else
            [SAMHeader,~, ActWgts]=readWeights([wtsNoSuf,'.wts']);
            save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts')
        end
        cohlr=zeros(size(ActWgts,1),1);
        %NW=zeros(size(ActWgts,1),1);
        for triali=1:length(data.trial)
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
                        if ~isempty(find(ActWgts(indR,:))) && ~isempty(find(ActWgts(indL,:))) %#ok<EFIND>
                            vsL=ActWgts(indL,:)*data.trial{1,1};
                            vsR=ActWgts(indR,:)*data.trial{1,1};
                            [Cxy,F] = mscohere(vsL,vsR,[],[],[],data.fsample);
                            fi=nearest(F,foi);
                            cohlr(indR,triali)=Cxy(fi);
                            cohlr(indL,triali)=Cxy(fi);
                            
                        end
                    end
                end
                display(['X = ',num2str(Xi)])
            end
            display(['trial ',num2str(triali)])
        end
        Yi=0;
        for Xi=-12:0.5:12
            for Zi=-2:0.5:15
                [indM,~]=voxIndex([Xi,Yi,Zi],100.*[...
                    SAMHeader.XStart SAMHeader.XEnd ...
                    SAMHeader.YStart SAMHeader.YEnd ...
                    SAMHeader.ZStart SAMHeader.ZEnd],...
                    100.*SAMHeader.StepSize,0);
                cohlr(indM,:)=1;
            end
        end
        cohlr=mean(cohlr,2);
        %eval(['coh',conds{i},'=cohlr;'])
        
        cfg=[];
        cfg.step=5;
        cfg.boxSize=[-120 120 -90 90 -20 150];
        cfg.prefix=['CohLR',num2str(foi),'Hz',conds{i}];
        VS2Brik(cfg,cohlr)
    end
    % save
end   
cd(PWD);

