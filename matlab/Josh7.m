%% Charisma movie

file=VideoReader('CharDC.avi');
vidHeight = file.Height;
vidWidth = file.Width;
numcharFrames=get(file,'numberOfFrames');
frcharFrames=file.FrameRate;
load charFrames
%read all the frames
%(can't do all at once)
% for k=1:numcharFrames
%     try
%         disp(['Reading frame ',num2str(k)])
%         charFrames(k,:,:,:)=read(file,k);
%     catch err
%         disp(['Frame ',num2str(k),' could not be read'])
%     end
% end

%calculations (w/ half-second overlap)
%(takes a couple hours)
startframe=1;
endframe=25;
for hsi=1:numcharFrames/frcharFrames*2
    for hi=1:vidHeight
        for wi=1:vidWidth
            bwcharFrames=squeeze(mean(charFrames(...
                startframe:endframe,hi,wi,:),4));
            %calculate sum of pixel variances within each second
            pixvar(hi,wi)=var(single(bwcharFrames));
        end

        %calculate average correlation between frames
        bwcharFrames=squeeze(mean(charFrames(startframe:endframe,hi,:,:),4));
        framecorr(hi)=mean(mean(corr(bwcharFrames')));
        disp(['Height = ',num2str(hi),'/',num2str(vidHeight)])
    end
    secdifol(hsi)=squeeze(sum(squeeze(sum(pixvar(:,:)))));
    disp(['Variance sum calculated for time ',num2str(hsi),'/300'])
    if ~iseven(hsi)
        startframe=startframe+12;
        endframe=endframe+12;
    else
        startframe=startframe+13;
        endframe=endframe+13;
    end
    seccorr(hsi)=mean(framecorr);
    disp(['Correlation average calculated for time ',num2str(hsi),'/300'])
end




%% Dull movie

file=VideoReader('Non-Charismatic.wmv');
%This file has to be decompressed for all of the frames to be read, and to
%decompress it, it needs to be converted to .avi

vidHeight = file.Height;
vidWidth = file.Width;
numdullFrames=get(file,'numberOfFrames');
frdullFrames=file.FrameRate;
% load dullFrames
% read all the frames
% (can't do all at once - will overload memory)
for k=1:numdullFrames
    try
        disp(['Reading frame ',num2str(k)])
        dullFrames(k,:,:,:)=read(file,k);
    catch err
        disp(['Frame ',num2str(k),' could not be read'])
    end
end
save dullFrames dullFrames

%calculations (w/ half-second overlap)
%(takes a couple hours)
startframe=1;
endframe=25;
for hsi=1:numdullFrames/frdullFrames*2
    for hi=1:vidHeight
        for wi=1:vidWidth
            bwdullFrames=squeeze(mean(dullFrames(...
                startframe:endframe,hi,wi,:),4));
            %calculate sum of pixel variances within each second
            pixvar(hi,wi)=var(single(bwdullFrames));
        end

        %calculate average correlation between frames
        bwdullFrames=squeeze(mean(dullFrames(startframe:endframe,hi,:,:),4));
        framecorr(hi)=mean(mean(corr(bwdullFrames')));
        disp(['Height = ',num2str(hi),'/',num2str(vidHeight)])
    end
    secdifol(hsi)=squeeze(sum(squeeze(sum(pixvar(:,:)))));
    disp(['Variance sum calculated for time ',num2str(hsi),'/300'])
    if ~iseven(hsi)
        startframe=startframe+12;
        endframe=endframe+12;
    else
        startframe=startframe+13;
        endframe=endframe+13;
    end
    seccorr(hsi)=mean(framecorr);
    disp(['Correlation average calculated for time ',num2str(hsi),'/300'])
end
save dullFrames secdifol seccorr -append