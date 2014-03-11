function marikOverlap

cd /home/yuval/Data/epilepsy/meanAbs/avg
cond={'seg','sw','all'};
for condi=1:3
    for foldi=1:3
        fold=num2str(foldi);
        [V_,info]=BrikLoad([cond{condi},fold,'Avg+orig']);
        eval(['V',num2str(foldi),'=V_;'])
    end
    [~,a1]=sort(V1(:),'descend');
    a1=a1(1:10);
    [~,a2]=sort(V2(:),'descend');
    a2=a2(1:10);
    [~,a3]=sort(V3(:),'descend');
    a3=a3(1:10);
    ol12=sum(ismember(a1,a2)); %
    ol23=sum(ismember(a2,a3)); %
    ol13=sum(ismember(a1,a3)); %
    ol=sum(ismember(a1(ismember(a1,a2)),a3));
    str=[cond{condi},', runs 1-2 ',num2str(ol12),'vox, runs 2-3 ',num2str(ol23),'vox, runs 1-3 ',num2str(ol13),'vox, all runs ',num2str(ol),'vox']
    if condi==2
        [~,ind]=ismember(a1,a2);
        ind12=a1(ind(ind>0));
        [~,ind]=ismember(ind12,a3);
        ind=a3(ind(ind>0));
        
    end
    for i=1:3
        eval(['ma_',cond{condi},num2str(i),'=a1;'])
    end
    %ma1=a1;ma2=a2;ma3=a3;
end
maind=ind;


cd /home/yuval/Data/epilepsy/g2/avg
cond={'seg','sw','_'}
 for condi=1:3
    for foldi=1:3
        fold=num2str(foldi);
        [g2_,info]=BrikLoad(['g2',cond{condi},fold,'Avg+orig']);
        eval(['g2',num2str(foldi),'=g2_;'])
        
        
        
%         OptTSOut.Prefix = ['g2',cond{condi},fold,'AvgPI'];
%         OptTSOut.Scale = 1;
%         OptTSOut.verbose = 1;
%         WriteBrik (g2_p, info,OptTSOut);
%         g2_i=mean(g2_(:,:,:,31:end),4);
%         OptTSOut.Prefix = ['g2',cond{condi},fold,'Avg'];
%         WriteBrik (g2_i, info,OptTSOut);



    end
    [~,a1]=sort(g21(:),'descend');
    a1=a1(1:10);
    [~,a2]=sort(g22(:),'descend');
    a2=a2(1:10);
    [~,a3]=sort(g23(:),'descend');
    a3=a3(1:10);
    ol12=sum(ismember(a1,a2)); % 
    ol23=sum(ismember(a2,a3)); % 
    ol13=sum(ismember(a1,a3)); % 
    ol=sum(ismember(a1(ismember(a1,a2)),a3));
    str=[cond{condi},', runs 1-2 ',num2str(ol12),'vox, runs 2-3 ',num2str(ol23),'vox, runs 1-3 ',num2str(ol13),'vox, all runs ',num2str(ol),'vox']
    if condi==2
        [~,ind]=ismember(a1,a2);
        ind12=a1(ind(ind>0));
        [~,ind]=ismember(ind12,a3);
        ind=a3(ind(ind>0));
        
    end
    for i=1:3
        eval(['a_',cond{condi},num2str(i),'=a1;'])
    end
end

save regions a_* ma_* ind maind
common=zeros(size(g2_(:)));
not_sw=unique([ma_all1;ma_all2;ma_all3;ma_seg1;ma_seg2;ma_seg3;a__1;a__2;a__3;a_seg1;a_seg2;a_seg3]);
common(not_sw)=1;
sw=unique([ma_sw1;ma_sw2;ma_sw3;ma_seg1;ma_seg2;ma_seg3;a_sw1;a_sw2;a_sw3;a_seg1;a_seg2;a_seg3]);
common(sw)=2;
commons=unique([ind,maind]);
common(commons)=3;
comcom=ind(find(ismember(ind,maind)));
common(comcom)=4;
C = reshape(common,49,37,35);
OptTSOut.Prefix = 'fabFig';
WriteBrik (C, info,OptTSOut);
