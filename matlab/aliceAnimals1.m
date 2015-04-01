cd /home/yuval/Copy/MEGdata/alice/ga2015
load('GavgEqTrl.mat')
cd ..
Subs={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
%permuteMovie('MaSW_',1,[],[],[],[0.1 0.075 0.05 0.025 0.01],'both','Asw');
vsWindows(Subs,avgMr,'general,3-35Hz,alla.wts',0.0125,[0.05 0.2],'Nat_','meanAbs');
permuteMovie('Nat_',1.35,[],[],[],[0.1 0.075 0.05 0.025 0.01],'both','nat12');
permuteMovie('Nat_',1.2,[],[],[],[0.1 0.075 0.05 0.025 0.01],'both','nat12_25');



%permuteMovie('ma12_',1.35,[],[],[],[0.1 0.075 0.05 0.025 0.01],'both','ma12');
%(varA,varB,Folder,mask,subBrik,pThr,sizeORt,prefix)
% 
% 
% cd /home/yuval/Data/Amyg
% 
% Subs=cellstr(num2str([1:12]'))
% Subs([1,4,6])=[];
% cd /home/yuval/Data/Amyg
% load Gavg246
% Gavg246.individual([1,4,6],:,:)=[];
% % vsWindows(Subs,'Gavg246',[],0.025,[0.05 0.225],'BL','blMean');
% % vsWindows(Subs,'Gavg246',[],0.025,[0.05 0.225],'BLmax','blMax');
% 
% %permuteMovie('BLmax_',1,[],[],[0 1 2],[0.1 0.075 0.05 0.025 0.01],'both','BLmax1');
% 
% vsWindows(Subs,'Gavg246',[],0.0125,[0.05 0.2],'ma12_','meanAbs');
% cd /home/yuval/Data/Amyg/briks
% permuteMovie('ma12_',1.35,[],[],[],[0.1 0.075 0.05 0.025 0.01],'both','ma12');
