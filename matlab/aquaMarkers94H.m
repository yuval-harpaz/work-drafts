function aquaMarkers94H
cd ('/media/Elements/quadaqua');
load subs subs
sess={'a','b'};
for subi=1:length(subs)
    cd ('/media/Elements/quadaqua');
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    cd (sub)
    for resti=1:2;
        cd(sess{resti})
        clnsource='xc,lf,hb_c,rfhp0.1Hz';
        if ~exist('restMarkerFile.mrk','file')
            %load(['/media/Elements/MEG/tal/s',sub,'_pow94_',num2str(resti)])
            load trl
            epochs94=trl(:,1)./1017.25;epochs94=epochs94';
%             load(['/media/Elements/MEG/tal/s',sub,'_pow92_',num2str(resti)])
%             epochs92=pow.cfg.previous.trl(:,1)./1017.25;epochs92=epochs92';
            Trig2mark('eyesClosed',epochs94)
            !cp MarkerFile.mrk restMarkerFile.mrk
        end
        if ~exist('warped+orig.BRIK','file')
            if ~exist('T.nii','file')
                fitMRI2hs(clnsource);
            end
            % !/home/megadmin/abin/3dWarp -deoblique T.nii
        end
        if ~exist('HS+orig.BRIK','file')
            hs2afni
        end
        % NOW  NUDGE
        cd ..
    end
    cd ..
end

