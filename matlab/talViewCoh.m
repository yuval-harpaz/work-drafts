% cd to where it all is.
if ~exist('subsV1','var')
    load subs36
end
% depending on the group you want to see 
gr=groups(groups>0);
subs=subsV1(find(gr==2))% CM, control, motor learning
rownum=1;cohTable=[];
reg1=3;reg2=15;
for subi =1:2:length(subs)
       for combi=1:18
           load(subs{subi});
            cohTable(rownum,1)=squeeze(squeeze(mean(coh1.cohspctrm(reg1,reg2,(8:13)),3)));
            cohTable(rownum,2)=squeeze(squeeze(mean(coh2.cohspctrm(reg1,reg2,(8:13)),3)));
            load(subs{(subi+1)});
            cohTable(rownum,3)=squeeze(squeeze(mean(coh1.cohspctrm(reg1,reg2,(8:13)),3)));
            cohTable(rownum,4)=squeeze(squeeze(mean(coh2.cohspctrm(reg1,reg2,(8:13)),3)));
            
       end
       display(num2str(rownum))
       rownum=rownum+1;
end
plot(cohTable(:,[1 3])')

% [H,P,CI,STATS] = ttest(cohTable(1,:),0)
