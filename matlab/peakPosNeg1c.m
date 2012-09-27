function [post,negt,posTri,negTri]=peakPosNeg1c(peaks,channel)

post=[];negt=[];
posTri=[];negTri=[];
chani=find(strcmp(channel,peaks.label));
for ti=1:length(peaks.chan{1,chani}.trial)
    try
        p=peaks.chan{1,chani}.trial{1,ti}.time(1,peaks.chan{1,chani}.trial{1,ti}.SNR>0);
        post=[post,p]; %#ok<*AGROW>
        posTri=[posTri,ti.*ones(size(p))];
    end
    
    try
        n=peaks.chan{1,chani}.trial{1,ti}.time(1,peaks.chan{1,chani}.trial{1,ti}.SNR<0);
        negt=[negt,n];
        negTri=[negTri,ti.*ones(size(n))];
    end
end