function sdata=talHilb(subs,coords,coordType,label,pat);
% subs={'quad01'}
% coords=[1.5 -3 9;1.5 3 9];
% coordType = 'orig'; % 'orig' (in pri) or 'tlrc' (in lpi);
% label={'Rmotor';'Lmotor'};
% pat='~/Desktop'; %for yuval's pc
PWD=pwd;
if ~exist('pat','var')
    pat=[];
end
if isempty(pat)
    pat='/media/Elements/MEG';
end
cd ([pat,'/tal'])
for subi=1:length(subs)
    sub=subs{subi};
    if exist(['~/Desktop/talResults/CohSource/',sub],'file')
        error(['file ~/Desktop/talResults/CohSource/',sub,' exists'])
    else
        display(['BEGGINING WITH ',sub]);
        indiv=indivPathTal(sub,'rest');
        for i=1:2 % two eyes closed per subject
            eval(['cd (indiv.path',num2str(i),')']);
            eval(['source=indiv.source',num2str(i),';'])
            % converting MarkerFile to trl
            trg=textread('restMarkerFile.mrk','%s');
            %load(['/media/Elements/MEG/tal/s',sub,'_pow94_',num2str(resti)])
            startTrg=find(strcmp('eyesClosed',trg))+14;
            numTrg=trg(startTrg-10);
            numTrg=str2num(numTrg{1,1});
            endTrg=startTrg+numTrg*2-2;
            trl=[];
            trli=1;
            load ~/Desktop/tal/cohTempData.mat
            if strcmp(coordType,'tlrc')
                coords=round(0.2*tlrc2orig(coords))/2;
            end
            for trgi=startTrg:2:endTrg
                trOnset=str2num(trg{trgi});
                strOnset=num2str(trOnset);
                trl(trli,1)=round(trOnset*1017.25);
                trli=trli+1;
            end
            trl(:,2)=trl(:,1)+1016;
            trl(:,3)=0;
            cfg=[];
            cfg.dataset=source;
            cfg.bpfilter='yes';
            cfg.bpfreq=[7 13];
            cfg.demean='yes';
            cfg.trl=trl;
            cfg.channel='MEG';
            data=ft_preprocessing(cfg);
            cd SAM;
            wtsNoSuf='alpha,7-13Hz,eyesCloseda';
            if ~exist([wtsNoSuf,'.mat'],'file')
                [SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
                save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts');
            else
                load([wtsNoSuf,'.mat']);
            end
            cd ..
            [~,allInd]=voxIndex([0,0,0],100.*[...
                SAMHeader.XStart SAMHeader.XEnd ...
                SAMHeader.YStart SAMHeader.YEnd ...
                SAMHeader.ZStart SAMHeader.ZEnd],...
                100.*SAMHeader.StepSize,1);
            vi=0;
            for voxi=1:size(coords,1)
                vi(voxi)=voxIndex(coords(voxi,:),100.*[...
                    SAMHeader.XStart SAMHeader.XEnd ...
                    SAMHeader.YStart SAMHeader.YEnd ...
                    SAMHeader.ZStart SAMHeader.ZEnd],...
                    100.*SAMHeader.StepSize,0);
            end
            filter=wts2filterByVox(ActWgts,vi);
            datavs=data;
            wts=ActWgts(vi,:);
            for triali=1:length(datavs.trial)
                datavs.trial{1,triali}=[];
                datavs.trial{1,triali}(1:size(coords,1),1:1017)=wts*data.trial{1,triali};
            end
            datavs.label=label;
            
%             sdata=wtsbox2ft_source(SAMHeader,data);
%             sdata.pos=coords;
%             sdata.inside=vi;
%             sdata.avg.filter=filter;
%             sdata.unit='cm';
%             sdata=ft_convert_units(sdata,'mm');
            cfg=[];
            cfg.demean='yes';
            cfg.hilbert='yes';
            cfg.bpfilter='yes';
            cfg.bpfreq=[7 13];
            dataHilb=ft_preprocessing(cfg,datavs);
            sumcor=0;
            avgs=[];
            for triali=1:length(dataHilb.trial)
                cor=corrcoef(dataHilb.trial{1,triali}');
                sumcor=sumcor+cor(1,2);
                avgs(triali,1:2)=mean(dataHilb.trial{1,triali},2);
            end
            AEC=sumcor./triali
            cor=corrcoef(avgs);
            CAE=cor(1,2)
            
            
            eval(['AEC',num2str(i),'=AEC;'])
            eval(['CAE',num2str(i),'=CAE;'])
        end
        if ~exist([pat,'/talResults/Hilbert'],'dir')
            mkdir([pat,'/talResults/Hilbert'])
        end
        end
        save([pat,'/talResults/Hilbert/',sub],'AEC1','AEC2','CAE1','CAE2')
end
cd(PWD);    
end

