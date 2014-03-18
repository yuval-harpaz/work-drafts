function aquaSAM(PARAM,Active,cond)
% PARAM='alpha';Active='eyesClosed';

function aquaPower
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
        clnsource=['xc,lf,hb_c,rfhp0.1Hz'];
        if ~exist([path2file(end),'.rtw'],'file')
            PWD=pwd;
            path2RTW=findDiRTW(PWD,'Su');
            copyfile(path2RTW,['./',path2file(end),'.rtw'])
        end
        if exist([cond,'MarkerFile.mrk'],'file')
            copyfile([cond,'MarkerFile.mrk'],'MarkerFile.mrk');
        else
            warning(['no ',cond,'MarkerFile.mrk'])
        end
        fileName= conditions{restcell(i)+2};
        if exist(['xc,hb,lf_',fileName],'file')
            source=['xc,hb,lf_',fileName];
        elseif exist(['hb,xc,lf_',fileName],'file')
            source=['hb,xc,lf_',fileName];
        elseif exist(['xc,lf_',fileName],'file')
            source=['xc,lf_',fileName];
        else
            warning('did not find clean file')
        end
        cd ..
        if ~exist([PARAM,'.param'],'file')
            copyfile(['/media/Elements/MEG/tal/',PARAM,'.param'],'./')
        end
        if ~exist([RUN,'/SAM/',PARAM,',SAMspm-Segments'],'file');
            eval(['!SAMcov -r ',RUN,' -d ',source,' -m ',PARAM,' -v']);
            eval(['!SAMwts -r ',RUN,' -d ',source,' -m ',PARAM,' -c ',Active,'a -v']);
            eval(['!SAMspm -r ',RUN,' -d ',source,' -m ',PARAM,' -v']);
            cd([RUN,'/SAM']);system(['cp *',Active,'*.svl ../']);cd ../..
        end
    end
end
end