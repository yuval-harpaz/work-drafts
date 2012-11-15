function talRTtpH(subs)
% subs=importdata('/home/yuval/Desktop/tal/subs3.txt')
%cd ('/home/yuval/Desktop/tal')
cd ('/media/Elements/MEG/tal')
%!echo  "   RT for Time Production" > /home/yuval/Desktop/talResults/RTtp.txt
for subi=1:length(subs)
    cd ('/media/Elements/MEG/tal')
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    cd ([sub,'/',sub,'/0.14d1']);
    conditions=textread('conditions','%s');
    TPcell=find(strcmp('timeProd',conditions));
    %for resti=1:length(restcell);
        path2file=conditions{TPcell(1)+1};
        source= conditions{TPcell(1)+2};
        cd(path2file)
%         if exist(['xc,hb,lf_',source],'file')
%             clnsource=['xc,hb,lf_',source];
%         elseif exist(['hb,xc,lf_',source],'file')
%             clnsource=['hb,xc,lf_',source];
%         elseif exist(['xc,lf_',source],'file')
%             clnsource=['xc,lf_',source];
%         else
%             error('no cleaned source file found')
%         end
        trig=readTrig_BIU(source);
        trig=clearTrig(trig);
        close all
        if ~max(find(unique(trig)==112))>0
            error('no rest trig')
        end
        RT=[];
        RT(1,1)=0;
        trialcount=1;
        resp=readChan(source,'RESPONSE');
        for trval=[84 88 96 112];
%            corrresp=round(1017.25*(trval-80));
            corr=num2str(1000*(trval-80));
            time0=find(trig==trval);
            endtval=length(time0);
            for triali=1:endtval
                RTtr=[];
                RTtr=round(1000*find(resp(time0(triali):end),1)/1017.25);
%                 if isempty(RTtr)
%                     RTtr=0;
%                 end
                RT(trialcount)=RTtr;
                trialcount=trialcount+1;
                eval(['!echo  ''',sub,' ',corr,' ',num2str(RTtr),''' >> ',...
                    '/media/Elements/MEG/talResults/RTtp.txt'])
            end
        end
end
cd ('/media/Elements/MEG/talResults')
end
