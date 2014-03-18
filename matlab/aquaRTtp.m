function aquaRTtp
cd ('/media/Elements/quadaqua');
load subs subs
sess={'a','b'};
%!echo  "   RT for Time Production" > /home/yuval/Desktop/talResults/RTtp.txt
!rm RTtp.txt
for subi=1:length(subs)
    cd ('/media/Elements/quadaqua')
    sub=subs{subi};
    display(sub);
    cd (sub);
    source='c,rfhp0.1Hz';
    for sessi=1:2
        if subi==2 && sessi==1
            trig=clearTrig(readTrig_BIU([sess{sessi},'/TP/',source]));
        else
        trig=clearTrig(readTrig_BIU([sess{sessi},'/',source]));
        end
        close
        if ~max(find(unique(trig)==112))>0
            error('no rest trig')
        end
        RT=[];
        RT(1,1)=0;
        trialcount=1;
        if subi==2 && sessi==1
            resp=readChan([sess{sessi},'/TP/',source],'RESPONSE');
        else
        resp=readChan([sess{sessi},'/',source],'RESPONSE');
        end
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
                eval(['!echo  ''',sub,sess{sessi},' ',corr,' ',num2str(RTtr),...
                    ''' >> ../RTtp.txt'])
            end
        end
        %            save(['~/Desktop/talResults/s',sub,'_pow',num2str(trval),'_',num2str(1)],'pow');
        %        end
        
        
        %
    end
end
