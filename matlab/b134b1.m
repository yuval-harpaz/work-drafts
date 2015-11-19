% b134b
cd /home/yuval/Data/epilepsy/b134b/2

cfg.jobs=4;
correctLF([],[],[],cfg);
correctHB;

% p=pdf4D('hb,lf_c,rfhp1.0Hz');
% sRate=double(get(p,'dr'));
% chi = channel_index(p, 'meg', 'name');
% data = read_data_block(p,[],chi);
% f=abs(fftBasic(data,sRate));
% for chi=1:248
%     data(chi,:)=data(chi,:)-median(data(chi,:));
% end
% maxData=max(abs(data));

rythmic=[155,169;284,321];
hf=[180.5,183.5;333,339.5;405,409];
samp=[];
for epi=1:2;
    smp=rythmic(epi,1):0.5:rythmic(epi,2);
    for smpi=1:(length(smp)-1)
        samp=[samp;round(smp(smpi)*sRate)];
    end
end
sampEnd=length(samp);
for epi=1:3;
    smp=hf(epi,1):0.5:hf(epi,2);
    for smpi=1:(length(smp)-1)
        samp=[samp;round(smp(smpi)*sRate)];
    end
end
samp(:,2)=0;
samp(1:sampEnd,3)=2; %
samp(sampEnd+1:end,3)=3;
sampBL=1:0.5:154;
sampBL=round(sampBL*sRate)';
sampBL(:,2)=0;
sampBL(:,3)=1;
samp=[sampBL;samp];