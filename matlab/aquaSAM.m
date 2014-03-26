function aquaSAM(PARAM)
% PARAM='alpha';Active='eyesClosed';
Active='eyesClosed';
cd ('/media/Elements/quadaqua');
load subs subs
sess={'a','b'};
for subi=1:length(subs)
    cd ('/media/Elements/quadaqua');
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    cd (sub)
    for resti=1:2;
        RUN=sess{resti};
        cd(RUN)
        %         if ~exist ('SAM/eyesClosed-NULL,P,Zp.svl','file')
        source='xc,lf,hb_c,rfhp0.1Hz';
        PWD=pwd;
        copyfile('~/SAM_BIU/docs/SuDi0812.rtw',['./',RUN,'.rtw'])
        copyfile('restMarkerFile.mrk','MarkerFile.mrk');
        cd ..
        if ~exist([PARAM,'.param'],'file')
            copyfile(['/media/Elements/MEG/tal/',PARAM,'.param'],'./')
        end
        if ~exist([RUN,'/SAM/',PARAM,',SAMspm-Segments'],'file');
            eval(['!SAMcov64 -r ',RUN,' -d ',source,' -m ',PARAM,' -v']);
            eval(['!SAMwts64 -r ',RUN,' -d ',source,' -m ',PARAM,' -c ',Active,'a -v']);
            eval(['!SAMspm64 -r ',RUN,' -d ',source,' -m ',PARAM,' -v']);
            cd([RUN,'/SAM']);
            eval(['!3dcopy alpha,7-13Hz,eyesClosed-NULL,P,Zp.svl ../../../SAM/rest_',RUN,'_',num2str(subi)])
            cd ../..
        end
        %         end
    end
end