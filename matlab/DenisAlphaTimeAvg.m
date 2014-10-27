%% check shift and tilt
function DenisAlphaTimeAvg
cd /home/yuval/Data/Denis/REST
load('Subs')
load grad
load neighbours
fftTopo=zeros(248,1);
fftTopoPlanar=fftTopo;
timeTopoPlanar=fftTopo;
for subi=1:length(Subs)
    subFold=num2str(Subs(subi));
    cd (subFold)
    load(['fftTopoMEG',num2str(subi)]);
    fftTopo(:,subi)=fftTopoMEG;
    if subi==17
        load(['timeTopoMEG',num2str(subi)]);
        timeTopoPlanar=timeTopoMEG;
    end
    load(['fftTopoMEGplanar',num2str(subi)]);
    fftTopoPlanar(:,subi)=fftTopoMEG;
    cd ..
end
save avgTime fftTopo fftTopoPlanar timeTopoPlanar
%save timeTopoMEGplanar timeTopoMEGplanar
