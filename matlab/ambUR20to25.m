function ambUR20to25(subs)
conds={'Dom','Sub'};
for subi=subs
    sub=num2str(subi);
    cd(['/home/yuval/Data/amb/',sub]);
    runi=1;
    run=num2str(runi);
    cd (run)
    for condi=1:2
        cond=conds{condi};
        %if ~exist(['../',cond,'UR.mat'],'file')
        if exist([cond,'.mrk'],'file')
            markerFile=textread([cond,'.mrk'],'%s','delimiter','\n');
            urLine=find(ismember(markerFile,[cond,'UR']));
            nTrl=str2num(markerFile{urLine+2});
            resp=readChan('c,rfhp1.0Hz,lp','RESPONSE');
            trl=[];
            Resp=[];
            for trli=1:nTrl
                trl(trli,1)=str2num(markerFile{urLine+3+trli}(5:end));
                RS=find(resp(trl(trli,1):end),1); % response time in samples
                Resp(trli,1)=RS+trl(trli,1);
                Resp(trli,2)=resp(Resp(trli,1));
                Resp(trli,3:4)=0;
                if Resp(trli,2)==512
                    if RS>50 && RS<4000
                        Resp(trli,3)=1;
                        Resp(trli,4)=1000*RS/(2*1017.25);
                    end
                end
            end
            trl=trl-2*306;
            trl(:,2)=trl+2*1017;
            trl(:,3)=-2*306;
            cfg=[];
            cfg.trl=trl;
            cfg.lpfilter='yes';
            cfg.lpfreq=70;
            cfg.demean='yes';
            cfg.baselinewindow=[-0.2 0];
            cfg.dataset='c,rfhp1.0Hz,lp';
            UR=ft_preprocessing(cfg);
            display([sub,' ',cond])
            save (['../',cond,'UR'],'UR','Resp')
            %               end
        end
    end
end
end
