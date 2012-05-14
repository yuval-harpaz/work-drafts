function dataHilb=talHilb2(subs,coordinates,coordType,label,freq,badChans,pat)
% subs={'quad01'}
% coordType = 'tlrc'; % 'orig' (in pri) or 'tlrc' (in lpi);
% label={'Lhip';'Rhip';'Lbr';'Rbr';'L47';'R47';'Litg';'Ritg';'Lstg';'Rstg';'Ltha';'Rtha';'Lins';'Rins';'Lcereb';'Rcereb';'Lmu';'Rmu'}
% pat='~/Desktop'; %for yuval's pc
% careful, when working in orig coordinates do one subject at a time!
% freq='alpha';
% coords=[ -40 -18 -8;40 -18 -8;... %   LR hippo, Wink 2006
% -49 17 17;49 17 17;... %        Broca
% -39 29 -6;39 29 -6;... %        IFG 47
% -48 -5 -21;48 -5 -21;... %      ITG
% -57 -12 -2;57 -12 -2;... %      STG
% -14 -20 12;14 -20 12;... %      thalamus
% -34 18 2;34 18 2;...    %       insula
% -30 -61 -36;30 -61 -36;... %    cerebellum
% -35 -25 60;35 -25 60]; %        central
% badChans=[74,204];
if ~exist('badChans','var')
    badChans=[];
end
if strcmp(freq,'alpha')
    freqlow=7;freqhigh=13;
elseif strcmp(freq,'theta')
    freqlow=3;freqhigh=7;
elseif strcmp(freq,'gamma')
    freqlow=25;freqhigh=45;
else
    error('only set for alpha theta and gamma')
end
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
                coords=round(0.2*tlrc2orig(coordinates))/2;
            end
            for trgi=startTrg:2:endTrg
                trOnset=str2num(trg{trgi}); %#ok<*ST2NM>
                strOnset=num2str(trOnset);
                trl(trli,1)=round(trOnset*1017.25); %#ok<*AGROW>
                trli=trli+1;
            end
            cfg=[];
            cfg.trl=trl(:,1)-509;
            cfg.trl(:,2)=trl(:,1)+1016+509;
            cfg.trl(:,3)=-509;
            cfg.dataset=source;
            %            cfg.padding=0.5;
            cfg.bpfilter='yes';
            cfg.bpfreq=[freqlow freqhigh];
            cfg.demean='yes';
            %            cfg.trl=trl;
            cfg.channel='MEG';
            %cfg.bpfiltord     =2;
            cfg.bpfilttype    = 'fir';
            data=ft_preprocessing(cfg);
            cd SAM;
            wtsNoSuf=[freq,',',num2str(freqlow),'-',num2str(freqhigh),'Hz,eyesCloseda'];
            display('loading SAM weights');
            if ~exist([wtsNoSuf,'.mat'],'file')
                [SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
                save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts');
            else
                load([wtsNoSuf,'.mat']);
            end
            cd ..
            display('index of 0,0,0 :');
            [~,allInd]=voxIndex([0,0,0],100.*[...
                SAMHeader.XStart SAMHeader.XEnd ...
                SAMHeader.YStart SAMHeader.YEnd ...
                SAMHeader.ZStart SAMHeader.ZEnd],...
                100.*SAMHeader.StepSize,1);
            vi=0;
            display('indices of vs :');
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
            if ~isempty(badChans)
                for badi = 1:length(badChans)
                    badChannels{1,badi}=['A',num2str(badChans(1,badi))];
                end
                [~,badind]=ismember(badChannels,data.label);
                wts(:,badind)=0;
                for triali=1:length(datavs.trial)
                    datavs.trial{1,triali}=[];
                    datavs.trial{1,triali}(1:size(coords,1),1:end)=wts*data.trial{1,triali};
                end
                datavs.label=label;
                cfg=[];
                cfg.demean='yes';
                cfg.hilbert='yes';
                cfg.bpfilter='yes';
                cfg.bpfreq=[freqlow freqhigh];
                cfg.bpfilttype    = 'fir';
                dataHilb=ft_preprocessing(cfg,datavs);
                % cut edges
                dataHilbCut=dataHilb;dataHilbCut.trial={};dataHilbCut.time={};
                for triali=1:length(dataHilb.trial)
                    dataHilbCut.trial{1,triali}=dataHilb.trial{1,triali}(:,510:1526);
                    dataHilbCut.time{1,triali}=dataHilb.time{1,triali}(:,510:1526);
                end
                avgs=[];
                vs=[];vs1row=[];
                halfSecCount=0;
                for vsi=1:size(dataHilb.trial{1,1},1);
                    halfSecCount=0;
                    for triali=1:length(dataHilb.trial)
                        % concatenating trials
                        if triali==1
                            vs1row=dataHilb.trial{1,1}(vsi,:);
                        else
                            %                     for vsi=1:size(dataHilb.trial{1,1},1)
                            vs1row=[vs1row dataHilb.trial{1,triali}(vsi,:)];
                        end
                        halfSecCount=halfSecCount+1;
                        avgs(halfSecCount,vsi)=mean(dataHilb.trial{1,triali}(vsi,1:509),2);
                        halfSecCount=halfSecCount+1;
                        avgs(halfSecCount,vsi)=mean(dataHilb.trial{1,triali}(vsi,509:1017),2);
                    end
                    if vsi==1
                        vs=vs1row;
                    else
                        vs(vsi,:)=vs1row;
                    end
                    %                 avgs(triali,1:2)=mean(dataHilb.trial{1,triali}(:,1:509),2);
                    %                 avgs(triali,3:4)=mean(dataHilb.trial{1,triali}(:,509:1017),2);
                end
                AEC=corrcoef(vs'); % note here there is no average so it is not realy AEC
                %            AEC=EC(1,2) %#ok<*NOPRT>
                rows=size(avgs,1);
                %             avgs((rows+1):(rows*2),1:2)=avgs(:,3:4);
                %             avgs=avgs(:,1:2);
                CAE=corrcoef(avgs);
                % CAE=cor(1,2) %#ok<*NASGU>
                eval(['AEC',num2str(i),'=AEC;'])
                eval(['CAE',num2str(i),'=CAE;'])
            end
            if ~exist([pat,'/talResults/Hilbert'],'dir')
                mkdir([pat,'/talResults/Hilbert'])
            end
            eval(['corrWts',num2str(i),'=corrcoef(wts',''');'])
        end
        
        save([pat,'/talResults/Hilbert/',sub,'_h2_',freq],'AEC1','AEC2','CAE1','CAE2','label','corrWts1','corrWts2')
    end
    %cd(PWD);
    cd /home/yuval/Desktop/talResults/Hilbert
end

