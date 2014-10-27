
cd /home/yuval/Copy/MEGdata/alice
sf={'idan' 'inbal' 'liron' 'maor'  'odelia'	'ohad'  'yoni' 'mark'};
EEG=zeros(30,8);
MEG=zeros(248,8);
fftEEG=zeros(30,8);
fftMEG=zeros(248,8);
for sfi=1:length(sf)
    subFold=sf{sfi};
    load ([subFold,'/timeTopo.mat'])
    EEG(:,sfi)=timeTopoEEG;
    MEG(:,sfi)=timeTopoMEG;
    fftEEG(:,sfi)=fftTopoEEG;
    fftMEG(:,sfi)=fftTopoMEG;
end
timeTopoEEG=EEG;
timeTopoMEG=MEG;
fftTopoEEG=fftEEG;
fftTopoMEG=fftMEG;
save timeTopo *Topo*
% planar
cd /home/yuval/Copy/MEGdata/alice
sf={'idan' 'inbal' 'liron' 'maor'  'odelia'	'ohad'  'yoni' 'mark'};
%EEG=zeros(30,8);
MEG=zeros(248,8);
%fftEEG=zeros(30,8);
fftMEG=zeros(248,8);
for sfi=1:length(sf)
    subFold=sf{sfi};
    load ([subFold,'/timeTopoPlanar.mat'])
    %EEG(:,sfi)=timeTopoEEG;
    MEG(:,sfi)=timeTopoMEG;
    %fftEEG(:,sfi)=fftTopoEEG;
    fftMEG(:,sfi)=fftTopoMEG;
end
%timeTopoEEG=EEG;
timeTopoMEG=MEG;
%fftTopoEEG=fftEEG;
fftTopoMEG=fftMEG;
save timeTopoPlanar *Topo*
for subi=1:8
    figure;
    topoplot248(timeTopoMEG(:,subi));
    title(['time ',num2str(subi)])
%     figure;
%     topoplot248(fftTopoMEG(:,subi));
%     title(['fft ',num2str(subi)])
end