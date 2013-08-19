function aliceMarkers
cd /home/yuval/Copy/MEGdata/alice
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
% prepare folders and stuff
for subi=1:8
    cd(['/home/yuval/Copy/MEGdata/alice/',sf{1,subi},])
    
        load files/triggers
        % load(['seg',num2str(segi)])
        samps=sort(trigS([find(trigV==100,1,'last'),find(trigV<19),find(trigV==50,1),find(trigV==102)]));
%         if max(diff(samps)<1017.25*30)>0
%             warning(['less than 30sec! for ',sf{1,subi}])
%             samps
%         end
        Trig2mark('all',samps./1017.25);

end