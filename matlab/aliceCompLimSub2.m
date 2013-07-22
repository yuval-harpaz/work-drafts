function [comps,EEGcomps,MEGcomps]=aliceCompLimSub2
cd /home/yuval/Data/alice
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
for i=1:length(sf)
    cd(sf{i})
    if ~exist('./files/times2.mat','file')
        load times
        EEGcomps.C100(i,1:2)=[times.troughE(1,1),times.troughE(1,2)];
        EEGcomps.C170(i,1:2)=[times.troughE(2,1),times.troughE(2,2)];
        MEGcomps.C100(i,1:2)=[times.troughM(1,1),times.troughM(1,2)];
        MEGcomps.C170(i,1:2)=[times.troughM(2,1),times.troughM(2,2)];
        
        %display([sf{i},' ',num2str(times.troughM(2,1)),' to ',num2str(times.troughM(2,2))]);
        
        %display(num2str(1000*(times.peakM(2)-times.peakE(2))));
        % display([sf{i},' M ',num2str(times.peakM(2)),' E ',num2str(times.peakE(2))]);
    end
    
    comps.C100(i,1)=max([EEGcomps.C100(i,1),MEGcomps.C100(i,1)]);
    comps.C100(i,2)=min([EEGcomps.C100(i,2),MEGcomps.C100(i,2)]);
    comps.C170(i,1)=max([EEGcomps.C170(i,1),MEGcomps.C170(i,1)]);
    comps.C170(i,2)=min([EEGcomps.C170(i,2),MEGcomps.C170(i,2)]);    
    
    cd ..
end
