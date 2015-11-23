% restore data using the rtw file
% you have to filter the ref data and multiply it seperately for analog and
% digital weights, I don't do it here
cd /home/yuval/Copy/MEGdata/alice/noWts
cd 14d1


sRate=1017.25;
t1=ceil(1+sRate*60);
p=pdf4D('c,rfhp1.0Hz');
chi=channel_index(p,'MEG');
data=read_data_block(p,[1 t1],chi);

fid = fopen('/home/yuval/SAM_BIU/docs/SuDi0812.rtw');
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

chiRef=channel_index(p,'ref');
refData=read_data_block(p,[1 t1],chiRef);
%refName=channel_name(p,chi)
raw=rtw*refData+data;

cd ../14n1
cd 1
p=pdf4D('c,rfhp1.0Hz');
dataNW=read_data_block(p,[1 t1],chi);

fW=abs(fftBasic(data,sRate));
fNW=abs(fftBasic(dataNW,sRate));
fRaw=abs(fftBasic(raw,sRate));
figure;topoplot248(fW(:,8))
figure;topoplot248(fNW(:,8))
figure;topoplot248(fRaw(:,8))
% 
% rawlf=correctLF(raw,sRate);
% rawhb=correctHB(rawlf,sRate);
% figure;
% plot(mean(abs(fftBasic(data,sRate))));
% 
% figure;
% plot(mean(abs(fftBasic(data,sRate))));
% hold on
% plot(mean(abs(fftBasic(raw,sRate))),'r');
% 

% refi=regexp(ref,'M');
% refi=sort([refi,regexp(ref,'G')]);
% for refii=1:23
%     REF{refii,1}=ref(refi(refii):refi(refii)+4);
% end
