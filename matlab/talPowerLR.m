function talPowerLR(subs,freqMethod,pat)
% freqMethod can be max, peak or a number
if ~exist('pat','var')
    pat=[];
end
if isempty(pat)
    pat='/media/Elements/MEG/tal';
end
if ~exist('freqMethod','var')
    freqMethod=[];
end
if isempty(freqMethod)
    freqMethod='max';
end
cd (pat)
load /home/yuval/ft_BIU/matlab/files/LRpairs.mat
% remove bad chans
Lchans=LRpairs([1:37 39:96 98:115],1);
Rchans=LRpairs([1:37 39:96 98:115],2);
! echo "sub freq1 pow1L pow1R freq2 pow2L pow2R" > powLR.txt
for subi=1:length(subs)
    cd (pat)
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    for resti=1:2;
        load (['s',sub,'_pow94_',num2str(resti),'.mat'])
        freqmax=zeros(1,length(pow.label));
        % find alpha peak freq
        if strcmp(freqMethod,'max')
            [~,freqmax]=max(pow.powspctrm(:,7:13)');freqmax=freqmax+6;
        elseif strcmp(freqMethod,'peak')
            for chi=1:length(pow.label)
                [powval,peakInd] = findpeaks(pow.powspctrm(chi,7:13));
                % in case there is more than one peak take the highest
                if isempty(peakInd)
                    freqmax(1,chi)=NaN;
                else
                    [~,maxInd]=max(powval);
                    freqmax(1,chi)=peakInd(maxInd);
                end
            end
            freqmax=freqmax+6;
        else
            freqmax=freqMethod;
        end       
        freqmax=mode(freqmax);
        eval(['freq',num2str(resti),'=freqmax;']);
        [~,Lloc] =ismember(Lchans,pow.label);
        powL=pow.powspctrm(Lloc,freqmax);
        powL=sqrt(mean(powL))*(10^13);
        eval(['pow',num2str(resti),'L=powL;']);
        [~,Rloc] =ismember(Rchans,pow.label);
        powR=pow.powspctrm(Rloc,freqmax);
        powR=sqrt(mean(powR))*(10^13);
        eval(['pow',num2str(resti),'R=powR;']);

    end
    eval(['!echo "',sub,' ',...
        num2str(freq1),' ',num2str(pow1L),' ',num2str(pow1R),' ',...
        num2str(freq2),' ',num2str(pow2L),' ',num2str(pow2R),'" >> powLR.txt'])
end
end
