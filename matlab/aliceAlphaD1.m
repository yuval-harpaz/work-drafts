cd /home/yuval/Copy/MEGdata/alice

sf={'idan','inbal','liron','maor','mark','odelia','ohad','yoni'};
for subi=1:8
    cd /home/yuval/Copy/MEGdata/alice
    cd (sf{subi})
    fn=ls('xc*lf*');
    fn=fn(1:end-1);
    load files/triggers
    t0=trigS(find(trigV==100,1,'last'))./1017.25;
    f=abs(fftRaw(fn,t0,60));
    rest(subi,1:248)=sum(f(:,8:12),2);
    figure;topoplot248(rest(subi,:),[],1);
    title(sf{subi});
end
for subi=1:8
    figure;topoplot248(rest(subi,:),[],1);
    title(sf{subi});
end

% for subi=1:8
%     cd /home/yuval/Copy/MEGdata/alice
%     cd (sf{subi})
%     fn=ls('xc*lf*');
%     fn=fn(1:end-1);
%     load files/triggers
%     
%     for piskai=[2 4 8 100]
%         % EEG
%         load(['files/seg',num2str(piskai)])
%         sampBeg=samps(find(samps(:,2)==1,1),1);
%         sampEnd=samps(find(samps(:,2)==1,1,'last'),1);
%         (sampEnd-sampBeg)/1017.25;
%         samps1s=sampBeg:1024:sampEnd;
%         trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
% %         [eegFr,eegLR,eegCoh]=pow(trl,LRpairsEEG);
% %         % title(num2str(piskai))
% %         eval(['eegFr',num2str(piskai),'=eegFr'])
% %         eval(['eegLR',num2str(piskai),'=eegLR'])
% %         eval(['eegCoh',num2str(piskai),'=eegCoh'])
%         % MEG
%         startSeeg=round(evt(find(evt(:,3)==piskai),1)*1024);
%         endSeeg=round(evt(find(evt(:,3)==piskai)+1,1)*1024);
%         startSmeg=trigS(find(trigV==piskai));
%         endSmeg=trigS(find(trigV==piskai)+1);
%         megSR=(endSmeg-startSmeg)/((endSeeg-startSeeg)/1024);
%         if round(megSR)~=1017
%             error('problem detecting MEG sampling rate')
%         end
%         trlMEG=round((trl(:,1)-startSeeg)/1024*megSR)+startSmeg;
%         trlMEG(:,2)=trlMEG+1017;
%         trlMEG(:,3)=zeros(length(trl),1);
%         
% %         [megFr,megLR,megCoh]=pow(trlMEG,LRpairs);
% %         eval(['megFr',num2str(piskai),'=megFr'])
% %         eval(['megLR',num2str(piskai),'=megLR'])
% %         eval(['megCoh',num2str(piskai),'=megCoh'])
%     end
%     
%     
%     
%     t0=trigS(find(trigV==100,1,'last'))./1017.25;
%     f=abs(fftRaw(fn,t0,60));
%     rest(subi,1:248)=sum(f(:,8:12),2);
%     figure;topoplot248(rest(subi,:),[],1);
%     title(sf{subi});
% end
% 
% 
%     
%     
% 
% 
% p=pdf4D('xc,hb,lf_c,rfDC');
% chi=channel_index(p,'MEG');
% data=read_data_block(p,[t0 t1],chi);
% sRate=1017.25;
% 
% fid = fopen('inbal.rtw');
% tline = fgets(fid);
% dis=false;
% str='';
% while ischar(tline)
%     if dis
%         str=[str,tline];
%     end
%     if length(tline)>8
%         if strcmp(tline(1:9),'	    MLzA')
%             ref=tline;
%             dis=true;
%         end
%     end
%     tline = fgets(fid);  
% end
% fclose(fid);
% 
% sep=' ';
% for chani=1:248
%     if chani==100
%         sep='\t';
%     end
%     ch0=regexp(str,['A',num2str(chani),sep]);
%     if chani==216
%         ch1=length(str);
%     else
%         ch1=regexp(str(ch0+1:end),['A']);
%         ch1=ch1(1)+ch0-1;
%     end
%     rtw(chani,1:24)=str2num(str(ch0+length(num2str(chani)):ch1));
% end
% rtw=rtw(:,2:end);
% 
% chi=channel_index(p,'ref');
% refData=read_data_block(p,[t0 t1],chi);
% refName=channel_name(p,chi)
% 
% 
% raw=rtw*refData+data;
% figure;
% plot(mean(abs(fftBasic(data,sRate))));
% hold on
% plot(mean(abs(fftBasic(raw,sRate))),'r');
% 
% 
% % refi=regexp(ref,'M');
% % refi=sort([refi,regexp(ref,'G')]);
% % for refii=1:23
% %     REF{refii,1}=ref(refi(refii):refi(refii)+4);
% % end
