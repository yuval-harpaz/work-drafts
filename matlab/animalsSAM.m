cd /home/yuval/Data/Amyg
for i=1:12;cd(num2str(i));rtw;cd ..;end

for i=1:12;
    cd(num2str(i));
    load avgAll1;
    times=(sampleinfo(:,1)+204)./1017.25;
    Trig2mark('All',times');
    cd ..;
end

for i=2:12;
    cd(num2str(i));
    copyfile /home/yuval/Data/Amyg/1/BadChans ./
    cd ..
end
    

for i=2:12;
    %unix(['SAMcov64 -d xc,hb,lf_c,rfhp0.1Hz -r ',num2str(i),' -m anim -v']);
    unix(['SAMwts64 -d xc,hb,lf_c,rfhp0.1Hz -r ',num2str(i),' -m anim -c Alla -v']);
end


for i=3:12
     cd(num2str(i));
    fitMRI2hs;
    cd ..
end

% NUDGING
for i=[1:3,5,7:12]
     cd(num2str(i));
    unix('@auto_tlrc -base ~/SAM_BIU/docs/temp+tlrc -input warped+orig -no_ss')
    cd ..
end
Subs=cellstr(num2str([1:12]'))
Subs([4,6])=[];
cd /home/yuval/Data/Amyg
load Gavg246
Gavg246.individual([4,6],:,:)=[];
vsWindows(Subs,'Gavg246',[],0.025,[0.05 0.225]);
cd /home/yuval/Data/Amyg/briks
permuteMovie('func_',1,[],[],[],[0.1 0.075 0.05 0.025 0.01],'both');




for i=[1:3,5,7:12]
    cd(num2str(i));
    cd 
    cd ..
end


% subjects 4 and 6 have bad headshape

[~,~, ActWgts]=readWeights('anim,1-40Hz,Alla.wts');
%    [~,~, ActWgts248]=readWeights('anim,1-40Hz,Alla248.wts');
    

plot(avg.time,avg.avg)
t=0.09;
s=nearest(avg.time,t)

vs248=abs(ActWgts248*avg.avg(:,s))./mean(abs(ActWgts248),2);
[~,i]=ismember({'A74','A204'},avg.label)
avgBC=avg.avg;
avgBC(i,:)=[];
vs=abs(ActWgts*avgBC(:,s))./mean(abs(ActWgts),2);
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='248';
VS2Brik(cfg,vs248);
cfg.prefix='246';
VS2Brik(cfg,vs)

