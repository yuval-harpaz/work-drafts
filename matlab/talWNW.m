function [cohLR,coh,freq,data]=talWNW(subs,foi,pat,chCmb)
% chCmb can be 'LR' or 'AntPost'
% [cohLR,freq,data]=cohTal({'quad01'},[1:50]);
cond='oneBack';
try
    if isempty(chCmb)
        chCmb='LR';
    end
catch
    chCmb='LR';
end

if ~exist('pat','var')
    pat=[];
end
if isempty(pat)
    pat='/media/Elements/MEG/tal';
end
patR=[pat(1:(end-3)),'talResults'];
conds={'W','NW'};
PWD=pwd;
cd (pat)
for subi=1:length(subs)
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    indiv=talIndivPathH(sub,cond,pat);
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
        cfg1=[];
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
            [SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
            save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts')
        end
        cohlr=zeros(size(ActWgts,1),1);
        %NW=zeros(size(ActWgts,1),1);
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
                        vsL=ActWgts(indL,:)*data.trial{1,1};
                        vsR=ActWgts(indR,:)*data.trial{1,1};
                        [Cxy,F] = mscohere(vsL,vsR,[],[],[],data.fsample);
                        fi=nearest(F,4);
                        
%                         dummy=data;
%                         dummy.label={'vsL';'vsR'};
%                         for tri=1:length(data.trial)
%                             dummy.trial{1,tri}=[vsL;vsR];
%                         end
%                         % fft
%                         cfg3           = [];
%                         cfg3.method    = 'mtmfft';
%                         cfg3.output    = 'fourier';
%                         cfg3.tapsmofrq = 1;
%                         cfg3.foi=foi;
%                         cfg3.keeptrials='yes';
%                         cfg3.feedback='no';
%                         freq          = ft_freqanalysis(cfg3, dummy);
%                         cfg4           = [];
%                         cfg4.method    = 'coh';
%                         %cfg4.channelcmb={'vsL','vsR'};
%                         %cfg4.keeptrial='yes';
%                         cohLR          = ft_connectivityanalysis(cfg4, freq);
                         cohlr(indR)=Cxy(fi);
                         cohlr(indL)=cohlr(indR);
                         display(['X Y Z = ',num2str([Xi,Yi,Zi])])
                    end
                end
            end
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
        eval(['coh',conds{i},'=cohlr;'])
        
        cfg=[];
        cfg.step=5;
        cfg.boxSize=[-120 120 -90 90 -20 150];
        cfg.prefix='W4HzCohLR';
        VS2Brik(cfg,cohW)
    end
    % save
end
    
    
    %         cfg.channelcmb={'all' 'all'};
    %         cfg.channel=chansL;
    %         cohL           = ft_connectivityanalysis(cfg, freq);
    %         cfg.channel=chansR;
    %         cohR           = ft_connectivityanalysis(cfg, freq);
    %         figure;
    %         plot(round(cohLR.freq),cohLR.cohspctrm(6:9,:));
    %         legend('A126','A129','A132','A135')
    %         title(sub)
    
        % save([patR,'/Coh/',sub,sufix],'coh1','coh2')
   

cd(PWD);
end
