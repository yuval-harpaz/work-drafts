function coords=talCorBehav(subs,coordinates,coordType,label,freq,badChans,pat)
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
            
            %load /media/Elements/MEG/tal/cohTempData.mat
            if strcmp(coordType,'tlrc')
                coords=round(0.2*tlrc2orig(coordinates))/2;
            end
           
            %eval(['corrWts',num2str(i),'=corrcoef(wts',''');'])
        end
        
        %save([pat,'/talResults/Hilbert/',sub,'_h2_',freq],'AEC1','AEC2','CAE1','CAE2','label','corrWts1','corrWts2')
    end
    %cd(PWD);
    %cd /home/yuval/Desktop/talResults/Hilbert
end

