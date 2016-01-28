

cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
load subCoor
load goodSubs
for subi=1:length(subCoor)
    if subi>length(goodSubs)
        cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
        sub=subCoor{subi,1};
        cd(sub);
        cd MRI
        pri=tlrc2orig(subCoor{subi,2});
        
        
        grid2t(pri./10);
        cd ../1
        
        if ~exist('SAM','dir')
            mkdir SAM
        end
        !cp ../MRI/pnt.txt SAM/pnt.txt
        load dataRejectIcaEye
        trl2mark(dataRejectIcaEye);
        
        cd ..
        !cp ~/SAM_BIU/docs/SuDi0811.rtw 1/1.rtw
        !cp /media/yuval/YuvalExtDrive/Data/Aviva/MEG/alpha.param ./
        if ~exist('1/SAM/alpha,8-12Hz','dir')
            !SAMcov64 -r 1 -d xc,hb,lf_c,rfhp0.1Hz -m alpha -v
        end
        if ~exist('1/SAM/alpha.wts','file')
            !SAMwts64 -r 1 -d xc,hb,lf_c,rfhp0.1Hz -m alpha -c Alla -t pnt.txt -v
            !mv 1/SAM/pnt.txt.wts 1/SAM/alpha.wts
        end
        if ~exist('1/SAM/noise.wts','file')
            !SAMwts64 -r 1 -d xc,hb,lf_c,rfhp0.1Hz -m alpha -c Noise -t pnt.txt -v
            !mv 1/SAM/pnt.txt.wts 1/SAM/noise.wts
        end
        if ~exist('1/SAM/alphaN.wts','file')
            !SAMNwts64 -r 1 -d xc,hb,lf_c,rfhp0.1Hz -m alpha -c Alla -t pnt.txt -v
            !mv 1/SAM/alpha,pnt.txt.wts 1/SAM/alphaN.wts
        end
        
        disp(['XXXXXXXXXXXXXXX ',sub,' XXXXXXXXXXXXXX'])
        if exist('1/SAM/alphaN.wts','file') && exist('1/SAM/alpha.wts','file')
            goodSubs(subi)=true;
        else
            goodSubs(subi)=false;
        end
    end
    save /media/yuval/YuvalExtDrive/Data/Aviva/MEG/goodSubs.mat goodSubs
end
