cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
for subi=1:40
    cd (['Char_',num2str(subi)])
    warped = dir('warped+orig.HEAD')
    if month(warped.date)==11
        !rm warped+tlrc*
    end
    if ~exist('warped+tlrc.BRIK','file')
        !@auto_tlrc -base ~/SAM_BIU/docs/temp+tlrc -input warped+orig -no_ss
    end
    cd ../
end
for subi=1:40
    cd (['Char_',num2str(subi)])
    if ~exist('warped+tlrc.BRIK','file')
        subi
    end
    cd ../
end


