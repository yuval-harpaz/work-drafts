trig=readTrig_BIU(source);
t0=find(bitand(uint16(trig),100),1);

p=pdf4D('xc,hb,lf_c,rfDC');
chi=channel_index(p,'MEG');
data=read_data_block(p,[t0 t1],chi);
sRate=1017.25;

fid = fopen('inbal.rtw');
tline = fgets(fid);
dis=false;
str='';
while ischar(tline)
    if dis
        str=[str,tline];
    end
    if length(tline)>8
        if strcmp(tline(1:9),'	    MLzA')
            ref=tline;
            dis=true;
        end
    end
    tline = fgets(fid);  
end
fclose(fid);

sep=' ';
for chani=1:248
    if chani==100
        sep='\t';
    end
    ch0=regexp(str,['A',num2str(chani),sep]);
    if chani==216
        ch1=length(str);
    else
        ch1=regexp(str(ch0+1:end),['A']);
        ch1=ch1(1)+ch0-1;
    end
    rtw(chani,1:24)=str2num(str(ch0+length(num2str(chani)):ch1));
end
rtw=rtw(:,2:end);

chi=channel_index(p,'ref');
refData=read_data_block(p,[t0 t1],chi);
refName=channel_name(p,chi)


raw=rtw*refData+data;
figure;
plot(mean(abs(fftBasic(data,sRate))));
hold on
plot(mean(abs(fftBasic(raw,sRate))),'r');


% refi=regexp(ref,'M');
% refi=sort([refi,regexp(ref,'G')]);
% for refii=1:23
%     REF{refii,1}=ref(refi(refii):refi(refii)+4);
% end
