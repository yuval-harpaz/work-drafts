%% Compare data to audio
  
%% Charisma
[charAud,sRate]=wavread('char.wav');
charAud=mean(charAud');
% char=abs(hilbert(charAud));
% plot(abs(charAud))
% hold on
% plot(char,'r')

% dataFiltFreq=15;
% ObjData=fdesign.lowpass('Fp,Fst,Ap,Ast',dataFiltFreq,dataFiltFreq+1.1*dataFiltFreq,1,60,sRate);
% FiltData=design(ObjData ,'butter');
% charFilt = myFilt(char,FiltData);
% figure;
% plot(abs(charAud))
% hold on
% plot(char,'r')
% plot(abs(charFilt),'g');

[peaks, Ipeaks] = findPeaks(abs(charAud),0,48*2);
for ind=1:length(peaks)-1
    charTrace(Ipeaks(ind):Ipeaks(ind+1))=linspace(peaks(ind),peaks(ind+1),length(Ipeaks(ind):Ipeaks(ind+1)));
end
charSmooth=smooth(charTrace,480);
figure;
plot(charAud);
hold on
plot(abs(charAud),'k');
plot(Ipeaks,peaks,'r.');
plot(charTrace,'g')
plot(charSmooth,'m')

load alphaCor
% audBlock=length(charSmooth)/length(dataavg(:,3));
% for block=1:length(dataavg(:,3))
%     audioChar(block)=max(charSmooth(((block-1)*audBlock+1):(block*audBlock)));
% end
load audioChar
timescale=[1:length(dataavg(:,3))]/2;
figure;
plot(timescale,dataavg(:,3),'b')
hold on
plot(timescale,audioChar,'r')
totalcorr=corr(dataavg(:,3),audioChar);
% for condi=1:6
%     for subi=1:40
%       datafix(isnan(datafix(:,subi,condi)),subi,condi)=squeeze(nanmean(datafix(:,subi,condi)));
%     end
% end
for subi=1:40
    subcorr(subi)=corr(datafix(:,subi,3),audioChar','rows','pairwise');
end
avgcorr=mean(subcorr);
medcorr=median(subcorr);

%% Dull
[dullAud,sRate]=wavread('dull.wav');
dullAud=mean(dullAud');
% dull=abs(hilbert(dullAud));
% plot(abs(dullAud))
% hold on
% plot(dull,'r')

% dataFiltFreq=15;
% ObjData=fdesign.lowpass('Fp,Fst,Ap,Ast',dataFiltFreq,dataFiltFreq+1.1*dataFiltFreq,1,60,sRate);
% FiltData=design(ObjData ,'butter');
% dullFilt = myFilt(dull,FiltData);
% figure;
% plot(abs(dullAud))
% hold on
% plot(dull,'r')
% plot(abs(dullFilt),'g');

[peaks, Ipeaks] = findPeaks(abs(dullAud),0,48*2);
for ind=1:length(peaks)-1
    dullTrace(Ipeaks(ind):Ipeaks(ind+1))=linspace(peaks(ind),peaks(ind+1),length(Ipeaks(ind):Ipeaks(ind+1)));
end
dullSmooth=smooth(dullTrace,480);
figure;
plot(dullAud);
hold on
plot(abs(dullAud),'k');
plot(Ipeaks,peaks,'r.');
plot(dullTrace,'g')
plot(dullSmooth,'m')

load alphaCor
dulldata=dataavg(1:282,5);
% audBlock=length(dullSmooth)/length(dulldata);
% for block=1:length(dulldata)
%     audioDull(block)=max(dullSmooth(((block-1)*audBlock+1):(block*audBlock)));
% end
load audioDull
timescale=[1:length(dulldata)]/2;
figure;
plot(timescale,dulldata,'b')
hold on
plot(timescale,audioDull,'r')
totalcorr=corr(dulldata,audioDull');
% for condi=1:6
%     for subi=1:40
%       datafix(isnan(datafix(:,subi,condi)),subi,condi)=squeeze(nanmean(datafix(:,subi,condi)));
%     end
% end
for subi=1:40
    subcorr(subi)=corr(datafix(1:282,subi,5),audioDull','rows','pairwise');
end
avgcorr=mean(subcorr);
medcorr=median(subcorr);