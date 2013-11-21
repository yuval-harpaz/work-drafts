function [results,subjects]=aliceTablesCmax
exps={'AviBP','AviMa','Hyp','Tuv','alice','tal'};
subjects={};
subCount=0;
resLine=0;
conds={'Open','Closed'};
results=[];
load LRpairs;
%anterior = {'A54', 'A55', 'A81', 'A82', 'A83', 'A112', 'A113', 'A114', 'A115', 'A144', 'A145', 'A146', 'A171', 'A172', 'A173', 'A174', 'A175', 'A193', 'A194', 'A209', 'A210', 'A211', 'A227', 'A228', 'A244', 'A245', 'A246', 'A247', 'A248'};
anterior = {'A54', 'A55', 'A81', 'A82', 'A83', 'A112', 'A113', 'A114', 'A115', 'A144', 'A145', 'A146', 'A171', 'A172', 'A173', 'A174', 'A193', 'A209', 'A210', 'A211', 'A227', 'A244', 'A245', 'A246', 'A247'};
posterior =  {'A51', 'A52', 'A77', 'A78', 'A79', 'A107', 'A108', 'A109', 'A110', 'A139', 'A140', 'A141', 'A142', 'A167', 'A168', 'A169', 'A170', 'A188', 'A189', 'A190', 'A191', 'A206', 'A207', 'A208', 'A225'};
freqs=[6 9 10 11 12 15];
for expi=2:6
    cd /home/yuval/Copy/MEGdata/alpha
    cd(exps{expi})
    load subs.mat
    disp(subs{1});
    for subi=1:length(subs)
        resLine=resLine+1;
        subCount=subCount+1;
        subjects{subCount}=subs{subi};
        for condi=1:2
            if exist([conds{condi},'.mat'],'file')
                load (conds{condi})
                eval(['gav=',conds{condi},';'])
                if subi==1;
                    freqi=[nearest(gav.freq,6),nearest(gav.freq,9),nearest(gav.freq,10),nearest(gav.freq,11),nearest(gav.freq,12),nearest(gav.freq,15)];
                    [~,aRi]=ismember(anterior,gav.label);
                    [~,pRi]=ismember(posterior,gav.label);
                    aCnt=0;
                    pCnt=0;
                    for pairi=1:length(LRpairs)
                        chAb=0;
                        [~,chAb]=ismember(LRpairs{pairi,2},anterior);
                        if chAb>0
                            aCnt=aCnt+1;
                            [~,aLi(aCnt)]=ismember(LRpairs{pairi,1},gav.label);
                        else
                            chPb=0;
                            [~,chPb]=ismember(LRpairs{pairi,2},posterior);
                            if chPb>0
                                pCnt=pCnt+1;
                                [~,pLi(pCnt)]=ismember(LRpairs{pairi,1},gav.label);
                            end
                        end
                    end
                    for pairi=1:length(LRpairs)
                        if ismember(LRpairs{pairi,1},gav.label) && ismember(LRpairs{pairi,2},gav.label)
                            pair(pairi)=true;
                        end
                    end
                    [~,Li]=ismember(LRpairs(find(pair),1),gav.label);
                    Li=Li(Li>0);
                    [~,Ri]=ismember(LRpairs(find(pair),2),gav.label);
                    Ri=Ri(Ri>0);
                end
                [Ra,RaChi]=getPow(gav,subi,aRi,freqi,'max');
                [Rp,RpChi]=getPow(gav,subi,pRi,freqi,'max');
                [La,LaChi]=getPow(gav,subi,aLi,freqi,'max');
                [Lp,LpChi]=getPow(gav,subi,pLi,freqi,'max');
%                 [a,b]=max(gav.powspctrm(subi,aRi,freqi),[],2);
%                 Ra=squeeze(a)';RaChi=squeeze(b)';
%                 [a,b]=max(gav.powspctrm(subi,pRi,freqi),[],2);
%                 Rp=squeeze(a)';RpChi=squeeze(b)';
%                 [a,b]=max(gav.powspctrm(subi,aLi,freqi),[],2);
%                 La=squeeze(a)';LaChi=squeeze(b)';
%                 [a,b]=max(gav.powspctrm(subi,pLi,freqi),[],2);
%                 Lp=squeeze(a)';LpChi=squeeze(b)';
%                 [Rp,RpChi]=squeeze(max(gav.powspctrm(subi,pRi,freqi),[],2))';
%                 [La,LaChi]=squeeze(max(gav.powspctrm(subi,aLi,freqi),[],2))';
%                 [Lp,LpChi]=squeeze(max(gav.powspctrm(subi,pLi,freqi),[],2))';
                [maxpRa,maxi]=max(Ra);
                maxfRa=freqs(maxi);
                [maxpRp,maxi]=max(Rp);
                maxfRp=freqs(maxi);
                [maxpLa,maxi]=max(La);
                maxfLa=freqs(maxi);
                [maxpLp,maxi]=max(Lp);
                maxfLp=freqs(maxi);
                L=getPow(gav,subi,Li,freqi,'mean');
                R=getPow(gav,subi,Ri,freqi,'mean');
%                 R=squeeze(mean(gav.powspctrm(subi,Ri,freqi),2))'; % Note, mean chans, not max chan
%                 L=squeeze(mean(gav.powspctrm(subi,Li,freqi),2))';
                [maxpR,maxi]=max(R);
                maxfR=freqs(maxi);
                [maxpL,maxi]=max(L);
                maxfL=freqs(maxi);
                toobig=[maxfLa,maxfLp,maxfRa,maxfRp,maxfL,maxfR]>12;
                toosmall=[maxfLa,maxfLp,maxfRa,maxfRp,maxfL,maxfR]<9;
                nomax=toobig+toosmall;
                maxMat=[La;Lp;Ra;Rp;L;R];
                if sum(nomax)>0
                    figure;
                    subplot(3,2,1)
                    [maxpLa,maxi]=max(La(2:end-1));
                    maxfLa=freqs(maxi+1);
                    plot(freqs,La)
                    hold on
                    plot(maxfLa,maxpLa,'or')
                    subplot(3,2,2)
                    [maxpRa,maxi]=max(Ra(2:end-1));
                    maxfRa=freqs(maxi+1);
                    plot(freqs,Ra)
                    hold on
                    plot(maxfRa,maxpRa,'or')
                    subplot(3,2,3)
                    [maxpLp,maxi]=max(Lp(2:end-1));
                    maxfLp=freqs(maxi+1);
                    plot(freqs,Lp)
                    hold on
                    plot(maxfLp,maxpLp,'or')
                    subplot(3,2,4)
                    [maxpRp,maxi]=max(Rp(2:end-1));
                    maxfRp=freqs(maxi+1);
                    plot(freqs,Rp)
                    hold on
                    plot(maxfRp,maxpRp,'or')
                    subplot(3,2,5)
                    [maxpL,maxi]=max(L(2:end-1));
                    maxfL=freqs(maxi+1);
                    plot(freqs,L)
                    hold on
                    plot(maxfL,maxpL,'or')
                     subplot(3,2,6)
                    [maxpR,maxi]=max(R(2:end-1));
                    maxfR=freqs(maxi+1);
                    plot(freqs,R)
                    hold on
                    plot(maxfR,maxpR,'or')
                    title(subs{subi})
                    figure;
                    cfg=[];
                    cfg.layout='4D248.lay';
                    cfg.trials=subi;
                    cfg.xlim=[10 10];
                    cfg.interactive='yes';
                    cfg.highlight ='labels';
%                     cfg.highlightchannel=anterior';
%                     cfg.highlightchannel(end+1:end+length(posterior),1)=posterior';
                    cfg.highlightchannel=[aRi,pRi,aLi,pLi];
                    ft_topoplotER(cfg,gav)
                    badLoc=find(nomax)
                    chans{1,1}=aLi;chans{1,2}=pLi;chans{1,3}=aRi;chans{1,4}=pRi;
                    locNames={'Left Anterior' 'Left Posterior' 'Right Anterior' 'Right Posterior' 'Left' 'Right'};
                    initials={'L','R','a','p',''};
                    inits=[1,3;1,4;2,3;2,4;1,5;2,5];
                    maxchi=[LaChi,LpChi,RaChi,RpChi];
                    for loci=1:length(badLoc)
                        maxVec=maxMat(badLoc(loci),:);
                        figure;
                        plot(freqs,maxVec)
                        if badLoc(loci)==5
                            chan='';
                        elseif badLoc(loci)==6
                            chan='';
                        else
                            chan=gav.label(chans{1,badLoc(loci)}(maxchi(badLoc(loci))));
                        end
                        title([subs{subi},' ',locNames{badLoc(loci)},' ',chan]);
                        if badLoc(loci)==5 %L
                            newChi=Li;
                        elseif badLoc(loci)==6 %R
                            newChi=Ri;
                        else
                            newCh = input([locNames{badLoc(loci)},' Channel '],'s');
                            [~,newChi]=ismember(newCh,gav.label);
                        end
                        newFr = input([locNames{badLoc(loci)},' Freq '],'s');
                        varstr=['maxp',initials{inits(badLoc(loci),1)},initials{inits(badLoc(loci),2)}];
                        if isempty(newFr)
                            eval([varstr,'=0;'])
                            newFr=0;
                        else % I need maxfLa and maxpLa
                            newFr=str2num(newFr);
                            newFri=nearest(gav.freq,newFr);
                            
                            chanstr=[initials{inits(badLoc(loci),2)},initials{inits(badLoc(loci),1)},'i'];
                            eval([varstr,'=getPow(gav,subi,',chanstr,',newFri,','''mean''',');'])
                            
                            % maxpLa=getPow(gav,subi,aLi,newFri,'mean');
                        end
                        eval(['maxf',initials{inits(badLoc(loci),1)},initials{inits(badLoc(loci),2)},'=newFr'])
                    end
                    close all
                end
                maxi=nearest(gav.freq,maxfRa);
                ra=squeeze(mean(gav.powspctrm(subi,aRi,maxi),2));
                maxi=nearest(gav.freq,maxfRp);
                rp=squeeze(mean(gav.powspctrm(subi,pRi,maxi),2));
                maxi=nearest(gav.freq,maxfLa);
                la=squeeze(mean(gav.powspctrm(subi,aLi,maxi),2));
                maxi=nearest(gav.freq,maxfLp);
                lp=squeeze(mean(gav.powspctrm(subi,pLi,maxi),2));
                maxi=nearest(gav.freq,maxfR);
                r=squeeze(mean(gav.powspctrm(subi,Ri,maxi),2));
                maxi=nearest(gav.freq,maxfL);
                l=squeeze(mean(gav.powspctrm(subi,Li,maxi),2));
                
                
                lineBL=0;
                if condi==2
                    lineBL=36;
                end
                % mean over chans, max freq
                results(resLine,lineBL+1)=la;
                results(resLine,lineBL+2)=lp;
                results(resLine,lineBL+3)=ra;
                results(resLine,lineBL+4)=rp;
                results(resLine,lineBL+5)=l;
                results(resLine,lineBL+6)=r;
                
                % max chan max freq
                results(resLine,lineBL+7)=maxpLa;
                results(resLine,lineBL+8)=maxpLp;
                results(resLine,lineBL+9)=maxpRa;
                results(resLine,lineBL+10)=maxpRp;
                results(resLine,lineBL+11)=maxpL;
                results(resLine,lineBL+12)=maxpR;
                
                results(resLine,lineBL+13)=maxfLa;
                results(resLine,lineBL+14)=maxfLp;
                results(resLine,lineBL+15)=maxfRa;
                results(resLine,lineBL+16)=maxfRp;
                results(resLine,lineBL+17)=maxfL;
                results(resLine,lineBL+18)=maxfR;
                
            end
        end
    end
end
subjects=subjects';

function [pow,chi]=getPow(data,subi,chans,freqi,method)
    chi=[];
    switch method
        case 'mean'
            pow=squeeze(mean(data.powspctrm(subi,chans,freqi),2))';
        case 'max'
          [a,b]=max(data.powspctrm(subi,chans,freqi),[],2);
                pow=squeeze(a)';chi=squeeze(b)';
    end

