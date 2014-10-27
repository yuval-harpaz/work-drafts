%function timeTopoMEG=aliceAlphaSashaTime

cd /home/yuval/Data/Sasha
load Subs
for subi=1:length(Subs)
    hdr=ft_read_header(Subs{subi});
    sRate=hdr.Fs;
    samp1=31000;%round(sRate*3);
    samp1Last=samp1+60*sRate;
    cfn=Subs{subi};
    cfg=[];
    cfg.dataset=cfn;
    cfg.trl=[samp1,samp1Last,0];
    cfg.channel='M*1';
    cfg.demean='yes';
    cfg.hpfilter='yes';
    cfg.hpfreq=6;
    cfg.feedback='no';
    meg1=ft_preprocessing(cfg);
    cfg.channel='M*2';
    meg2=ft_preprocessing(cfg);
    cfg.channel='M*3';
    meg3=ft_preprocessing(cfg);
    temp=[-25:25,24:-1:-25];
    blank=[];
    if meg1.fsample~=1000
        erorr('sRate?');
    end
    for chi=1:102
        str=[Subs{subi},' MEG ',num2str(chi)];
%         data=meg.trial;
%         data=data(chi,:);
        samps1=getAlphaSamps(meg1.trial{1,1}(chi,:),temp,1,1.5);
        samps2=getAlphaSamps(meg2.trial{1,1}(chi,:),temp,1,1.5);
        samps3=getAlphaSamps(meg3.trial{1,1}(chi,:),temp,1,1.5);
        timeTopoMEG1(chi,subi)=100*length(samps1)./length(meg1.time{1,1}); %#ok<AGROW>
        timeTopoMEG2(chi,subi)=100*length(samps2)./length(meg1.time{1,1}); %#ok<AGROW>
        timeTopoMEG3(chi,subi)=100*length(samps3)./length(meg1.time{1,1}); %#ok<AGROW>
        disp([blank,str]);
        blank=repmat(sprintf('\b'), 1, length(str)+1);
    end
    f=fftBasic(meg1.trial{1,1},1000);
    %topoplot102(mean(abs(f(:,9:11)),2))
    fftTopoMEG1(1:102,subi)=mean(abs(f(:,9:11)),2);
    f=fftBasic(meg2.trial{1,1},1000);
    fftTopoMEG2(1:102,subi)=mean(abs(f(:,9:11)),2);
    f=fftBasic(meg3.trial{1,1},1000);
    fftTopoMEG3(1:102,subi)=mean(abs(f(:,9:11)),2);
end
save timeTopo *Topo*
% end
figure;topoplot102(mean(timeTopoMEG3,2));title('3');

%% stats (Nothing really)
load ~/ft_BIU/matlab/files/LRpairsNeuroMag
load 
cd /home/yuval/Data/Sasha
load timeTopo
load ~/ft_BIU/matlab/plotNeuromag
for i=1:12;figure;topoplot102(timeTopoMEG1(:,i));title(num2str(i));end
% all channels
[~,Li]=ismember(LRpairs(:,1),plotNeuromag.label);
[~,Ri]=ismember(LRpairs(:,2),plotNeuromag.label);
L=mean(timeTopoMEG1(Li,:),1);
R=mean(timeTopoMEG1(Ri,:),1);
[~,P]=ttest(L,R);

% anterior 
[~,pairi]=ismember( {'MEG1121', 'MEG1131', 'MEG1141', 'MEG1221', 'MEG1231', 'MEG1311', 'MEG1321', 'MEG1331', 'MEG1341', 'MEG1411', 'MEG1441','MEG2211', 'MEG2221', 'MEG2231', 'MEG2411', 'MEG2421', 'MEG2431', 'MEG2441', 'MEG2641'},LRpairs(:,2));
%[~,pairi]=ismember( {'MEG2211', 'MEG2221', 'MEG2231', 'MEG2411', 'MEG2421', 'MEG2431', 'MEG2441', 'MEG2641'},LRpairs(:,2));

%[~,pairi]=ismember({'MEG1121', 'MEG1131', 'MEG1141', 'MEG1221', 'MEG1231', 'MEG1311', 'MEG1321', 'MEG1331', 'MEG1341', 'MEG1411', 'MEG1441'},LRpairs(:,2));
[~,Ri]=ismember(LRpairs(pairi,2),plotNeuromag.label)
[~,Li]=ismember(LRpairs(pairi,1),plotNeuromag.label)
L=mean(timeTopoMEG1(Li,:),1);
R=mean(timeTopoMEG1(Ri,:),1);
L=max(timeTopoMEG1(Li,:));
R=max(timeTopoMEG1(Ri,:));
[~,P]=ttest(L,R);
%end
% chan by chan

P=ones(1,102);
for chani=1:012
    [~,Li]=ismember(LRpairs{chani,1},plotNeuromag.label);
    [~,Ri]=ismember(LRpairs{chani,2},plotNeuromag.label);
    [~,P(Li)]=ttest(timeTopoMEG1(Li,:),timeTopoMEG1(Ri,:));
    P(Ri)=P(Li);
end
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(P<0.05);
topoplot102(mean(timeTopoMEG1,2),cfg);
 P=ones(1,102);
for chani=1:012
    [~,Li]=ismember(LRpairs{chani,1},plotNeuromag.label);
    [~,Ri]=ismember(LRpairs{chani,2},plotNeuromag.label);
    [~,P(Li)]=ttest(timeTopoMEG2(Li,:),timeTopoMEG2(Ri,:));
    P(Ri)=P(Li);
end
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(P<0.05);
topoplot102(mean(timeTopoMEG2,2),cfg);   
P=ones(1,102);
for chani=1:012
    [~,Li]=ismember(LRpairs{chani,1},plotNeuromag.label);
    [~,Ri]=ismember(LRpairs{chani,2},plotNeuromag.label);
    [~,P(Li)]=ttest(timeTopoMEG3(Li,:),timeTopoMEG3(Ri,:));
    P(Ri)=P(Li);
end
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(P<0.05);
topoplot102(mean(timeTopoMEG3,2),cfg);    
    