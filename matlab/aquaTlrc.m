function aquaTlrc
% PARAM='alpha';Active='eyesClosed';
% Active='eyesClosed';
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
%         %         if ~exist ('SAM/eyesClosed-NULL,P,Zp.svl','file')
%         source='xc,lf,hb_c,rfhp0.1Hz';
%         copyfile('~/SAM_BIU/docs/SuDi0812.rtw',['./',RUN,'.rtw'])
%         copyfile('restMarkerFile.mrk','MarkerFile.mrk');
%         cd ..
%         if ~exist([PARAM,'.param'],'file')
%             copyfile(['/media/Elements/MEG/tal/',PARAM,'.param'],'./')
%         end
%         if ~exist([RUN,'/SAM/',PARAM,',SAMspm-Segments'],'file');
%             eval(['!SAMcov64 -r ',RUN,' -d ',source,' -m ',PARAM,' -v']);
%             eval(['!SAMwts64 -r ',RUN,' -d ',source,' -m ',PARAM,' -c ',Active,'a -v']);
%             eval(['!SAMspm64 -r ',RUN,' -d ',source,' -m ',PARAM,' -v']);
%             cd([RUN,'/SAM']);
            !@auto_tlrc -base ~/SAM_BIU/docs/temp+tlrc -input warped+orig -no_ss
            eval(['!mv ../../SAM/rest_',RUN,'_',num2str(subi),'+orig* ./'])
           
            eval(['!@auto_tlrc -apar warped+tlrc -input rest_',RUN,'_',num2str(subi),'+orig -dxyz 5'])
            cd ..
%        end
        %         end
    end
end
cd /media/Elements/quadaqua/SAM
for subi=1:length(subs)
    sub=subs{subi};
    for resti=1:2;
        RUN=sess{resti};
        copyfile(['../',sub,'/',RUN,'/rest_',RUN,'_',num2str(subi),'+tlrc*'],'./')
    end
end